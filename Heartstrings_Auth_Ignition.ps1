Write-Host "--- HEARTSTRINGS MASTER LOGIC: AUTHENTICATED ---" -ForegroundColor Magenta

$Repo = "https://raw.githubusercontent.com/YourUser/M2n2_Nexus_Sovereign/main"
$Workers = @(
    "core/NettunDevice.ps1",
    "perceptions/PowerlineScanner.py",
    "tesla/TeslaOverlay.py"
)

# Ensure the Vault is ready
if (-not (Test-Path "Z:\Deep_Vault\workers")) { New-Item -Path "Z:\Deep_Vault\workers" -ItemType Directory -Force }

foreach ($W in $Workers) {
    $FileName = $W.Split('/')[-1]
    $Dest = "Z:\Deep_Vault\workers\$FileName"
    
    Try {
        Write-Host "[*] Requesting $FileName via Shielded Tunnel..." -ForegroundColor Cyan
        # Passing the Authorization Headers to bypass GitHub Private restrictions
        Invoke-WebRequest -Uri "$Repo/$W" -OutFile $Dest -Headers $using:Headers -UseBasicParsing -TimeoutSec 15
        Write-Host " [OK] $FileName Engraved." -ForegroundColor Green
    } Catch {
        Write-Host " [!] Access Denied for $FileName. Verify PAT or Repo Path." -ForegroundColor Yellow
        $_.Exception.Message
    }
}

Write-Host "--- ALL WORKERS ATTACHED ---" -ForegroundColor Green
