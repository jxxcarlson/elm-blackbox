# Elm-bb

Elm-bb provides a repl for talking to Elm code
that takes a string as input and produces a string
as output. You determine what the repl does by defining
a function

```elm
    Blackbox.transform : String -> String
```

which you import in module `Main` like this:

```elm
import Wordcount as Blackbox
```

If `Wordcount` is the imported module, the repl
acts like an implementation  of Unix `wc`:


```bash
    $ elm-bb

    > foo bar
    1, 2, 7

    > :get src/repl.js
    42, 97, 863
```
On the other hand, if you say `import Factor as Blackbox`,
the repl will factor integers into primes.

```bash
    $ elm-bb

    > 1234567
    9721, 127

    > 293
    293
```

# Making elm-bb work for you

To make `elm-repl` work for you, write  module that exports
a `transform` function as above, and also a string `helpText`.
Here is what happens with the default installation:

```elm  
$ elm-bb

Type ':help' for help

> :help
Commands:

   :help             help
   :get FILE         load FILE into memory, apply BlackBox.transform to it
   :show             show contents of memory
   :app              apply BlackBox.transform to the contents of memory

   STRING            apply BlackBox.transform to STRING

Example using the default BlackBox ...
```

## Compilation

To compile `elm-bb` just run `sh makes.sh`.  To test it locally,
run `node src/elm.repl`.

If you use npm, compile with `npm run build` and test locally with `npm start`


## Linking

To link to the global command  `elm-bb`, edit `PATH_TO` in the `link` script
of `package.json`, then run `npm link`.  Or just paste the link command
into the terminal.
