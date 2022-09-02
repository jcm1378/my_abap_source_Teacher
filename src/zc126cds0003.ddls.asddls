@AbapCatalog.sqlViewName: 'ZC126CDS0003_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Fake Standard table'
define view ZC126CDS0003 as select from ztc1260003 
{
    bukrs,
    belnr,
    gjahr,
    buzei,
    bschl
}
