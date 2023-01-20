
a.exe: FXStringTst.o FXString20.o FXString.o
	g++ -Wall FXStringTst.o FXString20.o FXString.o -o a.exe

FXStringTst.o : FXStringTst.cpp
	g++ -Wall -c -I. -I/cygdrive/c/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers FXStringTst.cpp

FXString20.o : FXString20.cpp FXString20.h 
	g++ -Wall -c -I. -I/cygdrive/c/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers FXString20.cpp

FXString.o : FXString.cpp FXString.h
	g++ -Wall -c -I. -I/cygdrive/c/Flight_Display/Development/Projects/Libraries/UtilToolBox/Headers FXString.cpp

