$imgDir = 'C:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\images'
$headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' }

$downloads = @(
    @{ url='https://m.media-amazon.com/images/I/61tCBU1Nz6L.jpg'; name='aislante.jpg' },
    @{ url='https://www.sunfull-hanbec.com/uploads/Refrigerator-Heating-Tube-Stainless-Steel-Tubular-1.jpg'; name='resistencia.jpg' },
    @{ url='https://m.media-amazon.com/images/I/61UFPXk-3XL.jpg'; name='boya.jpg' },
    @{ url='https://m.media-amazon.com/images/I/61-sxIG8GyL._AC_UF1000,1000_QL80_.jpg'; name='kit.jpg' },
    @{ url='https://cdn11.bigcommerce.com/s-pq4cspw2hy/images/stencil/1280x1280/products/11689/17479/klein-cl445-main__70797.1744056039.jpg?c=1&imbypass=on'; name='medicion.jpg' },
    @{ url='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0yEIpFOeDCsDTVjkZjtX_bK-Fi4Uto2ZvTw&s'; name='sellante.jpg' },
    @{ url='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSF9WewWiUoNSEqC0Ux6Hw4_XhWOAaURV0BHw&s'; name='presostato.jpg' },
    @{ url='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR__MONopUs7L6Kjbh407HfHQ8Y5EuOmfcvbg&s'; name='herramienta.jpg' },
    @{ url='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkVISFot4Faieg_9omWRgBcB2KGubxnlwaSQ&s'; name='cocina.jpg' },
    @{ url='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpIEnnFhos-5GTOFy_P87MmEZX8m-JQGE_kA&s'; name='accesorios.jpg' }
)

foreach ($item in $downloads) {
    $dest = Join-Path $imgDir $item.name
    try {
        Invoke-WebRequest -Uri $item.url -OutFile $dest -Headers $headers -TimeoutSec 20
        $size = (Get-Item $dest).Length
        Write-Host "OK $($item.name) ($size bytes)"
    } catch {
        Write-Host "FAIL $($item.name): $_"
    }
}
