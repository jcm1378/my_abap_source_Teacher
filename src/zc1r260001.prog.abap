*&---------------------------------------------------------------------*
*& Report ZC1R260001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r260001 MESSAGE-ID zc226.
TABLES : mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS : pa_werks TYPE mkal-werks DEFAULT '1010',
               pa_berid TYPE pbid-berid DEFAULT '1010',
               pa_pbdnr TYPE pbid-pbdnr,
               pa_versb TYPE pbid-versb DEFAULT '00'.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS : pa_crt  RADIOBUTTON GROUP rb1 DEFAULT 'X' USER-COMMAND mod,
               pa_disp RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-t03.
  SELECT-OPTIONS : so_matnr FOR mara-matnr MODIF ID mar,
                   so_mtart FOR mara-mtart MODIF ID mar,
                   so_matkl FOR mara-matkl MODIF ID mar.

  SELECT-OPTIONS : so_ekgrp FOR  marc-ekgrp MODIF ID mac.
  PARAMETERS     : pa_dispo TYPE marc-dispo MODIF ID mac,
                   pa_dismm TYPE marc-dismm MODIF ID mac.
SELECTION-SCREEN END OF BLOCK bl3.


AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen.















**TABLES : sflight, sbook.
**
**SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
*  PARAMETERS     : pa_carr TYPE sflight-carrid OBLIGATORY.
**  SELECT-OPTIONS : so_conn FOR  sflight-connid OBLIGATORY.
**  PARAMETERS     : pa_pltp TYPE sflight-planetype AS LISTBOX
**                   VISIBLE LENGTH 10.
**  SELECT-OPTIONS : so_bkid FOR  sbook-bookid.
**SELECTION-SCREEN END OF BLOCK bl1.
**
**
**AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_carr.
**  PERFORM f4_carrid.
**
**AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bkid-low.
**
**
**START-OF-SELECTION.
**
**  DATA : BEGIN OF gs_itab1,
**           carrid    TYPE sflight-carrid,
**           connid    TYPE sflight-connid,
**           fldate    TYPE sflight-fldate,
**           planetype TYPE sflight-planetype,
**           currency  TYPE sflight-currency,
**           bookid    TYPE sbook-bookid,
**           customid  TYPE sbook-customid,
**           custtype  TYPE sbook-custtype,
**           class     TYPE sbook-class,
**           agencynum TYPE sbook-agencynum,
**         END OF gs_itab1,
**
**         gt_itab1 LIKE TABLE OF gs_itab1,
**
**         BEGIN OF gs_itab2,
**           carrid    TYPE sflight-carrid,
**           connid    TYPE sflight-connid,
**           fldate    TYPE sflight-fldate,
**           bookid    TYPE sbook-bookid,
**           customid  TYPE sbook-customid,
**           custtype  TYPE sbook-custtype,
**           agencynum TYPE sbook-agencynum,
**         END OF gs_itab2,
**
**         gt_itab2 LIKE TABLE OF gs_itab2.
**
**  REFRESH : gt_itab1, gt_itab2.
**
**  SELECT a~carrid a~connid   a~fldate   a~planetype a~currency
**         b~bookid b~customid b~custtype b~agencynum b~class
**    INTO CORRESPONDING FIELDS OF TABLE gt_itab1
**    FROM sflight AS a
**   INNER JOIN sbook AS b
**      ON a~carrid = b~carrid
**     AND a~connid = b~connid
**     AND a~fldate = b~fldate
**   WHERE a~carrid = pa_carr
**     AND a~connid   IN so_conn
**     AND a~planetype = pa_pltp
**     AND b~bookid   IN so_bkid.
**
**  IF sy-subrc NE 0.
**    MESSAGE s001.
**    LEAVE LIST-PROCESSING.
**  ENDIF.
**
**  LOOP AT gt_itab1 INTO gs_itab1.
**
**    CASE gs_itab1-custtype.
**      WHEN 'B'.
**        MOVE-CORRESPONDING gs_itab1 TO gs_itab2.
**
**        APPEND gs_itab2 TO gt_itab2.
**        CLEAR  gs_itab2.
**
**    ENDCASE.
**
**  ENDLOOP.
**
**  SORT gt_itab2 BY carrid connid fldate.
**  DELETE ADJACENT DUPLICATES FROM gt_itab2 COMPARING carrid connid fldate.
**
**  IF gt_itab2 IS NOT INITIAL.
**    cl_demo_output=>display( gt_itab2 ).
**  ELSE.
**    MESSAGE s001.
**  ENDIF.
***&---------------------------------------------------------------------*
***& Form f4_carrid
***&---------------------------------------------------------------------*
***& text
***&---------------------------------------------------------------------*
***& -->  p1        text
***& <--  p2        text
***&---------------------------------------------------------------------*
**FORM f4_carrid .
**
**  DATA : BEGIN OF ls_carrid,
**           carrid   TYPE scarr-carrid,
**           carrname TYPE scarr-carrname,
**           currcode TYPE scarr-currcode,
**           url      TYPE scarr-url,
**         END OF ls_carrid,
**
**         lt_carrid LIKE TABLE OF ls_carrid.
**
**  REFRESH lt_carrid.
**
**  SELECT carrid carrname currcode url
**    INTO CORRESPONDING FIELDS OF TABLE lt_carrid
**    FROM scarr.
**
**  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
**    EXPORTING
**      retfield     = 'CARRID'   "선택하면 화면으로 세팅할 ITAB의 필드ID
**      dynpprog     = sy-repid
**      dynpnr       = sy-dynnr
**      dynprofield  = 'PA_CARR'  "서치헬프 화면에서 선택한 데이터가 세팅될 화면의 필드ID
***     WINDOW_TITLE = TEXT-t02
**      window_title = 'Airline List'
**      value_org    = 'S'
**      display      = 'X' "선택한 데이터가 세팅될 화면의 필드에 세팅 되는것 막음
**    TABLES
**      value_tab    = lt_carrid.
**
**ENDFORM.
*
*DATA : BEGIN OF ls_scarr,
*         carrid   TYPE scarr-carrid,
*         carrname TYPE scarr-carrname,
*         url      TYPE scarr-url,
*       END OF ls_scarr,
*       lt_scarr LIKE TABLE OF ls_scarr.
*
*SELECT carrid carrname url
*  INTO CORRESPONDING FIELDS OF TABLE lt_scarr
*  FROM scarr.
*
*READ TABLE lt_scarr INTO ls_scarr WITH KEY carrid = 'AA'.
*
** New syntax
*SELECT carrid, carrname, url
*  INTO TABLE @DATA(lt_scarr2)
*  FROM scarr.
*
**READ TABLE lt_scarr2 INTO DATA(ls_scarr2) WITH KEY carrid = 'AA'.
*
*LOOP AT lt_scarr2 INTO DATA(ls_scarr2).
*
*ENDLOOP.
***********************************************************************
*DATA : lv_carrid   TYPE scarr-carrid,
*       lv_carrname TYPE scarr-carrname.
*
*SELECT SINGLE carrid carrname
*  INTO (lv_carrid, lv_carrname)
*  FROM scarr
* WHERE carrid = pa_carr.
*
** New syntax
*SELECT SINGLE carrid, carrname
*  FROM scarr
* WHERE carrid = @pa_carr
*  INTO (@DATA(lv_carrid2), @DATA(lv_carrname2)).
***********************************************************************
*DATA : BEGIN OF ls_scarr3,
*         carrid   TYPE scarr-carrid,
*         carrname TYPE scarr-carrname,
*         url      TYPE scarr-url,
*       END OF ls_scarr3.
*
*ls_scarr3-carrid   = 'AA'.
*ls_scarr3-carrname = 'America Airline'.
*ls_scarr3-url      = 'www.aa.com'.
*
*ls_scarr3-carrid = 'KA'.
*
** new syntax
*ls_scarr3 = VALUE #( carrid   = 'AA'
*                     carrname = 'Americar Airline'
*                     url      = 'www.aa.com' ).
*
*ls_scarr3 = VALUE #( carrid = 'KA' ). "기술되지 않은 필드들은 모두 CLEAR 됨
*
*ls_scarr3 = VALUE #( BASE ls_scarr3   "->기술되지 않은 필드는 모두 유지시켜줌
*                     carrid = 'KA' ).
***********************************************************************
*DATA : BEGIN OF ls_scarr4,
*         carrid   TYPE scarr-carrid,
*         carrname TYPE scarr-carrname,
*         url      TYPE scarr-url,
*       END OF ls_scarr4,
*
*       lt_scarr4 LIKE TABLE OF ls_scarr4.
*
*ls_scarr4-carrid   = 'AA'.
*ls_scarr4-carrname = 'America Airline'.
*ls_scarr4-url      = 'www.aa.com'.
*
*APPEND ls_scarr4 TO lt_scarr4.
*
*ls_scarr4-carrid   = 'KA'.
*ls_scarr4-carrname = 'Korean Air'.
*ls_scarr4-url      = 'www.ka.com'.
*
*APPEND ls_scarr4 TO lt_scarr4.
*
** new syntax
*REFRESH lt_scarr4.
*
*lt_scarr4 = VALUE #(  "--> Work Area 필요 없이 데이터 append 가능
*                     ( carrid   = 'AA'
*                       carrname = 'America Airline'
*                       url      = 'www.aa.com'
*                     )
*                     ( carrid   = 'KA'
*                       carrname = 'Korean Air'
*                       url      = 'www.ka.com'
*                     )
*                   ).
*
*lt_scarr4 = VALUE #(  "--> 기존 itab의 row 모두 Refresh 되고 지금 추가한것만 남음
*                     ( carrid   = 'LH'
*                       carrname = 'Luft Hansa'
*                       url      = 'www.lh.com'
*                     )
*                   ).
*
*lt_scarr4 = VALUE #( BASE lt_scarr4 "--> 기존 itab의 row 모두 유지시킴
*                     ( carrid   = 'LH'
*                       carrname = 'Luft Hansa'
*                       url      = 'www.lh.com'
*                     )
*                   ).
*
**LOOP AT itab INTO wa.
**
**  lt_scarr4 = VALUE #( BASE lt_scarr4
**                       ( carrid   = wa-carrid
**                         carrname = wa-carrname
**                         url      = wa-url
**                       )
**                     ).
**
**ENDLOOP.
***********************************************************************
*MOVE-CORRESPONDING ls_scarr3 TO ls_scarr4.
*
** new syntax
*ls_scarr4 = CORRESPONDING #( ls_scarr3 ).
***********************************************************************
** ITAB의 데이터 이동 문법
***********************************************************************
**gt_color = lt_color."둘다 같은 구조의 itab 이어야 함 :기존데이터 사라짐
**gt_color[] = lt_color[]."둘다 같은 구조의 itab 이어야 함
*** 둘다 같은 구조의 itab이면서 기존 데이터 밑으로 append
**APPEND LINES OF lt_color TO gt_color.
**
*** 같은필드ID 에 대해서만 데이터 이동 : 기존 데이터 사라짐
**MOVE-CORRESPONDING lt_color TO gt_color.
**
***같은필드ID 에 대해서만 데이터 이동 : 기존 데이터 밑으로 append됨
**MOVE-CORRESPONDING lt_color TO gt_color KEEPING TARGET LINES.
***********************************************************************
** DB Table 과 ITAB의 Join 방법
***********************************************************************
*DATA : BEGIN OF ls_key,
*         carrid TYPE sflight-carrid,
*         connid TYPE sflight-connid,
*         fldate TYPE sflight-fldate,
*       END OF ls_key,
*
*       lt_key LIKE TABLE OF ls_key,
*       lt_sbook TYPE TABLE OF sbook.
*
*SELECT carrid connid fldate
*  INTO CORRESPONDING FIELDS OF TABLE lt_key
*  FROM sflight
* WHERE carrid = 'AA'.
*
** FOR ALL ENTRIES 의 선제조건
** 1. 반드시 정렬 먼저 할것 : SORT
** 2. 정렬 후 중복제거 할것
** 3. ITAB이 비어있는지 체크하고 수행할것 : 비어있으면 안된다
*SORT lt_key BY carrid connid fldate.
*DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.
*
*IF lt_key IS NOT INITIAL.
*  SELECT carrid connid fldate bookid customid custtype
*    INTO CORRESPONDING FIELDS OF TABLE lt_sbook
*    FROM sbook
*     FOR ALL ENTRIES IN lt_key
*   WHERE carrid   = lt_key-carrid
*     AND connid   = lt_key-connid
*     AND fldate   = lt_key-fldate
*     AND customid = '00000279'.
*ENDIF.
** new syntax
*SORT lt_key BY carrid connid fldate.
*DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.
*
*SELECT a~carrid, a~connid, a~fldate, a~bookid, a~customid
*  FROM sbook AS a
* INNER JOIN @lt_key AS b
*    ON a~carrid = b~carrid
*   AND a~connid = b~connid
*   AND a~fldate = b~fldate
* WHERE a~customid = '00000279'
*  INTO TABLE @DATA(lt_sbook2).
***********************************************************************
** lt_sbook2 에서 connid 의 MAX 값을 알고자 할때
*SORT lt_sbook2 BY connid DESCENDING.
*READ TABLE lt_sbook2 INTO DATA(ls_sbook2) INDEX 1.
**new syntax
*SELECT MAX( connid ) AS connid
*  FROM @lt_sbook2 AS a
*  INTO @DATA(lv_max).
***********************************************************************
**SELECT carrid connid price currency fldate
**  INTO CORRESPONDING FIELDS OF TABLE gt_data
**  FROM sflight.
**
**LOOP AT gt_data INTO gs_data.
**
**  CASE gs_data-carrid.
**    WHEN 'AA'.
**      gs_data-carrid = 'BB'.
**
**      MODIFY gt_data FROM gs_data INDEX sy-tabix TRANSPORTING carrid.
**  ENDCASE.
**
**ENDLOOP.
*
** new syntax
*SELECT CASE carrid
*          WHEN 'AA' THEN 'BB'
*         ELSE carrid
*       END AS carrid, connid, price, currency, fldate
*   INTO TABLE @DATA(lt_sflight)
*   FROM sflight.
***********************************************************************
*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .

  LOOP AT SCREEN.

    CASE screen-name.
      WHEN 'PA_PBDNR' OR 'PA_VERSB'.
        screen-input = 0.
        MODIFY SCREEN.
    ENDCASE.

    CASE 'X'.
      WHEN pa_crt.

        CASE screen-group1.
          WHEN 'MAC'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

      WHEN pa_disp.

        CASE screen-group1.
          WHEN 'MAR'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

    ENDCASE.

  ENDLOOP.

ENDFORM.
