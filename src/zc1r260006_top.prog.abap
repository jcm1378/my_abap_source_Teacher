*&---------------------------------------------------------------------*
*& Include ZC1R260006_TOP                           - Report ZC1R260006
*&---------------------------------------------------------------------*
REPORT zc1r260006 MESSAGE-ID zc226.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES : bkpf.

DATA : BEGIN OF gs_data,
         belnr TYPE bseg-belnr,   "전표번호
         buzei TYPE bseg-buzei,   "전표순번
         blart TYPE bkpf-blart,   "전표유형
         budat TYPE bkpf-budat,   "전기일자
         shkzg TYPE bseg-shkzg,   "차대지시자
         dmbtr TYPE bseg-dmbtr,   "전표금액
         waers TYPE bkpf-waers,   "통화키
         hkont TYPE bseg-hkont,   "G/L 계정
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.

* ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.

DATA : gv_okcode TYPE sy-ucomm.


DEFINE _clear.
  CLEAR   &1.
  REFRESH &2.
END-OF-DEFINITION.
