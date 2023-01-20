for ($i = 256; $i > 0; $i--)
{
    if (int(64*1024 / $i) * $i == (64*1024))
    {
        print "Good solution $i\n";
    }
}
