BlackBox provides a repl for applying the function
BlackBox.transform to the input to the repl.

One has

```elm
    transform : String -> String
```

This function can do arbitrary work and is left to the
user's discretion, whimsy, and creativity. Here is a demo:

## Example using the default BlackBox:

```
    > :help          ## show help screen

    > foo
    Characters: 3

    > :get src/repl.js
    File contents stored

    > :app
    Characters: 842
```
