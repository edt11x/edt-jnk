
typedef void * void_ptr, void_type;

char a[] = "abcdef\n";


main() {
char *b;
void_ptr c;
void_type *d;


    b = &a[0];
    c = b;
    b = c;
    printf(b);
    printf(c);

    d = b;
    b = d;
    printf(b);
    printf(d);

}

