
# Define the URL of the external script
$scriptUrl = "https://raw.githubusercontent.com/microsoft/build-2025-devcenter/refs/heads/jyotilama/add-linked-script/BuildLab/create-devbox-onbehalf.ps1"

try {

    . { iwr -useb $scriptUrl } | iex; install

}
catch {
    Write-Error "Failed to download the script from the URL. Error: $_"
}