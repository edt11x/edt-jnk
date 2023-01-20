#include <cstdio>
static thread_local struct X {
    int x;
    X() { puts("hi"); }
    ~X() { puts("bye"); }
} x;
int main() { x.x = 0; }

