# Aufgabe 1
## ntpdate:

Sets he local time by polling NTP (Network Time Protocol) servers. 
muss als root laufen, außer mit -q, da Clock nicht gesetzt wird.

```bash
ntpdate -q -d ntp1.hiz-saarland.de
ntpdig: querying 134.96.7.68 (ntp1.hiz-saarland.de)
org t1: ebd8d601.219cf000 rec t2: ebd8d601.33c5d908
xmt t3: ebd8d601.33cd5104 dst t4: ebd8d601.270f0000
org t1: 1747867521.131301 rec t2: 1747867521.202238
xmt t3: 1747867521.202352 dst t4: 1747867521.152573
rec-org t21: 0.070937  xmt-dst t34: 0.049779
2025-05-21 22:45:21.202351 (+0000) +0.060358 +/- 0.010579 ntp1.hiz-saarland.de 134.96.7.68 s2 no-leap

wir haben 4 Zeiten: org, rec, xmt, dst
org - origin time
rec - receive time 
xmt - Transmit Timestamp 
dst - destination timestamp 

Letzte Zeile : Zeit in UTC, Offset, und Fehlerquote

Die Unterschiede zwischen diesen Timestamps werden verwenden , um Round-Trip Zeiten zu berechnen
sowie, den Offset der locla clock mit der server clock zu bestimmen



```


-q: Query only – don't set the clock.

-d: Enable  the debugging mode, in which ntpdate will go through all
the steps, but not adjust the local clock and using an  unprivileged‐
  port.  Information useful for general debugging will also
be printed.

ntpdate -q ntp[1-3].hiz-saarland.de

ntpdate -q ptbtime[1-4].ptb.de

```shell
ntpdate -q ptbtime1.ptb.de
2025-05-21 22:57:16.849579 (+0000) -0.022671 +/- 0.013214 ptbtime1.ptb.de 192.53.103.108 s1 no-leap

-  22:57:16.849579 - aktuelle Zeit die gemeldet wurde
- -0.022671 - Offset der lokalen Uhr (- daher zu schnell)
- +/- 0.013214 - Fehlerquote
- ptbtime1.ptb.de 192.53.103.108 - Host Name und iP des abgefragten Hosts
- s1 - Stratum 1, hohe vertrauenswürdigkeit, no leap : keine Schaltsekunde


```




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



```shell

grep '/vereine/' fussball-tabelle.html | \ ## sucht nacht vereine in der html datei


sed -E 's/.*\/vereine\/([^\/]+)\/2025.*/\1/' | \  

- sed -E : extended regex
- Bevor /vereine/ kann alles stehen
- matched alles zwischen /vereine/ und /2025
- Rest wird ignored


capturing groups :
https://simpleregex.dev/capturing-groups/

- ([^\/]+) ist eine capturing group
- \1 ist der erste captured group
- \1 sagt sed dass es den ganzen match nur mit der ersten capturing group ersetzen soll


- Jetzt haben die Clubs noch Bindestriche im Namen

sed 's/-/ /g' | \

- g > globally, not just first match 
- syntax (s/old/new/)

nl -w1 -s'. '


nl : number lines 
-s :seperator zwischen einträgen : punkt und Leerzeichen 
- w1 : setzt die Breite auf 1

```


```shell
# KOMPLETTER COMMAND :

grep '/vereine/' fussball-tabelle.html | \
sed -E 's/.*\/vereine\/([^\/]+)\/2025.*/\1/' | \
sed 's/-/ /g' | \
nl -w1 -s'. '

```


  
  

  










