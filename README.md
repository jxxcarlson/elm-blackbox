# Elm-blackbox

Elm-blackbox provides a repl for talking to Elm code
(the black box) that takes a string as input and produces a string
as output. You determine what the repl does by importing
a function

```elm
    Blackbox.transform : String -> String
```

in module `Main`.   Below are three examples of what one can do
with this setup.

### Counting words

Suppose we import `Wordcount` as `Blackbox`:

```elm
import Wordcount as Blackbox
```

Then the repl acts like an implementation  of Unix `wc`:


```bash
    $ elm-bb

    > foo bar
    1, 2, 7

    > :get src/repl.js
    42, 97, 863
```

Note that `elm-bb` is the command you use start the repl.


### Factoring integers

If you say `import Factor as Blackbox`, the repl will factor integers into primes.

```bash
    $ elm-bb

    > 1234567
    9721, 127

    > 293
    293
```

### Statistics

The Statistics black box is more elaborate.  See *Statistics.md*.

## Make elm-bb work for you

Changing what the `elm-bb` command does is as
simple as changing black boxes and recompiling.
Just make sure that you import your module as `Blackbox` and that it exposes
a `transform` function as above, and also a string `helpText`.


## Compilation

**Prerequisite:** you must have `node.js` installed

To compile `elm-bb`, run `sh make.sh`.  To use your build locally,
run `node src/elm.repl`.

If you use npm, you can compile with `npm run build` and run locally with `npm start`


## Linking

To link to the global command  `elm-bb`, edit `PATH_TO` in the `link` script
of `package.json`, then say `npm run link`.  Or just paste the link command
into the terminal:

```bash
ln -s PATH_TO/src/repl.js /usr/local/bin/elm-bb
```

## Note on help and system commands

Here is what happens with the default installation:

```bash
$ elm-bb

Type ':help' for help

> :help
Commands:

   :help             help
   :get FILE         load FILE into memory, apply BlackBox.transform to it
   :show             show contents of memory
   :head             first five lines of memory
   :tail             last five lines of memory
   :mem              apply BlackBox.transform to the contents of memory

   STRING            apply BlackBox.transform to STRING

...
```

The commands `:help`, `:get`, `:show`, `:head`, `:tail`, and `:mem` are
defined in `Main.elm` and so are available regardless of what you use for the
black box.  Comments (lines beginning with '#') are stripped out of the
contents of memory before `Blackbox.transform` is applied.

## Advanced (hackish) usage  

There are some hooks in `Main.elm` for passing pseudo-arguments to the black box.
Since a black box only accepts strings, the idea is to send a string of the form

```
    INPUT = :CMD ARG1 ARG2 ... \nREST_OF_INPUT  
```

INPUT is separated into

```
   CMD_STRING = CMD ARG1 ARG2
```

and

```
    DATA = REST_OF_INPUT
```

The leading colon singles out INPUT for special handling.  As an example
of this feature, see the `Statistics` black box.  I am of mixed opinion
on the wisdom of this approach.  On the one hand, it enables one to build
more complex apps with black boxes that do nothing more than receive strings,
compute, and send strings back.  On the other hand, it is definitely hackish.

In this experiment I wanted to see how far I could get with this simple model.  It is
definitely OK for some applications. One can always design a `repl.js` and a `Main.elm`
that exchange a more complex data structure.

The args feature does not complicate `Main.elm` too much and can be ignored if it is not needed.
