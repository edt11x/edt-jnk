/*
 * cc6.c - sixth part of Small-C/Plus compiler
 *         code generator
 */

#include <stdio.h>
#include <string.h>
#include "ccdefs.h"
#include "cclvalue.h"

extern char Banner[], Author[], Version[], Filename[] ;
extern int litlab, Zsp, mainflg, trace ;


/* Begin a comment line for the assembler */
comment()
{
	outbyte(';');
}

/* Put out assembler info before any code is generated */
header()
{
	comment();	outstr(Banner);		nl();
	comment();	outstr(Author);		nl();
	comment();	outstr(Version);	nl();
	comment();				nl();
	if ( trace ) {
		ol("global ccregis"); /* declare these */
		ol("global ccleavi"); /* tracing routine */
	}
	if ( mainflg ) {		/* do stuff needed for first */
		ol("LD HL,(6)");	/* set up stack */
		ol("LD SP,HL");
		callrts("ccgo");
			/* set default drive for CP/M */
		zcall("main");
			 /* call code generated by small-c */
		zcall("exit");
	}
	else {
		/* not main program, output module name */
		ot("module ");
		if ( Filename[1] == ':' )
			outstr(&Filename[2]);
		else
			outstr(Filename) ;
		nl();
	}
}

/* Print any assembler stuff needed after all code */
trailer()
{
	nl();
	comment();
	outstr(" --- End of Compilation ---\n");
}

/* Print out a name such that it won't annoy the assembler
 *	(by matching anything reserved, like opcodes.)
 */
outname(sname)
char *sname;
{
	int i ;

	outbyte('q');
	if ( strlen(sname) > ASMLEN ) {
		i = ASMLEN;
		while ( i-- )
			outbyte(raise(*sname++));
	}
	else
		outstr(sname);
}

/* Fetch a static memory cell into the primary register */
getmem(sym)
SYMBOL *sym ;
{
	if( sym->ident != POINTER && sym->type == CCHAR ) {
		ot("LD A,("); outname(sym->name);
		outstr(")\n");
		callrts("ccsxt");
	}
	else if( sym->ident != POINTER && sym->type == DOUBLE ) {
		address(sym->name);
		callrts("dload");
	}
	else {
		ot("LD HL,("); outname(sym->name); outstr(")\n");
	}
}

/* Fetch the address of the specified symbol */
/*	into the primary register */
getloc(sym, off)
SYMBOL *sym;
int off ;
{
	const(sym->offset.i - Zsp + off);
	ol("ADD HL,SP");
}

/* Store the primary register into the specified */
/*	static memory cell */
putmem(sym)
SYMBOL *sym;
{
	if( sym->ident != POINTER && sym->type == DOUBLE ) {
		address(sym->name);
		callrts("dstore");
	}
	else {
		if( sym->ident != POINTER && sym->type == CCHAR ) {
			ol("LD A,L");
			ot("LD (");
			outname(sym->name); outstr("),A\n");
		}
		else {
			ot("LD (");
			outname(sym->name); outstr("),HL\n");
		}
	}
}

/* Store the specified object type in the primary register */
/*	at the address on the top of the stack */
putstk(typeobj)
char typeobj;
{
	switch ( typeobj ) {
	case DOUBLE :
		mainpop();
		callrts("dstore");
		break ;
	case CCHAR :
		zpop();
		ol("LD A,L");
		ol("LD (DE),A");
		break ;	
	default :
		callrts("ccpint");
		Zsp += 2 ;
	}
}

/* store a two byte object in the primary register at TOS */
puttos()
{
	ol("POP BC");
	ol("PUSH HL");
}

/* store a two byte object in the primary register at 2nd TOS */
put2tos()
{
	ol("POP DE");
	puttos();
	ol("PUSH DE");
}


/*
 * loadargc - load accumulator with number of args
 *            no special treatment of n==0, as this
 *            should never arise for printf etc.
 */
loadargc(n)
int n;
{
	ot("LD A," ) ;
	outdec(n >> 1) ;
	nl();
}

/* Fetch the specified object type indirect through the */
/*	primary register into the primary register */
indirect(typeobj)
char typeobj;
{
	switch ( typeobj ) {
	case CCHAR :
		callrts("ccgchar");
		break ;
	case DOUBLE :
		callrts("dload");
		break ;
	default :
		callrts("ccgint");
	}
}

/* Swap the primary and secondary registers */
swap()
{
	ol("EX DE,HL");
}

/* Print partial instruction to get an immediate value */
/*	into the primary register */
immed()
{
	ot("LD HL,");
}

/* Print partial instruction to get an immediate value */
/*	into the secondary register */
immed2()
{
	ot("LD DE,");
}

/* Partial instruction to access literal */
immedlit()
{
	immed();
	printlabel(litlab);
	outbyte('+');
}


/* Push the primary register onto the stack */
zpush()
{
	ol("PUSH HL");
	Zsp -= 2;
}

/* Push the primary floating point register onto the stack */
dpush()
{
	callrts("dpush");
	Zsp -= 6;
}

