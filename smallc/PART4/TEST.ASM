;* * *  Small-C/Plus  Version 1.00  * * *
;       Cain, Van Zandt, Hendrix, Yorston
;       25th February 1988
;
	LD HL,(6)
	LD SP,HL
	CALL ccgo
	CALL qmain
	CALL qexit
qinfile:	DEFS 2
	global qinfile
qoutfile:	DEFS 2
	global qoutfile
qbuf:	DEFS 80
	global qbuf
qchr:	DEFS 1
	global qchr
qa:	DEFS 2
	global qa
qb:	DEFS 2
	global qb
qc:	DEFS 2
	global qc
qd:	DEFS 2
	global qd
qline:	DEFS 2
	global qline
qe:	DEFS 6
	global qe
qf:	DEFS 6
	global qf
	global qmain
qmain:
	global qprintf
	LD HL,cc1+0
	PUSH HL
	LD A,1
	CALL qprintf
	POP BC
	LD HL,cc1+14
	PUSH HL
	LD HL,-1
	PUSH HL
	LD A,2
	CALL qprintf
	POP BC
	POP BC
	LD HL,cc1+23
	PUSH HL
	LD HL,-1
	PUSH HL
	LD A,2
	CALL qprintf
	POP BC
	POP BC
	LD HL,cc1+32
	PUSH HL
	LD HL,cc1+41
	PUSH HL
	LD A,2
	CALL qprintf
	POP BC
	POP BC
	LD HL,cc1+47
	PUSH HL
	LD HL,65
	PUSH HL
	LD A,2
	CALL qprintf
	POP BC
	POP BC
	global qputs
	LD HL,cc1+56
	PUSH HL
	CALL qputs
	POP BC
	global qgets
	LD HL,qbuf
	P