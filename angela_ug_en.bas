' Angela Game ugBASIC porting by Marco "Marco's Retrobits" V., 2025. https://retrobits.itch.io/
' ugBASIC port of the Quick Basic version (angela4.bas) by Claudio Larini (http://claudiolarini.altervista.org/emul2.htm)
' of the well-known computer game originally coded for the Olivetti Programma 101.

_Start:

CLS
'----------------
' set variabili
'----------------

primapuntata = 0
reg_A = 0
reg_M = 0
reg_R = 0
reg_B1 = 0
reg_B2 = 0  :'b split
reg_C1 = 0
reg_C2 = 0  :'c split
reg_D1 = 0
reg = 0
temp = 0
avvx$ = " - "
p101x$ = " - "
puntx$ = " - "
isPuntataValida = TRUE
fine = 0
contarighe = 6


'   LOCATE 5, 1: PRINT "Avvers. P101 Punt.Totale"
'   LOCATE 22, 1: PRINT "Registri Simulati P101";
'   LOCATE 23, 1: PRINT "   A.   M.   R.   B.   B/   C.   C/   D.";

   DO
'     LOCATE 1, 1
     INPUT "Target"; reg_M
     IF reg_M < 30 OR reg_M > 100 THEN
'        LOCATE 20, 1: PRINT "META NON VALIDA: introdurre un numero tra 30 e 100."
PRINT "Invalid target: input a number between 30 and 100."
      ELSE
        EXIT :'DO
     ENDIF
   LOOP

'   LOCATE 24, 6: PRINT USING "###"; reg_M;
   '-----------------
   ' memorizza meta
   '-----------------
   val$ = "B1": GOSUB _Trasf
'   LOCATE 24, 16: PRINT USING "####"; reg_B1;
   '-----------------
   ' interlinea
   ' cancella totale
   '-----------------
   val$ = "B2": GOSUB _Azzera
   '-----------------
   ' ultima puntata della P101 = meta (> 6): serve per avere
   ' prima puntata di A <> puntata prec. P anche se la prima
   ' puntata di A e' vuota
   '------------------
   val$ = "C1": GOSUB _Trasf
   primapuntata = 1

REPEAT
_Reinit:
'   LOCATE 20, 1: PRINT SPACE$(79);
'   LOCATE 3, 1: INPUT "Puntata"; reg_M
INPUT "Your number"; reg_M
   reg_M = INT(reg_M)    :' rotella decimale a 0 --> solo interi

   IF (reg_M < 0 OR reg_M > 6) AND primapuntata = 1 THEN
'     LOCATE 20, 1: PRINT "PUNTATA NON VALIDA: reimpostare la puntata."
PRINT "Invalid number: must be between 0 and 6."
     GOTO _Reinit
   ENDIF

   IF (reg_M < 1 OR reg_M > 6) AND primapuntata = 0 THEN
'     LOCATE 20, 1: PRINT "PUNTATA NON VALIDA: reimpostare la puntata."
PRINT "Invalid number: must be between 1 and 6."
     GOTO _Reinit
   ENDIF

   primapuntata = 0
   GOSUB _RV2
   GOSUB _AggiungiRigaPunteggi
   IF fine = 0 THEN: GOSUB _ControlloFineGiocoP: ENDIF

UNTIL fine = 1:' principale

INPUT "Press Enter to play again"; val$
GOTO _Start

END

'---------------------------
' algoritmo vero e proprio
'---------------------------
_RV2:
  val$ = "D1": GOSUB _Trasf
  avvx$ = STR$(reg_D1)
  val$ = "C2": GOSUB _Azzera
  GOTO _RY1

