#!/bin/sed -f -i.old

# write the sed command to remove single-line and multi-line comments
# but not delete those lines
#/\/\/\|\/\*\|\*\//! {p};  

#/\/\*/ {:a; x; s/\n$//g; x; /\*\//! {N;}; s/[\t ]*\/\*.*\*\/[\t ]*//g; Ta;s/\/\/.*//g;p;x; }
/\/\// {s|//.*||g;};  
## When multi-line comment is on single line, do not remove leading space or tab
/\/\*.*\*\// {s/\([ \t]*\)\/\*.*/\1/g;};
## When multi-line comment is on multiple lines, remove leading space or tab
/\/\*/ {:a; /\*\//! {x; s/$/\n/g; x;N;}; s/[ \t]*\/\*.*\*\/[ \t]*//g; Ta;p;x;N;s/\n//;s/\/\/.*//g; }
#w /dev/stderr
