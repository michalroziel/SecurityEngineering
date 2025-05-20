# Aufgabe 1
## ntpdate:
-q: Query only – don't set the clock.

-d: Enable  the debugging mode, in which ntpdate will go through all
the steps, but not adjust the local clock and using an  unprivi‐
leged  port.  Information useful for general debugging will also
be printed.

ntpdate -q ntp[1-3].hiz-saarland.de

ntpdate -q ptbtime[1-4].ptb.de

https://www.ntppool.org/zone/europe

# Aufgabe 2 (Pipes in der Kommandozeile)

## diff - Kommando
```shell
diff -u Bundesliga\ Tabelle2\ 2024_2025.html Bundesliga\ Tabelle\ 2024_2025.html

--- Bundesliga Tabelle2 2024_2025.html  2025-05-19 22:42:24
+++ Bundesliga Tabelle 2024_2025.html   2025-05-19 22:39:57
@@ -458,7 +458,7 @@
         <div class="row">
             <div class="col-md-8 col-xs-12 content-statistik content-divider">

```
## egrep -n  Kommando

### -n :

>      -n, --line-number
             Each output line is preceded by its relative line number in the file, starting at line 1.  The line number
             counter is reset for each file processed.  This option is ignored if -c, -L, -l, or -q is specified.

``` shell
egrep -n "Bayern" fussball-tabelle.html
egrep -n "Bayern" fussball-tabelle.html | cut -c1
 > 2

 egrep -n "leverkusen" fussball-tabelle.html | cut -c1
  > 3

```








