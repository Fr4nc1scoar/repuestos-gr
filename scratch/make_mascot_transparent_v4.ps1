Add-Type -AssemblyName System.Drawing
$srcPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_cropped.png"
$destPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_clean_final.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = New-Object System.Drawing.Bitmap($img)
$newBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Shifted circular mask to account for mascot offset in the crop
$centerX = $bmp.Width / 2
$centerY = ($bmp.Height / 2) + 10 # Shifting down to avoid the black fragments at top
$radius = 215 # Tighter radius to ensure we only get the white circle area

for ($x = 0; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $pixel = $bmp.GetPixel($x, $y)
        $dist = [Math]::Sqrt([Math]::Pow($x - $centerX, 2) + [Math]::Pow($y - $centerY, 2))
        
        if ($dist -le $radius) {
            $newBmp.SetPixel($x, $y, $pixel)
        } else {
            $newBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$newBmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Mascot cleaned with shifted spatial mask and saved to $destPath"
