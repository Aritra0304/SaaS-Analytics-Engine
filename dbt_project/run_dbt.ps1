# run_dbt.ps1 — loads .env variables into the shell session then runs dbt
# Usage (from dbt_project folder):
#   .\run_dbt.ps1 debug
#   .\run_dbt.ps1 run
#   .\run_dbt.ps1 test

param([Parameter(ValueFromRemainingArguments)][string[]]$DbtArgs)

$envFile = Join-Path $PSScriptRoot "..\\.env"

if (-not (Test-Path $envFile)) {
    Write-Error ".env file not found at $envFile"
    exit 1
}

# Load each KEY=VALUE line from .env into the current process environment
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    # Skip blank lines and comments
    if ($line -and $line -notmatch '^\s*#') {
        $parts = $line -split '=', 2
        if ($parts.Length -eq 2) {
            $key   = $parts[0].Trim()
            $value = $parts[1].Trim().Trim('"').Trim("'")
            [System.Environment]::SetEnvironmentVariable($key, $value, 'Process')
            Write-Host "  Set $key"
        }
    }
}

Write-Host ""
Write-Host "Running: dbt $DbtArgs"
Write-Host ""

dbt @DbtArgs

# After docs generate, copy project assets into target/assets/ so images
# are served correctly by dbt docs serve
if ($DbtArgs -contains 'generate' -and $DbtArgs -contains 'docs') {
    $src = Join-Path $PSScriptRoot "assets"
    $dst = Join-Path $PSScriptRoot "target\assets"
    if (Test-Path $src) {
        Write-Host ""
        Write-Host "Copying assets to target/assets/..."
        Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
        Write-Host "  Done."
    }
}
