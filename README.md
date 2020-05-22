# Elm-blackbox

Elm-blackbox provides a repl for talking to Elm code
(the black box) that takes a string as input and produces a string
as output. You determine what the repl does by importing
a function

```elm
    transform : String -> String
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


## Factoring integers

If you say `import Factor as Blackbox`, the repl will factor integers into primes.

```bash
    $ elm-bb

    > 1234567
    9721, 127

    > 293
    293
```

## Statistics

If you say `import Statistics as Blackbox`, the repl will compute statistics

```bash
    $ elm-bb
    > 1 2 3 4

    4 data points
    mean = 2.5, stdev = 1.291
    max = 4, min = 1

    > :get nyc2019.txt

    362 data points
    mean = 16.393, stdev = 10.681
    max = 35.6, min = -11.1

    > :head
    # Maximum daily Centigrade temperatures for New York City, 2019
    # Source: https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table
    11.7
    12.8
    3.3
```

The file `nyc2019.txt` contains temperature data. Note the
result of the `:head` command.  The first two lines of the
file are comments explaining the nature of the data. comments
in this form are stripped out before processing.  Data elements can be
separated by any combination of spaces, commas, and newlines.


## Make elm-bb work for you

Changing what the `elm-bb` command does is as
simple as changing black boxes and recompiling.
Just make sure that your imported module  exposes
a `transform` function as above, and also a string `helpText`.


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
   :head             first five lines of memory
   :tail             last five lines of memory
   :app              apply BlackBox.transform to the contents of memory

   STRING            apply BlackBox.transform to STRING

...
```

The commands `:help`, `:get`, `:show`, `:head`, `:tail`, and `:app` are
defined in `Main.elm` and so are available regardless of what you use for the
black box.
