object Form19: TForm19
  Left = 195
  Top = 110
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Parameter f'#252'r Nachfahrenlisten'
  ClientHeight = 364
  ClientWidth = 427
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
  object Panel3: TPanel
    Left = 236
    Top = 176
    Width = 191
    Height = 98
    TabOrder = 4
    object Label1: TLabel
      Left = 30
      Top = 13
      Width = 129
      Height = 16
      Caption = 'Anzahl Generationen: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 32
      Top = 32
      Width = 117
      Height = 16
      Caption = 'Beginn mit Kek.-Nr.:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 78
      Top = 38
      Width = 41
      Height = 21
      TabStop = False
      TabOrder = 0
      Text = '1'
    end
    object Button1: TButton
      Left = 56
      Top = 40
      Width = 18
      Height = 17
      Caption = '-'
      TabOrder = 1
      TabStop = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 123
      Top = 40
      Width = 18
      Height = 17
      Caption = '+'
      TabOrder = 2
      TabStop = False
      OnClick = Button2Click
    end
    object Edit2: TEdit
      Left = 78
      Top = 46
      Width = 41
      Height = 21
      TabStop = False
      TabOrder = 3
      Text = '1'
    end
    object Button3: TButton
      Left = 56
      Top = 48
      Width = 18
      Height = 17
      Caption = '-'
      TabOrder = 4
      TabStop = False
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 123
      Top = 48
      Width = 18
      Height = 17
      Caption = '+'
      TabOrder = 5
      TabStop = False
      OnClick = Button4Click
    end
  end
  object BitBtn1: TBitBtn
    Left = 80
    Top = 326
    Width = 84
    Height = 26
    Caption = 'Fertig'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 256
    Top = 326
    Width = 94
    Height = 26
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
    Width = 235
    Height = 274
    TabOrder = 2
    object CheckBox2: TCheckBox
      Left = 18
      Top = 85
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Quellen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckBox1: TCheckBox
      Left = 18
      Top = 21
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'IDs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 18
      Top = 117
      Width = 97
      Height = 17
      TabStop = False
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
      Left = 18
      Top = 149
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Beruf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 18
      Top = 213
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Bekenntnis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object CheckBox6: TCheckBox
      Left = 123
      Top = 21
      Width = 111
      Height = 17
      TabStop = False
      Caption = 'Todesursachen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object CheckBox12: TCheckBox
      Left = 18
      Top = 181
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Hofname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object CheckBox13: TCheckBox
      Left = 123
      Top = 53
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Taufpaten'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object CheckBox14: TCheckBox
      Left = 123
      Top = 85
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Trauzeugen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object CheckBox15: TCheckBox
      Left = 123
      Top = 117
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Lebensort(e)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = CheckBox15Click
    end
    object CheckBox16: TCheckBox
      Left = 123
      Top = 181
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'B'#252'rgerort(e)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Visible = False
    end
    object CheckBox9: TCheckBox
      Left = 123
      Top = 149
      Width = 110
      Height = 17
      TabStop = False
      Caption = 'and.Schreibw.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      Visible = False
    end
    object CheckBox10: TCheckBox
      Left = 18
      Top = 53
      Width = 97
      Height = 17
      TabStop = False
      Caption = 'Datensatz-Nr.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
    end
    object CheckBox17: TCheckBox
      Left = 18
      Top = 242
      Width = 211
      Height = 18
      Caption = 'Fam.-Namen in GROSSBUCHST.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
    end
  end
  object Panel2: TPanel
    Left = 236
    Top = 0
    Width = 191
    Height = 127
    TabOrder = 3
    object CheckBox7: TCheckBox
      Left = 22
      Top = 24
      Width = 162
      Height = 17
      TabStop = False
      Caption = 'alphabetische Liste'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckBox8: TCheckBox
      Left = 22
      Top = 56
      Width = 161
      Height = 17
      TabStop = False
      Caption = 'Ahnenschwund ber'#252'cks.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CheckBox11: TCheckBox
      Left = 22
      Top = 88
      Width = 163
      Height = 17
      TabStop = False
      Caption = 'nichtehel.Beziehungen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 274
    Width = 426
    Height = 41
    TabOrder = 5
    object RadioButton1: TRadioButton
      Left = 64
      Top = 12
      Width = 113
      Height = 17
      Caption = 'alle markieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 223
      Top = 13
      Width = 154
      Height = 17
      Caption = 'Markierungen l'#246'schen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = RadioButton2Click
    end
  end
  object Panel5: TPanel
    Left = 236
    Top = 127
    Width = 191
    Height = 49
    Caption = 'Panel5'
    TabOrder = 6
    object Label2: TLabel
      Left = 8
      Top = 18
      Width = 21
      Height = 16
      Caption = 'Art:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ComboBox1: TComboBox
      Left = 37
      Top = 14
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      TabStop = False
      OnChange = ComboBox1Change
      Items.Strings = (
        'Nachfahrenliste'
        'Stammliste')
    end
  end
end
