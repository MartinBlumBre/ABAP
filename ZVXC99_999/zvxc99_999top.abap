*&---------------------------------------------------------------------*
*&  Include           ZVXC99_999TOP
*&---------------------------------------------------------------------*
*& 1x Programm
*&   Kopiervorlage für Korrekturprogramme
*&---------------------------------------------------------------------*

 REPORT zvxc99_999 MESSAGE-ID zv01.

 DATA: gs_xcakt TYPE zva_xcakt.

* Makrodefinitionen
 DEFINE msg.
   message id &1 type &2 number &3 with &4 &5 &6 &7 into mv_msgtext.
   move-corresponding syst to ms_log_msg.
   call function 'BAL_LOG_MSG_ADD'
     exporting
       i_log_handle = mv_log_handle
       i_s_msg      = ms_log_msg
     exceptions
       others       = 0.
 END-OF-DEFINITION.

* Selektionsbild
 SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
 SELECT-OPTIONS: s_xcode FOR gs_xcakt-xcode NO INTERVALS.
 SELECTION-SCREEN END OF BLOCK b1.
 SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
 PARAMETERS: p_test TYPE c AS CHECKBOX DEFAULT 'X'.
 PARAMETERS: p_logs TYPE c AS CHECKBOX DEFAULT ' '.
 SELECTION-SCREEN COMMENT /2(50) text-003.
 SELECTION-SCREEN END OF BLOCK b2.
 PARAMETERS: p_anzcom TYPE i DEFAULT 500.
 PARAMETERS: p_anzrow TYPE i DEFAULT 250000.