/* Push the primary floating point register, preserving
	the top value  */
dpush2()
{
	callrts("dpush2");
	Zsp -= 6;
}

/* Pop the top of the stack into the primary register */
mainpop()
{
	ol("POP HL");
	Zsp += 2;
}

/* Pop the top of the stack into the secondary register */
zpop()
{
	ol("POP DE");
	Zsp += 2;
}

/* Swap the primary register and the top of the stack */
swapstk()
{
	ol("EX (SP),HL");
}

/* process switch statement */
sw()
{
	callrts("ccswitch");
}

/* Call the specified subroutine name */
zcall(sname)
char *sname;
{
	ot("CALL ");
	outname(sname);
	nl();
}

/* Call a run-time library routine */
callrts(sname)
char *sname;
{
	ot("CALL ");
	outstr(sname);
	nl();
}

/* Return from subroutine */
zret()
{
	ol("RET");
}

/*
 * Perform subroutine call to value on top of stack
 * Put arg count in A in case subroutine needs it
 */
callstk(n)
int n;
{
	loadargc(n) ;
	callrts( "ccdcal" ) ;
}

/* Jump to specified internal label number */
jump(label)
int label;
{
	ot("JP ");
	printlabel(label);
	nl();
}

/* Test the primary register and jump if false to label */
testjump(label)
int label;
{
	ol("LD A,H");
	ol("OR L");
	ot("JP Z,");
	printlabel(label);
	nl();
}

/* test primary register against zero and jump if false */
zerojump(oper, label, lval)
int (*oper)(), label ;
LVALUE *lval ;
{
	clearstage(lval->stage_add, 0) ;		/* purge conventional code */
	(*oper)(label) ;
}

/* Print pseudo-op to define a byte */
defbyte()
{
	ot("DEFB ");
}

/*Print pseudo-op to define storage */
defstorage()
{
	ot("DEFS ");
}

/* Print pseudo-op to define a word */
defword()
{
	ot("DEFW ");
}

/* Point to following object */
point()
{
	ol("DEFW $+2");
}

/* Modify the stack pointer to the new value indicated */
modstk(newsp,save)
int newsp;
int save ;		/* if true preserve contents of HL */
{
	int k;

	k = newsp - Zsp ;
	if ( k == 0 ) return newsp ;
	if ( k > 0 ) {
		if ( k < 7 ) {
			if ( k & 1 ) {
				ol("INC SP") ;
				--k ;
			}
			while ( k ) {
				ol("POP BC");
				k -= 2 ;
			}
			return newsp;
		}
	}
	if ( k < 0 ) {
		if ( k > -7 ) {
			if ( k & 1 ) {
				ol("DEC SP") ;
				++k ;
			}
			while ( k ) {
				ol("PUSH BC");
				k += 2 ;
			}
			return newsp;
		}
	}
	if ( save ) swap() ;
	const(k) ;
	ol("ADD HL,SP");
	ol("LD SP,HL");
	if ( save ) swap() ;
	return newsp ;
}

/* Multiply the primary register by the length of some variable */
scale(type, tag)
int type ;
TAG_SYMBOL *tag ;
{
	switch ( type ) {
	case CINT :
		doublereg() ;
		break ;
	case DOUBLE :
		sixreg() ;
		break ;
	case STRUCT :
		/* try to avoid multiplying if possible */
		switch (tag->size) {
		case 16 :
			doublereg() ;
		case 8 :
			doublereg() ;
		case 4 :
			doublereg() ;
		case 2 :
			doublereg() ;
			break ;
		case 12 :
			doublereg() ;
		case 6 :
			sixreg() ;
			break ;
		case 9 :
			threereg() ;
		case 3 :
			threereg() ;
			break ;
		case 15 :
			threereg() ;
		case 5 :
			fivereg() ;
			break ;
		case 10 :
			fivereg() ;
			doublereg() ;
			break ;
		case 14 :
			doublereg() ;
		case 7 :
			sixreg() ;
			addbc() ;	/* BC contains original value */
			break ;
		default :
			ol("PUSH DE") ;
			const2(tag->size) ;
			mult() ;
			ol("POP DE") ;
			break ;
		}
	}
}

/* add BC to the primary register */
addbc()
{
	ol("ADD HL,BC") ;
}

/* load BC from the primary register */
ldbc()
{
	ol("LD B,H") ;
	ol("LD C,L") ;
}

/* Double the primary register */
doublereg()
{
	ol("ADD HL,HL");
}

/* Multiply the primary register by three */
threereg()
{
	ldbc() ;
	addbc() ;
	addbc() ;
}

/* Multiply the primary register by five */
fivereg()
{
	ldbc() ;
	doublereg() ;
	doublereg() ;
	addbc() ;
}
	
/* Multiply the primary register by six */
sixreg()
{
	threereg() ;
	doublereg() ;
}

/* Add the primary and secondary registers (result in primary) */
zadd()
{
	ol("ADD HL,DE");
}

/* Add the primary floating point register to the
  value on the stack (under the return address)
  (result in primary) */
