object Form13: TForm13
  Left = 143
  Top = 90
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Grafik'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PaintBox1: TPaintBox
    Left = 0
    Top = 25
    Width = 783
    Height = 558
    Align = alClient
    Color = clBtnFace
    ParentColor = False
    ParentShowHint = False
    ShowHint = False
    OnPaint = PaintBox1Paint
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 0
    object SpeedButton11: TSpeedButton
      Left = 634
      Top = 0
      Width = 25
      Height = 25
      Hint = 'zum Anfang'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000000
        0000333377777777777733330FFFFFFFFFF033337F3FFF3F3FF733330F000F0F
        00F033337F777373773733330FFFFFFFFFF033337F3FF3FF3FF733330F00F00F
        00F033337F773773773733330FFFFFFFFFF033337FF3333FF3F7333300FFFF00
        F0F03333773FF377F7373330FB00F0F0FFF0333733773737F3F7330FB0BF0FB0
        F0F0337337337337373730FBFBF0FB0FFFF037F333373373333730BFBF0FB0FF
        FFF037F3337337333FF700FBFBFB0FFF000077F333337FF37777E0BFBFB000FF
        0FF077FF3337773F7F37EE0BFB0BFB0F0F03777FF3733F737F73EEE0BFBF00FF
        00337777FFFF77FF7733EEEE0000000003337777777777777333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object SpeedButton12: TSpeedButton
      Left = 1
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Zeichensatz'
      Caption = 'A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton12Click
    end
    object SpeedButton1: TSpeedButton
      Left = 584
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Drucken'
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
        33333337FFFF7733333333300000033333333337777773333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 46
      Top = 6
      Width = 27
      Height = 14
      Caption = 'Zoom'
    end
    object SpeedButton2: TSpeedButton
      Left = 510
      Top = 0
      Width = 25
      Height = 25
      Hint = 'fertig'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555555555555555555555555555555555555555FF55555555555559055555
        55555555577FF5555555555599905555555555557777F5555555555599905555
        555555557777FF5555555559999905555555555777777F555555559999990555
        5555557777777FF5555557990599905555555777757777F55555790555599055
        55557775555777FF5555555555599905555555555557777F5555555555559905
        555555555555777FF5555555555559905555555555555777FF55555555555579
        05555555555555777FF5555555555557905555555555555777FF555555555555
        5990555555555555577755555555555555555555555555555555}
      Layout = blGlyphRight
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton13: TSpeedButton
      Left = 609
      Top = 1
      Width = 24
      Height = 24
      Hint = 'Druckereinstellung'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555550FF0559
        1950555FF75F7557F7F757000FF055591903557775F75557F77570FFFF055559
        1933575FF57F5557F7FF0F00FF05555919337F775F7F5557F7F700550F055559
        193577557F7F55F7577F07550F0555999995755575755F7FFF7F5570F0755011
        11155557F755F777777555000755033305555577755F75F77F55555555503335
        0555555FF5F75F757F5555005503335505555577FF75F7557F55505050333555
        05555757F75F75557F5505000333555505557F777FF755557F55000000355557
        07557777777F55557F5555000005555707555577777FF5557F55553000075557
        0755557F7777FFF5755555335000005555555577577777555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = SpeedButton13Click
    end
    object Label2: TLabel
      Left = 164
      Top = 5
      Width = 46
      Height = 14
      Caption = 'Boxbreite'
    end
    object Label3: TLabel
      Left = 296
      Top = 5
      Width = 55
      Height = 14
      Caption = 'Linienbreite'
    end
    object SpeedButton3: TSpeedButton
      Left = 441
      Top = -1
      Width = 39
      Height = 26
      Caption = 'PDF'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object Button1: TButton
      Left = 666
      Top = 0
      Width = 39
      Height = 25
      Caption = 'symm.'
      Enabled = False
      TabOrder = 0
      Visible = False
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 240
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Boxbreite +'
      Caption = '--->'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 216
      Top = 0
      Width = 25
      Height = 25
      Hint = 'Boxbreite -'
      Caption = '<---'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 706
      Top = 0
      Width = 61
      Height = 25
      Hint = 'Grafik speichern'
      Caption = 'JPG'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Visible = False
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 80
      Top = 0
      Width = 25
      Height = 25
      Hint = 'verkleinern'
      Caption = '<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 105
      Top = 0
      Width = 25
      Height = 25
      Hint = 'vergr'#246#223'ern'
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 360
      Top = 0
      Width = 25
      Height = 25
      Caption = '<'
      TabOrder = 6
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 384
      Top = 0
      Width = 25
      Height = 25
      Caption = '>'
      TabOrder = 7
      OnClick = Button8Click
    end
  end
  object ScrollBar2: TScrollBar
    Left = 783
    Top = 25
    Width = 17
    Height = 558
    Align = alRight
    Kind = sbVertical
    PageSize = 0
    TabOrder = 2
    TabStop = False
    OnChange = ScrollBar2Change
  end
  object Memo1: TMemo
    Left = 344
    Top = 96
    Width = 417
    Height = 393
    ScrollBars = ssVertical
    TabOrder = 3
    Visible = False
  end
  object ScrollBar1: TScrollBar
    Left = 0
    Top = 583
    Width = 800
    Height = 17
    Align = alBottom
    PageSize = 0
    TabOrder = 1
    TabStop = False
    OnChange = ScrollBar1Change
  end
  object PrintDialog1: TPrintDialog
    Left = 40
    Top = 48
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdTrueTypeOnly, fdEffects]
    Left = 96
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Windows MetaFile |*.emf'
    Left = 152
    Top = 48
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 216
    Top = 47
  end
  object WPPDFPrinter1: TWPPDFPrinter
    CidFontMode = wpCIDOff
    PDFAMode = wpdfaOff
    PreselectedCJK = 128
    PDFReadMode = wpdfStandard
    CanvasReference = wprefScreen
    Filename = 'xxx.pdf'
    AutoLaunch = True
    EncodeStreamMethod = wpEncodeNone
    CompressStreamMethod = wpCompressNone
    Info.IsUTF8 = False
    Info.Producer = 'wPDF - http://www.wptools.de'
    CreateThumbnails = False
    CreateOutlines = False
    Modes = []
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
    Left = 280
    Top = 48
  end
  object WPPDFProperties1: TWPPDFProperties
    PDFPrinter = WPPDFPrinter1
    ShowStartButton = False
    ShowInputModes = False
    Left = 328
    Top = 48
  end
end
