class ZCLC126_0001 definition
  public
  final
  create public .

public section.

  methods GET_AIRLINE_INFO
    importing
      !PI_CARRID type SCARR-CARRID
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
    changing
      !ET_AIRLINE type ZC1TT26001 .
  methods GET_MAT_DESCRIPTION
    importing
      !PI_MATNR type MATNR
    exporting
      !PE_MAKTX type MAKT-MAKTX
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC126_0001 IMPLEMENTATION.


  METHOD get_airline_info.

    IF pi_carrid IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
    ENDIF.

    SELECT carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF TABLE et_airline
      FROM scarr
     WHERE carrid = pi_carrid.

    IF sy-subrc NE 0.
      pe_code = 'E'.
      pe_msg  = TEXT-e02.
      EXIT.
    ELSE.
      pe_code = 'S'.
    ENDIF.

  ENDMETHOD.


  METHOD get_mat_description.

    IF pi_matnr IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e03.
      EXIT.
    ENDIF.

    SELECT SINGLE maktx
      INTO pe_maktx
      FROM makt
     WHERE matnr = pi_matnr
       AND spras = sy-langu.

    IF sy-subrc NE 0.
      pe_code = 'E'.
      pe_msg  = TEXT-e02.
    ELSE.
      pe_code = 'S'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
