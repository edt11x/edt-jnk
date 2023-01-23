awk '
BEGIN {
     s="Serial0"
      gsub("[a-z]","",s)
       printf("s= ::%s::  should = ::S0::\n", s)
        exit
} '

