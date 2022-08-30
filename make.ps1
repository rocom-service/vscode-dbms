[CmdletBinding()]
param (
)
begin {
}
process {
    $package = Get-Content "$PSScriptRoot\package.json" | ConvertFrom-Json 
    git tag -a "v$($package.version)" -m "version $($package.version)"

    if ($LASTEXITCODE -eq 0) {
        vsce package
        Invoke-Item $PSScriptRoot
        Start-Process "https://marketplace.visualstudio.com/manage/publishers/rocomservice"
    }
}
end {        
}