dadd()
{
	callrts("dadd") ;
	Zsp += 6 ;
}

/* Subtract the primary register from the secondary */
/*	(results in primary) */
zsub()
{
	callrts("ccsub");
}

/* Subtract the primary floating point register from the
  value on the stack (under the return address)
  (result in primary) */
dsub()
{
	callrts("dsub"); Zsp += 6;
}

/* Multiply the primary and secondary registers */
/*	(results in primary */
mult()
{
	callrts("ccmult");
}

/* Multiply the primary floating point register by the value
  on the stack (under the return address)
  (result in primary) */
dmul()
{
	callrts("dmul"); Zsp += 6;
}

/* Divide the secondary register by the primary */
/*	(quotient in primary, remainder in secondary) */
div()
{
	callrts("ccdiv");
}

/* Divide the value on the stack (under the return address)
  by the primary floating point register (quotient in primary) */
ddiv()
{
	callrts("ddiv"); Zsp += 6;
}

/* Compute remainder (mod) of secondary register divided
 *	by the primary
 *	(remainder in primary, quotient in secondary)
 */
zmod()
{
	div();
	swap();
}

/* Inclusive 'or' the primary and secondary */
/*	(results in primary) */
zor()
{
	callrts("ccor");
}

/* Exclusive 'or' the primary and secondary */
/*	(results in primary) */
zxor()
{
	callrts("ccxor");
}

/* 'And' the primary and secondary */
/*	(results in primary) */
zand()
{
	callrts("ccand");
}

/* Arithmetic shift right the secondary register number of */
/* 	times in primary (results in primary) */
asr()
{
	callrts("ccasr");
}

/* Arithmetic left shift the secondary register number of */
/*	times in primary (results in primary) */
asl()
{
	callrts("ccasl");
}

/* Form logical negation of primary register */
lneg()
{
	callrts("cclneg");
}

/* Form two's complement of primary register */
neg()
{
	callrts("ccneg");
}

/* Negate the primary floating point register */
dneg()
{
	callrts("minusfa");
}

/* Form one's complement of primary register */
com()
{
	callrts("cccom");
}

/* Increment the primary register by one */
inc()
{
	ol("INC HL");
}

/* Decrement the primary register by one */
dec()
{
	ol("DEC HL");
}

/* Following are the conditional operators */
/* They compare the secondary register against the primary */
/* and put a literal 1 in the primary if the condition is */
/* true, otherwise they clear the primary register */

/* Test for equal */
zeq()
{
	callrts("cceq");
}

/* test for equal to zero */
eq0(label)
int label ;
{
	ol("LD A,H") ;
	ol("OR L") ;
	ot("JP NZ,");
	printlabel(label) ;
	nl();
}

/* Test for not equal */
zne()
{
	callrts("ccne");
}

/* Test for less than (signed) */
zlt()
{
	callrts("cclt");
}

/* Test for less than zero */
lt0(label)
int label ;
{
	ol("XOR A") ;
	ol("OR H") ;
	ot("JP P,") ;
	printlabel(label) ;
	nl() ;
}

/* Test for less than or equal to (signed) */
zle()
{
	callrts("ccle");
}

/* Test for less than or equal to zero */
le0(label)
int label ;
{
	ol("LD A,H") ;
	ol("OR L");
	ol("JR Z,$+7");
	lt0(label);
}

/* Test for greater than (signed) */
zgt()
{
	callrts("ccgt");
}

/* test for greater than zero */
gt0(label)
int label ;
{
	ge0(label) ;
	ol("OR L");
	ot("JP Z,");
	printlabel(label);
	nl();
}

/* Test for greater than or equal to (signed) */
zge()
{
	callrts("ccge");
}

/* test for greater than or equal to zero */
ge0(label)
int label ;
{
	ol("XOR A") ;
	ol("OR H");
	ot("JP M,");
	printlabel(label);
	nl();
}

/* Test for less than (unsigned) */
ult()
{
	callrts("ccult");
}

/* Test for less than or equal to (unsigned) */
ule()
{
	callrts("ccule");
}

/* Test for greater than (unsigned) */
ugt()
{
	callrts("ccugt");
}

/* Test for greater than or equal to (unsigned) */
uge()
{
	callrts("ccuge");
}

/* The following conditional operations compare the
   top of the stack (TOS) against the primary floating point
   register (FA), resulting in 1 if true and 0 if false */

/* Test for floating equal */
deq()
{
	callrts("deq"); Zsp += 6;
}

/* Test for floating not equal */
dne()
{
	callrts("dne"); Zsp += 6;
}

/* Test for floating less than   (that is, TOS < FA)	*/
dlt()
{
	callrts("dlt"); Zsp += 6;
}

/* Test for floating less than or equal to */
dle()
{
	callrts("dle"); Zsp += 6;
}

/* Test for floating greater than */
dgt()
{
	callrts("dgt"); Zsp += 6;
}

/* Test for floating greater than or equal */
dge()
{
	callrts("dge"); Zsp += 6;
}

/*	<<<<<  End of Small-C/Plus compiler  >>>>>	*/
