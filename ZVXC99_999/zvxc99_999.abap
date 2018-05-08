*&---------------------------------------------------------------------*
*& Report  ZVXC99_999
*&
*&---------------------------------------------------------------------*
*& 1x Programm
*&   Kopiervorlage für Korrekturprogramme
*&---------------------------------------------------------------------*
*& erstellt von: Martin Blum, HANSA-FLEX AG            am: 31.08.16
*&---------------------------------------------------------------------*


INCLUDE zvxc99_999top.
INCLUDE zvxc99_999cld.     " ABAP-OO Klassendefinitionen
INCLUDE zvxc99_999cli.     " ABAP-OO Klassendimplementierung

AT SELECTION-SCREEN ON s_xcode.
  IF s_xcode IS NOT INITIAL.
    SELECT SINGLE * FROM vbak INTO gs_vbak
        WHERE vbeln IN s_vbeln.
    IF sy-subrc NE 0.
      MESSAGE e138.
    ENDIF.
  ENDIF.

* Verarbeitung
START-OF-SELECTION.
  IF p_anzrow = 0.
    MOVE 999999999 TO p_anzrow.
  ENDIF.
  CREATE OBJECT go_zvxc99_999.
  go_zvxc99_999->main( ).

  RETURN.
