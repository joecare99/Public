object Form33: TForm33
  Left = 201
  Top = 67
  HelpContext = 7
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Orts-Verwaltung'
  ClientHeight = 535
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 24
    Top = 86
    Width = 62
    Height = 16
    Caption = 'Abk'#252'rzung'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 59
    Width = 101
    Height = 16
    Caption = 'Neuer Orts-Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 140
    Width = 59
    Height = 16
    Caption = 'Gemeinde'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 24
    Top = 167
    Width = 56
    Height = 16
    Caption = 'Landkreis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 24
    Top = 221
    Width = 93
    Height = 16
    Caption = '(Bundes-)Land *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 24
    Top = 248
    Width = 96
    Height = 16
    Caption = 'Land (internat.) *'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 24
    Top = 275
    Width = 98
    Height = 16
    Caption = 'Pfarrei/Kirchspiel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 24
    Top = 358
    Width = 67
    Height = 16
    Caption = 'L'#228'ngengrad'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 24
    Top = 382
    Width = 66
    Height = 16
    Caption = 'Breitengrad'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 25
    Top = 194
    Width = 68
    Height = 16
    Caption = 'Reg.-Bezirk'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 24
    Top = 113
    Width = 23
    Height = 16
    Caption = 'PLZ'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Shape1: TShape
    Left = -23
    Top = 476
    Width = 433
    Height = 1
  end
  object Label12: TLabel
    Left = 24
    Top = 14
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape2: TShape
    Left = 0
    Top = 42
    Width = 410
    Height = 1
  end
  object Shape3: TShape
    Left = -23
    Top = 437
    Width = 434
    Height = 1
  end
  object Label13: TLabel
    Left = 24
    Top = 304
    Width = 29
    Height = 16
    Caption = 'GOV'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Shape4: TShape
    Left = -24
    Top = 416
    Width = 434
    Height = 1
  end
  object Label14: TLabel
    Left = 24
    Top = 420
    Width = 194
    Height = 13
    Caption = '* Tabelle zu Terr.bzw. Land:  s. Hilfedatei'
  end
  object Label15: TLabel
    Left = 24
    Top = 331
    Width = 70
    Height = 16
    Caption = 'Maidenhead'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object DBEdit2: TDBEdit
    Left = 144
    Top = 83
    Width = 241
    Height = 24
    DataField = 'Abk'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object DBEdit3: TDBEdit
    Left = 144
    Top = 137
    Width = 241
    Height = 24
    DataField = 'Gde'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object DBEdit4: TDBEdit
    Left = 144
    Top = 164
    Width = 241
    Height = 24
    DataField = 'Lkr'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object DBEdit5: TDBEdit
    Left = 144
    Top = 218
    Width = 241
    Height = 24
    DataField = 'Bland'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object DBEdit6: TDBEdit
    Left = 144
    Top = 245
    Width = 241
    Height = 24
    DataField = 'Land'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object DBEdit7: TDBEdit
    Left = 144
    Top = 272
    Width = 241
    Height = 24
    DataField = 'Pfr'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object DBEdit8: TDBEdit
    Left = 144
    Top = 355
    Width = 241
    Height = 24
    DataField = 'Lg'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
  end
  object DBEdit9: TDBEdit
    Left = 144
    Top = 379
    Width = 241
    Height = 24
    DataField = 'Bg'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
  end
  object DBEdit10: TDBEdit
    Left = 144
    Top = 191
    Width = 241
    Height = 24
    DataField = 'RegBez'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object DBEdit11: TDBEdit
    Left = 144
    Top = 110
    Width = 241
    Height = 24
    DataField = 'PLZ'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 248
    Top = 490
    Width = 75
    Height = 25
    Caption = 'Fertig'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    TabStop = False
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 438
    Width = 410
    Height = 38
    TabOrder = 13
    object RadioButton1: TRadioButton
      Left = 13
      Top = 10
      Width = 196
      Height = 17
      Caption = #228'ndern im aktuellen Datensatz'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 237
      Top = 10
      Width = 156
      Height = 17
      Caption = 'alle Vorkommen '#228'ndern'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object BitBtn2: TBitBtn
    Left = 88
    Top = 491
    Width = 84
    Height = 25
    Caption = 'Abbruch'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 15
    TabStop = False
    OnClick = BitBtn2Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object Edit1: TEdit
    Left = 144
    Top = 56
    Width = 241
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object DBEdit1: TDBEdit
    Left = 144
    Top = 300
    Width = 169
    Height = 24
    DataField = 'Gov'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object DBEdit12: TDBEdit
    Left = 144
    Top = 328
    Width = 169
    Height = 24
    DataField = 'Maid'
    DataSource = DataModule2.DataSource13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
end
