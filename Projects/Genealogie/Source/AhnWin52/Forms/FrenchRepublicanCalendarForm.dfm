object Form7: TFrenchRepublicanCalendarForm
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Frz.Revolutions-Kalender'
  ClientHeight = 217
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 8
    Width = 183
    Height = 14
    Caption = 'Datum des Revolutionskalenders'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 23
    Top = 47
    Width = 19
    Height = 14
    Caption = 'Tag'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 105
    Top = 48
    Width = 34
    Height = 14
    Caption = 'Monat'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 275
    Top = 48
    Width = 24
    Height = 14
    Caption = 'Jahr'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 88
    Top = 96
    Width = 213
    Height = 14
    Caption = 'Datum des Gregorianischen Kalenders'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape1: TShape
    Left = 0
    Top = 173
    Width = 385
    Height = 1
  end
  object ComboBox1: TComboBox
    Left = 52
    Top = 44
    Width = 42
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 0
    OnChange = ComboBox1Change
    Items.Strings = (
      ' 1'
      ' 2'
      ' 3'
      ' 4'
      ' 5'
      ' 6'
      ' 7'
      ' 8'
      ' 9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23'
      '24'
      '25'
      '26'
      '27'
      '28'
      '29'
      '30'
      'jc 1'
      'jc 2'
      'jc 3'
      'jc 4'
      'jc 5'
      'jrev'
    )
  end
  object ComboBox2: TComboBox
    Left = 148
    Top = 44
    Width = 113
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    OnChange = ComboBox2Change
    Items.Strings = (
      'Vendémiaire'
      'Brumaire'
      'Frimaire'
      'Nivôse'
      'Pluviôse'
      'Ventôse'
      'Germinal'
      'Floréal'
      'Prairial'
      'Messidor'
      'Thermidor'
      'Fructidor'
    )
  end
  object ComboBox3: TComboBox
    Left = 308
    Top = 44
    Width = 44
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 2
    OnChange = ComboBox3Change
    Items.Strings = (
      ' I'
      ' II'
      ' III'
      ' IV'
      ' V'
      ' VI'
      ' VII'
      ' VIII'
      ' IX'
      ' X'
      ' XI'
      ' XII'
      ' XIII'
      ' XIV'
    )
  end
  object Edit1: TEdit
    Left = 171
    Top = 133
    Width = 71
    Height = 18
    TabStop = False
    AutoSelect = False
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
  end
  object BitBtn1: TBitBtn
    Left = 166
    Top = 184
    Width = 81
    Height = 25
    Caption = '  fertig'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 4
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
      0000
    }
    NumGlyphs = 2
  end
end
