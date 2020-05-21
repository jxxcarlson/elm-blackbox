# Elm-blackbox

Elm-blackbox provides a repl for talking to Elm code
(the black box) that takes a string as input and produces a string
as output. You determine what the repl does by importing
a function

```elm
    transform : String -> String
```

in module `Main`.  For example, if a `transform` function
is exposed by a module `Wordcount`, we say

```elm
import Wordcount as Blackbox
```
In this case, the repl acts like an implementation  of Unix `wc`:


```bash
    $ elm-bb

    > foo bar
    1, 2, 7

    > :get src/repl.js
    42, 97, 863
```

Note that `elm-bb` is the command you use start the repl.

On the other hand, if you say `import Factor as Blackbox`,
the repl will factor integers into primes.

```bash
    $ elm-bb

    > 1234567
    9721, 127

    > 293
    293
```

In a word, changing what the `elm-bb` command does is as
simple as changing black boxes and recompiling.

## Making elm-bb work for you

To make `elm-bb` work for you, write  a module that exposes
a `transform` function as above, and also a string `helpText`.
Then import your module as `Blackbox`.


## Compilation

**Prerequisite:** you must have `node.js` installed 

To compile `elm-bb` just run `sh make.sh`.  To use your build locally,
run `node src/elm.repl`.

If you use npm, you can compile with `npm run build` and run locally with `npm start`


## Linking

To link to the global command  `elm-bb`, edit `PATH_TO` in the `link` script
of `package.json`, then say `npm run link`.  Or just paste the link command
into the terminal.

## Note on help

Here is what happens with the default installation:

```bash
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
