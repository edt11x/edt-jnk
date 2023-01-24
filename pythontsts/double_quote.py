import re

string = "   asdf \"  \" asdf asdf \""
match_quote_quote_quote = re.compile("\"[^\"]+\"[^\"]+\"")
if match_quote_quote_quote.search(string):
    print "Found quote quote quote"
match_quote = re.compile("\"")
if match_quote.search(string):
    print "Found single quote"
match_quote_quote = re.compile("\"[^\"]+\"")
if match_quote_quote.search(string):
    print "Found double quote"
match_quote_space_quote = re.compile("\"\s+\"")
if match_quote_space_quote.search(string):
    print "Found quote space quote"

