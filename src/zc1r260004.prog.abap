*&---------------------------------------------------------------------*
*& Report ZC1R260004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r260004_top                          .    " Global Data

INCLUDE zc1r260004_s01                          .  " Selection Screen
INCLUDE zc1r260004_c01                          .  " Local Class
INCLUDE zc1r260004_o01                          .  " PBO-Modules
INCLUDE zc1r260004_i01                          .  " PAI-Modules
INCLUDE zc1r260004_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_bom_data.

  CALL SCREEN '0100'.
