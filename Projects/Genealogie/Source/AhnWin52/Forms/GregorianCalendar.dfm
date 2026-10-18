object GregorianCalendarForm: TGregorianCalendarForm
  Left = 192
  Top = 114
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Gregorianischer Kalender (ab 1582)'
  ClientHeight = 439
  ClientWidth = 601
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 25
    Top = 28
    Width = 550
    Height = 1
  end
  object SpeedButton1: TSpeedButton
    Left = 27
    Top = 3
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      0003377777777777777308888888888888807F33333333333337088888888888
      88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
      8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
      8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333
    }
    NumGlyphs = 2
    OnClick = SpeedButton1Click
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 50
    Width = 551
    Height = 108
    TabStop = False
    ColCount = 28
    DefaultColWidth = 18
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goThumbTracking]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
  end
  object StringGrid2: TStringGrid
    Left = 24
    Top = 182
    Width = 551
    Height = 108
    TabStop = False
    ColCount = 28
    DefaultColWidth = 18
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goThumbTracking]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 1
  end
  object StringGrid3: TStringGrid
    Left = 24
    Top = 314
    Width = 551
    Height = 108
    TabStop = False
    ColCount = 28
    DefaultColWidth = 18
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goThumbTracking]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 291
    Top = 2
    Width = 37
    Height = 20
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnChange = Edit1Change
    OnKeyDown = Edit1KeyDown
  end
  object Button1: TButton
    Left = 337
    Top = 2
    Width = 20
    Height = 20
    Caption = '>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 263
    Top = 2
    Width = 20
    Height = 20
    Caption = '<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    TabStop = False
    OnClick = Button2Click
  end
  object BitBtn1: TBitBtn
    Left = 512
    Top = 2
    Width = 63
    Height = 21
    Caption = 'fertig'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 6
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
      0000
    }
    NumGlyphs = 2
  end
  object Edit2: TEdit
    Left = 102
    Top = 31
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 7
    Text = '    Januar'
  end
  object Edit3: TEdit
    Left = 230
    Top = 31
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 8
    Text = '   Februar'
  end
  object Edit4: TEdit
    Left = 342
    Top = 31
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 9
    Text = '      März'
  end
  object Edit5: TEdit
    Left = 476
    Top = 31
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 10
    Text = '     April'
  end
  object Edit6: TEdit
    Left = 102
    Top = 162
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 11
    Text = '       Mai  '
  end
  object Edit7: TEdit
    Left = 231
    Top = 162
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 12
    Text = '      Juni'
  end
  object Edit8: TEdit
    Left = 350
    Top = 162
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 13
    Text = '      Juli'
  end
  object Edit9: TEdit
    Left = 476
    Top = 162
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 14
    Text = '   August'
  end
  object Edit10: TEdit
    Left = 102
    Top = 294
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 15
    Text = 'September'
  end
  object Edit11: TEdit
    Left = 231
    Top = 294
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 16
    Text = '  Oktober'
  end
  object Edit12: TEdit
    Left = 353
    Top = 294
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 17
    Text = 'November'
  end
  object Edit13: TEdit
    Left = 476
    Top = 294
    Width = 58
    Height = 15
    TabStop = False
    AutoSize = False
    BorderStyle = bsNone
    Color = clSilver
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 18
    Text = 'Dezember'
  end
end
