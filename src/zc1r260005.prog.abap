*&---------------------------------------------------------------------*
*& Report ZC1R260005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r260005_top                          .    " Global Data

INCLUDE zc1r260005_s01                          .  " Selection Screen
INCLUDE zc1r260005_c01                          .  " Local Class
INCLUDE zc1r260005_o01                          .  " PBO-Modules
INCLUDE zc1r260005_i01                          .  " PAI-Modules
INCLUDE zc1r260005_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_flight_list.
  PERFORM set_carrname.

  CALL SCREEN '0100'.
