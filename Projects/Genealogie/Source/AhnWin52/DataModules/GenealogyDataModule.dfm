object DataModule2: TGenealogyDataModule
  OldCreateOrder = False
  Left = 172
  Top = 107
  Height = 547
  Width = 784
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 32
    Top = 16
  end
  object Table1: TTable
    AutoRefresh = True
    FilterOptions = [foCaseInsensitive]
    TableName = 'AWD.DB'
    Left = 64
    Top = 16
    object Table1Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table1Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table1Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table1Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table1Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table1Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table1Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table1Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table1Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table1Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table1Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table1Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table1Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table1Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table1Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table1Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table1Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table1Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table1Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table1Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table1Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table1Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table1Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table1Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table1Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table1Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table1Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table1Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table1Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table1Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table1Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table1Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table1Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table1Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table1Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table1IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table1Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table1Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table1Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table1Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table1PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table1Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table1Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table1Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table1Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table1Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table1Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table1Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table1Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table1Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table1Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table1Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object Table2: TTable
    IndexName = 'lo'
    TableName = 'lc.db'
    Left = 152
    Top = 16
    object Table2Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
  end
  object DataSource2: TDataSource
    DataSet = Table2
    Left = 120
    Top = 16
  end
  object DataSource3: TDataSource
    DataSet = Table3
    Left = 208
    Top = 16
  end
  object Table3: TTable
    TableName = 'AWD.DB'
    Left = 240
    Top = 16
    object Table3Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table3Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table3Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table3Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table3Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table3Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table3Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table3Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table3Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table3Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table3Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table3Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table3Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table3Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table3Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table3Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table3Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table3Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table3Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table3Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table3Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table3Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table3Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table3Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table3Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table3Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table3Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table3Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table3Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table3Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table3Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table3Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table3Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table3Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table3Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table3IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table3Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table3Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table3Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table3Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table3PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table3Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table3Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table3Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table3Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table3Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table3Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table3Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table3Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table3Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table3Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table3Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object DataSource4: TDataSource
    DataSet = Table4
    Left = 304
    Top = 16
  end
  object Table4: TTable
    TableName = 'NUMRES.DB'
    Left = 336
    Top = 16
    object Table4Num: TIntegerField
      FieldName = 'Num'
    end
  end
  object DataSource5: TDataSource
    DataSet = Table5
    Left = 400
    Top = 16
  end
  object Table5: TTable
    IndexName = 'num'
    MasterFields = 'Nummer'
    MasterSource = DataSource1
    TableName = 'MRG.DB'
    Left = 432
    Top = 16
    object Table5Numr: TAutoIncField
      FieldName = 'Numr'
      ReadOnly = True
    end
    object Table5Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table5Epnum: TIntegerField
      FieldName = 'Epnum'
    end
    object Table5Htag: TStringField
      FieldName = 'Htag'
      Size = 2
    end
    object Table5Hmonat: TStringField
      FieldName = 'Hmonat'
      Size = 2
    end
    object Table5Hjahr: TStringField
      FieldName = 'Hjahr'
      Size = 4
    end
    object Table5Hort: TStringField
      FieldName = 'Hort'
      Size = 40
    end
    object Table5Trauz: TStringField
      FieldName = 'Trauz'
      Size = 120
    end
    object Table5Satag: TStringField
      FieldName = 'Satag'
      Size = 2
    end
    object Table5Samonat: TStringField
      FieldName = 'Samonat'
      Size = 2
    end
    object Table5Sajahr: TStringField
      FieldName = 'Sajahr'
      Size = 4
    end
    object Table5Saort: TStringField
      FieldName = 'Saort'
      Size = 40
    end
    object Table5Satrauz: TStringField
      FieldName = 'Satrauz'
      Size = 120
    end
    object Table5Verbind: TStringField
      FieldName = 'Verbind'
    end
    object Table5Schtag: TStringField
      FieldName = 'Schtag'
      Size = 2
    end
    object Table5Schmonat: TStringField
      FieldName = 'Schmonat'
      Size = 2
    end
    object Table5Schjahr: TStringField
      FieldName = 'Schjahr'
      Size = 4
    end
    object Table5Schort: TStringField
      FieldName = 'Schort'
      Size = 40
    end
    object Table5Hqu: TStringField
      FieldName = 'Hqu'
      Size = 150
    end
    object Table5Saqu: TStringField
      FieldName = 'Saqu'
      Size = 150
    end
    object Table5Schqu: TStringField
      FieldName = 'Schqu'
      Size = 150
    end
    object Table5Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table5Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
  end
  object DataSource6: TDataSource
    DataSet = Table6
    Left = 488
    Top = 16
  end
  object Table6: TTable
    IndexFieldNames = 'Nummer'
    MasterFields = 'Epnum'
    MasterSource = DataSource5
    TableName = 'AWD.DB'
    Left = 528
    Top = 16
    object Table6Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table6Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table6Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table6Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table6Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table6Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table6Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table6Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table6Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table6Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table6Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table6Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table6Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table6Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table6Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table6Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table6Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table6Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table6Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table6Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table6Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table6Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table6Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table6Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table6Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table6Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table6Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table6Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table6Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table6Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table6Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table6Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table6Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table6Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table6Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table6IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table6Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table6Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table6Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table6Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table6PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table6Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table6Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table6Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table6Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table6Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table6Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table6Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table6Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table6Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table6Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table6Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object DataSource7: TDataSource
    DataSet = Table7
    Left = 584
    Top = 16
  end
  object Table7: TTable
    IndexFieldNames = 'Vater'
    MasterFields = 'Nummer'
    MasterSource = DataSource1
    TableName = 'AWD.DB'
    Left = 616
    Top = 16
    object Table7Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table7Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table7Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table7Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table7Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table7Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table7Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table7Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table7Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table7Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table7Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table7Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table7Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table7Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table7Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table7Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table7Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table7Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table7Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table7Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table7Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table7Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table7Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table7Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table7Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table7Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table7Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table7Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table7Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table7Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table7Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table7Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table7Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table7Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table7Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table7IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table7Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table7Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table7Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table7Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table7PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table7Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table7Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table7Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table7Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table7Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table7Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table7Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table7Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table7Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table7Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table7Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object DataSource8: TDataSource
    DataSet = Table8
    Left = 32
    Top = 96
  end
  object Table8: TTable
    TableName = 'AWD.DB'
    Left = 64
    Top = 96
    object Table8Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table8Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table8Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table8Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table8Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table8Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table8Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table8Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table8Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table8Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table8Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table8Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table8Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table8Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table8Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table8Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table8Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table8Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table8Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table8Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table8Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table8Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table8Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table8Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table8Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table8Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table8Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table8Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table8Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table8Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table8Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table8Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table8Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table8Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table8Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table8IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table8Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table8Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table8Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table8Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table8PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table8Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table8Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table8Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table8Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table8Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table8Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table8Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table8Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table8Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table8Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table8Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object Table9: TTable
    AutoRefresh = True
    TableName = 'AWD.DB'
    Left = 160
    Top = 96
    object Table9Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table9Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table9Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table9Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table9Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table9Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table9Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table9Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table9Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table9Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table9Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table9Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table9Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table9Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table9Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table9Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table9Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table9Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table9Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table9Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table9Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table9Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table9Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table9Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table9Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table9Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table9Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table9Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table9Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table9Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table9Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table9Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table9Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table9Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table9Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table9IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table9Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table9Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table9Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table9Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table9PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table9Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table9Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table9Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table9Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table9Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table9Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table9Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table9Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table9Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table9Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table9Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object DataSource9: TDataSource
    DataSet = Table9
    Left = 128
    Top = 96
  end
  object Table10: TTable
    TableName = 'MRG.DB'
    Left = 248
    Top = 96
    object Table10Numr: TAutoIncField
      FieldName = 'Numr'
      ReadOnly = True
    end
    object Table10Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table10Epnum: TIntegerField
      FieldName = 'Epnum'
    end
    object Table10Htag: TStringField
      FieldName = 'Htag'
      Size = 2
    end
    object Table10Hmonat: TStringField
      FieldName = 'Hmonat'
      Size = 2
    end
    object Table10Hjahr: TStringField
      FieldName = 'Hjahr'
      Size = 4
    end
    object Table10Hort: TStringField
      FieldName = 'Hort'
      Size = 40
    end
    object Table10Trauz: TStringField
      FieldName = 'Trauz'
      Size = 120
    end
    object Table10Satag: TStringField
      FieldName = 'Satag'
      Size = 2
    end
    object Table10Samonat: TStringField
      FieldName = 'Samonat'
      Size = 2
    end
    object Table10Sajahr: TStringField
      FieldName = 'Sajahr'
      Size = 4
    end
    object Table10Saort: TStringField
      FieldName = 'Saort'
      Size = 40
    end
    object Table10Satrauz: TStringField
      FieldName = 'Satrauz'
      Size = 120
    end
    object Table10Verbind: TStringField
      FieldName = 'Verbind'
    end
    object Table10Schtag: TStringField
      FieldName = 'Schtag'
      Size = 2
    end
    object Table10Schmonat: TStringField
      FieldName = 'Schmonat'
      Size = 2
    end
    object Table10Schjahr: TStringField
      FieldName = 'Schjahr'
      Size = 4
    end
    object Table10Schort: TStringField
      FieldName = 'Schort'
      Size = 40
    end
    object Table10Hqu: TStringField
      FieldName = 'Hqu'
      Size = 150
    end
    object Table10Saqu: TStringField
      FieldName = 'Saqu'
      Size = 150
    end
    object Table10Schqu: TStringField
      FieldName = 'Schqu'
      Size = 150
    end
    object Table10Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table10Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
  end
  object DataSource10: TDataSource
    DataSet = Table10
    Left = 216
    Top = 96
  end
  object Query1: TQuery
    Left = 680
    Top = 96
  end
  object Table11: TTable
    TableName = 'chnt.db'
    Left = 344
    Top = 96
    object Table11FELD001: TStringField
      FieldName = 'FELD001'
      Size = 25
    end
    object Table11FELD002: TStringField
      FieldName = 'FELD002'
      Size = 2
    end
    object Table11FELD003: TStringField
      FieldName = 'FELD003'
      Size = 2
    end
    object Table11Nr: TIntegerField
      FieldName = 'Nr'
    end
  end
  object DataSource11: TDataSource
    DataSet = Table11
    Left = 304
    Top = 96
  end
  object Table12: TTable
    TableName = 'NM.db'
    Left = 440
    Top = 96
    object Table12Name: TStringField
      FieldName = 'Name'
      Size = 50
    end
  end
  object Table13: TTable
    TableName = 'LOC.db'
    Left = 536
    Top = 96
    object Table13Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table13PLZ: TStringField
      FieldName = 'PLZ'
      Size = 10
    end
    object Table13Land: TStringField
      FieldName = 'Land'
      Size = 50
    end
    object Table13RegBez: TStringField
      FieldName = 'RegBez'
      Size = 50
    end
    object Table13Gov: TStringField
      FieldName = 'Gov'
      Size = 30
    end
    object Table13Bland: TStringField
      FieldName = 'Bland'
      Size = 50
    end
    object Table13Gde: TStringField
      FieldName = 'Gde'
      Size = 50
    end
    object Table13Pfr: TStringField
      FieldName = 'Pfr'
      Size = 50
    end
    object Table13Lkr: TStringField
      FieldName = 'Lkr'
      Size = 50
    end
    object Table13Abk: TStringField
      FieldName = 'Abk'
    end
    object Table13Lg: TStringField
      FieldName = 'Lg'
      Size = 30
    end
    object Table13Bg: TStringField
      FieldName = 'Bg'
      Size = 30
    end
    object Table13Maid: TStringField
      FieldName = 'Maid'
      Size = 10
    end
  end
  object DataSource12: TDataSource
    DataSet = Table12
    Left = 400
    Top = 96
  end
  object DataSource13: TDataSource
    DataSet = Table13
    Left = 496
    Top = 96
  end
  object DataSource14: TDataSource
    DataSet = Table14
    Left = 32
    Top = 160
  end
  object Table14: TTable
    TableName = 'OUTP.db'
    Left = 80
    Top = 160
    object Table14Nr: TAutoIncField
      FieldName = 'Nr'
      ReadOnly = True
    end
    object Table14Zeile: TMemoField
      FieldName = 'Zeile'
      BlobType = ftMemo
      Size = 10
    end
    object Table14Nm: TStringField
      FieldName = 'Nm'
      Size = 25
    end
    object Table14Nm2: TStringField
      FieldName = 'Nm2'
      Size = 4
    end
    object Table14Nm3: TStringField
      FieldName = 'Nm3'
      Size = 50
    end
  end
  object DataSource15: TDataSource
    DataSet = Table15
    Left = 136
    Top = 160
  end
  object Table15: TTable
    TableName = 'MRG.DB'
    Left = 184
    Top = 160
    object Table15Numr: TAutoIncField
      FieldName = 'Numr'
      ReadOnly = True
    end
    object Table15Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table15Epnum: TIntegerField
      FieldName = 'Epnum'
    end
    object Table15Htag: TStringField
      FieldName = 'Htag'
      Size = 2
    end
    object Table15Hmonat: TStringField
      FieldName = 'Hmonat'
      Size = 2
    end
    object Table15Hjahr: TStringField
      FieldName = 'Hjahr'
      Size = 4
    end
    object Table15Hort: TStringField
      FieldName = 'Hort'
      Size = 40
    end
    object Table15Trauz: TStringField
      FieldName = 'Trauz'
      Size = 120
    end
    object Table15Satag: TStringField
      FieldName = 'Satag'
      Size = 2
    end
    object Table15Samonat: TStringField
      FieldName = 'Samonat'
      Size = 2
    end
    object Table15Sajahr: TStringField
      FieldName = 'Sajahr'
      Size = 4
    end
    object Table15Saort: TStringField
      FieldName = 'Saort'
      Size = 40
    end
    object Table15Satrauz: TStringField
      FieldName = 'Satrauz'
      Size = 120
    end
    object Table15Verbind: TStringField
      FieldName = 'Verbind'
    end
    object Table15Schtag: TStringField
      FieldName = 'Schtag'
      Size = 2
    end
    object Table15Schmonat: TStringField
      FieldName = 'Schmonat'
      Size = 2
    end
    object Table15Schjahr: TStringField
      FieldName = 'Schjahr'
      Size = 4
    end
    object Table15Schort: TStringField
      FieldName = 'Schort'
      Size = 40
    end
    object Table15Hqu: TStringField
      FieldName = 'Hqu'
      Size = 150
    end
    object Table15Saqu: TStringField
      FieldName = 'Saqu'
      Size = 150
    end
    object Table15Schqu: TStringField
      FieldName = 'Schqu'
      Size = 150
    end
    object Table15Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table15Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
  end
  object Table16: TTable
    TableName = 'over.db'
    Left = 296
    Top = 160
    object Table16Nn: TAutoIncField
      FieldName = 'Nn'
      ReadOnly = True
    end
    object Table16Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table16Name: TStringField
      FieldName = 'Name'
      Size = 60
    end
    object Table16Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 4
    end
    object Table16Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 3
    end
    object Table16Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table16Gebort: TStringField
      FieldName = 'Gebort'
      Size = 30
    end
    object Table16Sttag: TStringField
      FieldName = 'Sttag'
      Size = 4
    end
    object Table16Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 3
    end
    object Table16Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table16Stort: TStringField
      FieldName = 'Stort'
      Size = 30
    end
    object Table16Htag: TStringField
      FieldName = 'Htag'
      Size = 7
    end
    object Table16Hmonat: TStringField
      FieldName = 'Hmonat'
      Size = 3
    end
    object Table16Hjahr: TStringField
      FieldName = 'Hjahr'
      Size = 4
    end
    object Table16Hort: TStringField
      FieldName = 'Hort'
      Size = 30
    end
    object Table16Hname: TStringField
      FieldName = 'Hname'
      Size = 60
    end
    object Table16Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
  end
  object DataSource16: TDataSource
    DataSet = Table16
    Left = 240
    Top = 160
  end
  object DataSource17: TDataSource
    DataSet = Table17
    Left = 352
    Top = 160
  end
  object Table17: TTable
    TableName = 'awd.db'
    Left = 400
    Top = 160
    object Table17Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table17Vater: TIntegerField
      FieldName = 'Vater'
    end
    object Table17Mutter: TIntegerField
      FieldName = 'Mutter'
    end
    object Table17Name: TStringField
      FieldName = 'Name'
      Size = 45
    end
    object Table17Vornamen: TStringField
      FieldName = 'Vornamen'
      Size = 45
    end
    object Table17Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table17Religion: TStringField
      FieldName = 'Religion'
      Size = 2
    end
    object Table17Beruf: TStringField
      FieldName = 'Beruf'
      Size = 70
    end
    object Table17Gebtag: TStringField
      FieldName = 'Gebtag'
      Size = 2
    end
    object Table17Gebmonat: TStringField
      FieldName = 'Gebmonat'
      Size = 2
    end
    object Table17Gebjahr: TStringField
      FieldName = 'Gebjahr'
      Size = 4
    end
    object Table17Gebort: TStringField
      FieldName = 'Gebort'
      Size = 40
    end
    object Table17Tauftag: TStringField
      FieldName = 'Tauftag'
      Size = 2
    end
    object Table17Taufmonat: TStringField
      FieldName = 'Taufmonat'
      Size = 2
    end
    object Table17Taufjahr: TStringField
      FieldName = 'Taufjahr'
      Size = 4
    end
    object Table17Taufort: TStringField
      FieldName = 'Taufort'
      Size = 40
    end
    object Table17Taufpat: TStringField
      FieldName = 'Taufpat'
      Size = 120
    end
    object Table17Lebensort: TStringField
      FieldName = 'Lebensort'
      Size = 80
    end
    object Table17Sttag: TStringField
      FieldName = 'Sttag'
      Size = 2
    end
    object Table17Stmonat: TStringField
      FieldName = 'Stmonat'
      Size = 2
    end
    object Table17Stjahr: TStringField
      FieldName = 'Stjahr'
      Size = 4
    end
    object Table17Stort: TStringField
      FieldName = 'Stort'
      Size = 40
    end
    object Table17Todesurs: TStringField
      FieldName = 'Todesurs'
      Size = 40
    end
    object Table17Begtag: TStringField
      FieldName = 'Begtag'
      Size = 2
    end
    object Table17Begmonat: TStringField
      FieldName = 'Begmonat'
      Size = 2
    end
    object Table17Begjahr: TStringField
      FieldName = 'Begjahr'
      Size = 4
    end
    object Table17Begort: TStringField
      FieldName = 'Begort'
      Size = 40
    end
    object Table17Quelleg: TStringField
      FieldName = 'Quelleg'
      Size = 150
    end
    object Table17Quellet: TStringField
      FieldName = 'Quellet'
      Size = 150
    end
    object Table17Quelles: TStringField
      FieldName = 'Quelles'
      Size = 150
    end
    object Table17Quelleb: TStringField
      FieldName = 'Quelleb'
      Size = 150
    end
    object Table17Kommentar: TMemoField
      FieldName = 'Kommentar'
      BlobType = ftMemo
      Size = 10
    end
    object Table17Lebt: TStringField
      FieldName = 'Lebt'
      Size = 1
    end
    object Table17Bild: TGraphicField
      FieldName = 'Bild'
      BlobType = ftGraphic
    end
    object Table17Namex: TStringField
      FieldName = 'Namex'
      Size = 60
    end
    object Table17IDNR: TStringField
      FieldName = 'IDNR'
      Size = 10
    end
    object Table17Kistat: TStringField
      FieldName = 'Kistat'
      Size = 2
    end
    object Table17Hausname: TStringField
      FieldName = 'Hausname'
      Size = 70
    end
    object Table17Adr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object Table17Adr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object Table17PLZ: TStringField
      FieldName = 'PLZ'
      Size = 30
    end
    object Table17Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table17Adrzus: TStringField
      FieldName = 'Adrzus'
      Size = 30
    end
    object Table17Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table17Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table17Indt: TStringField
      FieldName = 'Indt'
      Size = 2
    end
    object Table17Alter: TStringField
      FieldName = 'Alter'
      Size = 15
    end
    object Table17Tel: TStringField
      FieldName = 'Tel'
      Size = 25
    end
    object Table17Ema: TStringField
      FieldName = 'Ema'
      Size = 50
    end
    object Table17Ur: TStringField
      FieldName = 'Ur'
      Size = 50
    end
    object Table17Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
    object Table17Rufname: TStringField
      FieldName = 'Rufname'
      Size = 40
    end
  end
  object Table18: TTable
    TableName = 'MRG.DB'
    Left = 504
    Top = 160
    object Table18Numr: TAutoIncField
      FieldName = 'Numr'
      ReadOnly = True
    end
    object Table18Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table18Epnum: TIntegerField
      FieldName = 'Epnum'
    end
    object Table18Htag: TStringField
      FieldName = 'Htag'
      Size = 2
    end
    object Table18Hmonat: TStringField
      FieldName = 'Hmonat'
      Size = 2
    end
    object Table18Hjahr: TStringField
      FieldName = 'Hjahr'
      Size = 4
    end
    object Table18Hort: TStringField
      FieldName = 'Hort'
      Size = 40
    end
    object Table18Trauz: TStringField
      FieldName = 'Trauz'
      Size = 120
    end
    object Table18Satag: TStringField
      FieldName = 'Satag'
      Size = 2
    end
    object Table18Samonat: TStringField
      FieldName = 'Samonat'
      Size = 2
    end
    object Table18Sajahr: TStringField
      FieldName = 'Sajahr'
      Size = 4
    end
    object Table18Saort: TStringField
      FieldName = 'Saort'
      Size = 40
    end
    object Table18Satrauz: TStringField
      FieldName = 'Satrauz'
      Size = 120
    end
    object Table18Verbind: TStringField
      FieldName = 'Verbind'
    end
    object Table18Schtag: TStringField
      FieldName = 'Schtag'
      Size = 2
    end
    object Table18Schmonat: TStringField
      FieldName = 'Schmonat'
      Size = 2
    end
    object Table18Schjahr: TStringField
      FieldName = 'Schjahr'
      Size = 4
    end
    object Table18Schort: TStringField
      FieldName = 'Schort'
      Size = 40
    end
    object Table18Hqu: TStringField
      FieldName = 'Hqu'
      Size = 150
    end
    object Table18Saqu: TStringField
      FieldName = 'Saqu'
      Size = 150
    end
    object Table18Schqu: TStringField
      FieldName = 'Schqu'
      Size = 150
    end
    object Table18Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table18Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
  end
  object DataSource18: TDataSource
    DataSet = Table18
    Left = 456
    Top = 160
  end
  object Table19: TTable
    TableName = 'FKMG.db'
    Left = 616
    Top = 160
    object Table19TX: TStringField
      FieldName = 'TX'
      Size = 100
    end
    object Table19ABK: TStringField
      FieldName = 'ABK'
      Size = 3
    end
  end
  object DataSource19: TDataSource
    DataSet = Table19
    Left = 576
    Top = 160
  end
  object Table20: TTable
    TableName = 'FOKO.DBF'
    Left = 80
    Top = 224
    object Table20GV: TStringField
      FieldName = 'GV'
      Size = 3
    end
    object Table20MNR: TStringField
      FieldName = 'MNR'
      Size = 4
    end
    object Table20NAME: TStringField
      FieldName = 'NAME'
      Size = 32
    end
    object Table20BEKENN: TStringField
      FieldName = 'BEKENN'
      Size = 2
    end
    object Table20STAAT: TStringField
      FieldName = 'STAAT'
      Size = 3
    end
    object Table20PLZ_KZ: TStringField
      FieldName = 'PLZ_KZ'
      Size = 6
    end
    object Table20ORT: TStringField
      FieldName = 'ORT'
      Size = 24
    end
    object Table20TER: TStringField
      FieldName = 'TER'
      Size = 3
    end
    object Table20MK: TStringField
      FieldName = 'MK'
      Size = 2
    end
    object Table20VON: TStringField
      FieldName = 'VON'
      Size = 4
    end
    object Table20BIS: TStringField
      FieldName = 'BIS'
      Size = 4
    end
    object Table20ZTRL: TStringField
      FieldName = 'ZTRL'
      Size = 1
    end
    object Table20KORRDAT: TStringField
      FieldName = 'KORRDAT'
      Size = 8
    end
    object Table20STD: TStringField
      FieldName = 'STD'
      Size = 1
    end
  end
  object DataSource20: TDataSource
    DataSet = Table20
    Left = 24
    Top = 224
  end
  object Table21: TTable
    TableName = 'FKHF.DB'
    Left = 192
    Top = 224
    object Table21Name: TStringField
      FieldName = 'Name'
      Size = 30
    end
    object Table21Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table21Zeit: TStringField
      FieldName = 'Zeit'
      Size = 4
    end
    object Table21N: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object Table21Bekenn: TStringField
      FieldName = 'Bekenn'
      Size = 2
    end
  end
  object DataSource21: TDataSource
    DataSet = Table21
    Left = 136
    Top = 224
  end
  object Table22: TTable
    TableName = 'nol.db'
    Left = 296
    Top = 224
    object Table22No: TStringField
      FieldName = 'No'
      Size = 50
    end
    object Table22Zus: TMemoField
      FieldName = 'Zus'
      BlobType = ftMemo
      Size = 10
    end
  end
  object DataSource22: TDataSource
    DataSet = Table22
    Left = 248
    Top = 224
  end
  object Table23: TTable
    Left = 408
    Top = 224
  end
  object DataSource23: TDataSource
    DataSet = Table23
    Left = 352
    Top = 224
  end
  object DataSource24: TDataSource
    DataSet = Table24
    Left = 456
    Top = 224
  end
  object Table24: TTable
    AutoRefresh = True
    TableName = 'VORF.DB'
    Left = 512
    Top = 224
    object Table24Pp: TIntegerField
      FieldName = 'Pp'
    end
    object Table24Lfdn: TIntegerField
      FieldName = 'Lfdn'
    end
    object Table24Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table24Kek: TFloatField
      FieldName = 'Kek'
    end
    object Table24Gen: TIntegerField
      FieldName = 'Gen'
    end
    object Table24Kekr: TFloatField
      FieldName = 'Kekr'
    end
    object Table24Geschlecht: TStringField
      FieldName = 'Geschlecht'
      Size = 1
    end
    object Table24Hd: TStringField
      FieldName = 'Hd'
      Size = 100
    end
  end
  object DataSource25: TDataSource
    DataSet = Table25
    Left = 568
    Top = 224
  end
  object DataSource26: TDataSource
    DataSet = Table26
    Left = 24
    Top = 296
  end
  object Table25: TTable
    TableName = 'gedh.db'
    Left = 616
    Top = 224
    object Table25Z: TAutoIncField
      FieldName = 'Z'
      ReadOnly = True
    end
    object Table25N: TIntegerField
      FieldName = 'N'
    end
    object Table25A: TIntegerField
      FieldName = 'A'
    end
  end
  object Table26: TTable
    TableName = 'repso.db'
    Left = 80
    Top = 296
    object Table26Z: TAutoIncField
      FieldName = 'Z'
      ReadOnly = True
    end
    object Table26Nr: TIntegerField
      FieldName = 'Nr'
    end
    object Table26Inh: TStringField
      FieldName = 'Inh'
      Size = 255
    end
    object Table26Inh2: TMemoField
      FieldName = 'Inh2'
      BlobType = ftMemo
      Size = 10
    end
    object Table26Alt: TStringField
      FieldName = 'Alt'
      Size = 30
    end
  end
  object Table27: TTable
    TableName = 'alfls.db'
    Left = 200
    Top = 296
    object Table27Nr: TAutoIncField
      FieldName = 'Nr'
      ReadOnly = True
    end
    object Table27Dsn: TIntegerField
      FieldName = 'Dsn'
    end
    object Table27Kn: TStringField
      FieldName = 'Kn'
    end
    object Table27Namvorn: TStringField
      FieldName = 'Namvorn'
      Size = 125
    end
    object Table27Geb: TStringField
      FieldName = 'Geb'
      Size = 60
    end
    object Table27Sterb: TStringField
      FieldName = 'Sterb'
      Size = 60
    end
    object Table27Kmt: TStringField
      FieldName = 'Kmt'
      Size = 100
    end
  end
  object DataSource27: TDataSource
    DataSet = Table27
    Left = 136
    Top = 296
  end
  object Table28: TTable
    TableName = 'ng2h'
    Left = 312
    Top = 296
    object Table28N: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object Table28Nr: TIntegerField
      FieldName = 'Nr'
    end
    object Table28Bn: TIntegerField
      FieldName = 'Bn'
    end
    object Table28Ep: TIntegerField
      FieldName = 'Ep'
    end
    object Table28Elt: TIntegerField
      FieldName = 'Elt'
    end
    object Table28Absz: TIntegerField
      FieldName = 'Absz'
    end
    object Table28Ord: TIntegerField
      FieldName = 'Ord'
    end
    object Table28K: TStringField
      FieldName = 'K'
      Size = 1
    end
    object Table28E: TIntegerField
      FieldName = 'E'
    end
    object Table28Lf: TIntegerField
      FieldName = 'Lf'
    end
  end
  object DataSource28: TDataSource
    DataSet = Table28
    Left = 256
    Top = 296
  end
  object Table29: TTable
    TableName = 'sour'
    Left = 424
    Top = 296
    object Table29Quelle: TStringField
      FieldName = 'Quelle'
      Size = 150
    end
  end
  object DataSource29: TDataSource
    DataSet = Table29
    Left = 376
    Top = 296
  end
  object Table30: TTable
    TableName = 'ng2h'
    Left = 512
    Top = 296
    object Table30N: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object Table30Nr: TIntegerField
      FieldName = 'Nr'
    end
    object Table30Bn: TIntegerField
      FieldName = 'Bn'
    end
    object Table30Ep: TIntegerField
      FieldName = 'Ep'
    end
    object Table30Elt: TIntegerField
      FieldName = 'Elt'
    end
    object Table30Absz: TIntegerField
      FieldName = 'Absz'
    end
    object Table30Ord: TIntegerField
      FieldName = 'Ord'
    end
    object Table30K: TStringField
      FieldName = 'K'
      Size = 1
    end
    object Table30E: TIntegerField
      FieldName = 'E'
    end
  end
  object DataSource30: TDataSource
    DataSet = Table30
    Left = 472
    Top = 296
  end
  object Table31: TTable
    TableName = 'adp'
    Left = 624
    Top = 296
    object Table31Nummer: TIntegerField
      FieldName = 'Nummer'
    end
    object Table31Av: TIntegerField
      FieldName = 'Av'
    end
    object Table31Am: TIntegerField
      FieldName = 'Am'
    end
  end
  object DataSource31: TDataSource
    DataSet = Table31
    Left = 576
    Top = 296
  end
  object Table32: TTable
    TableName = 'ftab'
    Left = 88
    Top = 376
    object Table32N: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object Table32Fv: TStringField
      FieldName = 'Fv'
      Size = 6
    end
    object Table32Fm: TStringField
      FieldName = 'Fm'
      Size = 6
    end
    object Table32Fk: TStringField
      FieldName = 'Fk'
      Size = 150
    end
    object Table32Fn: TStringField
      FieldName = 'Fn'
      Size = 15
    end
    object Table32H: TStringField
      FieldName = 'H'
      Size = 15
    end
    object Table32Ho: TStringField
      FieldName = 'Ho'
      Size = 50
    end
    object Table32S: TStringField
      FieldName = 'S'
      Size = 15
    end
    object Table32So: TStringField
      FieldName = 'So'
      Size = 50
    end
    object Table32Sch: TStringField
      FieldName = 'Sch'
      Size = 15
    end
    object Table32Scho: TStringField
      FieldName = 'Scho'
      Size = 50
    end
    object Table32Vb: TStringField
      FieldName = 'Vb'
      Size = 2
    end
    object Table32Indj: TStringField
      FieldName = 'Indj'
      Size = 4
    end
    object Table32Indm: TStringField
      FieldName = 'Indm'
      Size = 2
    end
    object Table32Hq: TStringField
      FieldName = 'Hq'
      Size = 150
    end
    object Table32Sq: TStringField
      FieldName = 'Sq'
      Size = 150
    end
    object Table32Schq: TStringField
      FieldName = 'Schq'
      Size = 150
    end
    object Table32Htz: TStringField
      FieldName = 'Htz'
      Size = 120
    end
    object Table32Stz: TStringField
      FieldName = 'Stz'
      Size = 120
    end
  end
  object DataSource32: TDataSource
    DataSet = Table32
    Left = 40
    Top = 376
  end
  object DataSource33: TDataSource
    DataSet = Table33
    Left = 144
    Top = 376
  end
  object Table33: TTable
    TableName = 'gede.db'
    Left = 200
    Top = 376
    object Table33Typ: TStringField
      FieldName = 'Typ'
    end
    object Table33Inh: TMemoField
      FieldName = 'Inh'
      BlobType = ftMemo
      Size = 10
    end
  end
  object Table34: TTable
    TableName = 'LOC2.db'
    Left = 368
    Top = 376
    object Table34Ort: TStringField
      FieldName = 'Ort'
      Size = 40
    end
    object Table34PLZ: TStringField
      FieldName = 'PLZ'
      Size = 10
    end
    object Table34Land: TStringField
      FieldName = 'Land'
      Size = 50
    end
    object Table34RegBez: TStringField
      FieldName = 'RegBez'
      Size = 50
    end
    object Table34FOKO_ID: TStringField
      FieldName = 'FOKO_ID'
      Size = 30
    end
    object Table34Bland: TStringField
      FieldName = 'Bland'
      Size = 50
    end
    object Table34Gde: TStringField
      FieldName = 'Gde'
      Size = 50
    end
    object Table34Pfr: TStringField
      FieldName = 'Pfr'
      Size = 50
    end
    object Table34Lkr: TStringField
      FieldName = 'Lkr'
      Size = 50
    end
    object Table34Abk: TStringField
      FieldName = 'Abk'
    end
    object Table34Lg: TStringField
      FieldName = 'Lg'
      Size = 30
    end
    object Table34Bg: TStringField
      FieldName = 'Bg'
      Size = 30
    end
    object Table34Maid: TStringField
      FieldName = 'Maid'
      Size = 10
    end
  end
  object DataSource34: TDataSource
    DataSet = Table34
    Left = 312
    Top = 376
  end
  object DataSource35: TDataSource
    DataSet = Table35
    Left = 448
    Top = 376
  end
  object Table35: TTable
    TableName = 'occ.db'
    Left = 512
    Top = 376
    object Table35NN: TAutoIncField
      FieldName = 'NN'
      ReadOnly = True
    end
    object Table35Occ: TStringField
      FieldName = 'Occ'
      Size = 70
    end
  end
  object DataSource36: TDataSource
    DataSet = Table36
    Left = 584
    Top = 376
  end
  object Table36: TTable
    TableName = 'lfbh.db'
    Left = 632
    Top = 376
    object Table36Nr: TAutoIncField
      FieldName = 'Nr'
      ReadOnly = True
    end
    object Table36Nm: TIntegerField
      FieldName = 'Nm'
    end
    object Table36Prob: TStringField
      FieldName = 'Prob'
      Size = 6
    end
    object Table36Eh: TStringField
      FieldName = 'Eh'
      Size = 70
    end
    object Table36Ix: TStringField
      FieldName = 'Ix'
      Size = 50
    end
    object Table36Nam: TStringField
      FieldName = 'Nam'
      Size = 50
    end
    object Table36Aus: TIntegerField
      FieldName = 'Aus'
    end
  end
  object Table37: TTable
    TableName = 'ndh.db'
    Left = 88
    Top = 440
    object Table37Hofname: TStringField
      FieldName = 'Hofname'
      Size = 100
    end
  end
  object DataSource37: TDataSource
    DataSet = Table37
    Left = 40
    Top = 440
  end
  object DataSource38: TDataSource
    DataSet = Table38
    Left = 168
    Top = 440
  end
  object Table38: TTable
    TableName = 'sour2'
    Left = 208
    Top = 440
    object Table38N: TAutoIncField
      FieldName = 'N'
      ReadOnly = True
    end
    object Table38Titel: TStringField
      FieldName = 'Titel'
      Size = 80
    end
    object Table38Abk: TStringField
      FieldName = 'Abk'
      Size = 80
    end
    object Table38Ereig: TStringField
      FieldName = 'Ereig'
      Size = 40
    end
    object Table38Von: TStringField
      FieldName = 'Von'
      Size = 10
    end
    object Table38Bis: TStringField
      FieldName = 'Bis'
      Size = 10
    end
    object Table38Standort: TStringField
      FieldName = 'Standort'
      Size = 40
    end
    object Table38Publ: TMemoField
      FieldName = 'Publ'
      BlobType = ftMemo
      Size = 10
    end
    object Table38Rep: TStringField
      FieldName = 'Rep'
      Size = 60
    end
    object Table38Bem: TMemoField
      FieldName = 'Bem'
      BlobType = ftMemo
      Size = 10
    end
    object Table38Bestand: TStringField
      FieldName = 'Bestand'
      Size = 40
    end
    object Table38Med: TStringField
      FieldName = 'Med'
    end
  end
end
