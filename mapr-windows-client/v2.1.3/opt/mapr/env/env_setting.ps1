# this script is used to set PATH for all environment
$environmentRegistryKey = "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"

# get the env path from current environment and remove all items start with "D:\opt\mapr"
$data = $env:path.split(";") | select-object -unique | Where-Object { !$_.contains("d:\opt\mapr")}
$new_path = $data -join ";"

# hadoop base ENV path
Write-Host "Prepare HADOOP_HOME"
[Environment]::SetEnvironmentVariable("HADOOP_HOME", "C:\opt\mapr\hadoop\hadoop-0.20.2", "Machine")
Write-Host "Prepare HADOOP_CMD"
[Environment]::SetEnvironmentVariable("HADOOP_CMD", "C:\opt\mapr\hadoop\hadoop-0.20.2\bin\hadoop.bat", "Machine")
Write-Host "Prepare JAVA_HOME"
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\opt\mapr\java", "Machine")
Write-Host "Prepare MAPR_HOME"
[Environment]::SetEnvironmentVariable("MAPR_HOME", "C:\opt\mapr", "Machine")
Write-Host "Prepare PIG_HOME"
[Environment]::SetEnvironmentVariable("PIG_HOME", "C:\opt\mapr\pig", "Machine")
Write-Host "Prepare HIVE_HOME"
[Environment]::SetEnvironmentVariable("HIVE_HOME", "C:\opt\mapr\hive-0.11.0", "Machine")

# hadoop bin
$hadoop_bin = "C:\opt\mapr\hadoop\hadoop-0.20.2\bin"

if (!$new_path.contains($hadoop_bin)) {
	$msg = "add " + $hadoop_bin + "to PATH"
	Write-Host $msg
	$new_path = $new_path + ";" + $hadoop_bin
	
	[Environment]::SetEnvironmentVariable("PATH", $new_path, "Machine")
} else {
	$msg = $hadoop_bin + " already exist in the current system."
	Write-Host $msg
}

# hadoop config
$hadoop_config = 'C:\opt\mapr\hadoop\hadoop-0.20.2\conf' 

if (!$new_path.contains($hadoop_config)) {
	$msg = "add " + $hadoop_config + " to PATH"
	Write-Host $msg
	$new_path = $new_path + ";" + $hadoop_config
	
	[Environment]::SetEnvironmentVariable("PATH", $new_path, "Machine")
} else {
	$msg = $hadoop_config + " already exist in the current system."
	Write-Host $msg
}

# pig bin
$pig_bin = "C:\opt\mapr\pig\bin" 

if (!$new_path.contains($pig_bin)) {
	$msg = "add " + $pig_bin + " to PATH"
	Write-Host $msg
	$new_Path = $new_path + ";" + $pig_bin
	
	[Environment]::SetEnvironmentVariable("PATH", $new_path, "Machine")
} else {
	$msg = $pig_bin + " already exist in the current system."
	Write-Host $msg
}

# hadoop native lib path
$hadoop_native = "C:\opt\mapr\hadoop\hadoop-0.20.2\lib\native\Windows_7-amd64-64"

if (!$new_path.contains($hadoop_native)) {
	$msg = "add " + $hadoop_native + " to PATH"
	Write-Host $msg
	$new_Path = $new_path + ";" + $hadoop_native
	
	[Environment]::SetEnvironmentVariable("PATH", $new_path, "Machine")
} else {
	$msg = $hadoop_native + " already exist in the current system."
	Write-Host $msg
}

# hive path
$hive_bin = "C:\opt\mapr\hive-0.11.0\bin"

if (!$new_path.contains($hive_bin)) {
	$msg = "add " + $hive_bin + " to PATH"
	Write-Host $msg
	$new_Path = $new_path + ";" + $hive_bin
	
	[Environment]::SetEnvironmentVariable("PATH", $new_path, "Machine")
} else {
	$msg = $hive_bin + " already exist in the current system."
	Write-Host $msg
}