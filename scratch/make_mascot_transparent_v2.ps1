Add-Type -AssemblyName System.Drawing
$srcPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_cropped.png"
$destPath = "c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\mascot_clean_final.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = New-Object System.Drawing.Bitmap($img)
$newBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Intelligent transparency: 
# 1. Any pixel outside a certain radius is transparent.
# 2. Any pixel inside that is "too dark" (black background) is also transparent.

$centerX = $bmp.Width / 2
$centerY = $bmp.Height / 2
$radius = ($bmp.Width / 2) - 1

for ($x = 0; $x -lt $bmp.Width; $x++) {
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        # Calculate distance from center
        $dist = [Math]::Sqrt([Math]::Pow($x - $centerX, 2) + [Math]::Pow($y - $centerY, 2))
        
        # Check if it's "black" (the background from the screenshot)
        # We use a threshold because compression might make it not exactly 0,0,0
        $isBlack = ($pixel.R -lt 40 -and $pixel.G -lt 40 -and $pixel.B -lt 40)

        if ($dist -le $radius -and -not $isBlack) {
            # Inside the mascot circle and NOT black background
            $newBmp.SetPixel($x, $y, $pixel)
        } else {
            # Outside or black background - make transparent
            $newBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$newBmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Mascot cleaned with intelligent transparency and saved to $destPath"
