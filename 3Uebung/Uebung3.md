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

## Stream–Editor sed:
#### Alle <th\> durch <td\> ersetzt und die </th\> durch </td\>  (Open und Closing tags)

```shell

sed -e "s:<th\>:<td\>:g" -e "s:</th>:</td>:g"<fussball-tabelle.html >fussball-tabelle2.html

```

### Beispiel sed :
```shell

sed -e "s:<th\>:<td\>:g" -e "s:</th>:</td>:g"<replace.html >replace2.html 
```




## diff - Kommando
```html

diff -u replace.html replace2.html                                                                                                                                          ─╯
--- replace.html        2025-05-21 13:20:31
+++ replace2.html       2025-05-21 13:20:54
@@ -1,7 +1,7 @@
 <table>
     <tr>
-        <th>Team</th>
-        <th>Punkte</th>
+        <td>Team</td>
+        <td>Punkte</td>
     </tr>
     <tr>
         <td>Bayern München</td>

```

## Suchen von Mustern: grep, fgrep, egrep

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








