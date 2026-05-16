Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile("c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_clean.png")
Write-Host "$($img.Width)x$($img.Height)"
$img.Dispose()