_RV3:
  '-------------------------
  ' totalizza puntata A
  '-------------------------
  val$ = "B2": GOSUB _Rich
  val$ = "D1": GOSUB _Somma
  val$ = "B2": GOSUB _Scambio
  '--------------------
  ' stampa totale A
  '--------------------
  puntx$ = STR$(reg_B2)
  GOSUB _ControlloFineGiocoA: IF fine = 1 THEN: RETURN: ENDIF
  '-----------------------------------------------
  ' puntata P (diff. modulo 9 - memorizza prima e
  ' seconda scelta)
  '-----------------------------------------------
  val$ = "B1": GOSUB _Rich
  val$ = "B2": GOSUB _Sottr
  value = 9: GOSUB _ConstProgr
  val$ = "M": GOSUB _Div
  val$ = "R": GOSUB _Scambio
  IF reg_A > 0 THEN: GOTO _RV4: ENDIF
  '-----------------------------
  ' _Somma 9 a diff. se diff <=0
  '-----------------------------
  val$ = "M": GOSUB _Somma

_RV4:
   '---------------------------------
   ' memorizza prima e seconda scelta
   ' 1 in A e Diff in M
   '---------------------------------
   val$ = "A": GOSUB _Div
   '---------------------------------
   ' memorizza Diff come prima scelta
   '---------------------------------
   val$ = "C1": GOSUB _Trasf
   '-------------------------------------
   ' memorizza Diff+1 come seconda scelta
   '-------------------------------------
   val$ = "M": GOSUB _Somma
   val$ = "C2": GOSUB _Scambio
   '-------------------------------------
   ' modifica i valori di prima e seconda
   ' scelta 
   ' D = 3
   '-------------------------------------
   val$ = "C1": GOSUB _Rich
   value = 3: GOSUB _ConstProgr
   val$ = "M": GOSUB _Sottr
   GOSUB _ValAss
   '----------------
   ' se <> 3 prova 6
   '----------------
   IF reg_A > 0 THEN: GOTO _RW1: ENDIF
   '-------------------------------
   ' se = 3 prima scelta inalterata
   ' seconda scelta = 5
   '-------------------------------
   value = 5: GOSUB _ConstProgr
   val$ = "C2": GOSUB _Trasf
   GOTO _RY1
 
_RW1:
   '--------------------
   ' D = 6
   ' _Sottrai 3
   '--------------------
   val$ = "M": GOSUB _Sottr
   IF reg_A > 0 THEN: GOTO _RW2: ENDIF
   GOSUB _ValAss
   '-------------------------
   ' se < 6 controlla puntata
   '--------------------------
   IF reg_A > 0 THEN: GOTO _RY1: ENDIF
   '---------------------------------
   ' se = 6 prima scelta inalterata
   ' seconda scelta = 3
   '---------------------------------
   '---------------------------------
   val$ = "C2": GOSUB _Trasf
   GOTO _RY1

_RW2:
   '--------------------
   ' D = 7
   '--------------------
   value = 1: GOSUB _ConstProgr
   val$ = "M": GOSUB _Sottr
   IF reg_A > 0 THEN: GOTO _RW3: ENDIF
   '--------------------
   ' seconda scelta = 1
   '--------------------
   val$ = "C2": GOSUB _Trasf
   '--------------------
   ' prima scelta = 3
   '--------------------
   value = 3: GOSUB _ConstProgr
   val$ = "C1": GOSUB _Trasf
   GOTO _RY1

_RW3:
   '--------------------
   ' D = 8
   '--------------------
   val$ = "M": GOSUB _Sottr
   IF reg_A > 0 THEN: GOTO _RW4: ENDIF
   '--------------------
   ' seconda scelta = 1
   '--------------------
   val$ = "C2": GOSUB _Trasf
   '--------------------
   ' prima scelta = 4
   '--------------------
   value = 4: GOSUB _ConstProgr
   val$ = "C1": GOSUB _Trasf
   GOTO _RY1

_RW4:
   '--------------------
   ' D = 9
   '--------------------
   val$ = "M": GOSUB _Sottr
   '--------------------
   ' sicuramente = 9
   ' prima scelta = 1
   '--------------------
   val$ = "C1": GOSUB _Trasf
   '--------------------
   ' seconda scelta = 2
   '--------------------
   val$ = "M": GOSUB _Somma
   val$ = "M": GOSUB _Somma
   val$ = "C2": GOSUB _Scambio
