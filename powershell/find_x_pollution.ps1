# run via powershell -noexit "& ""r:\tools\edt\find_x_pollution.ps1"""
get-childitem -literalpath x:\ -recurse | foreach-object { if ( ($_ | get-acl).owner -eq "LMDS\thompson_e" ) { Write-Output $_; } }

