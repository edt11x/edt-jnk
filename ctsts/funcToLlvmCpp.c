
// clang -emit-llvm -c funcToLlvmCpp.c -o foo.bytecode
// llc -march=cpp foo.bytecode -o foo.cpp

int addThree(int const val)
{
    return val + 3;
}

