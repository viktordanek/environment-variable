{ outputs = { self } : name : builtins.concatStringsSep "" [ "$" "{" ( builtins.toString name ) "}" ] ; }