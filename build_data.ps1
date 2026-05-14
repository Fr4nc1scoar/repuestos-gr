$data = Import-Csv 'c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\data.csv'

# Category mapping: keyword in product name -> {category label, image file}
$categoryMap = @(
    # --- SPECIFIC OVERRIDES (Must come first to match before general rules) ---
    @{ keys=@('PICO DE SOLDAR'); cat='SOLDADURA'; img='images/varilla.jpg' }
    @{ keys=@('PEGA TANKE'); cat='SELLANTES'; img='images/sellante.png' }
    @{ keys=@('CORTA TUBO'); cat='HERRAMIENTAS'; img='images/herramienta.jpg' }
    @{ keys=@('ROLINERA 6205'); cat='ROLINERAS'; img='images/rolinera_6205.png' }
    @{ keys=@('ACEITE TC-W3', 'ACITE 2T'); cat='ACEITES'; img='images/aceite_2t.png' }
    @{ keys=@('BIMETALICO PARA NEVERAS'); cat='BIMETALICOS'; img='images/bimetalico_nevera.png' }
    @{ keys=@('FILTRO SECADOR'); cat='FILTROS'; img='images/filtro_secador.png' }
    @{ keys=@('MANGUERA DE GAS'); cat='GASES'; img='images/manguera_gas.png' }
    @{ keys=@('ULTRA FLUSHING', 'ELIMINAD'); cat='SELLANTES'; img='images/limpiador.jpg' }
    @{ keys=@('PARRILLA'); cat='COCINA'; img='images/parrilla.png' }
    @{ keys=@('ASPA'); cat='MOTORES'; img='images/aspa.png' }
    @{ keys=@('POLEA'); cat='MOTORES'; img='images/polea.png' }
    @{ keys=@('LLAVE'); cat='GASES'; img='images/herramienta.jpg' }
    @{ keys=@('GOMA', 'O RING'); cat='ACCESORIOS'; img='images/goma.png' }
    @{ keys=@('TEIPE', 'TERMOENCOGIBLES'); cat='ACCESORIOS'; img='images/teipe.jpg' }
    @{ keys=@('CUCHILLA'); cat='ACCESORIOS'; img='images/cuchilla.jpg' }
    @{ keys=@('VASO'); cat='ACCESORIOS'; img='images/vaso.jpg' }
    @{ keys=@('CONTROL REMOTO'); cat='ELECTRONICA'; img='images/control_remoto.jpg' }
    @{ keys=@('CORREA'); cat='MOTORES'; img='images/correa.png' }
    @{ keys=@('FLUSHING', 'LIMPIAD'); cat='SELLANTES'; img='images/limpiador.jpg' }
    @{ keys=@('REJILLA'); cat='OTROS'; img='images/parrilla.png' }
    @{ keys=@('PERILLA', 'INTERRUPTOR', 'BOCINA', 'CARBON', 'CARBONES', 'PICO'); cat='OTROS'; img='images/accesorios.jpg' }
    # --------------------------------------------------------------------------

    @{ keys=@('CAPACITADOR','CAPACITOR'); cat='CAPACITORES'; img='images/capacitor.jpg' }
    @{ keys=@('BIMETALICO','BIMETALICOS'); cat='BIMETALICOS'; img='images/bimetalico.jpg' }
    @{ keys=@('TERMOSTATO','TERMICO','RETARDADOR'); cat='TERMOSTATOS'; img='images/termostato.jpg' }
    @{ keys=@('COMPRESOR'); cat='COMPRESORES'; img='images/compresor.jpg' }
    @{ keys=@('GAS','REFRIGERANTE'); cat='GASES'; img='images/gas.png' }
    @{ keys=@('RELOJ'); cat='RELOJES'; img='images/reloj.jpg' }
    @{ keys=@('ROLINERA','ROLINERS','ROLINER','ROLIENRA'); cat='ROLINERAS'; img='images/rolinera.jpg' }
    @{ keys=@('VARILLA','VARILLAS'); cat='VARILLAS'; img='images/varilla.jpg' }
    @{ keys=@('FILTRO'); cat='FILTROS'; img='images/filtro.jpg' }
    @{ keys=@('MANGUERA'); cat='MANGUERAS'; img='images/manguera.jpg' }
    @{ keys=@('ACEITE','ACITE'); cat='ACEITES'; img='images/aceite.jpg' }
    @{ keys=@('VALVULA'); cat='VALVULAS'; img='images/valvula.jpg' }
    @{ keys=@('CONTACTOR','CONTACTORES'); cat='CONTACTORES'; img='images/contactor.jpg' }
    @{ keys=@('PROTECTOR','PROTECTORES','RELE'); cat='PROTECTORES'; img='images/protector.png' }
    @{ keys=@('RESISTENCIA'); cat='RESISTENCIAS'; img='images/resistencia.jpg' }
    @{ keys=@('TARJETA','DISPLAY','CONTROL','SELECTOR'); cat='ELECTRONICA'; img='images/electronica.png' }
    @{ keys=@('MICROMOTOR','MOTOR','ASPA','POLEAS','CORREA','TRANSMISION'); cat='MOTORES'; img='images/motor.png' }
    @{ keys=@('TUBO','CODO','CONECTOR','ACOPLE','ROSCA','TAPA'); cat='TUBERIAS'; img='images/tubo.jpg' }
    @{ keys=@('SILICON','SILICONA','PASTA','PEGALO','PEGAS','LIMPIAD','DIELECT'); cat='SELLANTES'; img='images/sellante.png' }
    @{ keys=@('SOLDADURA'); cat='SOLDADURA'; img='images/varilla.jpg' }
    @{ keys=@('ARMAFLEX','GOMA','EMPACAD','JUNTA','ANILLO','SELLO','TEFL','AISLANTE'); cat='AISLANTES'; img='images/aislante.jpg' }
    @{ keys=@('PRESOSTATO','PRESON'); cat='PRESOSTATOS'; img='images/presostato.jpg' }
    @{ keys=@('TERMOMETRO','TERMOMETROS','VOLTIAMP'); cat='MEDICION'; img='images/medicion.jpg' }
    @{ keys=@('ABRAZADERA','TIRRAP','TORNILLO','TUERCA','PIN','PESO'); cat='ACCESORIOS'; img='images/accesorios.jpg' }
    @{ keys=@('KIT'); cat='KITS'; img='images/kit.jpg' }
    @{ keys=@('JUEGO'); cat='KITS'; img='images/kit.jpg' }
    @{ keys=@('BOMBA'); cat='BOMBAS'; img='images/motor.png' }
    @{ keys=@('BOYA'); cat='BOYAS'; img='images/boya.jpg' }
    @{ keys=@('HORNILLA','QUEMADOR','PARRILLA'); cat='COCINA'; img='images/cocina.png' }
    @{ keys=@('STAR'); cat='HERRAMIENTAS'; img='images/herramienta.jpg' }
)

