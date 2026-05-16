Add-Type -AssemblyName System.Drawing
$srcPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_clean.png"
$destPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_cropped.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = new-object System.Drawing.Bitmap($img)

# Crop region: Start from Y=180 to avoid phone UI, capture the mascot circle
$cropWidth = 485
$cropHeight = 485
$cropX = 0
$cropY = 180

$cropRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropWidth, $cropHeight)
$croppedImg = $bmp.Clone($cropRect, $bmp.PixelFormat)

$croppedImg.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)

$croppedImg.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Mascot cropped and saved to $destPath"
