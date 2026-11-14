object Form16: TForm16
  Left = 192
  Top = 114
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Druckvorschau'
  ClientHeight = 545
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 58
    Width = 792
    Height = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 58
    Align = alTop
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 304
      Top = 2
      Width = 25
      Height = 25
      Hint = 'Drucken'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
        8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
        8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
        8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 334
      Top = 2
      Width = 25
      Height = 25
      Hint = 'Speichern unter ...'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton6: TSpeedButton
      Left = 394
      Top = 2
      Width = 25
      Height = 25
      Hint = 'Speichern im HTML-Format'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333300333
        33333333333773FF333333333330F0033333333333373773FF333333330FFFF0
        03333333337F333773FF3333330FFFFFF003333333733FF33773333330FF00FF
        FF80333337F3773F3337333330FFFF0FFFF03FFFF7FFF3733F3700000000FFFF
        0FF0777777773FF373370000000000FFFFF07FFFFFF377FFF3370CCCCC000000
        FF037777773337773F7300CCC000003300307F77733337F37737000C00000033
        33307F373333F7F333370000007B703333307FFFF337F7F33337099900BBB033
        33307777F37777FF33370999007B700333037777F3373773FF73099900000030
        00337777FFFFF7F7773300000000003333337777777777333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton6Click
    end
    object SpeedButton1: TSpeedButton
      Left = 438
      Top = 2
      Width = 25
      Height = 25
      Hint = 'beenden'
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
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object Label5: TLabel
      Left = 390
      Top = 36
      Width = 45
      Height = 13
      Caption = 'Schriftart:'
    end
    object SpeedButton7: TSpeedButton
      Left = 304
      Top = 30
      Width = 25
      Height = 25
      Hint = 'Speichern im XML-Format'
      Caption = 'XML'
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object Label1: TLabel
      Left = 13
      Top = 8
      Width = 40
      Height = 14
      Caption = 'Anzeige'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Bevel2: TBevel
      Left = 182
      Top = 7
      Width = 107
      Height = 43
    end
    object Bevel1: TBevel
      Left = 7
      Top = 6
      Width = 170
      Height = 44
    end
    object Label2: TLabel
      Left = 190
      Top = 8
      Width = 32
      Height = 14
      Caption = 'Label2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object SpeedButton4: TSpeedButton
      Left = 365
      Top = 2
      Width = 25
      Height = 25
      Caption = 'PDF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton4Click
    end
    object Button9: TButton
      Left = 438
      Top = 30
      Width = 26
      Height = 25
      Caption = 'A'
      TabOrder = 0
      OnClick = Button9Click
    end
    object Button5: TButton
      Left = 334
      Top = 30
      Width = 25
      Height = 25
      Caption = 'A 3'
      TabOrder = 1
      Visible = False
      OnClick = Button5Click
    end
    object ComboBox1: TComboBox
      Left = 13
      Top = 24
      Width = 85
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      TabOrder = 2
      OnClick = ComboBox1Click
      Items.Strings = (
        '100 %'
        'ganze Seite'
        'Seitenbreite')
    end
    object SpinEdit1: TSpinEdit
      Left = 111
      Top = 24
      Width = 59
      Height = 22
      Increment = 10
      MaxValue = 1000
      MinValue = 10
      TabOrder = 3
      Value = 91
      OnChange = SpinEdit1Change
    end
    object Button1: TButton
      Left = 189
      Top = 25
      Width = 21
      Height = 20
      Caption = '<<'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 213
      Top = 25
      Width = 21
      Height = 20
      Caption = '<'
      TabOrder = 5
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 237
      Top = 25
      Width = 21
      Height = 20
      Caption = '>'
      TabOrder = 6
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 261
      Top = 25
      Width = 21
      Height = 20
      Caption = '>>'
      TabOrder = 7
      OnClick = Button4Click
    end
  end
  object QRPreview1: TQRPreview
    Left = 0
    Top = 58
    Width = 792
    Height = 487
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    OnPageAvailable = QRPreview1PageAvailable
    PageNumber = 1
    Zoom = 100
  end
  object PrintDialog1: TPrintDialog
    MinPage = 1
    Options = [poPageNums, poWarning, poDisablePrintToFile]
    PrintRange = prPageNums
    Left = 32
    Top = 80
  end
  object SaveDialog1: TSaveDialog
    Filter = 
      'Text-Dateien (*.txt)|*.txt|HTML-Dateien (*.htm)|*.htm|XML-Dateie' +
      'n (*.xml)|*.xml'
    Left = 66
    Top = 80
  end
  object OpenDialog1: TOpenDialog
    Left = 98
    Top = 82
  end
  object MainMenu1: TMainMenu
    Left = 176
    Top = 80
    object Datei1: TMenuItem
      Caption = '&Datei'
      object N2: TMenuItem
        Caption = '-'
      end
      object Beenden1: TMenuItem
        Caption = '&Beenden'
        OnClick = Beenden1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
    end
    object Anzeige1: TMenuItem
      Caption = 'Anzeige'
      Visible = False
    end
    object Optionen1: TMenuItem
      Caption = 'Optionen'
      Enabled = False
      Visible = False
      object bersichtsseiten1: TMenuItem
        Caption = #220'bersichtsseiten'
        object keine11: TMenuItem
          Caption = 'keine (1)'
        end
        object vier1: TMenuItem
          Caption = '4'
        end
        object neun1: TMenuItem
          Caption = '9'
        end
        object N161: TMenuItem
          Caption = '16'
        end
      end
      object Seitenausrichtung1: TMenuItem
        Caption = 'Seitenausrichtung'
        object hoch1: TMenuItem
          Caption = 'hoch'
        end
        object quer1: TMenuItem
          Caption = 'quer'
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 136
    Top = 80
  end
  object WPPDFPrinter1: TWPPDFPrinter
    CidFontMode = wpCIDOff
    PDFAMode = wpdfaOff
    PreselectedCJK = 128
    PDFReadMode = wpdfStandard
    CanvasReference = wprefScreen
    Filename = 'Default.PDF'
    AutoLaunch = True
    EncodeStreamMethod = wpEncodeNone
    CompressStreamMethod = wpCompressNone
    Info.IsUTF8 = False
    Info.Producer = 'wPDF - http://www.wptools.de'
    CreateThumbnails = False
    CreateOutlines = False
    Modes = [wpExactTextPositioning, wpClipRectSupport, wpArabicAlwaysAsOutline]
    Options = []
    PageMode = pwUseNone
    ZoomMode = pwZoomDefault
    FontMode = wpUseTrueTypeFonts
    Encryption = []
    Security = wpp40bit
    InMemoryMode = False
    JPEGQuality = wpNoJPEG
    ExtraMessages = []
    InputfileMode = pwIgnoreInput
    ConvertJPEGData = False
    DebugMode = False
    Left = 256
    Top = 80
  end
  object WPPDFProperties1: TWPPDFProperties
    PDFPrinter = WPPDFPrinter1
    ShowStartButton = False
    ShowInputModes = False
    Left = 304
    Top = 80
  end
end