function Get-Category($productName) {
    $upper = $productName.ToUpper()
    foreach ($entry in $categoryMap) {
        foreach ($key in $entry.keys) {
            if ($upper.Contains($key)) {
                return @{ cat=$entry.cat; img=$entry.img }
            }
        }
    }
    return @{ cat='OTROS'; img='images/generic.png' }
}

$products = @()
foreach ($row in $data) {
    $name = $row.Producto.Trim()
    if ([string]::IsNullOrWhiteSpace($name)) { continue }

    $priceStr = $row.'Costo Unit'.Trim() -replace '[^0-9.]',''
    $price = if ($priceStr -match '^\d+(\.\d+)?$') { [decimal]$priceStr } else { 0 }

    $catInfo = Get-Category($name)

    $products += [PSCustomObject]@{
        id    = $row.Codigo.Trim()
        name  = $name
        brand = $row.Marca.Trim()
        price = $price
        category = $catInfo.cat
        image = $catInfo.img
    }
}

$json = $products | ConvertTo-Json -Depth 5 -Compress
$js = "const productsData = $json;"
Set-Content -Path 'c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\data.js' -Value $js -Encoding UTF8
Write-Host "Generated $($products.Count) products"

# Print unique categories
$products | Select-Object -ExpandProperty category | Sort-Object -Unique | ForEach-Object { Write-Host $_ }
