-- /usr/share/nmap/scripts/allseeingeye-info.nse
local comm = require "comm"
local nmap = require "nmap"
local shortport = require "shortport"
local string = require "string"
local stdnse = require "stdnse"

description = [[
Detects the All-Seeing Eye service. Provided by some game servers for querying the server's status.

The All-Seeing Eye service can listen on a UDP port separate from the main game server port (usually game port + 123). On receiving a packet with the payload "s", it replies with various game server status info.

When run as a version detection script (-sV), the script will report on the game name, version, actual port, and whether it has a password. When run explicitly (--script allseeingeye-info), the script will additionally report on the server name, game type, map name, current number of players, maximum number of players, player information, and various other information.
]]

---
-- @usage
-- nmap -sV <target>
-- @usage
-- nmap -Pn -sU -sV --script allseeingeye-info -p <port> <target>

author = "Marin Maržić"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = { "discovery", "safe", "version" }

portrule = shortport.version_port_or_service({1258,2126,3123,12444,13200,23196,26000,27138,27244,27777,28138}, "allseeingeye", "udp")

action = function(host, port)
  local status, data = comm.exchange(host, port, "s", { timeout = 3000 })
  if not status then return end

  -- UDP port is open
  nmap.set_port_state(host, port, "open")

  if not string.match(data, "^EYE1") then return end

  -- Detected; extract fields
  local o = stdnse.output_table()
  local pos = 5
  
  -- Logic for unpacking game/port/version fields
  o["game"], o["port"], o["server name"], o["game type"], o["map"], o["version"], o["passworded"], o["num players"], o["max players"], pos = string.unpack("<s1"):rep(9), data, pos

  -- Extract the key-value pairs (settings)
  local kv = stdnse.output_table()
  o["settings"] = kv
  while data:byte(pos) ~= 1 do
    local key, value
    key, value, pos = string.unpack("s1s1", data, pos)
    kv[key] = value
  end
  pos = pos + 1

  -- Extract player info
  local players = stdnse.output_table()
  o["players"] = players
  local playernum = 0
  while pos <= #data do
    local flags = data:byte(pos)
    pos = pos + 1
    local player = stdnse.output_table()
    if (flags & 1) ~= 0 then player.name, pos = string.unpack("s1", data, pos) end
    if (flags & 2) ~= 0 then player.team, pos = string.unpack("s1", data, pos) end
    if (flags & 4) ~= 0 then player.skin, pos = string.unpack("s1", data, pos) end
    if (flags & 8) ~= 0 then player.score, pos = string.unpack("s1", data, pos) end
    if (flags & 16) ~= 0 then player.ping, pos = string.unpack("s1", data, pos) end
    if (flags & 32) ~= 0 then player.time, pos = string.unpack("s1", data, pos) end
    players["player " .. playernum] = player
    playernum = playernum + 1
  end

  port.version.name = "ase"
  port.version.name_confidence = 10
  port.version.product = "All-Seeing Eye"
  local passworded_string
  if o["passworded"] == "0" then passworded_string = "; no password" else passworded_string = "; has password" end
  port.version.extrainfo = "game: " .. o["game"] .. " " .. o["version"] .. "; port: " .. o["port"] .. passworded_string

  nmap.set_port_version(host, port, "hardmatched")
  return o
end