'''''''GOTO _RY1

_RY1:
   '-------------------------
   ' controlla puntata A o P
   '-------------------------
   val$ = "D1": GOSUB _Rich
   val$ = "C1": GOSUB _Sottr
   GOSUB _ValAss
   '---------------------------------
   ' se A <> P controlla complemento
   '---------------------------------
   IF reg_A > 0 THEN: GOTO _RY2: ENDIF
   GOTO _RY3

_RY2:
   '-------------------
   ' complemento A - P
   '-------------------
   value = 7: GOSUB _ConstProgr
   val$ = "M": GOSUB _Rich
   val$ = "D1": GOSUB _Sottr
   val$ = "C1": GOSUB _Sottr
   GOSUB _ValAss
   '-----------------------------------
   ' se compl A - P verifica Dev A - P
   '-----------------------------------
   IF reg_A > 0 THEN: GOTO _RZ1: ENDIF
'''''''GOTO _RY3

_RY3:
   '-------------------------------------------
   ' bloccca puntata A o definisce prima e
   ' seconda scelta (primo sondaggio Dev A - P)
   '-------------------------------------------
   val$ = "C2": GOSUB _Rich
   '-------------------------------------------
   ' se Dev |A - P| = P esegui seconda scelta
   '-------------------------------------------
   IF reg_A > 0 THEN: GOTO _RY4: ENDIF
   '------------------------------------------------
   ' se Dev |A - P| = A segnala puntata A non valida
   '------------------------------------------------
'   LOCATE 20, 1: PRINT "NON BARARE. Reimpostare la puntata."
PRINT "Don't cheat. Choose a valid number."
   isPuntataValida = FALSE: RETURN

_RY4:
   '----------------------
   ' seconda scelta in C1
   '----------------------
   val$ = "C1": GOSUB _Scambio

_RZ1:
   val$ = "C2": GOSUB _Rich
   IF reg_A > 0 THEN: GOTO _RZ2: ENDIF
   GOTO _RV3

_RZ2:
   val$ = "B1": GOSUB _Rich
   val$ = "B2": GOSUB _Sottr
   value = 2: GOSUB _ConstProgr
   val$ = "M": GOSUB _Sottr
   IF reg_A > 0 THEN: GOTO _RZ3: ENDIF
   val$ = "D1": GOSUB _Rich
   val$ = "M": GOSUB _Sottr
   GOSUB _ValAss
   IF reg_A > 0 THEN: GOTO _RZ3: ENDIF
   value = 1: GOSUB _ConstProgr
   val$ = "C1": GOSUB _Trasf
'''''''GOTO _RZ3

_RZ3:
   p101x$ = STR$(reg_C1)
   val$ = "B2": GOSUB _Rich
   val$ = "C1": GOSUB _Somma
   val$ = "B2": GOSUB _Scambio
   puntx$ = STR$(reg_B2)
RETURN


_ControlloFineGiocoA:
fine = 0
val$ = "B1": GOSUB _Rich
val$ = "B2": GOSUB _Sottr
'IF reg_A = 0 THEN: LOCATE 20, 1: PRINT "HAI VINTO."; : fine = 1: ENDIF
'IF reg_A < 0 THEN: LOCATE 20, 1: PRINT "HAI PERSO."; : fine = 1: ENDIF
IF reg_A = 0 THEN: PRINT "You win!": fine = 1: ENDIF
IF reg_A < 0 THEN: PRINT "You lose!": fine = 1: ENDIF
RETURN

