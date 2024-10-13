{
    inputs = { } ;
    outputs = { self } : { lib = name : builtins.concatStringsSep "" [ "$" "{" ( builtins.toString name ) "}" ] ; } ;
}