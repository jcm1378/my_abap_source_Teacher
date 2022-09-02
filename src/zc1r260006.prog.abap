*&---------------------------------------------------------------------*
*& Report ZC1R260006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r260006_top                          .    " Global Data

INCLUDE zc1r260006_s01                          .  " Selection Screen
INCLUDE zc1r260006_c01                          .  " Local Class
INCLUDE zc1r260006_o01                          .  " PBO-Modules
INCLUDE zc1r260006_i01                          .  " PAI-Modules
INCLUDE zc1r260006_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.

START-OF-SELECTION.
  PERFORM get_belnr.

  CALL SCREEN '0100'.