_ControlloFineGiocoP:
fine = 0
val$ = "B1": GOSUB _Rich
val$ = "B2": GOSUB _Sottr
'IF reg_A = 0 THEN: LOCATE 20, 1: PRINT "HAI PERSO."; : fine = 1: ENDIF
'IF reg_A < 0 THEN: LOCATE 20, 1: PRINT "HAI VINTO."; : fine = 1: ENDIF
IF reg_A = 0 THEN: PRINT "You lose!": fine = 1: ENDIF
IF reg_A < 0 THEN: PRINT "You win!": fine = 1: ENDIF
RETURN

_AggiungiRigaPunteggi:
  IF isPuntataValida THEN
'     LOCATE contarighe, 1: PRINT USING "\ \    \ \    \ \"; avvx$; p101x$; puntx$
PRINT "You: ";avvx$;" P101: ";p101x$;" Sc: ";puntx$:
     contarighe = contarighe + 1
   ELSE
     isPuntataValida = TRUE
  ENDIF
  avvx$ = " - ": p101x$ = " - "
RETURN

'-----------------------------
' subroutine di emulazione
'-----------------------------
_Somma:
   GOSUB _ColE
   reg_M = reg
'   LOCATE 24, 6: PRINT USING "####"; reg_M;
   reg_A = reg_A + reg_M
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
RETURN


_Sottr:
   GOSUB _ColE
   reg_M = reg
'   LOCATE 24, 6: PRINT USING "####"; reg_M;
   reg_A = reg_A - reg_M
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
RETURN

_Molt:
   GOSUB _ColE
   reg_M = reg
'   LOCATE 24, 6: PRINT USING "####"; reg_M;
   reg_A = reg_A * reg_M
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
RETURN

_Div:
   temp = reg_A
   GOSUB _ColE
   reg_M = reg
'   LOCATE 24, 6: PRINT USING "####"; reg_M;
   reg_A = reg_A / reg_M
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
   reg_R = temp MOD reg_M
'   LOCATE 24, 11: PRINT USING "####"; reg_R;
RETURN

_Trasf:
   reg = reg_M
   GOSUB _ColU
   GOSUB _StampaReg
RETURN

_Rich:
   GOSUB _ColE
   reg_A = reg
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
RETURN

_Scambio:
   temp = reg_A
   GOSUB _ColE
   reg_A = reg
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
   reg = temp
   GOSUB _ColU
   GOSUB _StampaReg
RETURN

_ValAss:
   reg_A = ABS(reg_A)
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
RETURN

_ConstProgr:
   reg_M = value
'   LOCATE 24, 6: PRINT USING "####"; reg_M;
RETURN

_Azzera:
   reg = 0
   GOSUB _ColU
   GOSUB _StampaReg
RETURN

_ColE:
   SELECT CASE val$
      CASE "A": reg = reg_A
      CASE "M": reg = reg_M
      CASE "R": reg = reg_R
      CASE "B1": reg = reg_B1
      CASE "B2": reg = reg_B2
      CASE "C1": reg = reg_C1
      CASE "C2": reg = reg_C2
      CASE "D1": reg = reg_D1
   ENDSELECT
RETURN

_ColU:
   SELECT CASE val$
      CASE "A": reg_A = reg
      CASE "M": reg_M = reg
      CASE "R": reg_R = reg
      CASE "B1": reg_B1 = reg
      CASE "B2": reg_B2 = reg
      CASE "C1": reg_C1 = reg
      CASE "C2": reg_C2 = reg
      CASE "D1": reg_D1 = reg
   ENDSELECT
RETURN

_StampaReg:
'   LOCATE 24, 1: PRINT USING "####"; reg_A;
'   LOCATE 24, 6: PRINT USING "####"; reg_M;
'   LOCATE 24, 11: PRINT USING "####"; reg_R;
'   LOCATE 24, 16: PRINT USING "####"; reg_B1;
'   LOCATE 24, 21: PRINT USING "####"; reg_B2;
'   LOCATE 24, 26: PRINT USING "####"; reg_C1;
'   LOCATE 24, 31: PRINT USING "####"; reg_C2;
'   LOCATE 24, 36: PRINT USING "####"; reg_D1;
RETURN

