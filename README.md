# Angela Game ugBASIC (angela-ug)
ugBASIC port of the [Quick Basic version (angela4.bas) by Claudio Larini](http://claudiolarini.altervista.org/emul2.htm) of Angela Game, the well-known computer game originally coded for the Olivetti Programma 101.

## History
New York, 1965.
At the B.E.M.A. (Business Equipment Manufacturers Association), visitors’ attention is drawn to a small machine exhibited at the Olivetti booth. It is the Programma 101, also known as the P101 or Perottina: the first desktop computer in history.
Among the demonstration programs shown to the amazed audience, a game could not be missing: Angela Game.

## The rules
The rules are simple, but winning isn't easy at all:
* You set a number to reach (target)
* You choose a number from 1 to 6
  (only the first time, you can choose 0 if you want the computer to play first)
* The computer does the same
* The chosen numbers are added together, contributing to the progress towards the target
* You cannot play the same number as your opponent nor its complement to 7 (e.g. 1/6, 2/5, 3/4)
* The winner is the player that exactly reaches the target, or forces the opponent to exceed it

## The ugBASIC port
Inspired by the [Applesoft Basic port](https://www.applefritter.com/content/angela-game-porting-olivetti-programma-101-applesoft-basic), I ported the [QuickBasic version of Angela Game by Claudio Larini](http://claudiolarini.altervista.org/emul2.htm) to [ugBASIC](https://ugbasic.iwashere.eu/), thus making it available for many 8-bit homecomputers from the '80s.
Two versions are available:
* angela_ug_en.bas: simple console I/O, compatible with a greater number of target machines;
* angela_ug_V2.bas: enhanced version with better UI and the possibility to display the simulated P101 registers.
From the [project page on itch.io](https://retrobits.itch.io/angela-ug), you can download the versions for all supported computers: Sinclair ZX Spectrum, Amstrad CPC, MSX, Atari 8 bit, Commodore 64, TRS-80 CoCo 3, Olivetti Prodest PC 128, Thomson MO6.

