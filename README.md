# BlackBox

BlackBox provides a repl for talking to Elm code
that takes a string as input and produces a string
as output:

```elm
    transform : String -> String
```

The supplied `Blackbox.elm` file provides an uninteresting
`transform` function for demonstration purposes: it imitates
the Unix command `wc`.  You can modify the code of Blackbox
to make it do whatever you like — factor an integer into primes,
run an RPN calculator, compute statistics, etc.

## Example using the default BlackBox:

```
    $ npm install -g elm-bb
    $ elm-bb

    > :help                 # show help screen

    > foo bar               # apply transform to "foo bar" -- report lines, words, chars
    1, 2, 7

    > :get src/repl.js      # load file into memory and apply transform to it
    42, 97, 863

    > :app                  # apply transform to contents of memory
    42, 97, 863
```

To uninstall, run `npm uninstall elm-bb`.

## Running Blackbox from source

```bash
    $ sh make.sh  
    $ node src/repl.js
    > foo bar
    1, 2, 7
```

## Customizing

You can customize BlackBox as described below.

### Set-up

First, make a directory somewhere — let's call it bb.
Second, put the text below in a file `package.json`

```
{
  "name": "bb",
  "version": "1.0.0",
  "description": "",
  "main": "node_modules/.bin/elm-bb",
  "scripts": {
    "edit": "atom node_modules/elm-bb/src/BlackBox.elm",
    "build": "cd node_modules/elm-bb && sh make.sh",
    "elm-bb": "./node_modules/.bin/elm-bb"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "elm-bb": "^0.9.5 "
  }
}
```

If you wish, change 'atom' to your favorite editor.  Third, run `npm install`.
Test your installation with `npm run elm-bb`.

### Changing BlackBox

First, edit `./node_modules/elm-bb/src/Main.elm`.  If `package.json`
is configured to run your editor, you can say `npm run edit`.

Second, say `npm run build`.

You have now customized `elm-bb` and can test it with `npm run elm-bb`

### Linking

To install `elm-bb` as a system-wide command, do ........
