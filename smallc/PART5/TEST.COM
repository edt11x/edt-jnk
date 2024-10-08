1> ���͆��
����e����e��L�  �N�9�M�H�: � �W=2 �a: ��W<2 �a� �������*  "v"�  � 7ʃ�  7?������!�ʹ: _ !�^#V�~� ʪʹÞ!�ʹ����~#� ��_� �ôY8 Press p{PgUp}q, p{PgDn}q, or p{End}q E �al� 		Welcome to pZ80MU Professionalq!
 
 This is a CP/M program running on your IBM PC! It is able to run only because
 pZ80MU Professionalq is running in your PC, and emulating everything that CP/M
 itself would do. Every instruction within this CP/M program is being emulated
 in software by pZ80MUq. This CP/M program has no idea that it isn't running
 on a real CP/M system.
 
 This is pnotq a demonstration version of pZ80MUq. It is a fully-functional version
 of the product, which must be licensed before it may be used. The startup
 screen gives licensing information.
 
 You may page through these instructions by pressing the PC's p{PgUp}q or p{PgDn}q
 keys. When you are ready to exit this CP/M program and proceed with pZ80MUq
 itself, press the PC's p{End}q key.
 
 Pressing p{Alt-Q}q (or typing in the command "QUIT") in response to pZ80MUq's
 prompt will quit pZ80MUq and return you to DOS.
  		pMoving CP/M Files to PC Disksq
 
 Before you can run a CP/M program under pZ80MU Professionalq, you must get
 that CP/M program (and all of its associated files) onto the PC. This can be
 a difficult process.
 
 If you are a registered user of pZ80MU Professionalq, then we will be happy
 to help you with this difficult step.
 
 If you are pnotq a registered user, then I'm afraid that you are on
 your own...
 
 Fred Cisin at XenoSoft has created a product called pXenoCopy-PCq which may
 be able to convert your CP/M files to PC files. Contact him to be sure:
 
 	Fred Cisin
 	XenoSoft
 	2210 Sixth Street
 	Berkeley, Calif 94710
 	(415) 644-9366
  		pRunning CP/M Programs under Z80MU Professionalq
 
 Once you have moved your CP/M files to the PC, copy them to the same DOS
 directory which holds this version of pZ80MU Professionalq (or else into
 one of the directories specified by the "CPMPATH" environment variable).
 
 Start pZ80MUq. Once you are at the pZ80MUq prompt, then just pretend that
 you're in CP/M, and run your program as you would on any CP/M system.
 
 You may need to run an install program to configure your CP/M program for
 a particular terminal. If this is true for your particular program, then
 install your program to use a Heath H19 terminal, because that's what pZ80MUq
 is currently configured to emulate. If your CP/M program can't be configured
 for this type of terminal, then use pZ80MUq's "SET_TERM" command to make pZ80MUq
 emulate a Kaypro, Osborne, or Televideo 950 terminal.
 
 Your executing CP/M program may use all CP/M functions, except for a few
 low-level functions which assume specific disk formats.
  		pFeatures of Z80MU Professionalq
 
 Builtin terminal emulations: H19, Kaypro, Osborne, Televideo 950, Raw
 Full SUBMIT file support, with argument substitution
 Interactive full-screen CP/M memory examine and patch, in HEX or ASCII
 Interactive full-screen debugger
 Interactive full-screen disassembler
 Full-screen online HELP screens
 pExceedinglyq accurate CP/M 2.2 emulation
 
 Choice of two CP/M CPU chips:
 
 	- pExceedinglyq accurate Z80 software emulation
 	- 8080 hardware mode (and speed!) courtesy of NEC V20/V30 chips
 
 Optional CCP to allow WORDSTAR's SPELSTAR (and BDS C) to work
 CP/M command line keyboard macro expansion
 CP/M command recall and edit
 Full RESOURCE capability to produce source code from object code
 Z80 IN and OUT addresses mapped to PC I/O addresses
 Assign CP/M's RDR, PUN, and LIST to the PC's COM: or LPT: ports
  		pNotice to Techy Heavyweightsq
 
 pZ80MUq contains a DEBUG and RESOURCE facility which has to be seen to be
 believed. You can press p^BREAKq and interrupt the executing Z80 program
 at just about any point. You can then issue pZ80MUq's "DEBUG" command to enter
 the debugger. Try it...
 
 To see the power of the RESOURCE facility, type in the following pZ80MUq commands:
 	read test.com
 	dissam 100		<--- Note: no symbols appear
 	submit test.sym		<--- Note: load symbols
 	dissam 100		<--- Note: source code appears!
 
  y it...
 
 To see the power of the RESOURCE facility, type in the following pZ80MUq commands:
 	read test.com
 	dissam 100		<--- Note: no symbols appear
 	submit test.sym		<--- Note: load symbols
 	dissam 100		<--- Note: source code appears!
 
                                                                                                                           