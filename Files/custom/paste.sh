#!/bin/bash
# WTF? https://patrickwu.space/2019/08/03/wsl-powershell-raster-font-problem/
oemcp=$(reg.exe query "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage" /v OEMCP 2>&1 | sed -n 3p | sed -e 's|\r||g' | grep -o '[[:digit:]]*')
chcp.com $oemcp > /dev/null
/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command Get-Clipboard | tr -d "\r" | sed -z "\$ s/\n\$//" | tmux load-buffer -
chcp.com 65001 > /dev/null
