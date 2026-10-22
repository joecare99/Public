object QRCompEd: TQRCompEd
  Left = 251
  Top = 142
  BorderStyle = bsDialog
  Caption = 'Reporteinstellungen'
  ClientHeight = 425
  ClientWidth = 459
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object About: TButton
    Left = 8
    Top = 394
    Width = 117
    Height = 25
    Caption = #220'ber &QuickReport'
    TabOrder = 5
    OnClick = AboutClick
  end
  object Preview: TButton
    Left = 129
    Top = 394
    Width = 74
    Height = 25
    Caption = '&Druckbild'
    TabOrder = 6
    OnClick = PreviewClick
  end
  object Apply1: TButton
    Left = 207
    Top = 394
    Width = 84
    Height = 25
    Caption = #220'&bernehmen'
    TabOrder = 7
    OnClick = Apply1Click
  end
  object OK1: TButton
    Left = 295
    Top = 394
    Width = 74
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 8
    OnClick = OK1Click
  end
  object Cancel1: TButton
    Left = 373
    Top = 394
    Width = 74
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 9
    OnClick = Cancel1Click
  end
  object PaperSizeGB: TGroupBox
    Left = 8
    Top = 4
    Width = 441
    Height = 47
    Caption = 'Papiergr'#246#223'e'
    TabOrder = 0
    object Label5: TLabel
      Left = 152
      Top = 20
      Width = 27
      Height = 13
      Caption = 'Breite'
    end
    object Label6: TLabel
      Left = 236
      Top = 20
      Width = 30
      Height = 13
      Caption = 'L'#228'nge'
    end
    object PaperSize: TComboBox
      Left = 8
      Top = 16
      Width = 139
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object PageWidth: TEdit
      Left = 194
      Top = 16
      Width = 37
      Height = 21
      TabOrder = 1
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object PageLength: TEdit
      Left = 278
      Top = 16
      Width = 37
      Height = 21
      TabOrder = 2
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object OrientationCB: TComboBox
      Left = 330
      Top = 16
      Width = 93
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'Hochformat'
        'Querformat')
    end
  end
  object MarginsGB: TGroupBox
    Left = 8
    Top = 56
    Width = 441
    Height = 69
    Caption = 'R'#228'nder'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 26
      Height = 13
      Caption = 'Oben'
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 29
      Height = 13
      Caption = 'Unten'
    end
    object Label3: TLabel
      Left = 152
      Top = 16
      Width = 25
      Height = 13
      Caption = 'Links'
    end
    object Label4: TLabel
      Left = 152
      Top = 42
      Width = 34
      Height = 13
      Caption = 'Rechts'
    end
    object Label7: TLabel
      Left = 274
      Top = 14
      Width = 105
      Height = 13
      AutoSize = False
      Caption = 'Spaltenabstand'
    end
    object Label8: TLabel
      Left = 274
      Top = 44
      Width = 105
      Height = 13
      AutoSize = False
      Caption = 'Anzahl Spalten'
    end
    object SpeedButton1: TSpeedButton
      Left = 408
      Top = 37
      Width = 13
      Height = 12
      Glyph.Data = {
        8A000000424D8A00000000000000760000002800000007000000050000000100
        0400000000001400000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF00000
        0000F00000F0FF000FF0FFF0FFF0}
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 408
      Top = 48
      Width = 13
      Height = 12
      Glyph.Data = {
        86000000424D8600000000000000760000002800000007000000040000000100
        0400000000001000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF0FFF0FF00
        0FF0F00000F000000000}
      OnClick = SpeedButton2Click
    end
    object Topmargin: TEdit
      Left = 62
      Top = 12
      Width = 37
      Height = 21
      TabOrder = 0
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object BottomMargin: TEdit
      Left = 62
      Top = 38
      Width = 37
      Height = 21
      TabOrder = 1
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object LeftMargin: TEdit
      Left = 194
      Top = 12
      Width = 37
      Height = 21
      TabOrder = 2
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object RightMargin: TEdit
      Left = 194
      Top = 38
      Width = 37
      Height = 21
      TabOrder = 3
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object ColumnMargin: TEdit
      Left = 384
      Top = 12
      Width = 37
      Height = 21
      TabOrder = 4
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object Columns: TEdit
      Left = 384
      Top = 38
      Width = 23
      Height = 21
      TabOrder = 5
      Text = '1'
      OnKeyPress = FloatKeyPress
    end
  end
  object OtherGB: TGroupBox
    Left = 8
    Top = 130
    Width = 441
    Height = 47
    Caption = 'Sonstiges'
    TabOrder = 2
    object Label9: TLabel
      Left = 276
      Top = 20
      Width = 48
      Height = 13
      AutoSize = False
      Caption = 'Einheit'
    end
    object Label10: TLabel
      Left = 8
      Top = 20
      Width = 37
      Height = 13
      Caption = 'Schrift'
    end
    object Label11: TLabel
      Left = 168
      Top = 20
      Width = 39
      Height = 13
      AutoSize = False
      Caption = 'Gr'#246#223'e'
    end
    object Units: TComboBox
      Left = 328
      Top = 18
      Width = 93
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'mm'
        'Zoll'
        'Pixel'
        'Zeichen'
        'Origin'#228'r')
    end
    object FontName: TComboBox
      Left = 50
      Top = 16
      Width = 111
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object FontSize: TComboBox
      Left = 210
      Top = 16
      Width = 53
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnKeyPress = FloatKeyPress
    end
  end
  object PageFrameGB: TGroupBox
    Left = 8
    Top = 184
    Width = 441
    Height = 61
    Caption = 'Seitenrand'
    TabOrder = 3
    object Label12: TLabel
      Left = 142
      Top = 18
      Width = 39
      Height = 13
      AutoSize = False
      Caption = 'Farbe'
    end
    object FrameColor: TShape
      Left = 182
      Top = 16
      Width = 17
      Height = 17
      Pen.Style = psClear
      Pen.Width = 0
    end
    object Label13: TLabel
      Left = 308
      Top = 18
      Width = 69
      Height = 13
      AutoSize = False
      Caption = 'Randbreite'
    end
    object SpeedButton3: TSpeedButton
      Left = 408
      Top = 13
      Width = 13
      Height = 12
      Glyph.Data = {
        8A000000424D8A00000000000000760000002800000007000000050000000100
        0400000000001400000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFF00000
        0000F00000F0FF000FF0FFF0FFF0}
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 408
      Top = 25
      Width = 13
      Height = 12
      Glyph.Data = {
        86000000424D8600000000000000760000002800000007000000040000000100
        0400000000001000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF0FFF0FF00
        0FF0F00000F000000000}
      OnClick = SpeedButton4Click
    end
    object PageFrameTop: TCheckBox
      Left = 8
      Top = 16
      Width = 61
      Height = 17
      Caption = 'Oben'
      TabOrder = 0
    end
    object PageFrameBottom: TCheckBox
      Left = 8
      Top = 36
      Width = 73
      Height = 17
      Caption = 'Unten'
      TabOrder = 1
    end
    object PageFrameLeft: TCheckBox
      Left = 84
      Top = 16
      Width = 53
      Height = 17
      Caption = 'Links'
      TabOrder = 2
    end
    object PageFrameRight: TCheckBox
      Left = 84
      Top = 36
      Width = 60
      Height = 17
      Caption = 'Rechts'
      TabOrder = 3
    end
    object ColorButton: TButton
      Left = 206
      Top = 14
      Width = 58
      Height = 21
      Caption = #196'ndern'
      TabOrder = 4
      OnClick = ColorButtonClick
    end
    object PageFramePenWidth: TEdit
      Left = 384
      Top = 14
      Width = 23
      Height = 21
      TabOrder = 5
      Text = '0'
      OnKeyPress = FloatKeyPress
    end
  end
  object BandsGB: TGroupBox
    Left = 8
    Top = 250
    Width = 441
    Height = 135
    Caption = 'Bereiche'
    TabOrder = 4
    object Label14: TLabel
      Left = 118
      Top = 12
      Width = 30
      Height = 13
      Caption = 'L'#228'nge'
    end
    object Label15: TLabel
      Left = 360
      Top = 12
      Width = 30
      Height = 13
      Caption = 'L'#228'nge'
    end
    object Title: TCheckBox
      Left = 8
      Top = 56
      Width = 89
      Height = 17
      Caption = 'Titel'
      TabOrder = 2
    end
    object PageHeader: TCheckBox
      Left = 8
      Top = 32
      Width = 89
      Height = 17
      Caption = 'Kopfzeile'
      TabOrder = 0
    end
    object ColumnHeader: TCheckBox
      Left = 8
      Top = 80
      Width = 100
      Height = 17
      Caption = 'Spaltentitel'
      TabOrder = 4
    end
    object Detail: TCheckBox
      Left = 8
      Top = 104
      Width = 100
      Height = 17
      Caption = 'Detailbereich'
      TabOrder = 6
    end
    object PageHeaderLength: TEdit
      Left = 118
      Top = 28
      Width = 37
      Height = 21
      TabOrder = 1
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object TitleLength: TEdit
      Left = 118
      Top = 52
      Width = 37
      Height = 21
      TabOrder = 3
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object ColumnHeaderLength: TEdit
      Left = 118
      Top = 76
      Width = 37
      Height = 21
      TabOrder = 5
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object DetailLength: TEdit
      Left = 118
      Top = 100
      Width = 37
      Height = 21
      TabOrder = 7
      OnEnter = PageWidthEnter
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object SummaryLength: TEdit
      Left = 361
      Top = 52
      Width = 37
      Height = 21
      TabOrder = 11
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object PageFooter: TCheckBox
      Left = 226
      Top = 32
      Width = 85
      Height = 17
      Caption = 'Fu'#223'zeile'
      TabOrder = 8
    end
    object Summary: TCheckBox
      Left = 226
      Top = 56
      Width = 130
      Height = 17
      Caption = 'Zusammenfassung'
      TabOrder = 10
    end
    object PageFooterLength: TEdit
      Left = 361
      Top = 28
      Width = 37
      Height = 21
      TabOrder = 9
      OnExit = PageWidthExit
      OnKeyPress = FloatKeyPress
    end
    object FirstPageHeader: TCheckBox
      Left = 226
      Top = 80
      Width = 160
      Height = 17
      Caption = 'Erste Kopfzeile drucken'
      TabOrder = 12
    end
    object LastPageFooter: TCheckBox
      Left = 226
      Top = 104
      Width = 164
      Height = 17
      Caption = 'Letzte Fu'#223'zeile drucken'
      TabOrder = 13
    end
  end
end
