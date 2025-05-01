
# This script is attached to the Lab Vm life cycle.
# Make sure to update endpoint back to main once the script is ready to be used in production.

# Define the URL of the external script
$scriptUrl = "https://raw.githubusercontent.com/microsoft/build-2025-devcenter/refs/heads/jyotilama/update-project-premissions/BuildLab/life-cycle-scripts/create-devbox-onbehalf.ps1"
 
try {
        # Use Invoke-WebRequest to download the script
        $response = Invoke-WebRequest -UseBasicParsing -Uri $scriptUrl
 
        Write-Error "Parsed script url"
 
        # Extract the content from the response
        $scriptContent = $response.Content
 
        Write-Error "Got content from script"
 
        # Execute the script content
        Invoke-Expression $scriptContent
 
        Write-Error "Finished invoking script"
}
catch {
    Write-Error "Failed to download or run the script from the URL. Error: $_"
}