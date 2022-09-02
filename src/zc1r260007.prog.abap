*&---------------------------------------------------------------------*
*& Report ZC1R260007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r260007_top                          .    " Global Data

INCLUDE zc1r260007_s01                          .  " Selection Screen
INCLUDE zc1r260007_c01                          .  " Local Class
INCLUDE zc1r260007_o01                          .  " PBO-Modules
INCLUDE zc1r260007_i01                          .  " PAI-Modules
INCLUDE zc1r260007_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_emp_data.
  PERFORM set_style.

  CALL SCREEN '0100'.
