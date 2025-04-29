
# Define the URL of the external script
# Make sure to update endpoint back to main once the script is ready to be used in production.
$scriptUrl = "https://raw.githubusercontent.com/microsoft/build-2025-devcenter/refs/heads/main/BuildLab/life-cycle-scripts/link-script.ps1"

try {

    . { iwr -useb $scriptUrl } | iex; install

}
catch {
    Write-Error "Failed to download the script from the URL. Error: $_"
}