object Form17: TForm17
  Left = 193
  Top = 115
  Width = 259
  Height = 519
  Caption = 'Parameter f'#252'r Familienblatt'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 32
    Top = 445
    Width = 75
    Height = 24
    Caption = 'Fertig'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
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
  object BitBtn2: TBitBtn
    Left = 136
    Top = 445
    Width = 80
    Height = 24
    Caption = 'Abbruch'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn2Click
    Kind = bkAbort
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 243
    Height = 433
    Align = alTop
    TabOrder = 2
    object Shape1: TShape
      Left = 2
      Top = 374
      Width = 246
      Height = 1
    end
    object CheckBox1: TCheckBox
      Left = 72
      Top = 14
      Width = 97
      Height = 17
      Caption = 'IDs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 72
      Top = 62
      Width = 97
      Height = 17
      Caption = 'Quellen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 72
      Top = 86
      Width = 97
      Height = 17
      Caption = 'Text(e)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 72
      Top = 204
      Width = 145
      Height = 17
      Caption = 'Taufpaten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 72
      Top = 348
      Width = 129
      Height = 17
      Caption = 'Bilder Kinder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object CheckBox6: TCheckBox
      Left = 72
      Top = 228
      Width = 97
      Height = 17
      Caption = 'Trauzeugen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object CheckBox7: TCheckBox
      Left = 72
      Top = 180
      Width = 97
      Height = 17
      Caption = 'Bekenntnis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object CheckBox8: TCheckBox
      Left = 72
      Top = 300
      Width = 113
      Height = 17
      Caption = 'Todesursachen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object CheckBox11: TCheckBox
      Left = 72
      Top = 134
      Width = 97
      Height = 17
      Caption = 'Beruf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object CheckBox12: TCheckBox
      Left = 72
      Top = 252
      Width = 97
      Height = 17
      Caption = 'Ehen Kinder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object CheckBox13: TCheckBox
      Left = 72
      Top = 157
      Width = 97
      Height = 17
      Caption = 'Hofname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
    object CheckBox14: TCheckBox
      Left = 72
      Top = 108
      Width = 158
      Height = 17
      Caption = 'andere Schreibweisen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
    end
    object CheckBox15: TCheckBox
      Left = 72
      Top = 276
      Width = 158
      Height = 17
      Caption = 'Sterbe-Alter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
    end
    object CheckBox16: TCheckBox
      Left = 72
      Top = 324
      Width = 65
      Height = 17
      Caption = 'Bild(er)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
    end
    object RadioButton1: TRadioButton
      Left = 71
      Top = 384
      Width = 113
      Height = 17
      Caption = 'alle markieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 71
      Top = 408
      Width = 113
      Height = 17
      Caption = 'alle l'#246'schen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      OnClick = RadioButton2Click
    end
    object CheckBox9: TCheckBox
      Left = 72
      Top = 39
      Width = 97
      Height = 17
      Caption = 'Datensatz-Nr.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
    end
  end
end
