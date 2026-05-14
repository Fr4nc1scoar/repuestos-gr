$data = Import-Csv 'c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\data.csv'
$words = $data | ForEach-Object { ($_.Producto.Trim() -split ' ')[0].ToUpper() } | Sort-Object -Unique | Where-Object { $_ -ne '' }
$words
