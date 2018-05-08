*&---------------------------------------------------------------------*
*&  Include           ZVXC99_999CLI
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lcl_zvxc99_999 IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_zvxc99_999 IMPLEMENTATION.
* Methodenimplementierungen

*&---------------------------------------------------------------------*
*&       Methode main
*&---------------------------------------------------------------------*
* Hauptverarbeitung
*----------------------------------------------------------------------*
  METHOD main.
* Anwendungslog erstellen
    bal_log_create( ).

* Daten selektieren
    select_data( ).
* Fehlerhafte Daten korrigieren
    update_data( ).

* Anwendungslog ausgeben
    IF sy-batch IS INITIAL.
      bal_log_display( ).
    ENDIF.

  ENDMETHOD.                    "main

*&---------------------------------------------------------------------*
*&       Methode bal_log_create
*&---------------------------------------------------------------------*
* Anwendungslog erstellen
*----------------------------------------------------------------------*
  METHOD bal_log_create.

    ms_log-extnumber = sy-repid.
    ms_log-object = 'ZHF'.
    ms_log-subobject = 'ZSD'.
    ms_log_msg-msg_count = 1.
    ms_log_msg-alsort = '000'.
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = ms_log
      IMPORTING
        e_log_handle            = mv_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE a175(zv01).
    ENDIF.

  ENDMETHOD.                    "bal_log_create

*&---------------------------------------------------------------------*
*&       Methode bal_log_save
*&---------------------------------------------------------------------*
* Anwendungslog auf Datenbank speichern
*----------------------------------------------------------------------*
  METHOD bal_log_save.

    DATA: lt_log_handle TYPE bal_t_logh,
          lt_lognumbers TYPE bal_t_lgnm.

    INSERT mv_log_handle INTO TABLE lt_log_handle.
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = lt_log_handle
      IMPORTING
        e_new_lognumbers = lt_lognumbers
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

  ENDMETHOD.                    "bal_log_save

*&---------------------------------------------------------------------*
*&       Methode bal_log_display
*&---------------------------------------------------------------------*
* Anwendungslog ausgeben
*----------------------------------------------------------------------*
  METHOD bal_log_display.

    DATA: lt_log_handle TYPE bal_t_logh.

    INSERT mv_log_handle INTO TABLE lt_log_handle.

* display appl log
    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_t_log_handle = lt_log_handle
      EXCEPTIONS
        OTHERS         = 0.

  ENDMETHOD.                    "bal_log_display

*&---------------------------------------------------------------------*
*&       Methode select_data
*&---------------------------------------------------------------------*
* Daten lesen
*----------------------------------------------------------------------*
  METHOD select_data.

*    SELECT * FROM vbak
*        INTO CORRESPONDING FIELDS OF TABLE mt_data
*        UP TO p_anzrow ROWS
*        WHERE vbeln IN s_vbeln.

  ENDMETHOD.                    "select_data

*&---------------------------------------------------------------------*
*&       Methode update_data
*&---------------------------------------------------------------------*
* Fehlerhafte Daten korrigieren
*----------------------------------------------------------------------*
  METHOD update_data.

    DATA: lv_anz_commit TYPE i,
          lv_anz        TYPE i,
          lv_tabix      LIKE sy-tabix.

    LOOP AT mt_data INTO ms_data.
      lv_tabix = sy-tabix.
      IF p_test IS INITIAL.
*        UPDATE .... SET ...
*            WHERE vbeln = ms_data-vbeln.
        IF sy-subrc = 0.
          ADD 1 TO lv_anz.
          ADD 1 TO lv_anz_commit.
          IF p_logs IS NOT INITIAL.
            msg 'ZV01' 'I' 018 ms_data-vbeln 'xxx' 'geändert auf' 'yyy'. "Anwendungslog
          ENDIF.
        ELSE.
          msg 'ZV01' 'E' 018 'Fehler bei Update Datensatz' ms_data-vbeln sy-msgv1 sy-msgv2. "Anwendungslog
        ENDIF.
        IF lv_anz_commit = p_anzcom.
          COMMIT WORK AND WAIT.
          CLEAR lv_anz_commit.
        ENDIF.
      ELSE.
        ADD 1 TO lv_anz.
        IF p_logs IS NOT INITIAL.
          msg 'ZV01' 'I' 018 ms_data-vbeln 'xxx' 'würde geändert auf' 'yyy'. "Anwendungslog
        ENDIF.
      ENDIF.
    ENDLOOP.

* Letzte Gruppe abschließen
    IF lv_anz_commit > 0.
      COMMIT WORK AND WAIT.
    ENDIF.

* Anzahl geänderter Datensätze ins Joblog schreiben
    WRITE lv_anz TO sy-msgv1 LEFT-JUSTIFIED.
    IF p_test IS INITIAL.
      IF p_logs IS INITIAL
          OR lines( mt_data ) = 0.
        msg 'ZV01' 'S' 107 sy-msgv1 ' ' ' ' ' '.
      ENDIF.
      IF sy-batch IS NOT INITIAL.
        MESSAGE s107(zv01) WITH sy-msgv1.
      ENDIF.
    ELSE.
      IF p_logs IS INITIAL
          OR lines( mt_data ) = 0.
        msg 'ZV01' 'S' 212 sy-msgv1 ' ' ' ' ' '.
      ENDIF.
      IF sy-batch IS NOT INITIAL.
        MESSAGE s212(zv01) WITH sy-msgv1.
      ENDIF.
    ENDIF.

* Anwendungslog speichern
    IF lines( mt_data ) > 0.
      CALL METHOD bal_log_save.
    ENDIF.

  ENDMETHOD.                    "update_data

ENDCLASS.                    "lcl_zvxc99_999
