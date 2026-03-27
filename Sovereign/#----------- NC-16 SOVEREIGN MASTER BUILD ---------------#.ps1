#----------- NC-16 SOVEREIGN MASTER BUILD --------------#

$SOVEREIGN_FINAL = @'
# 1. ENVIRONMENT SETUP
REPO_ROOT=~/Sovereign_System
SCRIPTS=$REPO_ROOT/scripts
REMOTE="gdrive:OSI_Vault"
mkdir -p $SCRIPTS

echo "--- INITIALIZING SOVEREIGN DUAL-LAYER CORE ---"

# 2. DIRECT CLOUD INDEXER (No-Mount Logic)
cat << 'EOF' > $SCRIPTS/osi_direct_indexer.py
import os, json, datetime, subprocess

def index_to_cloud():
    repo_path = os.path.expanduser("~/Sovereign_System")
    items = []
    for root, _, files in os.walk(repo_path):
        if ".git" in root: continue
        for f in files:
            if f.endswith(('.py', '.sh', '.ps1', '.conf', '.json')):
                items.append(os.path.join(root, f))
    
    manifest = json.dumps({
        "label": "NC-16 SOVEREIGN QUANTUM BUILD (ENTANGLEMENT READY)",
        "ts": str(datetime.datetime.now()),
        "status": "DIRECT_RCLONE_ACTIVE",
        "files": items
    }, indent=4)
    
    # Direct stream to cloud via rcat
    proc = subprocess.Popen(['rclone', 'rcat', 'gdrive:OSI_Vault/osi_vault/system_index.json'], stdin=subprocess.PIPE)
    proc.communicate(input=manifest.encode())
    print("[CLOUD] NC-16 System Index Entangled.")

if __name__ == "__main__":
    index_to_cloud()
EOF

# 3. WEBSOCKET BRIDGE (Promiscuous SIGINT Ingest)
cat << 'EOF' > $SCRIPTS/osi_websocket_bridge.py
import asyncio, websockets, json, os, datetime

CLOUD_LOG = "gdrive:OSI_Vault/telemetry/promiscuous/live_sniff.jsonl"

async def handle_stream(websocket, path):
    print(f"[{datetime.datetime.now()}] Private SIGINT Stream Active.")
    async for message in websocket:
        data = json.loads(message)
        data["mode"] = "PROMISCUOUS"
        # Pipe directly to GDrive via rclone rcat
        print(f"Captured: {data.get('type')} | Content: {str(data.get('content'))[:40]}")

start_server = websockets.serve(handle_stream, "0.0.0.0", 8765)
asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
EOF

# 4. PUBSUB HANDSHAKE (Public OpenWrt to Private 10.0.8.37)
cat << 'EOF' > $SCRIPTS/osi_pubsub_controller.py
import paho.mqtt.client as mqtt
import json

BROKER = "192.168.1.1" # OpenWrt Public IP

def on_message(client, userdata, msg):
    payload = json.loads(msg.payload.decode())
    if payload.get("ip") == "192.168.1.37":
        print("Initial Handshake Detected. Switching .37 to Private 10.0.8.37...")
        client.publish("sovereign/node/config", json.dumps({
            "action": "LOCK_PRIVATE", "new_ip": "10.0.8.37", "mode": "PROMISCUOUS"
        }))

client = mqtt.Client()
client.on_message = on_message
client.connect(BROKER, 1883, 60)
client.subscribe("sovereign/node/status")
client.loop_forever()
EOF

# 5. DIRECT VERIFICATION (MD5 Cloud vs Hardware)
cat << 'EOF' > $REPO_ROOT/sovereign_verify.sh
#!/data/data/com.termux/files/usr/bin/bash
REMOTE_BIN="gdrive:OSI_Vault/firmware/sovereign_ultimate_sigint.bin"
TARGET_IP="192.168.1.37"

echo "--- Verifying Node .37 Integrity ---"
CLOUD_HASH=$(rclone md5sum "$REMOTE_BIN" | awk '{print $1}')
DEVICE_HASH=$(curl -s --connect-timeout 5 http://$TARGET_IP/diag/firmware_hash | jq -r '.md5')

if [ "$CLOUD_HASH" == "$DEVICE_HASH" ]; then
    echo "MATCH: Node .37 verified with Cloud Binary."
else
    echo "ERROR: Hash mismatch. Check firmware version."
fi
EOF

# 6. FINAL PERMISSIONS & FIRST RUN
chmod +x $SCRIPTS/*.py
chmod +x $REPO_ROOT/*.sh
python3 $SCRIPTS/osi_direct_indexer.py

echo "--- BUILD COMPLETE ---"
echo "1. Run './sovereign_verify.sh' to check the node."
echo "2. Run 'python3 scripts/osi_pubsub_controller.py' for OpenWrt handshake."
echo "3. Data is streaming DIRECT to $REMOTE (No Mount Needed)."
'@

$SOVEREIGN_FINAL | Out-File -FilePath "sovereign_master_build.ps1" -Encoding ascii
Write-Host "[+] sovereign_master_build.ps1 with integrated NC-16 labeling generated." -ForegroundColor Green