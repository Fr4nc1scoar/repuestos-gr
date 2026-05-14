Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Dell\.gemini\antigravity\brain\fbf1f3b2-0fa9-4bdf-87be-1922bcec5859\media__1778709187952.png"
$destPath = "C:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images\logo.png"

$img = [System.Drawing.Image]::FromFile($srcPath)
$bmp = New-Object System.Drawing.Bitmap($img)

# Crop: X=250, Y=250, Width=500, Height=230
$cropRect = New-Object System.Drawing.Rectangle(250, 250, 500, 230)
$cropped = $bmp.Clone($cropRect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Draw a white polygon over the top-right corner
$g = [System.Drawing.Graphics]::FromImage($cropped)
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$points = [System.Drawing.Point[]]@(
    [System.Drawing.Point]::new(400, 0),
    [System.Drawing.Point]::new(500, 0),
    [System.Drawing.Point]::new(500, 80)
)
$g.FillPolygon($whiteBrush, $points)
$g.Dispose()

# Make white background transparent
for ($x = 0; $x -lt $cropped.Width; $x++) {
    for ($y = 0; $y -lt $cropped.Height; $y++) {
        $pixel = $cropped.GetPixel($x, $y)
        $r = [int]$pixel.R
        $g = [int]$pixel.G
        $b = [int]$pixel.B
        
        # Make white and near-white transparent
        if ($r -gt 210 -and $g -gt 210 -and $b -gt 210) {
            $cropped.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        }
    }
}

$cropped.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$cropped.Dispose()
$bmp.Dispose()
$img.Dispose()
Write-Host "Logo v15 saved - polygon masking fixed"
