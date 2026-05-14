Add-Type -AssemblyName System.Drawing
$srcPath = "C:\Users\Dell\.gemini\antigravity\brain\fbf1f3b2-0fa9-4bdf-87be-1922bcec5859\media__1778709187952.png"
$destPath = "C:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\logo.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = new-object System.Drawing.Bitmap($img)

# Crop region: X=250, Y=250, Width=524, Height=226
$cropRect = New-Object System.Drawing.Rectangle(250, 250, 524, 226)
$croppedImg = $bmp.Clone($cropRect, $bmp.PixelFormat)

$croppedImg.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)

$croppedImg.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Logo cropped and saved to $destPath"
