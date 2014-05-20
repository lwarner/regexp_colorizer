regexp_colorizer
================

Colorize obscure strings in log files or other bodies of text, using XTerm / ANSI color sequences.

Currently only supports colorization of UUIDs (e.g. AD28F9DE-1565-4D75-A140-E28C9C5EF56F)

## Usage

```
./colorizer.pl [file ...]
```

Works with ANSI escape sequences (designed for terminal, not for web usage)

It will accept input from STDIN as well as files passed on the command line.

It uses the same color when it encounters a UUID a second time (i.e. each instance of a single UUID will be colored 
with the same combination of foreground and background colors.

## Example

```
tail -f /var/log/system.log | ./colorizer.pl
```
