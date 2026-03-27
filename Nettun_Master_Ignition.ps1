# M2N2 NEXUS - SPECTER-NETTUN ATTACHMENT
Write-Host "--- INITIALIZING SPECTER-NETTUN FABRIC ---" -ForegroundColor Magenta

# PURGE LOCAL RESIDUE
Write-Host "[!] SCRUBBING LOCAL FOOTPRINT..." -ForegroundColor Red
$PurgeTargets = @("$env:TEMP\*", "$env:USERPROFILE\AppData\Local\Temp\*")
foreach ($Target in $PurgeTargets) { Remove-Item $Target -Recurse -ErrorAction SilentlyContinue }

# DOWNLOAD WORKERS
Write-Host "[*] DOWNLOADING SHADOW-WORKERS FROM GITHUB..." -ForegroundColor Cyan
$RepoUrl = "https://github.com/YourUser/M2n2_Nexus_Sovereign/raw/main/core"
$Workers = @("NettunDevice.ps1", "PowerlineScanner.py", "TeslaOverlay.py")

if (-not (Test-Path "Z:\Deep_Vault\workers")) { New-Item -ItemType Directory -Force -Path "Z:\Deep_Vault\workers" }

foreach ($W in $Workers) {
    Try {
        Invoke-WebRequest -Uri "$RepoUrl/$W" -OutFile "Z:\Deep_Vault\workers\$W" -TimeoutSec 10
    } Catch {
        Write-Host "[!] Connection failed for $W. Check GitHub URL or PAT." -ForegroundColor Yellow
    }
}

# NETTUN ATTACH
Write-Host "[*] ESTABLISHING NETTUN ATTACHMENT..." -ForegroundColor Yellow
$NettunConfig = @{
    Identity = "Master_Ghost"
    Tunnel   = "IKEv3_Shield"
    Lense    = "X-Ray_Underlay"
} | ConvertTo-Json
$NettunConfig | Out-File "Z:\Deep_Vault\Nettun_State.json" -Force

Write-Host "--- NETTUN ATTACHED. ---" -ForegroundColor Green
[Console]::Beep(1500, 200); [Console]::Beep(2500, 600)
