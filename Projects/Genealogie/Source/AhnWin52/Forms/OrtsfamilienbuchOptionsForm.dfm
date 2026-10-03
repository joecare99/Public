object Form24: TOrtsfamilienbuchOptionsForm
  Left = 199
  Top = 113
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Parameter für OFB (keine Auswahl -> alle)'
  ClientHeight = 489
  ClientWidth = 904
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Namen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 296
    Top = 8
    Width = 25
    Height = 13
    Caption = 'Orte'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape1: TShape
    Left = 0
    Top = 233
    Width = 904
    Height = 1
  end
  object Label4: TLabel
    Left = 584
    Top = 8
    Width = 58
    Height = 13
    Caption = 'Hofnamen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 121
    Height = 185
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnDblClick = ListBox1DblClick
  end
  object ListBox2: TListBox
    Left = 296
    Top = 32
    Width = 121
    Height = 185
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnDblClick = ListBox2DblClick
  end
  object ListBox3: TListBox
    Left = 160
    Top = 32
    Width = 121
    Height = 185
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
    OnDblClick = ListBox3DblClick
  end
  object ListBox4: TListBox
    Left = 448
    Top = 32
    Width = 121
    Height = 185
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
    OnDblClick = ListBox4DblClick
  end
  object Button2: TButton
    Left = 134
    Top = 88
    Width = 22
    Height = 21
    Caption = '>'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 422
    Top = 88
    Width = 22
    Height = 21
    Caption = '>'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 134
    Top = 112
    Width = 22
    Height = 21
    Caption = '<'
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 422
    Top = 112
    Width = 22
    Height = 21
    Caption = '<'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 134
    Top = 136
    Width = 22
    Height = 21
    Caption = '<<'
    TabOrder = 8
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 422
    Top = 136
    Width = 22
    Height = 21
    Caption = '<<'
    TabOrder = 9
    OnClick = Button7Click
  end
  object Panel1: TPanel
    Left = 152
    Top = 234
    Width = 288
    Height = 215
    TabOrder = 10
    object CheckBox4: TCheckBox
      Left = 142
      Top = 64
      Width = 59
      Height = 17
      Caption = 'Alter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckBox5: TCheckBox
      Left = 24
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Beruf'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CheckBox6: TCheckBox
      Left = 24
      Top = 104
      Width = 57
      Height = 17
      Caption = 'Text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object CheckBox7: TCheckBox
      Left = 142
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Todesursache'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CheckBox8: TCheckBox
      Left = 24
      Top = 184
      Width = 82
      Height = 17
      Caption = 'Trauzeugen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object CheckBox9: TCheckBox
      Left = 24
      Top = 144
      Width = 81
      Height = 17
      Caption = 'Taufpaten'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object CheckBox2: TCheckBox
      Left = 142
      Top = 125
      Width = 97
      Height = 17
      Caption = 'nichtehel.Kinder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
    end
    object CheckBox10: TCheckBox
      Left = 24
      Top = 64
      Width = 81
      Height = 17
      Caption = 'Bekenntnis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object CheckBox1: TCheckBox
      Left = 142
      Top = 104
      Width = 129
      Height = 17
      Caption = 'auch Einzelpersonen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object CheckBox3: TCheckBox
      Left = 142
      Top = 183
      Width = 97
      Height = 17
      Caption = 'Datensatz-Nr.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object CheckBox11: TCheckBox
      Left = 142
      Top = 144
      Width = 97
      Height = 17
      Caption = 'and.Schreibw.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
  end
  object Panel2: TPanel
    Left = 750
    Top = 234
    Width = 155
    Height = 255
    TabOrder = 11
    object SpeedButton1: TSpeedButton
      Left = 30
      Top = 96
      Width = 90
      Height = 26
      Caption = 'OFB-Druck'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
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
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 31
      Top = 166
      Width = 89
      Height = 26
      Caption = 'Abbruch'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
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
        0000
      }
      NumGlyphs = 2
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object Button9: TButton
      Left = 19
      Top = 26
      Width = 110
      Height = 25
      Caption = 'Listen aktualisieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button9Click
    end
  end
  object Panel3: TPanel
    Left = 151
    Top = 449
    Width = 289
    Height = 40
    TabOrder = 12
    object RadioButton4: TRadioButton
      Left = 10
      Top = 12
      Width = 103
      Height = 17
      Caption = 'alle markieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = RadioButton4Click
    end
    object RadioButton5: TRadioButton
      Left = 122
      Top = 12
      Width = 153
      Height = 17
      Caption = 'Markierungen entfernen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = RadioButton5Click
    end
  end
  object ListBox5: TListBox
    Left = 584
    Top = 32
    Width = 145
    Height = 185
    ItemHeight = 13
    Sorted = True
    TabOrder = 13
    OnDblClick = ListBox5DblClick
  end
  object ListBox6: TListBox
    Left = 762
    Top = 32
    Width = 135
    Height = 185
    ItemHeight = 13
    Sorted = True
    TabOrder = 14
    OnDblClick = ListBox4DblClick
  end
  object Button1: TButton
    Left = 734
    Top = 88
    Width = 22
    Height = 21
    Caption = '>'
    TabOrder = 15
    OnClick = Button1Click
  end
  object Button8: TButton
    Left = 734
    Top = 112
    Width = 22
    Height = 21
    Caption = '<'
    TabOrder = 16
    OnClick = Button8Click
  end
  object Button10: TButton
    Left = 734
    Top = 136
    Width = 22
    Height = 21
    Caption = '<<'
    TabOrder = 17
    OnClick = Button10Click
  end
  object Panel4: TPanel
    Left = 0
    Top = 234
    Width = 151
    Height = 255
    TabOrder = 18
    object Label3: TLabel
      Left = 26
      Top = 29
      Width = 64
      Height = 14
      Caption = 'sortiert nach:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object RadioButton1: TRadioButton
      Left = 24
      Top = 64
      Width = 105
      Height = 17
      Caption = 'Geburts-Datum'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 24
      Top = 104
      Width = 97
      Height = 17
      Caption = 'Heirats-Datum'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 24
      Top = 144
      Width = 97
      Height = 17
      Caption = 'Name,Vorname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object TPanel
    Left = 440
    Top = 234
    Width = 309
    Height = 255
    TabOrder = 19
    object Label5: TLabel
      Left = 38
      Top = 170
      Width = 63
      Height = 14
      Caption = 'Namen-Liste:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object CheckBox14: TCheckBox
      Left = 124
      Top = 64
      Width = 113
      Height = 17
      Caption = 'Kinder tabellarisch'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object CheckBox16: TCheckBox
      Left = 124
      Top = 104
      Width = 97
      Height = 17
      Caption = 'Orte abkürzen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CheckBox15: TCheckBox
      Left = 124
      Top = 136
      Width = 121
      Height = 17
      Caption = 'auch Einzelpersonen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
    object CheckBox17: TCheckBox
      Left = 124
      Top = 167
      Width = 89
      Height = 17
      Caption = 'mit Vornamen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CheckBox17Click
    end
    object CheckBox18: TCheckBox
      Left = 124
      Top = 191
      Width = 89
      Height = 17
      Caption = 'mit Geb.-Jahr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = CheckBox18Click
    end
  end
end
