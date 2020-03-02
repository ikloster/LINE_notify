get-process | export-csv processes.csv
$p = import-CSV processes.csv
$p | out-gridview
