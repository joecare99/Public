object OKBottomDlg1: TOKBottomDlg1
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Parameter f.Gedcom-Datei'
  ClientHeight = 370
  ClientWidth = 342
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 326
    Height = 224
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 15
    Top = 26
    Width = 43
    Height = 13
    Caption = 'Ihr Name'
  end
  object Label2: TLabel
    Left = 15
    Top = 74
    Width = 41
    Height = 13
    Caption = 'Anschrift'
  end
  object Label3: TLabel
    Left = 15
    Top = 106
    Width = 23
    Height = 13
    Caption = 'PLZ '
  end
  object Label5: TLabel
    Left = 16
    Top = 202
    Width = 56
    Height = 13
    Caption = 'internat.Tel.'
  end
  object SpeedButton1: TSpeedButton
    Left = 72
    Top = 330
    Width = 69
    Height = 26
    Caption = 'Fertig'
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
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 200
    Top = 330
    Width = 74
    Height = 26
    Caption = 'Abbruch'
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
    OnClick = SpeedButton2Click
  end
  object Label6: TLabel
    Left = 15
    Top = 45
    Width = 123
    Height = 14
    Caption = '(bitte unbedingt angeben)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 15
    Top = 138
    Width = 14
    Height = 13
    Caption = 'Ort'
  end
  object Label8: TLabel
    Left = 15
    Top = 170
    Width = 25
    Height = 13
    Caption = 'Email'
  end
  object Edit1: TEdit
    Left = 80
    Top = 22
    Width = 233
    Height = 21
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 80
    Top = 70
    Width = 233
    Height = 21
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 80
    Top = 102
    Width = 233
    Height = 21
    TabOrder = 2
  end
  object Edit4: TEdit
    Left = 80
    Top = 198
    Width = 233
    Height = 21
    TabOrder = 5
  end
  object Panel1: TPanel
    Left = 8
    Top = 231
    Width = 325
    Height = 42
    TabOrder = 6
  end
  object CheckBox1: TCheckBox
    Left = 120
    Top = 246
    Width = 113
    Height = 17
    Caption = 'Texte ausschlie'#223'en'
    TabOrder = 7
  end
  object Panel2: TPanel
    Left = 8
    Top = 273
    Width = 325
    Height = 41
    TabOrder = 8
    object Label4: TLabel
      Left = 16
      Top = 13
      Width = 51
      Height = 13
      Caption = 'Codierung:'
    end
    object RadioButton1: TRadioButton
      Left = 162
      Top = 13
      Width = 71
      Height = 17
      Caption = 'ANSI'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 82
      Top = 13
      Width = 63
      Height = 17
      Caption = 'UTF-8'
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 234
      Top = 13
      Width = 71
      Height = 17
      Caption = 'Unicode'
      Enabled = False
      TabOrder = 2
      Visible = False
    end
  end
  object Edit5: TEdit
    Left = 80
    Top = 134
    Width = 233
    Height = 21
    TabOrder = 3
  end
  object Edit6: TEdit
    Left = 80
    Top = 166
    Width = 233
    Height = 21
    TabOrder = 4
  end
end
