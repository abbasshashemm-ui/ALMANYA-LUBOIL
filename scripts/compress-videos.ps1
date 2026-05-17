$ErrorActionPreference = 'Stop'
$ffmpeg = 'C:\Users\abbas\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.1-full_build\bin\ffmpeg.exe'
$assets = Join-Path $PSScriptRoot '..\assets'

function Compress-Video($name, $maxWidth, $targetKbps) {
    $input = Join-Path $assets $name
    $output = Join-Path $assets ($name -replace '\.webm$', '-compressed.webm')
    $maxrate = "${targetKbps}k"
    $bufsize = "$([int]($targetKbps * 1.5))k"

    Write-Host "Compressing $name ..."
    & $ffmpeg -y -hide_banner -loglevel error -i $input -an `
        -vf "scale='min($maxWidth,iw)':-2,fps=30" `
        -c:v libvpx -deadline good -cpu-used 4 `
        -b:v $maxrate -maxrate $maxrate -bufsize $bufsize `
        -auto-alt-ref 1 -lag-in-frames 16 `
        $output

    if (-not (Test-Path $output)) { throw "Failed to create $output" }
    $oldMb = [math]::Round((Get-Item $input).Length / 1MB, 2)
    $newMb = [math]::Round((Get-Item $output).Length / 1MB, 2)
    Write-Host "$name : ${oldMb} MB -> ${newMb} MB"
    Move-Item -Force $output $input
}

Compress-Video 'main.webm' 1280 900
Compress-Video 'truck.webm' 1280 600
Compress-Video 'factory.webm' 1280 600
Write-Host 'Done.'
