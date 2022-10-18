param (
)
begin {
    New-Alias `
        -Name gimp `
        -Value (Get-ChildItem "C:\Program Files\GIMP *\bin\gimp-*.exe" | Sort-Object Length | Select-Object -Last 1).FullName `
        -ErrorAction SilentlyContinue
}
process {
    Push-Location $PSScriptRoot
    Remove-Item logo.png -Force -ErrorAction SilentlyContinue

    $image  = 1
    $script = @"
(gimp-image-scale $image 128 128)
(file-png-save RUN-NONINTERACTIVE $image (car (gimp-image-merge-visible-layers $image 0)) \"logo.png\" \"logo.png\" 0 9 0 0 0 0 0)
(gimp-quit 0)
"@

    gimp --no-interface --no-data --no-fonts --batch=$script "logo.xcf"
    
    while ($null -eq $p) {
        $p = Get-Process -ProcessName "script-fu" -ErrorAction SilentlyContinue 
        Start-Sleep -Milliseconds 500
    }
    $p.WaitForExit() | Out-Null
    
    $p = Get-Process -ProcessName "gimp-*"
    $p.WaitForInputIdle() | Out-Null
    $p.CloseMainWindow()

    Get-ChildItem logo.png
    Pop-Location
}
end {
}