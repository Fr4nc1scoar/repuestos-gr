# Crear imágenes faltantes para las categorías que no tienen imagen generada
# Usaremos SVG inline guardado como .jpg (los navegadores lo soportan si es <img>)
# Pero mejor, crearemos SVGs reales y los guardamos como .svg que el HTML lee con onerror

$imgDir = 'C:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images'

# Copiar imágenes existentes para cubrir alias
$aliases = @(
    @('bimetalico.jpg', 'termico.jpg'),
    @('contactor.jpg', 'rele.jpg'),
    @('contactor.jpg', 'presostato.jpg'),
    @('varilla.jpg', 'soldadura.jpg'),
    @('reloj.jpg', 'boya.jpg'),
    @('micromotor.jpg', 'bomba.jpg'),
    @('micromotor.jpg', 'motor.jpg'),
    @('generic.jpg', 'sealant.jpg'),
    @('generic.jpg', 'insulation.jpg'),
    @('generic.jpg', 'resistance.jpg'),
    @('generic.jpg', 'pressure.jpg'),
    @('generic.jpg', 'display.jpg'),
    @('generic.jpg', 'belt.jpg')
)

foreach ($alias in $aliases) {
    $src = Join-Path $imgDir $alias[0]
    $dst = Join-Path $imgDir $alias[1]
    if ((Test-Path $src) -and -not (Test-Path $dst)) {
        Copy-Item $src $dst
        Write-Host "Alias created: $($alias[1])"
    }
}

Write-Host "Done."
