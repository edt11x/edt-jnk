#!/usr/bin/perl
for ($i = 0; $i < 256; $i++)
{
    printf("%3d, ", $i);
    if ((($i + 1) % 16) == 0)
    {
        printf("\n");
    }
}

