param(
  [Parameter(Mandatory=$true)]
  [string]$ProcessName
)

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
  [DllImport("user32.dll")]
  public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")]
  public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

$process = Get-Process $ProcessName -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowHandle -ne 0} | Select-Object -First 1

if ($process) {
  [Win32]::ShowWindow($process.MainWindowHandle, 3) # 3 = SW_MAXIMIZE, 9 = SW_RESTORE (shows as windowed)
  [Win32]::SetForegroundWindow($process.MainWindowHandle)
}

