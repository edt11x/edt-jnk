;* * *  Small-C/Plus  Version 1.00  * * *
;       Cain, Van Zandt, Hendrix, Yorston
;       25th February 1988
;
	LD HL,(6)
	LD SP,HL
	CALL ccgo
	CALL qmain
	CALL qexit
	global qmain
qmain:
	global qprintf
	LD HL,cc1+0
	PUSH HL
	LD A,1
	CALL qprintf
	POP BC
	RET
cc1:	DEFB 104,101,108,108,111,32,119,111,114,108
	DEFB 100,13,0

; --- End of Compilation ---
