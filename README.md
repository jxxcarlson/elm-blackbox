# BlackBox

BlackBox provides a repl for talking to Elm code
that takes a string as input and produces a string
as output:

```elm
    transform : String -> String
```

The supplied `Blackbox.elm` file provides an uninteresting
`transform` function for demonstration purposes.  You
can modify it with to make it do whatever you like — factor an integer into primes,
run an RPN calculator, compute statistics, etc.

## Example using the default BlackBox:

```
    > :help                 # show help screen

    > foo                   # apply transform to "foo"
    Characters: 3

    > :get src/repl.js      # load file into memory
    File contents stored

    > :app                  # apply transform to contents of memory
    Characters: 842
```

## Running Blackbox from source

```bash
    $ sh make.sh  
```

After compilation, do this

```bash
    $ node src/repl.js
```

## Installing via npm  

Run `npm -g install` to install the repl  
as `elm-bb`.  Then you can do

```bash
   $ elm-bb
   > foo
   Characters: 3
```

## Uninstalling

Run `npm uninstall`
