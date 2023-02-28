# Update the version as needed.
$boost_version = '1.81.0'

$drive = 'C:'
$directory_name = 'boost_' + $boost_version.Replace('.', '_')
$archive_name = $directory_name + '.zip'
$boost_root_path = "$drive\boost"
$boost_directory_path = "$boost_root_path\$directory_name"
$boost_library_path = "$boost_directory_path\stage\lib"
$boost_archive_path = "$boost_root_path\$archive_name"
$download_url = "https://boostorg.jfrog.io/artifactory/main/release/$boost_version/source/$archive_name"
$bootstrap_script_path = "$boost_directory_path\bootstrap.bat"

Clear-Host

if (-Not (Test-Path -Path $boost_directory_path)) {
  Write-Output "$boost_directory_path does not exist. Creating ..."
  mkdir -p $boost_directory_path
  Write-Output "Created $boost_directory_path."

  Write-Output "Downloading $archive_name from $download_url, saving to $boost_archive_path ..."
  Invoke-WebRequest $download_url -OutFile $boost_archive_path
  Write-Output "Finished downloading $archive_name from $download_url to $boost_archive_path."

  Write-Output "Extracting $boost_archive_path to $boost_root_path"
  Expand-Archive $boost_archive_path -DestinationPath $boost_root_path
  Write-Output "Extracted $boost_archive_path to $boost_root_path"

  Write-Output "Deleting $boost_archive_path ..."
  Remove-Item -Path $boost_archive_path -Force
  Write-Output "Deleted $boost_archive_path."

  Push-Location $boost_directory_path

  Write-Output "Starting bootstrapping process ..."
  Start-Process -FilePath $bootstrap_script_path -Wait -NoNewWindow -PassThru
  Write-Output "Finished bootstrapping."
  Start-Sleep -Seconds 2
  Clear-Host

  Write-Output "Starting build process for Boost $boost_version ..."
  Start-Process -FilePath .\b2 -Wait -NoNewWindow -PassThru
  Write-Output "Built Boost $boost_version."
  Start-Sleep -Seconds 2
  Clear-Host

  Pop-Location
} else {
  Write-Output "$boost_directory_path already exists. Assuming it contains a valid installation of Boost $boost_version."
  Start-Sleep -Seconds 1
  Clear-Host
}

$build_dir = "$PSScriptRoot\build"

if (-Not (Test-Path -Path $build_dir)) {
  mkdir -p $build_dir
}

$cpu_count = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

Push-Location $build_dir
cmake -DCMAKE_BUILD_TYPE=Debug -DBOOST_VERSION_TO_USE="$boost_version" -DBOOST_ROOT="$boost_directory_path" -DBOOST_INCLUDEDIR="$boost_directory_path" -DBOOST_LIBRARYDIR="$boost_library_path" ..
cmake --build . --config Debug --parallel $cpu_count

if (-Not ($LASTEXITCODE -eq "0")) {
  Write-Output "cmake --build for Debug mode failed!"
  Pop-Location
  exit 1
}

Pop-Location
Push-Location $build_dir

cmake -DCMAKE_BUILD_TYPE=Release -DBOOST_VERSION_TO_USE="$boost_version" -DBOOST_ROOT="$boost_directory_path" -DBOOST_INCLUDEDIR="$boost_directory_path" -DBOOST_LIBRARYDIR="$boost_library_path" ..
cmake --build . --config Release --parallel $cpu_count

if (-Not ($LASTEXITCODE -eq "0")) {
  Write-Output "cmake --build for Release mode failed!"
  Pop-Location
  exit 1
}

Pop-Location
exit 0
