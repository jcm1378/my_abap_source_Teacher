@AbapCatalog.sqlViewAppendName: 'ZC126EXT0003_V'
@EndUserText.label: '[C1] Fake Standard table Extend'
extend view ZC126CDS0003 with ZC126EXT0003 
{
    ztc1260003.zzsaknr,
    ztc1260003.zzkostl,
    ztc1260003.zzshkzg,
    ztc1260003.zzlgort
}
