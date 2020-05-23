
# The Statistics black box

If you say `import Statistics as Blackbox`, the repl will compute statistics

```bash
    $ elm-bb
    > 1 2 3
    3 data points, mean = 2, stdev = 1

    > :get data1.txt

    362 data points
    mean = 16.393, stdev = 10.681
    max = 35.6, min = -11.1

    > :head
    # Maximum daily temperatures for New York City, 2019
    # Source: https://www.climate.gov/maps-data/dataset/past-weather-zip-code-data-table
    11.7
    12.8
    3.3

    > :get w.csv column=5:csv

    362 data points
    mean = 16.393, stdev = 10.681
    max = 35.6, min = -11.1

    > :calc column=6:csv

    362 data points
    mean = 6.066, stdev = 9.695
    max = 25, min = -18.3

    > :get w.csv regression column=5:csv column=6:csv

    m = 0.853, b = -7.915, r2 = 0.867    
```

The file `data1.txt` contains temperature data as a single column. Note the
result of the `:head` command.  The first two lines of the
file are comments explaining the nature of the data. Comments
in this form are stripped out before processing.  Data elements can be
separated by any combination of spaces, commas, and newlines.

## Test files

The  files `data2.txt` and `data2.csv` have two columns of data. In the first,
items in a row are separated by spaces.  In the second, they are separated
by commas.  The file `w.csv` contains temperature data from NOAA.
