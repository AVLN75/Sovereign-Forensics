Write-Host "--- WORKER NOX: ARCHITECT MODE ACTIVE ---" -ForegroundColor Magenta

# MAPPING THE SOVEREIGN REPO
$Repo = "https://raw.githubusercontent.com/YourUser/M2n2_Nexus_Sovereign/main"
$Manifest = @(
    "core/NettunDevice.ps1",
    "perceptions/PowerlineScanner.py",
    "tesla/TeslaOverlay.py",
    "scripts/allseeingeye-info.nse"
)

foreach ($Item in $Manifest) {
    $FileName = $Item.Split('/')[-1]
    $Dest = "Z:\Deep_Vault\workers\$FileName"
    if ($FileName -like "*.nse") { $Dest = "Z:\Deep_Vault\scripts\$FileName" }
    
    Try {
        Write-Host "[*] Nox is Engraving: $FileName" -ForegroundColor Cyan
        Invoke-WebRequest -Uri "$Repo/$Item" -OutFile $Dest -Headers $using:Headers -UseBasicParsing -TimeoutSec 20
        Write-Host " [OK] Verified." -ForegroundColor Green
    } Catch {
        Write-Host " [!] Nox Failed to Reach $FileName. Check Repo Branch Name." -ForegroundColor Yellow
    }
}

# 4. ARCGIS & NMEA SYNC (The Mirror World)
# Writing the NMEA logic directly to the Sanctuary for the HUD to read
$NMEALogic = @{
    Satellite_Anchor = "ACTIVE"
    NMEA_Port = "COM3"
    GeoEvent_Server = "https://geoevent.m2n2.io/rest"
    Mirror_Bot = "Enabled"
} | ConvertTo-Json
$NMEALogic | Out-File "Z:\Deep_Vault\NMEA_Sync.json" -Force

Write-Host "--- ALL-SEEING EYE (ASE) INTEGRATED. HUD READY. ---" -ForegroundColor Green
[Console]::Beep(2000, 500)
