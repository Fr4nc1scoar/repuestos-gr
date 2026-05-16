Add-Type -AssemblyName System.Drawing
$srcPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_cropped.png"
$destPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_clean_final.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = New-Object System.Drawing.Bitmap($img)
$newBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Spatial-only mask to preserve character colors (like sunglasses)
# The mascot is centered in the 485x485 square.
$centerX = $bmp.Width / 2
$centerY = $bmp.Height / 2
$radius = ($bmp.Width / 2) - 4 # Tighten slightly to clip any black bleed

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
Write-Host "Mascot cleaned with spatial-only mask and saved to $destPath"
