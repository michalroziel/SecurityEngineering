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