$excel = New-Object -ComObject Excel.Application
$excel.DisplayAlerts = $false
$excelPath = 'c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\1_4997305675664067156.xlsx'
$csvPath = 'c:\Users\Dell\.gemini\antigravity\scratch\repuestos-gr\data.csv'
$workbook = $excel.Workbooks.Open($excelPath)
$workbook.SaveAs($csvPath, 6) # 6 is xlCSV
$workbook.Close($false)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
Write-Host "Conversión completada."
