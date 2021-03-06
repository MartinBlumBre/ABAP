*&---------------------------------------------------------------------*
*&  Include           ZVXC99_999CLD
*&---------------------------------------------------------------------*
CLASS lcl_zvxc99_999 DEFINITION DEFERRED.
DATA: go_zvxc99_999 TYPE REF TO lcl_zvxc99_999.

*----------------------------------------------------------------------*
*       CLASS lcl_zvxc99_999 DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_zvxc99_999 DEFINITION.
* Klassendefinitionen

  PUBLIC SECTION.

    METHODS: main.


  PROTECTED SECTION.

    TYPES: BEGIN OF ts_data,
             vbeln TYPE vbak-vbeln,
             vkorg TYPE vbak-vkorg,
           END OF ts_data.

    METHODS: bal_log_create,
      bal_log_save,
      bal_log_display,
      select_data,
      update_data.


  PRIVATE SECTION.
* APPL_LOG
    DATA: mv_log_handle   TYPE balloghndl,
          ms_log          TYPE bal_s_log,
          ms_log_msg      TYPE bal_s_msg,
          mv_msgtext(255) TYPE c.

    DATA: mt_data TYPE TABLE OF ts_data,
          ms_data TYPE ts_data.

ENDCLASS.                    "lcl_zvxc99_999 DEFINITION
