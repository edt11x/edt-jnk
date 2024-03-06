# run via powershell -noexit "& ""r:\tools\edt\findthumbs.ps1"""
get-childitem -literalpath r:\ -recurse | foreach-object { if ( ($_ | get-acl).owner -eq "LMDS\thompson_e" -and [System.IO.Path]::GetFileNameWithoutExtension($_.Name) -eq "Thumbs" ) { Write-Output $_; } }

