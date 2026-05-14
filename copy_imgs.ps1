$srcDir = 'C:\Users\Dell\.gemini\antigravity\brain\fbf1f3b2-0fa9-4bdf-87be-1922bcec5859'
$dstDir = 'C:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images'

$files = Get-ChildItem -Path $srcDir -Filter '*.png'
foreach ($f in $files) {
    Write-Host $f.Name
}

# Copy each specifically
$pairs = @(
    @('compressor_*.png', 'compresor.jpg'),
    @('valve_*.png', 'valvula.jpg'),
    @('filter_drier_*.png', 'filtro.jpg'),
    @('hose_manifold_*.png', 'manguera.jpg'),
    @('oil_compressor_*.png', 'aceite.jpg'),
    @('contactor_*.png', 'contactor.jpg'),
    @('fan_motor_*.png', 'micromotor.jpg'),
    @('control_board_*.png', 'tarjeta.jpg'),
    @('copper_tube_*.png', 'tubo.jpg')
)

foreach ($pair in $pairs) {
    $pattern = $pair[0]
    $destName = $pair[1]
    $found = Get-ChildItem -Path $srcDir -Filter $pattern | Select-Object -First 1
    if ($found) {
        Copy-Item $found.FullName (Join-Path $dstDir $destName) -Force
        Write-Host "Copied $($found.Name) -> $destName"
    } else {
        Write-Host "NOT FOUND: $pattern"
    }
}
