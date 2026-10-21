object Form1: TForm1
  Left = 192
  Top = 92
  BorderStyle = bsSingle
  Caption = 'AHNENWIN 5.1'
  ClientHeight = 546
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 3
    Width = 791
    Height = 1
  end
  object Label9: TLabel
    Left = 11
    Top = 184
    Width = 29
    Height = 15
    Caption = 'Beruf'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label14: TLabel
    Left = 12
    Top = 275
    Width = 24
    Height = 15
    Caption = 'geb.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 648
    Top = 2
    Width = 23
    Height = 20
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
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 546
    ActivePage = TabSheet2
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabIndex = 1
    TabOrder = 0
    TabStop = False
    OnExit = PageControl1Exit
    object TabSheet1: TTabSheet
      Caption = 'Auswahl'
      OnExit = TabSheet1Exit
      OnMouseDown = TabSheet1MouseDown
      OnShow = TabSheet1Show
      object DBGrid1: TDBGrid
        Left = 28
        Top = 10
        Width = 740
        Height = 480
        Hint = 
          'Auswahl durch Doppelclick auf Name oder <ENTER>;  Schlie'#223'en auch' +
          ' mit <ESC>'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -12
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
        OnKeyDown = DBGrid1KeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'Nummer'
            Width = 54
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Name'
            Width = 218
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Vornamen'
            Width = 220
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Gebjahr'
            ImeName = '*'
            Title.Alignment = taCenter
            Title.Caption = '*'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Gebort'
            Title.Caption = 'Geb.-Ort'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Taufjahr'
            Title.Alignment = taCenter
            Title.Caption = '~'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Taufort'
            Title.Caption = 'Tauf-Ort'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Stjahr'
            Title.Alignment = taCenter
            Title.Caption = '+'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IDNR'
            Width = 64
            Visible = True
          end>
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Bearbeiten'
      ImageIndex = 1
      OnEnter = TabSheet2Enter
      OnExit = TabSheet2Exit
      OnShow = TabSheet2Show
      object Label1: TLabel
        Left = 8
        Top = 70
        Width = 34
        Height = 15
        Caption = 'Name'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 96
        Width = 56
        Height = 15
        Caption = 'Vornamen'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 687
        Top = 2
        Width = 15
        Height = 15
        Caption = 'Nr.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 3
        Top = 322
        Width = 38
        Height = 15
        Caption = 'Label6'
      end
      object Label7: TLabel
        Left = 402
        Top = 322
        Width = 38
        Height = 15
        Caption = 'Label7'
      end
      object Shape2: TShape
        Left = 1
        Top = 56
        Width = 783
        Height = 1
      end
      object Label8: TLabel
        Left = 688
        Top = 27
        Width = 12
        Height = 15
        Caption = 'ID'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Shape3: TShape
        Left = 149
        Top = 1
        Width = 372
        Height = 52
        Brush.Color = clBtnFace
      end
      object Label11: TLabel
        Left = 156
        Top = 7
        Width = 27
        Height = 15
        Caption = 'Vater'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 155
        Top = 30
        Width = 33
        Height = 15
        Caption = 'Mutter'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 8
        Top = 212
        Width = 24
        Height = 15
        Caption = 'geb.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 8
        Top = 240
        Width = 20
        Height = 15
        Caption = 'get.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 8
        Top = 266
        Width = 27
        Height = 15
        Caption = 'gest.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 8
        Top = 293
        Width = 27
        Height = 15
        Caption = 'best.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 597
        Top = 0
        Width = 3
        Height = 15
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Visible = False
      end
      object Label19: TLabel
        Left = 559
        Top = 20
        Width = 3
        Height = 15
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
        Visible = False
      end
      object Label20: TLabel
        Left = 775
        Top = 62
        Width = 3
        Height = 15
      end
      object Label22: TLabel
        Left = 55
        Top = 212
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object Label23: TLabel
        Left = 55
        Top = 240
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object Label24: TLabel
        Left = 55
        Top = 267
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object Label25: TLabel
        Left = 55
        Top = 293
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object Label28: TLabel
        Left = 128
        Top = 180
        Width = 62
        Height = 15
        Caption = 'Bekenntnis'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Image1: TImage
        Left = 608
        Top = 73
        Width = 145
        Height = 176
        Stretch = True
      end
      object Label3: TLabel
        Left = 8
        Top = 124
        Width = 29
        Height = 15
        Caption = 'Beruf'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 8
        Top = 151
        Width = 51
        Height = 15
        Caption = 'Hofname'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 8
        Top = 180
        Width = 62
        Height = 15
        Caption = 'Geschlecht'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label79: TLabel
        Left = 128
        Top = 323
        Width = 45
        Height = 15
        Caption = 'Label79'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object DBText1: TDBText
        Left = 706
        Top = 2
        Width = 74
        Height = 19
        Hint = 'gelb: Datenschutz ein'
        Alignment = taCenter
        Color = clSilver
        DataField = 'Nummer'
        DataSource = DataModule2.DataSource1
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
      end
      object Label80: TLabel
        Left = 348
        Top = 180
        Width = 41
        Height = 15
        Caption = 'adopt.v.'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label81: TLabel
        Left = 464
        Top = 58
        Width = 45
        Height = 15
        Caption = 'Label81'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Edit7: TEdit
        Left = 200
        Top = 210
        Width = 329
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 39
      end
      object FileListBox2: TFileListBox
        Left = 536
        Top = 8
        Width = 145
        Height = 97
        ItemHeight = 15
        Mask = '_q*.*'
        TabOrder = 37
        Visible = False
      end
      object FileListBox1: TFileListBox
        Left = 424
        Top = 176
        Width = 145
        Height = 17
        ItemHeight = 15
        TabOrder = 33
        Visible = False
      end
      object Memo1: TMemo
        Left = 56
        Top = 280
        Width = 617
        Height = 41
        TabStop = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 29
        Visible = False
        WantTabs = True
      end
      object DBNavigator1: TDBNavigator
        Left = 12
        Top = 14
        Width = 120
        Height = 25
        DataSource = DataModule2.DataSource1
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        TabOrder = 1
        BeforeAction = DBNavigator1BeforeAction
        OnClick = DBNavigator1Click
      end
      object DBEdit2: TDBEdit
        Left = 80
        Top = 91
        Width = 370
        Height = 23
        DataField = 'Vornamen'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnExit = DBEdit2Exit
      end
      object DBEdit3: TDBEdit
        Left = 80
        Top = 119
        Width = 370
        Height = 23
        DataField = 'Beruf'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnExit = DBEdit3Exit
      end
      object StringGrid1: TStringGrid
        Left = -1
        Top = 341
        Width = 398
        Height = 173
        Hint = 'Einf'#252'gen/entfernen mit rechter Maustaste'
        HelpContext = 34
        TabStop = False
        ColCount = 6
        DefaultRowHeight = 20
        RowCount = 8
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowMoving, goRowSelect]
        ParentFont = False
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 24
        OnDblClick = StringGrid1DblClick
        OnRowMoved = StringGrid1RowMoved
        ColWidths = (
          9
          43
          183
          47
          49
          60)
      end
      object StringGrid2: TStringGrid
        Left = 400
        Top = 341
        Width = 384
        Height = 173
        Hint = 'Einf'#252'gen/entfernen mit rechter Maustaste'
        TabStop = False
        ColCount = 6
        DefaultRowHeight = 20
        RowCount = 8
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowMoving, goRowSelect]
        ParentFont = False
        ParentShowHint = False
        PopupMenu = PopupMenu2
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 25
        OnDblClick = StringGrid2DblClick
        OnRowMoved = StringGrid2RowMoved
        ColWidths = (
          9
          45
          183
          47
          46
          64)
      end
      object DBEdit5: TDBEdit
        Left = 706
        Top = 24
        Width = 74
        Height = 23
        HelpKeyword = ' '
        HelpContext = 4
        TabStop = False
        DataField = 'IDNR'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 26
        OnMouseDown = DBEdit5MouseDown
      end
      object DBEdit6: TDBEdit
        Left = 80
        Top = 148
        Width = 370
        Height = 23
        DataField = 'Hausname'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnExit = DBEdit6Exit
      end
      object Edit1: TEdit
        Left = 200
        Top = 4
        Width = 318
        Height = 20
        Hint = 'Einf'#252'gen/entfernen mit rechter Maustaste'
        HelpContext = 28
        TabStop = False
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = PopupMenu3
        ReadOnly = True
        ShowHint = True
        TabOrder = 27
        Text = 'Edit1'
        OnDblClick = Edit1DblClick
      end
      object Edit2: TEdit
        Left = 200
        Top = 28
        Width = 317
        Height = 20
        Hint = 'Einf'#252'gen/entfernen mit rechter Maustaste'
        HelpContext = 29
        TabStop = False
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        PopupMenu = PopupMenu4
        ReadOnly = True
        ShowHint = True
        TabOrder = 28
        Text = 'Edit2'
        OnDblClick = Edit2DblClick
      end
      object DBEdit7: TDBEdit
        Left = 80
        Top = 178
        Width = 25
        Height = 23
        DataField = 'Geschlecht'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnExit = DBEdit7Exit
      end
      object DBEdit8: TDBEdit
        Left = 80
        Top = 209
        Width = 25
        Height = 23
        DataField = 'Gebtag'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnChange = DBEdit8Change
        OnExit = DBEdit8Exit
      end
      object DBEdit9: TDBEdit
        Left = 112
        Top = 209
        Width = 25
        Height = 23
        DataField = 'Gebmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnChange = DBEdit9Change
        OnExit = DBEdit9Exit
      end
      object DBEdit10: TDBEdit
        Left = 144
        Top = 209
        Width = 45
        Height = 23
        DataField = 'Gebjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        OnChange = DBEdit10Change
        OnExit = DBEdit10Exit
      end
      object DBEdit12: TDBEdit
        Left = 80
        Top = 236
        Width = 25
        Height = 23
        DataField = 'Tauftag'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        OnExit = DBEdit12Exit
      end
      object DBEdit13: TDBEdit
        Left = 112
        Top = 236
        Width = 25
        Height = 23
        DataField = 'Taufmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        OnExit = DBEdit13Exit
      end
      object DBEdit14: TDBEdit
        Left = 144
        Top = 236
        Width = 45
        Height = 23
        DataField = 'Taufjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        OnExit = DBEdit14Exit
      end
      object DBEdit16: TDBEdit
        Left = 80
        Top = 263
        Width = 25
        Height = 23
        DataField = 'Sttag'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 15
        OnExit = DBEdit16Exit
      end
      object DBEdit17: TDBEdit
        Left = 112
        Top = 263
        Width = 25
        Height = 23
        DataField = 'Stmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 16
        OnExit = DBEdit17Exit
      end
      object DBEdit18: TDBEdit
        Left = 144
        Top = 263
        Width = 45
        Height = 23
        DataField = 'Stjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 17
        OnExit = DBEdit18Exit
      end
      object DBEdit20: TDBEdit
        Left = 80
        Top = 290
        Width = 25
        Height = 23
        DataField = 'Begtag'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 20
        OnExit = DBEdit20Exit
      end
      object DBEdit21: TDBEdit
        Left = 112
        Top = 290
        Width = 25
        Height = 23
        DataField = 'Begmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 21
        OnExit = DBEdit21Exit
      end
      object DBEdit22: TDBEdit
        Left = 144
        Top = 290
        Width = 45
        Height = 23
        DataField = 'Begjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 22
        OnExit = DBEdit22Exit
      end
      object DBEdit4: TDBEdit
        Left = 534
        Top = 263
        Width = 107
        Height = 23
        DataField = 'Alter'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 19
      end
      object DBCheckBox1: TDBCheckBox
        Left = 279
        Top = 176
        Width = 47
        Height = 25
        TabStop = False
        Caption = ' lebt'
        DataField = 'Lebt'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 30
        ValueChecked = 'j'
        ValueUnchecked = 'n'
        OnExit = DBCheckBox1Exit
      end
      object UpDown1: TUpDown
        Left = 760
        Top = 223
        Width = 17
        Height = 30
        Min = 0
        Position = 0
        TabOrder = 32
        Wrap = False
        OnClick = UpDown1Click
      end
      object DBEdit69: TDBEdit
        Left = 552
        Top = 32
        Width = 121
        Height = 23
        DataField = 'Nummer'
        DataSource = DataModule2.DataSource1
        TabOrder = 34
        Visible = False
        OnChange = DBEdit69Change
      end
      object DBComboBox2: TDBComboBox
        Left = 201
        Top = 178
        Width = 46
        Height = 23
        DataField = 'Religion'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        Items.Strings = (
          'ak'
          'ap'
          'ba'
          'bd'
          'ca'
          'ev'
          'fr'
          'go'
          'ht'
          'is'
          'jd'
          'ka'
          'lt'
          'lu'
          'me'
          'ml'
          'mt'
          'na'
          'ob'
          'ox'
          'pr'
          'rf'
          'rk'
          'ro'
          'so'
          'un'
          'wr'
          'zj')
        ParentFont = False
        TabOrder = 6
      end
      object DBGrid3: TDBGrid
        Left = 462
        Top = 75
        Width = 320
        Height = 208
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Options = [dgEditing, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 36
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Arial'
        TitleFont.Style = [fsBold]
        OnDblClick = DBGrid3DblClick
        OnExit = DBGrid3Exit
        OnKeyDown = DBGrid3KeyDown
      end
      object DBComboBox3: TDBComboBox
        Left = 394
        Top = 178
        Width = 57
        Height = 24
        DataField = 'Kistat'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        Items.Strings = (
          ''
          'V'
          'M')
        ParentFont = False
        TabOrder = 35
        TabStop = False
        OnChange = DBComboBox3Change
        OnExit = DBComboBox3Exit
      end
      object ComboBox4: TComboBox
        Left = 80
        Top = 63
        Width = 370
        Height = 21
        Style = csSimple
        ItemHeight = 15
        Sorted = True
        TabOrder = 0
        OnDblClick = ComboBox4DblClick
        OnExit = ComboBox4Exit
      end
      object ComboBox6: TComboBox
        Left = 200
        Top = 209
        Width = 330
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        Sorted = True
        TabOrder = 10
        OnExit = ComboBox4Exit
      end
      object ComboBox7: TComboBox
        Left = 200
        Top = 236
        Width = 330
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        Sorted = True
        TabOrder = 14
        OnExit = ComboBox4Exit
      end
      object ComboBox8: TComboBox
        Left = 200
        Top = 263
        Width = 330
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        Sorted = True
        TabOrder = 18
        OnExit = ComboBox4Exit
      end
      object ComboBox9: TComboBox
        Left = 200
        Top = 289
        Width = 330
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        Sorted = True
        TabOrder = 23
        OnExit = ComboBox4Exit
      end
      object StringGrid5: TStringGrid
        Left = 439
        Top = 74
        Width = 345
        Height = 248
        Hint = 'Schlie'#223'en: Click und ESC-Taste; Speichern: re.Maustaste'
        TabStop = False
        Color = clSilver
        ColCount = 4
        DefaultRowHeight = 20
        FixedCols = 0
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 31
        OnDblClick = StringGrid5DblClick
        OnKeyDown = StringGrid5KeyDown
        OnMouseDown = StringGrid5MouseDown
        ColWidths = (
          51
          161
          55
          55)
      end
      object Edit3: TEdit
        Left = 80
        Top = 63
        Width = 367
        Height = 23
        TabOrder = 38
      end
      object Edit11: TEdit
        Left = 200
        Top = 236
        Width = 329
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 40
      end
      object Edit12: TEdit
        Left = 200
        Top = 263
        Width = 329
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 41
      end
      object Edit16: TEdit
        Left = 200
        Top = 289
        Width = 329
        Height = 23
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 42
      end
      object Button1: TButton
        Left = 592
        Top = 320
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 43
        Visible = False
        OnClick = Button1Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Details'
      ImageIndex = 2
      OnEnter = TabSheet3Enter
      OnExit = TabSheet3Exit
      object Label35: TLabel
        Left = 6
        Top = 12
        Width = 48
        Height = 15
        Caption = 'Kind von'
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Visible = False
      end
      object Label41: TLabel
        Left = 687
        Top = 2
        Width = 15
        Height = 15
        Caption = 'Nr.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label63: TLabel
        Left = 688
        Top = 22
        Width = 12
        Height = 15
        Caption = 'ID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label29: TLabel
        Left = 6
        Top = 65
        Width = 34
        Height = 15
        Caption = 'Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label30: TLabel
        Left = 4
        Top = 92
        Width = 56
        Height = 15
        Caption = 'Vornamen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label31: TLabel
        Left = 6
        Top = 120
        Width = 29
        Height = 15
        Caption = 'Beruf'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label32: TLabel
        Left = 5
        Top = 174
        Width = 62
        Height = 15
        Caption = 'Geschlecht'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label52: TLabel
        Left = 5
        Top = 146
        Width = 48
        Height = 15
        Caption = 'lebt(e) in'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label33: TLabel
        Left = 6
        Top = 204
        Width = 24
        Height = 15
        Caption = 'geb.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label34: TLabel
        Left = 6
        Top = 232
        Width = 20
        Height = 15
        Caption = 'get.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label39: TLabel
        Left = 6
        Top = 259
        Width = 33
        Height = 15
        Caption = 'Taufp.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label40: TLabel
        Left = 6
        Top = 289
        Width = 27
        Height = 15
        Caption = 'gest.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label42: TLabel
        Left = 6
        Top = 316
        Width = 16
        Height = 15
        Caption = 'TU'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label43: TLabel
        Left = 6
        Top = 344
        Width = 27
        Height = 15
        Caption = 'best.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label60: TLabel
        Left = 390
        Top = 344
        Width = 12
        Height = 16
        Caption = '---'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label59: TLabel
        Left = 390
        Top = 289
        Width = 12
        Height = 16
        Caption = '---'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label58: TLabel
        Left = 390
        Top = 231
        Width = 12
        Height = 16
        Caption = '---'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label57: TLabel
        Left = 390
        Top = 202
        Width = 12
        Height = 16
        Caption = '---'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label50: TLabel
        Left = 414
        Top = 45
        Width = 177
        Height = 15
        Caption = 'Andere Namensschreibweisen :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label44: TLabel
        Left = 6
        Top = 383
        Width = 33
        Height = 15
        Caption = 'Heirat'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label45: TLabel
        Left = 46
        Top = 383
        Width = 45
        Height = 15
        Caption = 'kirchlich'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label46: TLabel
        Left = 27
        Top = 408
        Width = 65
        Height = 15
        Caption = 'Trauzeugen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label47: TLabel
        Left = 6
        Top = 438
        Width = 67
        Height = 15
        Caption = 'Standesamt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label49: TLabel
        Left = 27
        Top = 464
        Width = 65
        Height = 15
        Caption = 'Trauzeugen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label48: TLabel
        Left = 6
        Top = 489
        Width = 79
        Height = 15
        Caption = 'Scheid./Trenn.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Shape4: TShape
        Left = 0
        Top = 373
        Width = 783
        Height = -1
      end
      object Shape5: TShape
        Left = 0
        Top = 45
        Width = 783
        Height = 1
      end
      object DBText2: TDBText
        Left = 715
        Top = 0
        Width = 68
        Height = 17
        Alignment = taCenter
        Color = clSilver
        DataField = 'Nummer'
        DataSource = DataModule2.DataSource1
        ParentColor = False
      end
      object Label68: TLabel
        Left = 117
        Top = 174
        Width = 62
        Height = 15
        Caption = 'Bekenntnis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label53: TLabel
        Left = 352
        Top = 176
        Width = 46
        Height = 15
        Caption = 'Quellen:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label99: TLabel
        Left = 414
        Top = 92
        Width = 51
        Height = 15
        Caption = 'Rufname'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Edit32: TEdit
        Left = 587
        Top = 461
        Width = 20
        Height = 24
        TabStop = False
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 47
        Visible = False
      end
      object DBEdit25: TDBEdit
        Left = 715
        Top = 20
        Width = 68
        Height = 23
        HelpContext = 43
        TabStop = False
        AutoSize = False
        DataField = 'IDNR'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 46
      end
      object DBEdit57: TDBEdit
        Left = 45
        Top = 341
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Begtag'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 27
      end
      object DBEdit56: TDBEdit
        Left = 69
        Top = 341
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Begmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 28
      end
      object DBEdit55: TDBEdit
        Left = 93
        Top = 341
        Width = 39
        Height = 24
        AutoSize = False
        DataField = 'Begjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 29
        OnExit = DBEdit55Exit
      end
      object DBEdit60: TDBEdit
        Left = 45
        Top = 314
        Width = 344
        Height = 24
        AutoSize = False
        DataField = 'Todesurs'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 26
      end
      object DBEdit52: TDBEdit
        Left = 93
        Top = 286
        Width = 39
        Height = 24
        AutoSize = False
        DataField = 'Stjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 23
        OnExit = DBEdit52Exit
      end
      object DBEdit51: TDBEdit
        Left = 69
        Top = 286
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Stmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 22
      end
      object DBEdit50: TDBEdit
        Left = 45
        Top = 286
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Sttag'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 21
      end
      object DBEdit59: TDBEdit
        Left = 45
        Top = 258
        Width = 532
        Height = 24
        AutoSize = False
        DataField = 'Taufpat'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 20
      end
      object DBEdit49: TDBEdit
        Left = 45
        Top = 230
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Tauftag'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 15
      end
      object DBEdit48: TDBEdit
        Left = 69
        Top = 230
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Taufmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 16
      end
      object DBEdit47: TDBEdit
        Left = 93
        Top = 230
        Width = 39
        Height = 24
        AutoSize = False
        DataField = 'Taufjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 17
        OnExit = DBEdit47Exit
      end
      object DBEdit44: TDBEdit
        Left = 93
        Top = 201
        Width = 39
        Height = 24
        AutoSize = False
        DataField = 'Gebjahr'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        OnExit = DBEdit44Exit
      end
      object DBEdit43: TDBEdit
        Left = 69
        Top = 201
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Gebmonat'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
      end
      object DBEdit42: TDBEdit
        Left = 45
        Top = 201
        Width = 23
        Height = 24
        AutoSize = False
        DataField = 'Gebtag'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
      end
      object DBEdit26: TDBEdit
        Left = 70
        Top = 145
        Width = 505
        Height = 24
        AutoSize = False
        DataField = 'Lebensort'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object DBEdit40: TDBEdit
        Left = 86
        Top = 173
        Width = 21
        Height = 21
        AutoSize = False
        DataField = 'Geschlecht'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnExit = DBEdit40Exit
      end
      object DBComboBox7: TDBComboBox
        Left = 196
        Top = 172
        Width = 45
        Height = 23
        DataField = 'Religion'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        Items.Strings = (
          'ak'
          'ap'
          'ba'
          'bd'
          'ca'
          'ev'
          'fr'
          'go'
          'ht'
          'is'
          'jd'
          'ka'
          'lt'
          'lu'
          'me'
          'ml'
          'mt'
          'na'
          'ob'
          'ox'
          'pr'
          'rf'
          'rk'
          'ro'
          'so'
          'un'
          'wr'
          'zj')
        ParentFont = False
        Sorted = True
        TabOrder = 7
        OnExit = DBComboBox7Exit
      end
      object DBCheckBox2: TDBCheckBox
        Left = 280
        Top = 172
        Width = 47
        Height = 24
        TabStop = False
        Caption = ' lebt'
        DataField = 'Lebt'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        ValueChecked = 'j'
        ValueUnchecked = 'n'
      end
      object DBEdit31: TDBEdit
        Left = 414
        Top = 60
        Width = 366
        Height = 24
        TabStop = False
        AutoSize = False
        DataField = 'Namex'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Edit4: TEdit
        Left = 115
        Top = 379
        Width = 25
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 32
        Visible = False
      end
      object Edit5: TEdit
        Left = 141
        Top = 379
        Width = 25
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 33
        Visible = False
      end
      object Edit6: TEdit
        Left = 167
        Top = 379
        Width = 47
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 4
        ParentFont = False
        TabOrder = 34
        Visible = False
        OnExit = Edit6Exit
      end
      object Edit30: TEdit
        Left = 115
        Top = 407
        Width = 446
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 120
        ParentFont = False
        TabOrder = 36
        Visible = False
      end
      object Edit10: TEdit
        Left = 167
        Top = 435
        Width = 47
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 4
        ParentFont = False
        TabOrder = 39
        Visible = False
        OnExit = Edit10Exit
      end
      object Edit9: TEdit
        Left = 141
        Top = 435
        Width = 25
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 38
        Visible = False
      end
      object Edit8: TEdit
        Left = 115
        Top = 435
        Width = 25
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 37
        Visible = False
      end
      object Edit31: TEdit
        Left = 115
        Top = 462
        Width = 446
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 120
        ParentFont = False
        TabOrder = 41
        Visible = False
      end
      object Edit13: TEdit
        Left = 167
        Top = 488
        Width = 47
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 4
        ParentFont = False
        TabOrder = 44
        Visible = False
        OnExit = Edit13Exit
      end
      object Edit14: TEdit
        Left = 141
        Top = 488
        Width = 25
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 43
        Visible = False
      end
      object Edit15: TEdit
        Left = 115
        Top = 488
        Width = 25
        Height = 24
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 2
        ParentFont = False
        TabOrder = 42
        Visible = False
      end
      object Panel1: TPanel
        Left = 576
        Top = 378
        Width = 205
        Height = 68
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 48
        object Label64: TLabel
          Left = 15
          Top = 9
          Width = 106
          Height = 15
          Caption = 'Art der Verbindung'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ComboBox5: TComboBox
          Left = 19
          Top = 30
          Width = 166
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 15
          ParentFont = False
          TabOrder = 0
          OnChange = ComboBox5Change
          OnExit = ComboBox5Exit
          Items.Strings = (
            'Eheschliessung'
            'Verlobung'
            'Lebensgemeinschaft'
            'andere Beziehung')
        end
      end
      object DBEdit32: TDBEdit
        Left = 70
        Top = 117
        Width = 346
        Height = 24
        AutoSize = False
        DataField = 'Beruf'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 80
        ParentFont = False
        TabOrder = 4
        OnExit = DBEdit32Exit
      end
      object DBEdit33: TDBEdit
        Left = 70
        Top = 88
        Width = 316
        Height = 24
        AutoSize = False
        DataField = 'Vornamen'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        MaxLength = 80
        ParentFont = False
        TabOrder = 2
        OnExit = DBEdit33Exit
      end
      object ComboBox1: TComboBox
        Left = 224
        Top = 379
        Width = 338
        Height = 23
        Hint = 'neuer Ort: re.Maustaste; l'#246'schen: ESC'
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 35
        OnExit = ComboBox20Exit
        OnKeyPress = ComboBox1KeyPress
      end
      object ComboBox2: TComboBox
        Left = 224
        Top = 435
        Width = 338
        Height = 23
        Hint = 'neuer Ort: re.Maustaste; l'#246'schen: ESC'
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 40
        OnExit = ComboBox20Exit
        OnKeyPress = ComboBox2KeyPress
      end
      object ComboBox3: TComboBox
        Left = 224
        Top = 488
        Width = 338
        Height = 23
        Hint = 'neuer Ort: re.Maustaste; l'#246'schen: ESC'
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 45
        OnExit = ComboBox20Exit
        OnKeyPress = ComboBox3KeyPress
      end
      object ComboBox10: TComboBox
        Left = 70
        Top = 60
        Width = 316
        Height = 23
        Style = csSimple
        ItemHeight = 0
        Sorted = True
        TabOrder = 0
        OnExit = ComboBox4Exit
      end
      object ComboBox11: TComboBox
        Left = 404
        Top = 174
        Width = 381
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 8
        OnExit = ComboBox11Exit
      end
      object ComboBox12: TComboBox
        Left = 404
        Top = 201
        Width = 381
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 14
        OnExit = ComboBox11Exit
      end
      object ComboBox13: TComboBox
        Left = 403
        Top = 230
        Width = 381
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 19
        OnExit = ComboBox11Exit
      end
      object ComboBox14: TComboBox
        Left = 403
        Top = 286
        Width = 381
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 25
        OnExit = ComboBox11Exit
      end
      object ComboBox15: TComboBox
        Left = 403
        Top = 342
        Width = 381
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 31
        OnExit = ComboBox11Exit
      end
      object ComboBox16: TComboBox
        Left = 144
        Top = 201
        Width = 245
        Height = 23
        Style = csSimple
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        Sorted = True
        TabOrder = 13
        OnExit = ComboBox4Exit
      end
      object ComboBox17: TComboBox
        Left = 144
        Top = 230
        Width = 245
        Height = 23
        Style = csSimple
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        Sorted = True
        TabOrder = 18
        OnExit = ComboBox4Exit
      end
      object ComboBox18: TComboBox
        Left = 144
        Top = 286
        Width = 245
        Height = 23
        Style = csSimple
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        Sorted = True
        TabOrder = 24
        OnExit = ComboBox4Exit
      end
      object ComboBox19: TComboBox
        Left = 144
        Top = 342
        Width = 245
        Height = 23
        Style = csSimple
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        Sorted = True
        TabOrder = 30
        OnExit = ComboBox4Exit
      end
      object DBEdit19: TDBEdit
        Left = 480
        Top = 88
        Width = 300
        Height = 24
        TabStop = False
        AutoSize = False
        DataField = 'Rufname'
        DataSource = DataModule2.DataSource1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 40
        ParentFont = False
        TabOrder = 3
        OnExit = DBEdit32Exit
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Ehen u.a.'
      ImageIndex = 3
      OnEnter = TabSheet4Enter
      OnExit = TabSheet4Exit
      OnShow = TabSheet4Show
      object Shape8: TShape
        Left = 41
        Top = 237
        Width = 712
        Height = 268
        Brush.Style = bsClear
      end
      object Shape6: TShape
        Left = 53
        Top = 336
        Width = 685
        Height = 1
      end
      object Shape7: TShape
        Left = 53
        Top = 436
        Width = 686
        Height = 1
      end
      object Label62: TLabel
        Left = 532
        Top = 20
        Width = 106
        Height = 15
        Caption = 'Art der Verbindung'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label36: TLabel
        Left = 52
        Top = 250
        Width = 40
        Height = 15
        Caption = 'Kirche:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label37: TLabel
        Left = 144
        Top = 250
        Width = 36
        Height = 15
        Caption = 'Heirat '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label38: TLabel
        Left = 144
        Top = 282
        Width = 65
        Height = 15
        Caption = 'Trauzeugen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label54: TLabel
        Left = 144
        Top = 308
        Width = 36
        Height = 15
        Caption = 'Quelle'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label51: TLabel
        Left = 52
        Top = 351
        Width = 72
        Height = 15
        Caption = 'Standesamt:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label55: TLabel
        Left = 144
        Top = 351
        Width = 36
        Height = 15
        Caption = 'Heirat '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label56: TLabel
        Left = 144
        Top = 381
        Width = 65
        Height = 15
        Caption = 'Trauzeugen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label61: TLabel
        Left = 144
        Top = 407
        Width = 36
        Height = 15
        Caption = 'Quelle'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label65: TLabel
        Left = 52
        Top = 450
        Width = 124
        Height = 15
        Caption = 'Scheidung (Trennung)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label66: TLabel
        Left = 148
        Top = 476
        Width = 36
        Height = 15
        Caption = 'Quelle'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label67: TLabel
        Left = 44
        Top = 13
        Width = 3
        Height = 15
        Color = clSilver
        ParentColor = False
      end
      object Label69: TLabel
        Left = 201
        Top = 250
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object Label71: TLabel
        Left = 202
        Top = 450
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object Label70: TLabel
        Left = 201
        Top = 351
        Width = 45
        Height = 15
        Caption = 'Label22'
        Color = clSilver
        ParentColor = False
        Transparent = True
        Visible = False
      end
      object StringGrid3: TStringGrid
        Left = 41
        Top = 45
        Width = 398
        Height = 176
        Hint = 'Datenanzeige durch Click auf Name'
        TabStop = False
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 17
        OnClick = StringGrid3Click
        ColWidths = (
          59
          224
          61
          60
          63)
      end
      object DBEdit35: TDBEdit
        Left = 226
        Top = 247
        Width = 24
        Height = 23
        DataField = 'Htag'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object DBEdit36: TDBEdit
        Left = 254
        Top = 247
        Width = 24
        Height = 23
        DataField = 'Hmonat'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object DBEdit37: TDBEdit
        Left = 282
        Top = 247
        Width = 46
        Height = 23
        DataField = 'Hjahr'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnExit = DBEdit37Exit
      end
      object DBEdit38: TDBEdit
        Left = 226
        Top = 277
        Width = 509
        Height = 23
        DataField = 'Trauz'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object DBEdit39: TDBEdit
        Left = 226
        Top = 348
        Width = 24
        Height = 23
        DataField = 'Satag'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object DBEdit41: TDBEdit
        Left = 254
        Top = 348
        Width = 24
        Height = 23
        DataField = 'Samonat'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
      object DBEdit45: TDBEdit
        Left = 282
        Top = 348
        Width = 46
        Height = 23
        DataField = 'Sajahr'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnExit = DBEdit45Exit
      end
      object DBEdit46: TDBEdit
        Left = 226
        Top = 378
        Width = 509
        Height = 23
        DataField = 'Satrauz'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
      end
      object DBComboBox1: TDBComboBox
        Left = 533
        Top = 43
        Width = 181
        Height = 23
        DataField = 'Verbind'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        Items.Strings = (
          'Eheschliessung'
          'Verlobung'
          'Lebensgemeinschaft'
          'andere Beziehung')
        ParentFont = False
        TabOrder = 18
        TabStop = False
        OnExit = DBComboBox1Exit
      end
      object DBEdit61: TDBEdit
        Left = 226
        Top = 447
        Width = 24
        Height = 23
        DataField = 'Schtag'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
      end
      object DBEdit62: TDBEdit
        Left = 254
        Top = 447
        Width = 24
        Height = 23
        DataField = 'Schmonat'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
      end
      object DBEdit63: TDBEdit
        Left = 282
        Top = 447
        Width = 46
        Height = 23
        DataField = 'Schjahr'
        DataSource = DataModule2.DataSource5
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
        OnExit = DBEdit63Exit
      end
      object ComboBox20: TComboBox
        Left = 336
        Top = 247
        Width = 260
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 3
        OnExit = ComboBox20Exit
      end
      object ComboBox21: TComboBox
        Left = 336
        Top = 348
        Width = 260
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 9
        OnExit = ComboBox20Exit
      end
      object ComboBox22: TComboBox
        Left = 336
        Top = 447
        Width = 260
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 15
        OnExit = ComboBox20Exit
      end
      object ComboBox23: TComboBox
        Left = 226
        Top = 306
        Width = 509
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 5
        OnExit = ComboBox11Exit
      end
      object ComboBox24: TComboBox
        Left = 226
        Top = 407
        Width = 509
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 11
        OnExit = ComboBox11Exit
      end
      object ComboBox25: TComboBox
        Left = 226
        Top = 475
        Width = 509
        Height = 23
        Style = csSimple
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        MaxLength = 150
        ParentFont = False
        Sorted = True
        TabOrder = 16
        OnExit = ComboBox11Exit
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Geschwister'
      ImageIndex = 4
      OnEnter = TabSheet5Enter
      object Label26: TLabel
        Left = 200
        Top = 27
        Width = 3
        Height = 15
        Color = clSilver
        ParentColor = False
      end
      object StringGrid4: TStringGrid
        Left = 195
        Top = 79
        Width = 398
        Height = 306
        Hint = 
          'Doppelclick auf Name (oder Eingabetaste) wechselt zur ausgew'#228'hlt' +
          'en Person'
        HelpContext = 33
        TabStop = False
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        OnDblClick = StringGrid4DblClick
        ColWidths = (
          54
          245
          64
          64
          33)
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Text'
      ImageIndex = 5
      OnEnter = TabSheet6Enter
      object Label21: TLabel
        Left = 48
        Top = 11
        Width = 3
        Height = 15
        Color = clSilver
        ParentColor = False
      end
      object DBMemo1: TDBMemo
        Left = 48
        Top = 40
        Width = 617
        Height = 433
        Hint = 'Zeilenumbruch mit [Strg][Eingabetaste]'
        DataField = 'Kommentar'
        DataSource = DataModule2.DataSource1
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 0
        WantTabs = True
        OnExit = DBMemo1Exit
      end
    end
    object TabSheet7: TTabSheet
      ImageIndex = 6
      ParentShowHint = False
      ShowHint = True
      TabVisible = False
      OnEnter = TabSheet7Enter
      OnMouseDown = TabSheet7MouseDown
      object Label27: TLabel
        Left = 34
        Top = 15
        Width = 3
        Height = 15
        Color = clSilver
        ParentColor = False
      end
      object DBGrid2: TDBGrid
        Left = 31
        Top = 48
        Width = 716
        Height = 433
        Hint = 
          'Auswahl durch Doppelclick auf Name oder <ENTER>;  Schlie'#223'en auch' +
          ' mit <ESC>'
        DataSource = DataModule2.DataSource9
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
        OnDblClick = DBGrid2DblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'Nummer'
            Width = 54
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Name'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Vornamen'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Gebjahr'
            Title.Alignment = taCenter
            Title.Caption = '*'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Gebort'
            Title.Caption = 'Geb.-Ort'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Taufjahr'
            Title.Alignment = taCenter
            Title.Caption = '~'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Taufort'
            Title.Caption = 'Tauf-Ort'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Stjahr'
            Title.Alignment = taCenter
            Title.Caption = '+'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'IDNR'
            Width = 64
            Visible = True
          end>
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Adresse'
      ImageIndex = 7
      OnEnter = TabSheet8Enter
      object Label78: TLabel
        Left = 77
        Top = 39
        Width = 3
        Height = 15
        Color = clSilver
        ParentColor = False
      end
      object Panel2: TPanel
        Left = 76
        Top = 72
        Width = 629
        Height = 369
        HelpContext = 103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object Label73: TLabel
          Left = 16
          Top = 41
          Width = 62
          Height = 15
          Caption = 'Anschrift 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label74: TLabel
          Left = 16
          Top = 82
          Width = 62
          Height = 15
          Caption = 'Anschrift 2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label75: TLabel
          Left = 16
          Top = 123
          Width = 22
          Height = 15
          Caption = 'PLZ'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label76: TLabel
          Left = 16
          Top = 164
          Width = 18
          Height = 15
          Caption = 'Ort'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label77: TLabel
          Left = 16
          Top = 202
          Width = 38
          Height = 15
          Caption = 'Zusatz'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Shape9: TShape
          Left = 8
          Top = 240
          Width = 399
          Height = 1
        end
        object Label82: TLabel
          Left = 16
          Top = 258
          Width = 41
          Height = 15
          Caption = 'Telefon'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label83: TLabel
          Left = 16
          Top = 290
          Width = 31
          Height = 15
          Caption = 'Email'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label84: TLabel
          Left = 16
          Top = 322
          Width = 78
          Height = 15
          Caption = 'Web-Adresse'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Shape10: TShape
          Left = 416
          Top = 23
          Width = 201
          Height = 327
          Brush.Color = clBtnFace
        end
        object Shape11: TShape
          Left = 416
          Top = 240
          Width = 201
          Height = 1
        end
        object Label86: TLabel
          Left = 432
          Top = 288
          Width = 155
          Height = 15
          Caption = 'vorname.name@provider.de'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label87: TLabel
          Left = 432
          Top = 320
          Width = 148
          Height = 15
          Caption = 'www.meine_homepage.de'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label85: TLabel
          Left = 432
          Top = 256
          Width = 81
          Height = 15
          Caption = '08190-123456'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label88: TLabel
          Left = 432
          Top = 40
          Width = 66
          Height = 15
          Caption = 'Baumstr. 42'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label89: TLabel
          Left = 432
          Top = 80
          Width = 119
          Height = 15
          Caption = 'Himmelhof [= Ortsteil]'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label90: TLabel
          Left = 432
          Top = 120
          Width = 48
          Height = 15
          Caption = 'D-12345'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label91: TLabel
          Left = 432
          Top = 160
          Width = 59
          Height = 15
          Caption = 'Engelbach'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label92: TLabel
          Left = 432
          Top = 200
          Width = 74
          Height = 15
          Caption = 'Niederbayern'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label93: TLabel
          Left = 415
          Top = 5
          Width = 55
          Height = 15
          Caption = 'Beispiele:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object DBEdit64: TDBEdit
          Left = 104
          Top = 40
          Width = 297
          Height = 19
          AutoSize = False
          DataField = 'Adr1'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object DBEdit65: TDBEdit
          Left = 104
          Top = 80
          Width = 297
          Height = 20
          AutoSize = False
          DataField = 'Adr2'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object DBEdit66: TDBEdit
          Left = 104
          Top = 120
          Width = 297
          Height = 19
          AutoSize = False
          DataField = 'PLZ'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object DBEdit68: TDBEdit
          Left = 104
          Top = 200
          Width = 297
          Height = 19
          AutoSize = False
          DataField = 'Adrzus'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object DBEdit1: TDBEdit
          Left = 104
          Top = 256
          Width = 297
          Height = 19
          AutoSize = False
          DataField = 'Tel'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object DBEdit11: TDBEdit
          Left = 104
          Top = 288
          Width = 297
          Height = 19
          AutoSize = False
          DataField = 'Ema'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object DBEdit15: TDBEdit
          Left = 104
          Top = 320
          Width = 297
          Height = 19
          AutoSize = False
          DataField = 'Ur'
          DataSource = DataModule2.DataSource1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object ComboBox26: TComboBox
          Left = 104
          Top = 157
          Width = 298
          Height = 24
          Style = csSimple
          ItemHeight = 0
          TabOrder = 3
          OnExit = ComboBox4Exit
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Bilder'
      ImageIndex = 8
      OnExit = TabSheet9Exit
      OnShow = TabSheet9Show
      object Image2: TImage
        Left = 10
        Top = 22
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image3: TImage
        Left = 122
        Top = 22
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image4: TImage
        Left = 234
        Top = 22
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image5: TImage
        Left = 346
        Top = 22
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image6: TImage
        Left = 458
        Top = 22
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image7: TImage
        Left = 570
        Top = 22
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image13: TImage
        Left = 570
        Top = 147
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image12: TImage
        Left = 458
        Top = 147
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image11: TImage
        Left = 346
        Top = 147
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image10: TImage
        Left = 234
        Top = 147
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image9: TImage
        Left = 122
        Top = 147
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image8: TImage
        Left = 10
        Top = 147
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image14: TImage
        Left = 10
        Top = 274
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image15: TImage
        Left = 122
        Top = 274
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image16: TImage
        Left = 234
        Top = 274
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image17: TImage
        Left = 346
        Top = 274
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image18: TImage
        Left = 458
        Top = 274
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image19: TImage
        Left = 570
        Top = 274
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image26: TImage
        Left = 682
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image25: TImage
        Left = 570
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image24: TImage
        Left = 458
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image23: TImage
        Left = 346
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image22: TImage
        Left = 234
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image21: TImage
        Left = 122
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Image20: TImage
        Left = 10
        Top = 400
        Width = 89
        Height = 97
        Proportional = True
        Stretch = True
        OnClick = Image2Click
      end
      object Label94: TLabel
        Left = 688
        Top = 80
        Width = 3
        Height = 15
        Visible = False
      end
      object Label95: TLabel
        Left = 688
        Top = 16
        Width = 3
        Height = 15
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label96: TLabel
        Left = 688
        Top = 112
        Width = 3
        Height = 15
        Visible = False
      end
      object Label97: TLabel
        Left = 688
        Top = 144
        Width = 3
        Height = 15
        Visible = False
      end
      object Label98: TLabel
        Left = 688
        Top = 48
        Width = 3
        Height = 15
      end
      object Label72: TLabel
        Left = 8
        Top = 0
        Width = 3
        Height = 14
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 712
    Top = 220
    object Datei1: TMenuItem
      Caption = 'Datei'
      object GebDatumTaufdatum1: TMenuItem
        Caption = 'Geb.-Datum -> Taufdatum'
        Enabled = False
        Visible = False
        OnClick = GebDatumTaufdatum1Click
      end
      object N32: TMenuItem
        Caption = '-'
        Enabled = False
        Visible = False
      end
      object Datenlschen1: TMenuItem
        Caption = 'alle Daten l'#246'schen'
        HelpContext = 1
        OnClick = Datenlschen1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object IDSatznr1: TMenuItem
        Caption = 'ID = Satznr.'
        HelpContext = 2
        OnClick = IDSatznr1Click
      end
      object IDslschen1: TMenuItem
        Caption = 'IDs l'#246'schen'
        HelpContext = 3
        OnClick = IDslschen1Click
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Datenschutzein1: TMenuItem
        Caption = 'Datenschutz ein'
        HelpContext = 56
        OnClick = Datenschutzein1Click
      end
      object Datenschutzaus1: TMenuItem
        Caption = 'Datenschutz aus'
        HelpContext = 56
        OnClick = Datenschutzaus1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Druckereinstellung1: TMenuItem
        Caption = 'Druckereinstellung'
        HelpContext = 19
        OnClick = Druckereinstellung1Click
      end
      object Bildschirmdrucken1: TMenuItem
        Caption = 'Bildschirm drucken'
        HelpContext = 40
        ShortCut = 32848
        OnClick = Bildschirmdrucken1Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object ExcelExport1: TMenuItem
        Caption = 'Excel-Export'
        HelpContext = 401
        OnClick = ExcelExport1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object EhenKiordnen1: TMenuItem
        Caption = 'Ehen/Kinder ordnen'
        HelpContext = 111
        OnClick = EhenKiordnen1Click
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object beenden1: TMenuItem
        Caption = 'beenden'
        ShortCut = 32856
        OnClick = beenden1Click
      end
    end
    object Datenaustausch1: TMenuItem
      Caption = 'Datenaustausch'
      object AHNENDOSeinlesen1: TMenuItem
        Caption = 'AHNEN DOS einlesen'
        Enabled = False
        HelpContext = 2
        Visible = False
        OnClick = AHNENDOSeinlesen1Click
      end
      object OSBeinlesen1: TMenuItem
        Caption = 'OSB einlesen'
        Enabled = False
        HelpContext = 3
        Visible = False
        OnClick = OSBeinlesen1Click
      end
      object N22: TMenuItem
        Caption = '-'
        Visible = False
      end
      object GedcomDateischreiben1: TMenuItem
        Caption = 'Gedcom-Datei schreiben'
        HelpContext = 5
        OnClick = GedcomDateischreiben1Click
      end
      object GedcomDateieinlesen1: TMenuItem
        Caption = 'Gedcom-Datei einlesen'
        HelpContext = 400
        OnClick = GedcomDateieinlesen1Click
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object GedcomXMLschreiben1: TMenuItem
        Caption = 'Gedcom-XML schreiben'
        Enabled = False
        Visible = False
      end
      object GedcomXMLeinlesen1: TMenuItem
        Caption = 'Gedcom-XML einlesen'
        Enabled = False
        Visible = False
      end
      object N19: TMenuItem
        Caption = '-'
        Visible = False
      end
      object FOKODateierstellen1: TMenuItem
        Caption = 'FOKO-Datei erstellen'
        HelpContext = 7
        OnClick = FOKODateierstellen1Click
      end
      object FOKODateieditieren1: TMenuItem
        Caption = 'FOKO-Datei editieren'
        HelpContext = 16
        OnClick = FOKODateieditieren1Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object inyTafelerstellen1: TMenuItem
        Caption = 'Tiny-Tafel erstellen'
        HelpContext = 6
        OnClick = inyTafelerstellen1Click
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object Adressendateischreiben1: TMenuItem
        Caption = 'Adressendatei schreiben'
        HelpContext = 38
        OnClick = Adressendateischreiben1Click
      end
    end
    object Datensatz1: TMenuItem
      Caption = 'Datensatz'
      object neu1: TMenuItem
        Caption = 'neu'
        HelpContext = 402
        OnClick = neu1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object schen1: TMenuItem
        Caption = 'l'#246'schen'
        HelpContext = 403
        OnClick = schen1Click
      end
    end
    object Suchen1: TMenuItem
      Caption = 'Suchen'
      object DatensatzNr1: TMenuItem
        Caption = 'Datensatz-Nr.'
        HelpContext = 9
        OnClick = DatensatzNr1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object GlobaleSuche1: TMenuItem
        Caption = 'Globale Suche'
        HelpContext = 22
        OnClick = GlobaleSuche1Click
      end
      object N27: TMenuItem
        Caption = '-'
      end
      object Partnersuche1: TMenuItem
        Caption = 'Partnersuche'
        HelpContext = 57
        OnClick = Partnersuche1Click
      end
      object LetzteSuche1: TMenuItem
        Caption = 'Letzte Suche'
        object anzeigen1: TMenuItem
          Caption = 'anzeigen'
          HelpContext = 58
          OnClick = anzeigen1Click
        end
        object drucken1: TMenuItem
          Caption = 'drucken'
          HelpContext = 58
          OnClick = drucken1Click
        end
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object Verwandtschaft1: TMenuItem
        Caption = 'Verwandtschaft'
        OnClick = Verwandtschaft1Click
      end
      object Vettern1: TMenuItem
        Caption = 'Vettern'
        OnClick = Vettern1Click
      end
      object Basen1: TMenuItem
        Caption = 'Basen'
        OnClick = Basen1Click
      end
    end
    object Listen1: TMenuItem
      Caption = 'Listen'
      object Familienblatt2: TMenuItem
        Caption = 'Familienblatt'
        HelpContext = 12
        OnClick = Familienblatt2Click
      end
      object FamilienblattHTML1: TMenuItem
        Caption = 'Familienblatt HTML'
        HelpContext = 404
        OnClick = FamilienblattHTML1Click
      end
      object FamGrafik1: TMenuItem
        Caption = 'Familien-Grafik'
        HelpContext = 405
        OnClick = FamGrafik1Click
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object OFBDruck1: TMenuItem
        Caption = 'OFB-Druck'
        HelpContext = 20
        OnClick = OFBDruck1Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object Namensliste1: TMenuItem
        Caption = 'Namensliste'
        object allePersonen1: TMenuItem
          Caption = 'alle Personen'
          HelpContext = 60
          OnClick = allePersonen1Click
        end
        object frbestimmtenOrt1: TMenuItem
          Caption = 'f'#252'r bestimmten Ort'
          HelpContext = 58
          OnClick = frbestimmtenOrt1Click
        end
      end
      object Ortsliste1: TMenuItem
        Caption = 'Ortsliste'
        object allePersonen2: TMenuItem
          Caption = 'alle Personen'
          HelpContext = 61
          OnClick = allePersonen2Click
        end
        object Probandenname1: TMenuItem
          Caption = 'Probandenname'
          HelpContext = 28
          OnClick = Probandenname1Click
        end
      end
      object Quellenliste1: TMenuItem
        Caption = 'Quellenliste'
        Visible = False
        OnClick = Quellenliste1Click
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object NamensListeeditieren1: TMenuItem
        Caption = 'Namens-Verwaltung'
        HelpContext = 69
        OnClick = NamensListeeditieren1Click
      end
      object OrtsDatei1: TMenuItem
        Caption = 'Orts-Verwaltung'
        HelpContext = 70
        OnClick = OrtsDatei1Click
      end
      object BerufeVerwaltung1: TMenuItem
        Caption = 'Berufe-Verwaltung'
        HelpContext = 32
        OnClick = BerufeVerwaltung1Click
      end
      object QuellenListeeditieren1: TMenuItem
        Caption = 'Quellen-Verwaltung'
        HelpContext = 71
        OnClick = QuellenListeeditieren1Click
      end
      object HofnamenVerwaltung1: TMenuItem
        Caption = 'Hofnamen-Verwaltung'
        OnClick = HofnamenVerwaltung1Click
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object Listenaktualisieren1: TMenuItem
        Caption = 'Listen aktualisieren'
        HelpContext = 14
        OnClick = Listenaktualisieren1Click
      end
    end
    object Vorfahren1: TMenuItem
      Caption = 'Vorfahren'
      object Listen2: TMenuItem
        Caption = 'Listen'
        HelpContext = 49
        OnClick = Listen2Click
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object Spitzenahnen1: TMenuItem
        Caption = 'Spitzenahnen'
        object Proband1: TMenuItem
          Caption = 'Proband'
          HelpContext = 407
          OnClick = Proband1Click
        end
        object allePersonen3: TMenuItem
          Caption = 'alle Personen'
          HelpContext = 406
          OnClick = allePersonen3Click
        end
      end
      object Basisahnen1: TMenuItem
        Caption = 'Basisahnen'
        HelpContext = 408
        OnClick = Basisahnen1Click
      end
      object N25: TMenuItem
        Caption = '-'
      end
      object Grafikalt1: TMenuItem
        Caption = 'Grafik I'
        HelpContext = 54
        OnClick = Grafikalt1Click
      end
      object Grafik1: TMenuItem
        Caption = 'Grafik II'
        HelpContext = 72
        OnClick = Grafik1Click
      end
      object Neu2: TMenuItem
        Caption = '-'
      end
    end
    object Nachfahren1: TMenuItem
      Caption = 'Nachfahren'
      object Liste1: TMenuItem
        Caption = 'Listen'
        HelpContext = 15
        OnClick = Liste1Click
      end
      object geschachtelt1: TMenuItem
        Caption = 'geschachtelt'
        HelpContext = 15
        OnClick = geschachtelt1Click
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object GrafikI1: TMenuItem
        Caption = 'Grafik I'
        HelpContext = 55
        OnClick = GrafikI1Click
      end
      object Grafikneu1: TMenuItem
        Caption = 'Grafik II'
        HelpContext = 73
        OnClick = Grafikneu1Click
      end
    end
    object Kalender1: TMenuItem
      Caption = 'Kalender'
      object GregorianischerKalender1: TMenuItem
        Caption = 'Gregorianischer Kalender'
        HelpContext = 8
        OnClick = GregorianischerKalender1Click
      end
      object FrzRevolutionskalender1: TMenuItem
        Caption = 'Frz.Revolutionskalender'
        HelpContext = 29
        OnClick = FrzRevolutionskalender1Click
      end
      object Osterberechnung1: TMenuItem
        Caption = 'Osterberechnung'
        HelpContext = 10
        OnClick = Osterberechnung1Click
      end
      object ChristlicheNamenstage1: TMenuItem
        Caption = 'Christliche Namenstage'
        HelpContext = 11
        OnClick = ChristlicheNamenstage1Click
      end
    end
    object Bilder1: TMenuItem
      Caption = 'Bilder'
      object einfgen1: TMenuItem
        Caption = 'einf'#252'gen'
        HelpContext = 52
        OnClick = einfgen1Click
      end
      object entfernen1: TMenuItem
        Caption = 'entfernen'
        HelpContext = 23
        OnClick = entfernen1Click
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object bmpjpg1: TMenuItem
        Caption = 'bmp -> jpg'
        HelpContext = 24
        OnClick = bmpjpg1Click
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object alleBilderentfernen1: TMenuItem
        Caption = 'alle Bilder entfernen'
        HelpContext = 25
        OnClick = alleBilderentfernen1Click
      end
      object bernehmen1: TMenuItem
        Caption = #252'bernehmen'
        HelpContext = 31
        OnClick = bernehmen1Click
      end
    end
    object Datenprfung1: TMenuItem
      Caption = 'Datenpr'#252'fung'
      object Prfen1: TMenuItem
        Caption = 'Plausibilit'#228'ts-Pr'#252'fung'
        HelpContext = 42
        OnClick = Prfen1Click
      end
      object N29: TMenuItem
        Caption = '-'
      end
      object Einzelpersonen1: TMenuItem
        Caption = 'Einzelpersonen '
        HelpContext = 63
        OnClick = Einzelpersonen1Click
      end
      object DoppelteEintrge1: TMenuItem
        Caption = 'Mehrfach-Eintr'#228'ge'
        HelpContext = 64
        OnClick = DoppelteEintrge1Click
      end
      object N30: TMenuItem
        Caption = '-'
      end
      object nichtverknpfteBeziehungen1: TMenuItem
        Caption = 'nicht verkn'#252'pfte Beziehungen'
        HelpContext = 65
        OnClick = NichtverknpfteBeziehungen1Click
      end
    end
    object Filter1: TMenuItem
      Caption = 'Filter'
      object ID1: TMenuItem
        Caption = 'ID'
        HelpContext = 66
        OnClick = ID1Click
      end
      object Name1: TMenuItem
        Caption = 'Name'
        HelpContext = 66
        OnClick = Name1Click
      end
      object Hausname1: TMenuItem
        Caption = 'Hofname'
        HelpContext = 66
        OnClick = Hausname1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object aus1: TMenuItem
        Caption = 'aus'
        OnClick = aus1Click
      end
    end
    object Info1: TMenuItem
      Caption = 'Info'
      object Hilfe1: TMenuItem
        Caption = 'Hilfe'
        ShortCut = 112
        OnClick = Hilfe1Click
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object zuAHNENWIN1: TMenuItem
        Caption = 'zu AHNENWIN'
        OnClick = zuAHNENWIN1Click
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object Fenstertitelndern1: TMenuItem
        Caption = 'Fenstertitel '#228'ndern'
        OnClick = Fenstertitelndern1Click
      end
    end
    object Datensicherung1: TMenuItem
      Caption = 'Sicherung'
      object Datensichern1: TMenuItem
        Caption = 'Daten sichern'
        HelpContext = 108
        OnClick = Datensichern1Click
      end
      object SicherungsDateieinlesen2: TMenuItem
        Caption = 'Sicherungs-Datei einlesen'
        OnClick = SicherungsDateieinlesen1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 
      'Gedcom-Dateien (*.ged)|*.ged|Textdateien (*.txt)|*.txt|Sicherung' +
      's-Dateien (*.hej)|*.hej'
    Left = 560
    Top = 221
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'AHNEN-Dateien|ahnen.dbf|OSB-Dateien|kibu.dbf|Gedcom-Dateien|*.ge' +
      'd|Text-Dateien|*.txt|Sicherungs-Datei|*.hej|Bilder '#252'bernehmen|*.' +
      'bmp; *.jpg'
    Left = 592
    Top = 221
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 672
    Top = 187
    object Verbindungeinfgen1: TMenuItem
      Caption = 'Verbindung einf'#252'gen'
      OnClick = Verbindungeinfgen1Click
    end
    object Verbindunglschen1: TMenuItem
      Caption = 'Verbindung entfernen'
      OnClick = Verbindunglschen1Click
    end
  end
  object PopupMenu2: TPopupMenu
    OnPopup = PopupMenu2Popup
    Left = 704
    Top = 187
    object Kindereinfgen1: TMenuItem
      Caption = 'Kind einf'#252'gen'
      HelpContext = 23
      OnClick = Kindereinfgen1Click
    end
    object Kinderentfernen1: TMenuItem
      Caption = 'Kind entfernen'
      HelpContext = 37
      OnClick = Kinderentfernen1Click
    end
  end
  object PopupMenu3: TPopupMenu
    OnPopup = PopupMenu3Popup
    Left = 640
    Top = 220
    object Vatereinfgen1: TMenuItem
      Caption = 'Vater einf'#252'gen'
      OnClick = Vatereinfgen1Click
    end
    object Vaterentfernen1: TMenuItem
      Caption = 'Vater entfernen'
      OnClick = Vaterentfernen1Click
    end
  end
  object PopupMenu4: TPopupMenu
    OnPopup = PopupMenu4Popup
    Left = 672
    Top = 220
    object Muttereinfgen1: TMenuItem
      Caption = 'Mutter einf'#252'gen'
      OnClick = Muttereinfgen1Click
    end
    object Mutterentfernen1: TMenuItem
      Caption = 'Mutter entfernen'
      OnClick = Mutterentfernen1Click
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 608
    Top = 184
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 520
    Top = 216
  end
  object Query1: TQuery
    DataSource = DataModule2.DataSource1
    Left = 544
    Top = 184
  end
  object DataSource1: TDataSource
    Left = 512
    Top = 184
  end
  object DataSource2: TDataSource
    DataSet = lfbh2
    Left = 673
    Top = 156
  end
  object lfbh2: TClientDataSet
    Active = False
    Aggregates = <>
    FileName = 'lfbh2.xml'
    FieldDefs = <
      item
        Name = 'Nr'
        Attributes = [faReadonly, faUnNamed]
        DataType = ftAutoInc
      end
      item
        Name = 'Nm'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'Prob'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 6
      end
      item
        Name = 'Eh'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Ix'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Nam'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Aus'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'Hei'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 4
      end>
    IndexDefs = <
      item
        Name = 'na'
        Fields = 'Nam; Ix'
      end
      item
        Name = 'num'
        Fields = 'Nm'
      end
      item
        Name = 'Pro'
        Fields = 'Prob'
      end
      item
        Name = 'heir'
        Fields = 'hei'
      end>
    IndexName = 'heir'
    Params = <>
    StoreDefs = True
    Left = 705
    Top = 156
    Data = {
      DE0000009619E0BD010000001800000008000000000003000000DE00024E7204
      0001001200010007535542545950450200490008004175746F696E6300024E6D
      04000100100000000450726F6201004900100001000557494454480200020006
      0002456801004900100001000557494454480200020046000249780100490010
      000100055749445448020002003200034E616D01004900100001000557494454
      4802000200320003417573040001001000000003486569010049001000010005
      574944544802000200040001000C4155544F494E4356414C5545040001003CA9
      0000}
    object lfbh2Nr: TAutoIncField
      FieldName = 'Nr'
      ReadOnly = True
    end
    object lfbh2Nm: TIntegerField
      FieldName = 'Nm'
    end
    object lfbh2Prob: TStringField
      FieldName = 'Prob'
      Size = 6
    end
    object lfbh2Eh: TStringField
      FieldName = 'Eh'
      Size = 70
    end
    object lfbh2Ix: TStringField
      FieldName = 'Ix'
      Size = 50
    end
    object lfbh2Nam: TStringField
      FieldName = 'Nam'
      Size = 50
    end
    object lfbh2Aus: TIntegerField
      FieldName = 'Aus'
    end
    object lfbh2Hei: TStringField
      FieldName = 'Hei'
      Size = 4
    end
  end
  object DataSource4: TDataSource
    DataSet = Repso2
    Left = 593
    Top = 156
  end
  object Repso2: TClientDataSet
    Active = False
    Aggregates = <>
    FileName = 'repso2.xml'
    FieldDefs = <
      item
        Name = 'z'
        Attributes = [faReadonly, faUnNamed]
        DataType = ftAutoInc
      end
      item
        Name = 'nr'
        Attributes = [faUnNamed]
        DataType = ftInteger
      end
      item
        Name = 'inh'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 255
      end
      item
        Name = 'inh2'
        Attributes = [faUnNamed]
        DataType = ftMemo
        Size = 10
      end
      item
        Name = 'alt'
        Attributes = [faUnNamed]
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <
      item
        Name = 'alt_'
        Fields = 'alt'
      end
      item
        Name = 'ih'
        Fields = 'inh'
      end
      item
        Name = 'nro'
        Fields = 'nr'
      end>
    Params = <>
    StoreDefs = True
    Left = 625
    Top = 156
    Data = {
      44F900009619E0BD010000001800000005004406000003000000F94B017A0400
      01001200010007535542545950450200490008004175746F696E6300026E7204
      0001001000000003696E68020049001000010005574944544802000200FF0004
      696E683204004B00100002000753554254595045020049000500546578740005
      5749445448020002000A0003616C740100490010000100055749445448020002
      001E0002000A4348414E47455F4C4F4704008200CC1200000100000000000000
      0400000002000000000000000400000003000000000000000400000004000000
      0000000004000000050000000000000004000000060000000000000004000000
      0700000000000000040000000800000000000000040000000900000000000000
      040000000A00000000000000040000000B00000000000000040000000C000000
      00000000040000000D00000000000000040000000E0000000000000004000000
      0F00000000000000040000001000000000000000040000001100000000000000
      0400000012000000000000000400000013000000000000000400000014000000
      0000000004000000150000000000000004000000160000000000000004000000
      1700000000000000040000001800000000000000040000001900000000000000
      040000001A00000000000000040000001B00000000000000040000001C000000
      00000000040000001D00000000000000040000001E0000000000000004000000
      1F00000000000000040000002000000000000000040000002100000000000000
      0400000022000000000000000400000023000000000000000400000024000000
      0000000004000000250000000000000004000000260000000000000004000000
      2700000000000000040000002800000000000000040000002900000000000000
      040000002A00000000000000040000002B00000000000000040000002C000000
      00000000040000002D00000000000000040000002E0000000000000004000000
      2F00000000000000040000003000000000000000040000003100000000000000
      0400000032000000000000000400000033000000000000000400000034000000
      0000000004000000350000000000000004000000360000000000000004000000
      3700000000000000040000003800000000000000040000003900000000000000
      040000003A00000000000000040000003B00000000000000040000003C000000
      00000000040000003D00000000000000040000003E0000000000000004000000
      3F00000000000000040000004000000000000000040000004100000000000000
      0400000042000000000000000400000043000000000000000400000044000000
      0000000004000000450000000000000004000000460000000000000004000000
      4700000000000000040000004800000000000000040000004900000000000000
      040000004A00000000000000040000004B00000000000000040000004C000000
      00000000040000004D00000000000000040000004E0000000000000004000000
      4F00000000000000040000005000000000000000040000005100000000000000
      0400000052000000000000000400000053000000000000000400000054000000
      0000000004000000550000000000000004000000560000000000000004000000
      5700000000000000040000005800000000000000040000005900000000000000
      040000005A00000000000000040000005B00000000000000040000005C000000
      00000000040000005D00000000000000040000005E0000000000000004000000
      5F00000000000000040000006000000000000000040000006100000000000000
      0400000062000000000000000400000063000000000000000400000064000000
      0000000004000000650000000000000004000000660000000000000004000000
      6700000000000000040000006800000000000000040000006900000000000000
      040000006A00000000000000040000006B00000000000000040000006C000000
      00000000040000006D00000000000000040000006E0000000000000004000000
      6F00000000000000040000007000000000000000040000007100000000000000
      0400000072000000000000000400000073000000000000000400000074000000
      0000000004000000750000000000000004000000760000000000000004000000
      7700000000000000040000007800000000000000040000007900000000000000
      040000007A00000000000000040000007B00000000000000040000007C000000
      00000000040000007D00000000000000040000007E0000000000000004000000
      7F00000000000000040000008000000000000000040000008100000000000000
      0400000082000000000000000400000083000000000000000400000084000000
      0000000004000000850000000000000004000000860000000000000004000000
      8700000000000000040000008800000000000000040000008900000000000000
      040000008A00000000000000040000008B00000000000000040000008C000000
      00000000040000008D00000000000000040000008E0000000000000004000000
      8F00000000000000040000009000000000000000040000009100000000000000
      0400000092000000000000000400000093000000000000000400000094000000
      0000000004000000950000000000000004000000960000000000000004000000
      9700000000000000040000009800000000000000040000009900000000000000
      040000009A00000000000000040000009B00000000000000040000009C000000
      00000000040000009D00000000000000040000009E0000000000000004000000
      9F0000000000000004000000A00000000000000004000000A100000000000000
      04000000A20000000000000004000000A30000000000000004000000A4000000
      0000000004000000A50000000000000004000000A60000000000000004000000
      A70000000000000004000000A80000000000000004000000A900000000000000
      04000000AA0000000000000004000000AB0000000000000004000000AC000000
      0000000004000000AD0000000000000004000000AE0000000000000004000000
      AF0000000000000004000000B00000000000000004000000B100000000000000
      04000000B20000000000000004000000B30000000000000004000000B4000000
      0000000004000000B50000000000000004000000B60000000000000004000000
      B70000000000000004000000B80000000000000004000000B900000000000000
      04000000BA0000000000000004000000BB0000000000000004000000BC000000
      0000000004000000BD0000000000000004000000BE0000000000000004000000
      BF0000000000000004000000C00000000000000004000000C100000000000000
      04000000C20000000000000004000000C30000000000000004000000C4000000
      0000000004000000C50000000000000004000000C60000000000000004000000
      C70000000000000004000000C80000000000000004000000C900000000000000
      04000000CA0000000000000004000000CB0000000000000004000000CC000000
      0000000004000000CD0000000000000004000000CE0000000000000004000000
      CF0000000000000004000000D00000000000000004000000D100000000000000
      04000000D20000000000000004000000D30000000000000004000000D4000000
      0000000004000000D50000000000000004000000D60000000000000004000000
      D70000000000000004000000D80000000000000004000000D900000000000000
      04000000DA0000000000000004000000DB0000000000000004000000DC000000
      0000000004000000DD0000000000000004000000DE0000000000000004000000
      DF0000000000000004000000E00000000000000004000000E100000000000000
      04000000E20000000000000004000000E30000000000000004000000E4000000
      0000000004000000E50000000000000004000000E60000000000000004000000
      E70000000000000004000000E80000000000000004000000E900000000000000
      04000000EA0000000000000004000000EB0000000000000004000000EC000000
      0000000004000000ED0000000000000004000000EE0000000000000004000000
      EF0000000000000004000000F00000000000000004000000F100000000000000
      04000000F20000000000000004000000F30000000000000004000000F4000000
      0000000004000000F50000000000000004000000F60000000000000004000000
      F70000000000000004000000F80000000000000004000000F900000000000000
      04000000FA0000000000000004000000FB0000000000000004000000FC000000
      0000000004000000FD0000000000000004000000FE0000000000000004000000
      FF00000000000000040000000001000000000000040000000101000000000000
      0400000002010000000000000400000003010000000000000400000004010000
      0000000004000000050100000000000004000000060100000000000004000000
      0701000000000000040000000801000000000000040000000901000000000000
      040000000A01000000000000040000000B01000000000000040000000C010000
      00000000040000000D01000000000000040000000E0100000000000004000000
      0F01000000000000040000001001000000000000040000001101000000000000
      0400000012010000000000000400000013010000000000000400000014010000
      0000000004000000150100000000000004000000160100000000000004000000
      1701000000000000040000001801000000000000040000001901000000000000
      040000001A01000000000000040000001B01000000000000040000001C010000
      00000000040000001D01000000000000040000001E0100000000000004000000
      1F01000000000000040000002001000000000000040000002101000000000000
      0400000022010000000000000400000023010000000000000400000024010000
      0000000004000000250100000000000004000000260100000000000004000000
      2701000000000000040000002801000000000000040000002901000000000000
      040000002A01000000000000040000002B01000000000000040000002C010000
      00000000040000002D01000000000000040000002E0100000000000004000000
      2F01000000000000040000003001000000000000040000003101000000000000
      0400000032010000000000000400000033010000000000000400000034010000
      0000000004000000350100000000000004000000360100000000000004000000
      3701000000000000040000003801000000000000040000003901000000000000
      040000003A01000000000000040000003B01000000000000040000003C010000
      00000000040000003D01000000000000040000003E0100000000000004000000
      3F01000000000000040000004001000000000000040000004101000000000000
      0400000042010000000000000400000043010000000000000400000044010000
      0000000004000000450100000000000004000000460100000000000004000000
      4701000000000000040000004801000000000000040000004901000000000000
      040000004A01000000000000040000004B01000000000000040000004C010000
      00000000040000004D01000000000000040000004E0100000000000004000000
      4F01000000000000040000005001000000000000040000005101000000000000
      0400000052010000000000000400000053010000000000000400000054010000
      0000000004000000550100000000000004000000560100000000000004000000
      5701000000000000040000005801000000000000040000005901000000000000
      040000005A01000000000000040000005B01000000000000040000005C010000
      00000000040000005D01000000000000040000005E0100000000000004000000
      5F01000000000000040000006001000000000000040000006101000000000000
      0400000062010000000000000400000063010000000000000400000064010000
      0000000004000000650100000000000004000000660100000000000004000000
      6701000000000000040000006801000000000000040000006901000000000000
      040000006A01000000000000040000006B01000000000000040000006C010000
      00000000040000006D01000000000000040000006E0100000000000004000000
      6F01000000000000040000007001000000000000040000007101000000000000
      0400000072010000000000000400000073010000000000000400000074010000
      0000000004000000750100000000000004000000760100000000000004000000
      7701000000000000040000007801000000000000040000007901000000000000
      040000007A01000000000000040000007B01000000000000040000007C010000
      00000000040000007D01000000000000040000007E0100000000000004000000
      7F01000000000000040000008001000000000000040000008101000000000000
      0400000082010000000000000400000083010000000000000400000084010000
      0000000004000000850100000000000004000000860100000000000004000000
      8701000000000000040000008801000000000000040000008901000000000000
      040000008A01000000000000040000008B01000000000000040000008C010000
      00000000040000008D01000000000000040000008E0100000000000004000000
      8F01000000000000040000009001000000000000040000009101000000000000
      0400000092010000000000000400000093010000000000000400000094010000
      0000000004000000950100000000000004000000960100000000000004000000
      9701000000000000040000009801000000000000040000009901000000000000
      040000009A01000000000000040000009B01000000000000040000009C010000
      00000000040000009D01000000000000040000009E0100000000000004000000
      9F0100000000000004000000A00100000000000004000000A101000000000000
      04000000A20100000000000004000000A30100000000000004000000A4010000
      0000000004000000A50100000000000004000000A60100000000000004000000
      A70100000000000004000000A80100000000000004000000A901000000000000
      04000000AA0100000000000004000000AB0100000000000004000000AC010000
      0000000004000000AD0100000000000004000000AE0100000000000004000000
      AF0100000000000004000000B00100000000000004000000B101000000000000
      04000000B20100000000000004000000B30100000000000004000000B4010000
      0000000004000000B50100000000000004000000B60100000000000004000000
      B70100000000000004000000B80100000000000004000000B901000000000000
      04000000BA0100000000000004000000BB0100000000000004000000BC010000
      0000000004000000BD0100000000000004000000BE0100000000000004000000
      BF0100000000000004000000C00100000000000004000000C101000000000000
      04000000C20100000000000004000000C30100000000000004000000C4010000
      0000000004000000C50100000000000004000000C60100000000000004000000
      C70100000000000004000000C80100000000000004000000C901000000000000
      04000000CA0100000000000004000000CB0100000000000004000000CC010000
      0000000004000000CD0100000000000004000000CE0100000000000004000000
      CF0100000000000004000000D00100000000000004000000D101000000000000
      04000000D20100000000000004000000D30100000000000004000000D4010000
      0000000004000000D50100000000000004000000D60100000000000004000000
      D70100000000000004000000D80100000000000004000000D901000000000000
      04000000DA0100000000000004000000DB0100000000000004000000DC010000
      0000000004000000DD0100000000000004000000DE0100000000000004000000
      DF0100000000000004000000E00100000000000004000000E101000000000000
      04000000E20100000000000004000000E30100000000000004000000E4010000
      0000000004000000E50100000000000004000000E60100000000000004000000
      E70100000000000004000000E80100000000000004000000E901000000000000
      04000000EA0100000000000004000000EB0100000000000004000000EC010000
      0000000004000000ED0100000000000004000000EE0100000000000004000000
      EF0100000000000004000000F00100000000000004000000F101000000000000
      04000000F20100000000000004000000F30100000000000004000000F4010000
      0000000004000000F50100000000000004000000F60100000000000004000000
      F70100000000000004000000F80100000000000004000000F901000000000000
      04000000FA0100000000000004000000FB0100000000000004000000FC010000
      0000000004000000FD0100000000000004000000FE0100000000000004000000
      FF01000000000000040000000002000000000000040000000102000000000000
      0400000002020000000000000400000003020000000000000400000004020000
      0000000004000000050200000000000004000000060200000000000004000000
      0702000000000000040000000802000000000000040000000902000000000000
      040000000A02000000000000040000000B02000000000000040000000C020000
      00000000040000000D02000000000000040000000E0200000000000004000000
      0F02000000000000040000001002000000000000040000001102000000000000
      0400000012020000000000000400000013020000000000000400000014020000
      0000000004000000150200000000000004000000160200000000000004000000
      1702000000000000040000001802000000000000040000001902000000000000
      040000001A02000000000000040000001B02000000000000040000001C020000
      00000000040000001D02000000000000040000001E0200000000000004000000
      1F02000000000000040000002002000000000000040000002102000000000000
      0400000022020000000000000400000023020000000000000400000024020000
      0000000004000000250200000000000004000000260200000000000004000000
      2702000000000000040000002802000000000000040000002902000000000000
      040000002A02000000000000040000002B02000000000000040000002C020000
      00000000040000002D02000000000000040000002E0200000000000004000000
      2F02000000000000040000003002000000000000040000003102000000000000
      0400000032020000000000000400000033020000000000000400000034020000
      0000000004000000350200000000000004000000360200000000000004000000
      3702000000000000040000003802000000000000040000003902000000000000
      040000003A02000000000000040000003B02000000000000040000003C020000
      00000000040000003D02000000000000040000003E0200000000000004000000
      3F02000000000000040000004002000000000000040000004102000000000000
      0400000042020000000000000400000043020000000000000400000044020000
      0000000004000000450200000000000004000000460200000000000004000000
      4702000000000000040000004802000000000000040000004902000000000000
      040000004A02000000000000040000004B02000000000000040000004C020000
      00000000040000004D02000000000000040000004E0200000000000004000000
      4F02000000000000040000005002000000000000040000005102000000000000
      0400000052020000000000000400000053020000000000000400000054020000
      0000000004000000550200000000000004000000560200000000000004000000
      5702000000000000040000005802000000000000040000005902000000000000
      040000005A02000000000000040000005B02000000000000040000005C020000
      00000000040000005D02000000000000040000005E0200000000000004000000
      5F02000000000000040000006002000000000000040000006102000000000000
      0400000062020000000000000400000063020000000000000400000064020000
      0000000004000000650200000000000004000000660200000000000004000000
      6702000000000000040000006802000000000000040000006902000000000000
      040000006A02000000000000040000006B02000000000000040000006C020000
      00000000040000006D02000000000000040000006E0200000000000004000000
      6F02000000000000040000007002000000000000040000007102000000000000
      0400000072020000000000000400000073020000000000000400000074020000
      0000000004000000750200000000000004000000760200000000000004000000
      7702000000000000040000007802000000000000040000007902000000000000
      040000007A02000000000000040000007B02000000000000040000007C020000
      00000000040000007D02000000000000040000007E0200000000000004000000
      7F02000000000000040000008002000000000000040000008102000000000000
      0400000082020000000000000400000083020000000000000400000084020000
      0000000004000000850200000000000004000000860200000000000004000000
      8702000000000000040000008802000000000000040000008902000000000000
      040000008A02000000000000040000008B02000000000000040000008C020000
      00000000040000008D02000000000000040000008E0200000000000004000000
      8F02000000000000040000009002000000000000040000009102000000000000
      0400000092020000000000000400000093020000000000000400000094020000
      0000000004000000950200000000000004000000960200000000000004000000
      9702000000000000040000009802000000000000040000009902000000000000
      040000009A02000000000000040000009B02000000000000040000009C020000
      00000000040000009D02000000000000040000009E0200000000000004000000
      9F0200000000000004000000A00200000000000004000000A102000000000000
      04000000A20200000000000004000000A30200000000000004000000A4020000
      0000000004000000A50200000000000004000000A60200000000000004000000
      A70200000000000004000000A80200000000000004000000A902000000000000
      04000000AA0200000000000004000000AB0200000000000004000000AC020000
      0000000004000000AD0200000000000004000000AE0200000000000004000000
      AF0200000000000004000000B00200000000000004000000B102000000000000
      04000000B20200000000000004000000B30200000000000004000000B4020000
      0000000004000000B50200000000000004000000B60200000000000004000000
      B70200000000000004000000B80200000000000004000000B902000000000000
      04000000BA0200000000000004000000BB0200000000000004000000BC020000
      0000000004000000BD0200000000000004000000BE0200000000000004000000
      BF0200000000000004000000C00200000000000004000000C102000000000000
      04000000C20200000000000004000000C30200000000000004000000C4020000
      0000000004000000C50200000000000004000000C60200000000000004000000
      C70200000000000004000000C80200000000000004000000C902000000000000
      04000000CA0200000000000004000000CB0200000000000004000000CC020000
      0000000004000000CD0200000000000004000000CE0200000000000004000000
      CF0200000000000004000000D00200000000000004000000D102000000000000
      04000000D20200000000000004000000D30200000000000004000000D4020000
      0000000004000000D50200000000000004000000D60200000000000004000000
      D70200000000000004000000D80200000000000004000000D902000000000000
      04000000DA0200000000000004000000DB0200000000000004000000DC020000
      0000000004000000DD0200000000000004000000DE0200000000000004000000
      DF0200000000000004000000E00200000000000004000000E102000000000000
      04000000E20200000000000004000000E30200000000000004000000E4020000
      0000000004000000E50200000000000004000000E60200000000000004000000
      E70200000000000004000000E80200000000000004000000E902000000000000
      04000000EA0200000000000004000000EB0200000000000004000000EC020000
      0000000004000000ED0200000000000004000000EE0200000000000004000000
      EF0200000000000004000000F00200000000000004000000F102000000000000
      04000000F20200000000000004000000F30200000000000004000000F4020000
      0000000004000000F50200000000000004000000F60200000000000004000000
      F70200000000000004000000F80200000000000004000000F902000000000000
      04000000FA0200000000000004000000FB0200000000000004000000FC020000
      0000000004000000FD0200000000000004000000FE0200000000000004000000
      FF02000000000000040000000003000000000000040000000103000000000000
      0400000002030000000000000400000003030000000000000400000004030000
      0000000004000000050300000000000004000000060300000000000004000000
      0703000000000000040000000803000000000000040000000903000000000000
      040000000A03000000000000040000000B03000000000000040000000C030000
      00000000040000000D03000000000000040000000E0300000000000004000000
      0F03000000000000040000001003000000000000040000001103000000000000
      0400000012030000000000000400000013030000000000000400000014030000
      0000000004000000150300000000000004000000160300000000000004000000
      1703000000000000040000001803000000000000040000001903000000000000
      040000001A03000000000000040000001B03000000000000040000001C030000
      00000000040000001D03000000000000040000001E0300000000000004000000
      1F03000000000000040000002003000000000000040000002103000000000000
      0400000022030000000000000400000023030000000000000400000024030000
      0000000004000000250300000000000004000000260300000000000004000000
      2703000000000000040000002803000000000000040000002903000000000000
      040000002A03000000000000040000002B03000000000000040000002C030000
      00000000040000002D03000000000000040000002E0300000000000004000000
      2F03000000000000040000003003000000000000040000003103000000000000
      0400000032030000000000000400000033030000000000000400000034030000
      0000000004000000350300000000000004000000360300000000000004000000
      3703000000000000040000003803000000000000040000003903000000000000
      040000003A03000000000000040000003B03000000000000040000003C030000
      00000000040000003D03000000000000040000003E0300000000000004000000
      3F03000000000000040000004003000000000000040000004103000000000000
      0400000042030000000000000400000043030000000000000400000044030000
      0000000004000000450300000000000004000000460300000000000004000000
      4703000000000000040000004803000000000000040000004903000000000000
      040000004A03000000000000040000004B03000000000000040000004C030000
      00000000040000004D03000000000000040000004E0300000000000004000000
      4F03000000000000040000005003000000000000040000005103000000000000
      0400000052030000000000000400000053030000000000000400000054030000
      0000000004000000550300000000000004000000560300000000000004000000
      5703000000000000040000005803000000000000040000005903000000000000
      040000005A03000000000000040000005B03000000000000040000005C030000
      00000000040000005D03000000000000040000005E0300000000000004000000
      5F03000000000000040000006003000000000000040000006103000000000000
      0400000062030000000000000400000063030000000000000400000064030000
      0000000004000000650300000000000004000000660300000000000004000000
      6703000000000000040000006803000000000000040000006903000000000000
      040000006A03000000000000040000006B03000000000000040000006C030000
      00000000040000006D03000000000000040000006E0300000000000004000000
      6F03000000000000040000007003000000000000040000007103000000000000
      0400000072030000000000000400000073030000000000000400000074030000
      0000000004000000750300000000000004000000760300000000000004000000
      7703000000000000040000007803000000000000040000007903000000000000
      040000007A03000000000000040000007B03000000000000040000007C030000
      00000000040000007D03000000000000040000007E0300000000000004000000
      7F03000000000000040000008003000000000000040000008103000000000000
      0400000082030000000000000400000083030000000000000400000084030000
      0000000004000000850300000000000004000000860300000000000004000000
      8703000000000000040000008803000000000000040000008903000000000000
      040000008A03000000000000040000008B03000000000000040000008C030000
      00000000040000008D03000000000000040000008E0300000000000004000000
      8F03000000000000040000009003000000000000040000009103000000000000
      0400000092030000000000000400000093030000000000000400000094030000
      0000000004000000950300000000000004000000960300000000000004000000
      9703000000000000040000009803000000000000040000009903000000000000
      040000009A03000000000000040000009B03000000000000040000009C030000
      00000000040000009D03000000000000040000009E0300000000000004000000
      9F0300000000000004000000A00300000000000004000000A103000000000000
      04000000A20300000000000004000000A30300000000000004000000A4030000
      0000000004000000A50300000000000004000000A60300000000000004000000
      A70300000000000004000000A80300000000000004000000A903000000000000
      04000000AA0300000000000004000000AB0300000000000004000000AC030000
      0000000004000000AD0300000000000004000000AE0300000000000004000000
      AF0300000000000004000000B00300000000000004000000B103000000000000
      04000000B20300000000000004000000B30300000000000004000000B4030000
      0000000004000000B50300000000000004000000B60300000000000004000000
      B70300000000000004000000B80300000000000004000000B903000000000000
      04000000BA0300000000000004000000BB0300000000000004000000BC030000
      0000000004000000BD0300000000000004000000BE0300000000000004000000
      BF0300000000000004000000C00300000000000004000000C103000000000000
      04000000C20300000000000004000000C30300000000000004000000C4030000
      0000000004000000C50300000000000004000000C60300000000000004000000
      C70300000000000004000000C80300000000000004000000C903000000000000
      04000000CA0300000000000004000000CB0300000000000004000000CC030000
      0000000004000000CD0300000000000004000000CE0300000000000004000000
      CF0300000000000004000000D00300000000000004000000D103000000000000
      04000000D20300000000000004000000D30300000000000004000000D4030000
      0000000004000000D50300000000000004000000D60300000000000004000000
      D70300000000000004000000D80300000000000004000000D903000000000000
      04000000DA0300000000000004000000DB0300000000000004000000DC030000
      0000000004000000DD0300000000000004000000DE0300000000000004000000
      DF0300000000000004000000E00300000000000004000000E103000000000000
      04000000E20300000000000004000000E30300000000000004000000E4030000
      0000000004000000E50300000000000004000000E60300000000000004000000
      E70300000000000004000000E80300000000000004000000E903000000000000
      04000000EA0300000000000004000000EB0300000000000004000000EC030000
      0000000004000000ED0300000000000004000000EE0300000000000004000000
      EF0300000000000004000000F00300000000000004000000F103000000000000
      04000000F20300000000000004000000F30300000000000004000000F4030000
      0000000004000000F50300000000000004000000F60300000000000004000000
      F70300000000000004000000F80300000000000004000000F903000000000000
      04000000FA0300000000000004000000FB0300000000000004000000FC030000
      0000000004000000FD0300000000000004000000FE0300000000000004000000
      FF03000000000000040000000004000000000000040000000104000000000000
      0400000002040000000000000400000003040000000000000400000004040000
      0000000004000000050400000000000004000000060400000000000004000000
      0704000000000000040000000804000000000000040000000904000000000000
      040000000A04000000000000040000000B04000000000000040000000C040000
      00000000040000000D04000000000000040000000E0400000000000004000000
      0F04000000000000040000001004000000000000040000001104000000000000
      0400000012040000000000000400000013040000000000000400000014040000
      0000000004000000150400000000000004000000160400000000000004000000
      1704000000000000040000001804000000000000040000001904000000000000
      040000001A04000000000000040000001B04000000000000040000001C040000
      00000000040000001D04000000000000040000001E0400000000000004000000
      1F04000000000000040000002004000000000000040000002104000000000000
      0400000022040000000000000400000023040000000000000400000024040000
      0000000004000000250400000000000004000000260400000000000004000000
      2704000000000000040000002804000000000000040000002904000000000000
      040000002A04000000000000040000002B04000000000000040000002C040000
      00000000040000002D04000000000000040000002E0400000000000004000000
      2F04000000000000040000003004000000000000040000003104000000000000
      0400000032040000000000000400000033040000000000000400000034040000
      0000000004000000350400000000000004000000360400000000000004000000
      3704000000000000040000003804000000000000040000003904000000000000
      040000003A04000000000000040000003B04000000000000040000003C040000
      00000000040000003D04000000000000040000003E0400000000000004000000
      3F04000000000000040000004004000000000000040000004104000000000000
      0400000042040000000000000400000043040000000000000400000044040000
      0000000004000000450400000000000004000000460400000000000004000000
      4704000000000000040000004804000000000000040000004904000000000000
      040000004A04000000000000040000004B04000000000000040000004C040000
      00000000040000004D04000000000000040000004E0400000000000004000000
      4F04000000000000040000005004000002000000080000005104000006000000
      0800000052040000080000000800000053040000090000000800000054040000
      0E00000008000000550400001300000008000000560400001800000008000000
      570400001A000000080000005804000020000000080000005904000027000000
      080000005A0400002B000000080000005B04000030000000080000005C040000
      33000000080000005D04000034000000080000005E0400003700000008000000
      5F0400003800000008000000600400003C000000080000006104000045000000
      08000000620400004A0000000800000063040000550000000800000064040000
      5800000008000000650400005C00000008000000660400005F00000008000000
      6704000065000000080000006804000069000000080000006904000072000000
      080000006A04000074000000080000006B04000082000000080000006C040000
      8B000000080000006D0400008F000000080000006E0400009800000008000000
      6F040000AB0000000800000070040000AF0000000800000071040000B6000000
      0800000072040000B70000000800000073040000BD0000000800000074040000
      D30000000800000075040000D40000000800000076040000D500000008000000
      77040000DA0000000800000078040000DE0000000800000079040000E6000000
      080000007A040000E8000000080000007B040000EB000000080000007C040000
      EE000000080000007D040000F0000000080000007E040000F400000008000000
      7F040000FC000000080000008004000006010000080000008104000012010000
      08000000820400001A01000008000000830400001C0100000800000084040000
      2201000008000000850400002B01000008000000860400002F01000008000000
      8704000031010000080000008804000033010000080000008904000035010000
      080000008A04000039010000080000008B0400003C010000080000008C040000
      42010000080000008D0400005C010000080000008E0400006101000008000000
      8F0400006801000008000000900400006D010000080000009104000075010000
      0800000092040000770100000800000093040000790100000800000094040000
      7D01000008000000950400008801000008000000960400008E01000008000000
      97040000920100000800000098040000950100000800000099040000A4010000
      080000009A040000A8010000080000009B040000AE010000080000009C040000
      B9010000080000009D040000BE010000080000009E040000E401000008000000
      9F040000F301000008000000A0040000F701000008000000A1040000FE010000
      08000000A20400000502000008000000A30400000702000008000000A4040000
      0902000008000000A50400000B02000008000000A60400002202000008000000
      A70400002402000008000000A80400003502000008000000A904000043020000
      08000000AA0400004702000008000000AB0400005102000008000000AC040000
      5D02000008000000AD0400005F02000008000000AE0400008202000008000000
      AF0400008802000008000000B00400008D02000008000000B104000092020000
      08000000B20400009602000008000000B30400009802000008000000B4040000
      A702000008000000B5040000B702000008000000B6040000BC02000008000000
      B7040000C202000008000000B8040000DF02000008000000B9040000E4020000
      08000000BA040000E602000008000000BB040000EB02000008000000BC040000
      F002000008000000BD040000F502000008000000BE040000F802000008000000
      BF040000F902000008000000C00400003303000008000000C104000036030000
      08000000C20400004D03000008000000C30400005103000008000000C4040000
      5403000008000000C50400005703000008000000C60400005C03000008000000
      C70400006703000008000000C80400007803000008000000C904000081030000
      08000000CA0400008F03000008000000CB0400009203000008000000CC040000
      9503000008000000CD0400009903000008000000CE0400009C03000008000000
      CF040000A303000008000000D0040000A403000008000000D1040000A7030000
      08000000D2040000AD03000008000000D3040000B103000008000000D4040000
      B403000008000000D5040000B903000008000000D6040000BC03000008000000
      D7040000BE03000008000000D8040000C303000008000000D9040000C4030000
      08000000DA040000C803000008000000DB040000EE03000008000000DC040000
      F403000008000000DD040000FA03000008000000DE040000FD03000008000000
      DF040000FE03000008000000E0040000FF03000008000000E104000001040000
      08000000E20400000304000008000000E30400001904000008000000E4040000
      1C04000008000000E50400001D04000008000000E60400002104000008000000
      E70400002204000008000000E80400002604000008000000E904000027040000
      08000000EA0400002804000008000000EB0400002904000008000000EC040000
      2A04000008000000ED0400002C04000008000000EE0400002D04000008000000
      EF0400002E04000008000000F00400002F04000008000000F104000030040000
      08000000F20400003104000008000000F30400003204000008000000F4040000
      3304000008000000F50400003404000008000000F60400003504000008000000
      F70400003604000008000000F80400003C04000008000000F90400003D040000
      08000000FA0400003F04000008000000FB0400004004000008000000FC040000
      4404000008000000FD0400004504000008000000FE0400004604000008000000
      FF04000047040000080000000005000048040000080000000105000049040000
      08000000020500004A04000008000000030500004B0400000800000004050000
      4C04000008000000050500004D04000008000000060500004E04000008000000
      070500005E02000008000000080500001903000008000000090500007A000000
      080000000A05000084000000080000000B050000A5000000080000000C050000
      A3000000080000000D050000A7000000080000000E0500004F01000008000000
      0F050000F900000008000000100500007F0000000800000011050000B2010000
      0800000012050000C002000008000000130500001D0300000800000014050000
      770000000800000015050000A601000008000000160500001702000008000000
      17050000CF0000000800000018050000890300000800000019050000E5030000
      080000001A050000DB020000080000001B050000E3020000080000001C050000
      80010000080000001D0500008C030000080000001E0500006200000008000000
      1F050000BB0200000800000020050000FC030000080000002105000083010000
      0800000022050000110300000800000023050000E30300000800000024050000
      9002000008000000250500004603000008000000260500005B02000008000000
      270500009502000008000000280500001601000008000000290500004A030000
      080000002A0500005E030000080000002B0500001C000000080000002C050000
      05000000080000002D05000048030000080000002E0500009D01000008000000
      2F05000054010000080000003005000086000000080000003105000091000000
      0800000032050000EC0100000800000033050000940300000800000034050000
      4E00000008000000350500003802000008000000360500001700000008000000
      37050000B60200000800000038050000E0030000080000003905000062030000
      080000003A050000C0000000080000003B050000CD000000080000003C050000
      F0030000080000003D050000DE020000080000003E0500007D00000008000000
      3F050000830300000800000040050000D9020000080000004105000030020000
      08000000420500005302000008000000430500008E0000000800000044050000
      5E0000000800000045050000970100000800000046050000D503000008000000
      470500009103000008000000480500005603000008000000490500005B000000
      080000004A05000094000000080000004B05000087010000080000004C050000
      38010000080000004D0500001F030000080000004E0500009700000008000000
      4F0500002A00000008000000500500004C0300000800000051050000C2000000
      0800000052050000D900000008000000530500008C0200000800000054050000
      0C00000008000000550500005303000008000000560500004F03000008000000
      57050000B20200000800000058050000B50000000800000059050000EA020000
      080000005A05000012000000080000005B0500009B000000080000005C050000
      DD030000080000005D0500009E000000080000005E050000C301000008000000
      5F0500006003000008000000600500003600000008000000610500002F000000
      0800000062050000B00100000800000063050000E70300000800000064050000
      6D0000000800000065050000A201000008000000660500003B00000008000000
      670500008A0200000800000068050000F30000000800000069050000CB020000
      080000006A050000C7030000080000006B05000049020000080000006C050000
      15030000080000006D0500000B030000080000006E050000DD00000008000000
      6F050000D60200000800000070050000A6030000080000007105000087020000
      0800000072050000C50000000800000073050000A10000000800000074050000
      8A0000000800000075050000C701000008000000760500002603000008000000
      77050000410200000800000078050000A00100000800000079050000A2030000
      080000007A0500001B030000080000007B050000D3030000080000007C050000
      CB010000080000007D05000013030000080000007E0500004103000008000000
      7F0500008E0300000800000080050000C2030000080000008105000032000000
      0800000082050000F201000008000000830500000E0300000800000084050000
      BC0000000800000085050000E101000008000000860500004400000008000000
      87050000C900000008000000880500009D0200000800000089050000E2000000
      080000008A05000064000000080000008B0500001E010000080000008C050000
      57000000080000008D050000AA010000080000008E0500006501000008000000
      8F050000E802000008000000900500001E0000000800000091050000EB030000
      0800000092050000F30300000800000093050000590300000800000094050000
      CF0100000800000095050000D803000008000000960500000901000008000000
      970500003E0000000800000098050000710000000800000099050000DB030000
      080000009A0500002A010000080000009B050000D8010000080000009C050000
      58010000080000009D05000081000000080000009E050000CB00000008000000
      9F0500004100000008000000A0050000C700000008000000A1050000B9000000
      08000000A20500006701000008000000A30500006001000008000000A4050000
      4501000008000000A50500005B03000008000000A60500002600000008000000
      A70500001901000008000000A80500004C00000008000000A9050000B8010000
      08000000AA0500008501000008000000AB0500004900000008000000AC050000
      D100000008000000AD050000F600000008000000AE0500006800000008000000
      AF050000D700000008000000B00500006D02000008000000B1050000E5010000
      08000000B2050000F401000008000000B30500007300000008000000B4050000
      6600000008000000B50500006000000008000000B60500008A03000008000000
      B70500009500000008000000B80500002004000008000000B90500009A030000
      08000000BA0500000A00000008000000BB050000DC02000008000000BC050000
      1E04000008000000BD0500008800000008000000BE050000CC01000008000000
      BF050000E601000008000000C0050000E201000008000000C10500003A040000
      08000000C2050000F503000008000000C3050000BB01000008000000C4050000
      CA03000008000000C50500000302000008000000C60500006901000008000000
      C7050000AC02000008000000C8050000BD02000008000000C9050000C1020000
      08000000CA050000BE02000008000000CB050000B302000008000000CC050000
      4104000008000000CD0500004204000008000000CE050000B802000008000000
      CF0500006002000008000000D0050000B902000008000000D1050000A6020000
      08000000D20500006F00000008000000D3050000B002000008000000D4050000
      A802000008000000D5050000C302000008000000D6050000B402000008000000
      D7050000CC02000008000000D8050000CE02000008000000D905000043040000
      08000000DA0500001F04000008000000DB0500006A00000008000000DC050000
      9200000008000000DD0500008603000008000000DE0500008403000008000000
      DF0500009702000008000000E0050000D202000008000000E10500000F010000
      08000000E20500001301000008000000E30500000D01000008000000E4050000
      0B01000008000000E50500003902000008000000E60500000403000008000000
      E70500000803000008000000E8050000D901000008000000E90500003C020000
      08000000EA050000EF01000008000000EB0500000103000008000000EC050000
      AF02000008000000ED050000ED01000008000000EE0500004600000008000000
      EF0500005000000008000000F00500002300000008000000F10500001F000000
      08000000F20500002C00000008000000F30500005402000008000000F4050000
      5702000008000000F50500003E04000008000000F60500009B02000008000000
      F70500004602000008000000F80500004A02000008000000F90500001B040000
      08000000FA050000D702000008000000FB050000D001000008000000FC050000
      4202000008000000FD0500003D02000008000000FE050000EE01000008000000
      FF05000002030000080000000006000087000000080000000106000042000000
      0800000002060000240000000800000003060000510000000800000004060000
      240400000800000005060000DF0000000800000006060000E000000008000000
      07060000250400000800000008060000230400000800000009060000E7000000
      080000000A060000E9000000080000000B06000099000000080000000C060000
      36020000080000000D06000038040000080000000E060000F001000008000000
      0F060000DA01000008000000100600003B040000080000001106000039040000
      0800000012060000D60100000800000013060000DB0100000800000014060000
      060300000800000015060000090300000800000016060000D401000008000000
      170600006E000000080000001806000047010000080000001906000019000000
      080000001A060000DB000000080000001B06000028000000080000001C060000
      14000000080000001D06000037040000080000001E0600000700000008000000
      1F060000C50100000800000020060000C901000008000000210600000D000000
      08000000220600001500000008000000230600000F0000000800000024060000
      630100000800000025060000C80100000800000026060000C401000008000000
      2706000010000000080000002806000047000000080000002906000000030000
      080000002A060000FF010000080000002B060000EC000000080000002C060000
      F1000000080000002D060000AC010000080000002E0600007500000008000000
      2F0600008C0000000800000030060000590000000800000031060000E1020000
      08000000320600000C03000008000000330600006B0000000800000034060000
      390000000800000035060000BA0000000800000036060000BE00000008000000
      370600002D0000000800000038060000210000000800000039060000E4000000
      080000003A060000E3000000080000003B0600001A040000080000003C060000
      6C020000080000003D06000064020000080000003E060000C300000008000000
      3F0600003F02000008000000400600000300000008000000410600002B040000
      0800000042060000D200000008000000430600003F0000000800000044060000
      28030000080000000C4155544F494E4356414C55450400010056391E00045000
      07351E000100000002493105000008351E000100000005004050393440080000
      004DC3BC6E6368656E02493105400009351E0001000000060040533332304002
      49310450000A351E00020000000249320540000B351E00020000000500405333
      38400249320500000C351E00020000000500405035364011000000477261C39F
      6C66696E67204E722E2031350249320540000D351E0002000000060040533238
      35400249320500000E351E00020000000500405035344009000000477261C39F
      66696E670249320500000F351E0002000000050040503535400A000000477261
      C39F6C66696E6702493205400010351E00020000000600405331383040024932
      04500011351E000300000002493305400012351E000300000005004053373840
      02493305400013351E0003000000060040533238384002493305000014351E00
      0300000005004050393040070000004D617474696E6702493305400015351E00
      03000000060040533239304002493305400016351E0003000000060040533239
      344002493304500017351E000400000002493405400018351E00040000000500
      405338344002493405000019351E000400000006004050313537400500000054
      6575676E0249340540001A351E00040000000600405332383340024934054000
      1B351E000400000006004053323839400249340450001C351E00050000000249
      350540001D351E0005000000050040533438400249350500001E351E00050000
      00050040503533401000000047726173736C66696E67204E722E203402493505
      40001F351E0005000000060040533238304002493505000020351E0005000000
      06004050313834400B0000005A696567657473646F726602493504500021351E
      000600000002493605400022351E000600000005004053333740024936045000
      23351E000700000002493705400024351E000700000006004053313338400249
      3705400025351E0007000000060040533233384002493705000026351E000700
      0000050040503531400A0000004765727374686F66656E02493705400027351E
      0007000000060040533331324002493704500028351E00080000000249380540
      0029351E000800000006004053323337400249380540002A351E000800000006
      004053323536400249380450002B351E00090000000249390540002C351E0009
      00000006004053313630400249390500002D351E000900000005004050343040
      07000000456E7366656C640249390540002E351E000900000006004053323832
      400249390450002F351E000A0000000349313005400030351E000A0000000500
      40533733400349313005000031351E000A00000006004050313536400B000000
      5461676D6572736865696D0349313005400032351E000A000000060040533233
      39400349313005400033351E000A000000060040533331314003493130045000
      34351E000B0000000349313105400035351E000B000000050040533931400349
      313105000036351E000B000000050040503237400C00000044617474656E6861
      7573656E0349313104500037351E000C0000000349313205400038351E000C00
      000006004053313233400349313205000039351E000C00000004004050384008
      0000004175677362757267034931320500003A351E000C000000050040503735
      40070000004B656D7074656E034931320450003B351E000D0000000349313305
      40003C351E000D00000005004053393040034931330500003D351E000D000000
      06004050313236400800000052C3B6676C696E67034931330500003E351E000D
      00000005004050393340070000004D6F6E6865696D034931330540003F351E00
      0D00000006004053333038400349313304500040351E000E0000000349313405
      400041351E000E000000050040533936400349313405000042351E000E000000
      06004050313830400900000057657274696E67656E0349313404500043351E00
      0F0000000349313505400044351E000F00000006004053313435400349313505
      400045351E000F00000006004053333233400349313504500046351E00100000
      000349313605400047351E001000000006004053313533400349313605400048
      351E001000000006004053323535400349313604500049351E00110000000349
      31370540004A351E00110000000600405331323840034931370500004B351E00
      110000000600405031303840090000004F686D656E6865696D03493137054000
      4C351E00110000000600405332333540034931370540004D351E001100000006
      00405332393540034931370450004E351E0012000000034931380540004F351E
      001200000006004053313635400349313805000050351E001200000005004050
      3332400900000044696C6C696E67656E0349313804500051351E001300000003
      49313905400052351E001300000006004053313632400349313904500053351E
      00140000000349323005400054351E0014000000050040533436400349323004
      500055351E00150000000349323105400056351E001500000006004053323336
      400349323105400057351E001500000006004053323537400349323104500058
      351E00160000000349323204500059351E0017000000034932330450005A351E
      0018000000034932340500005B351E0018000000050040503532401100000047
      65727374686F66656E20284D4B644629034932340450005C351E001900000003
      4932350540005D351E00190000000600405331333440034932350500005E351E
      001900000006004050313832400C0000005769747469736C696E67656E034932
      350540005F351E001900000006004053333034400349323504500060351E001A
      0000000349323605400061351E001A0000000500405336374003493236050000
      62351E001A0000000500405031374008000000426572676865696D0349323604
      500063351E001B0000000349323705400064351E001B00000005004053363240
      0349323705000065351E001B000000050040503437400A000000467269636B69
      6E67656E0349323705400066351E001B00000006004053313735400349323704
      500067351E001C0000000349323805400068351E001C00000005004053323440
      0349323804500069351E001D000000034932390540006A351E001D0000000600
      405331333240034932390500006B351E001D0000000600405031373640140000
      005765696C6865696D20626569204D6F6E6865696D034932390540006C351E00
      1D0000000600405331373440034932390450006D351E001E0000000349333005
      40006E351E001E0000000600405331363840034933300500006F351E001E0000
      000600405031373440080000005765696C6865696D0349333005400070351E00
      1E00000006004053323134400349333005400071351E001E0000000600405333
      3037400349333004500072351E001F0000000349333105400073351E001F0000
      00050040533934400349333105400074351E001F000000060040533237384003
      49333105400075351E001F00000006004053323035400349333104500076351E
      00200000000349333205400077351E0020000000060040533134364003493332
      05000078351E002000000006004050313735400B0000005765696C6865696D20
      2A290349333205400079351E0020000000060040533137334003493332050000
      7A351E0020000000050040503235400700000044616974696E67034933320540
      007B351E00200000000600405333303240034933320450007C351E0021000000
      034933330540007D351E002100000005004053313440034933330450007E351E
      0022000000034933340450007F351E00230000000349333505400080351E0023
      0000000400405333400349333504500081351E00240000000349333604500082
      351E00250000000349333705400083351E002500000005004053353640034933
      3704500084351E00260000000349333805400085351E00260000000500405331
      30400349333804500086351E00270000000349333905400087351E0027000000
      06004053313531400349333905000088351E0027000000050040503632400C00
      000047756E64656C66696E67656E0349333904500089351E0028000000034934
      300540008A351E0028000000040040533440034934300450008B351E00290000
      00034934310540008C351E002900000005004053343240034934310540008D35
      1E00290000000600405332353440034934310540008E351E0029000000060040
      5331383340034934310450008F351E002A0000000349343205400090351E002A
      00000006004053313130400349343205000091351E002A000000060040503132
      32400800000052616D73626572670349343205400092351E002A000000060040
      53333033400349343204500093351E002B0000000349343305400094351E002B
      000000050040533631400349343305000095351E002B00000006004050313638
      40080000005761726368696E670349343304500096351E002C00000003493434
      05400097351E002C000000050040533433400349343405400098351E002C0000
      0006004053323135400349343404500099351E002D000000034934350540009A
      351E002D00000005004053363840034934350540009B351E002D000000060040
      5331373740034934350450009C351E002E000000034934360540009D351E002E
      00000005004053373240034934360500009E351E002E00000004004050314001
      0000003F034934360540009F351E002E00000006004053323635400349343604
      5000A0351E002F00000003493437054000A1351E002F00000005004053383540
      03493437045000A2351E003000000003493438045000A3351E00310000000349
      3439054000A4351E00310000000500405338374003493439045000A5351E0032
      00000003493530045000A6351E003300000003493531054000A7351E00330000
      00060040533130394003493531045000A8351E003400000003493532054000A9
      351E003400000004004053364003493532045000AA351E003500000003493533
      054000AB351E003500000004004053354003493533045000AC351E0036000000
      03493534054000AD351E003600000004004053374003493534045000AE351E00
      3700000003493535045000AF351E003800000003493536045000B0351E003900
      000003493537050000B1351E00390000000400405034400A000000416C747374
      657474656E03493537045000B2351E003A00000003493538045000B3351E003B
      00000003493539045000B4351E003C00000003493630050000B5351E003C0000
      0005004050313640040000004265726703493630045000B6351E003D00000003
      493631045000B7351E003E00000003493632045000B8351E003F000000034936
      33045000B9351E004000000003493634045000BA351E00410000000349363505
      4000BB351E00410000000500405338324003493635050000BC351E0041000000
      06004050313234400A000000526567656E736275726703493635050000BD351E
      0041000000050040503836400B0000004D616C6C657273646F72660349363504
      5000BE351E004200000003493636054000BF351E004200000006004053313535
      4003493636054000C0351E0042000000060040533330394003493636045000C1
      351E004300000003493637054000C2351E004300000006004053313236400349
      3637050000C3351E00430000000600405031383540140000005A696567657473
      646F72662048732E4E722E203603493637054000C4351E004300000006004053
      3331304003493637045000C5351E004400000003493638054000C6351E004400
      00000500405335324003493638045000C7351E004500000003493639054000C8
      351E00450000000500405337354003493639054000C9351E0045000000060040
      533331384003493639045000CA351E004600000003493730054000CB351E0046
      000000060040533130384003493730045000CC351E0047000000034937310540
      00CD351E0047000000060040533135344003493731045000CE351E0048000000
      03493732054000CF351E0048000000060040533132394003493732045000D035
      1E004900000003493733054000D1351E00490000000600405331353240034937
      33045000D2351E004A00000003493734054000D3351E004A0000000500405335
      334003493734045000D4351E004B00000003493735054000D5351E004B000000
      0500405331374003493735045000D6351E004C00000003493736054000D7351E
      004C000000060040533136364003493736054000D8351E004C00000006004053
      3332324003493736050000D9351E004C000000050040503238400A0000004465
      636862657474656E03493736050000DA351E004C00000006004050313630400D
      00000054726F792D204F616B6C616E6403493736050000DB351E004C00000005
      00405033304007000000446574726F697403493736045000DC351E004D000000
      03493737054000DD351E004D000000060040533136394003493737045000DE35
      1E004E00000003493738054000DF351E004E0000000500405337364003493738
      050000E0351E004E000000060040503131384006000000506F696B616D034937
      38054000E1351E004E000000060040533238314003493738045000E2351E004F
      00000003493739054000E3351E004F0000000600405331303440034937390500
      00E4351E004F00000006004050313133401000000050656E746C696E67204873
      2E4E722E3503493739054000E5351E004F000000060040533235394003493739
      054000E6351E004F000000060040533236304003493739045000E7351E005000
      000003493830054000E8351E0050000000060040533133314003493830054000
      E9351E0050000000060040533331344003493830054000EA351E005000000006
      0040533331334003493830045000EB351E005100000003493831050000EC351E
      005100000006004050313730400E000000576569636873656C6DC3BC686C6503
      493831054000ED351E0051000000060040533236334003493831050000EE351E
      005100000006004050313132400800000050656E746C696E6703493831054000
      EF351E0051000000060040533236344003493831045000F0351E005200000003
      493832050000F1351E005200000006004050313731400C000000576569636873
      6DC3BC686C6503493832054000F2351E00520000000600405332393940034938
      32045000F3351E005300000003493833050000F4351E00530000000500405037
      31400700000049726E73696E6703493833045000F5351E005400000003493834
      050000F6351E005400000005004050373940060000004C616162657203493834
      054000F7351E0054000000060040533330304003493834045000F8351E005500
      000003493835054000F9351E00550000000500405339384003493835050000FA
      351E0055000000050040503337400A000000456963687374C3A4747403493835
      045000FB351E005600000003493836054000FC351E0056000000060040533136
      374003493836045000FD351E005700000003493837045000FE351E0058000000
      03493838054000FF351E00580000000400405339400349383804500000361E00
      590000000349383904500001361E005A0000000349393005000002361E005A00
      000006004050313337400B00000053656C696E67737461647403493930045000
      03361E005B0000000349393104500004361E005C000000034939320450000536
      1E005D0000000349393304500006361E005E0000000349393404500007361E00
      5F0000000349393504500008361E00600000000349393604500009361E006100
      0000034939370450000A361E0062000000034939380450000B361E0063000000
      034939390500000C361E0063000000050040503333400B000000446F6E617577
      C3B6727468034939390450000D361E006400000004493130300450000E361E00
      6500000004493130310540000F361E0065000000060040533134344004493130
      3104500010361E0066000000044931303205400011361E006600000006004053
      32323340044931303204500012361E0067000000044931303305400013361E00
      670000000600405332323240044931303304500014361E006800000004493130
      3405400015361E00680000000600405332323040044931303404500016361E00
      69000000044931303504500017361E006A000000044931303605000018361E00
      6A000000050040503636400A0000004861727468617573656E04493130360540
      0019361E006A000000060040533232314004493130360450001A361E006B0000
      0004493130370450001B361E006C00000004493130380540001C361E006C0000
      000500405333344004493130380450001D361E006D0000000449313039045000
      1E361E006E00000004493131300540001F361E006E0000000600405331363140
      044931313005000020361E006E0000000600405031373340060000005765696C
      6572044931313004500021361E006F000000044931313105000022361E006F00
      0000050040503130401200000041756773627572672053742E20416E746F6E04
      4931313104500023361E0070000000044931313205400024361E007000000006
      00405331333340044931313204500025361E0071000000044931313304500026
      361E0072000000044931313404500027361E0073000000044931313505000028
      361E007300000005004050373340090000004B61726C73727568650449313135
      04500029361E007400000004493131360450002A361E00750000000449313137
      0450002B361E007600000004493131380450002C361E00770000000449313139
      0450002D361E007800000004493132300450002E361E00790000000449313231
      0450002F361E007A000000044931323205400030361E007A0000000600405331
      343840044931323205000031361E007A00000006004050313134400C00000050
      66616666656E686F66656E044931323204500032361E007B0000000449313233
      04500033361E007C000000044931323404500034361E007D0000000449313235
      05000035361E007D00000006004050313034400B0000004EC3B672646C696E67
      656E044931323504500036361E007E000000044931323605000037361E007E00
      000005004050323140060000004272656D656E044931323604500038361E007F
      000000044931323705000039361E007F0000000500405033394005000000456D
      64656E04493132370450003A361E008000000004493132380500003B361E0080
      000000050040503639400B000000486F68656E6B616D6D657204493132380450
      003C361E008100000004493132390450003D361E008200000004493133300540
      003E361E00820000000500405337304004493133300500003F361E0082000000
      05004050333640070000004568696E67656E044931333004500040361E008300
      0000044931333104500041361E0084000000044931333205000042361E008400
      0000050040503638400A00000048696E74657272696564044931333204500043
      361E0085000000044931333304500044361E0086000000044931333404500045
      361E0087000000044931333504500046361E0088000000044931333604500047
      361E0089000000044931333705000048361E0089000000050040503435400D00
      000046726175656E7374657474656E044931333704500049361E008A00000004
      493133380450004A361E008B00000004493133390540004B361E008B00000006
      0040533135384004493133390450004C361E008C00000004493134300540004D
      361E008C000000060040533237394004493134300450004E361E008D00000004
      493134310450004F361E008E000000044931343204500050361E008F00000004
      4931343304500051361E0090000000044931343404500052361E009100000004
      4931343504500053361E0092000000044931343604500054361E009300000004
      4931343705400055361E0093000000040040533840044931343704500056361E
      0094000000044931343804500057361E0095000000044931343904500058361E
      0096000000044931353004500059361E009700000004493135310540005A361E
      00970000000500405334314004493135310450005B361E009800000004493135
      320450005C361E009900000004493135330450005D361E009A00000004493135
      340540005E361E009A000000060040533135304004493135340450005F361E00
      9B000000044931353504500060361E009C000000044931353604500061361E00
      9D000000044931353705000062361E009D000000060040503130364009000000
      4F6265726E646F7266044931353704500063361E009E00000004493135380450
      0064361E009F000000044931353904500065361E00A000000004493136300540
      0066361E00A00000000600405331353740044931363005000067361E00A00000
      00060040503132354013000000526567656E73627572672D4B65696C62657267
      044931363004500068361E00A1000000044931363105400069361E00A1000000
      060040533239314004493136310450006A361E00A20000000449313632054000
      6B361E00A2000000060040533133364004493136320450006C361E00A3000000
      04493136330540006D361E00A300000006004053313536400449313633050000
      6E361E00A3000000060040503131394005000000506F696E6704493136330540
      006F361E00A30000000600405331393240044931363304500070361E00A40000
      00044931363404500071361E00A5000000044931363504500072361E00A60000
      00044931363605000073361E00A600000005004050343340070000004661796B
      757274044931363604500074361E00A7000000044931363704500075361E00A8
      000000044931363804500076361E00A9000000044931363904500077361E00AA
      000000044931373004500078361E00AB000000044931373104500079361E00AC
      00000004493137320450007A361E00AD00000004493137330500007B361E00AD
      00000005004050383340080000004C656E6766656C6404493137330450007C36
      1E00AE00000004493137340500007D361E00AE00000006004050313233400900
      0000526567656E6275726704493137340450007E361E00AF0000000449313735
      0500007F361E00AF000000050040503637400A00000048617567656E72696564
      044931373504500080361E00B0000000044931373604500081361E00B1000000
      044931373704500082361E00B2000000044931373805000083361E00B2000000
      05004050373440070000004B656C6865696D044931373804500084361E00B300
      0000044931373904500085361E00B4000000044931383005400086361E00B400
      000005004053323240044931383004500087361E00B500000004493138310450
      0088361E00B6000000044931383205400089361E00B600000005004053323740
      04493138320450008A361E00B700000004493138330540008B361E00B7000000
      060040533136344004493138330450008C361E00B80000000449313834054000
      8D361E00B80000000500405336394004493138340500008E361E00B800000005
      00405035374010000000477261C39F6C66696E67204E722E2034044931383404
      50008F361E00B9000000044931383504500090361E00BA000000044931383604
      500091361E00BB000000044931383704500092361E00BC000000044931383804
      500093361E00BD000000044931383905000094361E00BD000000050040503539
      400900000047726FC39F62657267044931383904500095361E00BE0000000449
      31393004500096361E00BF000000044931393104500097361E00C00000000449
      31393205000098361E00C000000005004050383740080000004D616E6E686569
      6D044931393204500099361E00C100000004493139330450009A361E00C20000
      0004493139340500009B361E00C20000000500405031384008000000426F6269
      6E67656E04493139340450009C361E00C300000004493139350540009D361E00
      C30000000500405336334004493139350450009E361E00C40000000449313936
      0450009F361E00C50000000449313937045000A0361E00C60000000449313938
      045000A1361E00C70000000449313939045000A2361E00C80000000449323030
      054000A3361E00C8000000050040533430400449323030045000A4361E00C900
      00000449323031045000A5361E00CA0000000449323032054000A6361E00CA00
      000006004053313134400449323032045000A7361E00CB000000044932303305
      4000A8361E00CB000000050040533935400449323033045000A9361E00CC0000
      000449323034050000AA361E00CC000000050040503431400F00000045707061
      6E2F53742E205061756C730449323034045000AB361E00CD0000000449323035
      054000AC361E00CD000000050040533135400449323035045000AD361E00CE00
      00000449323036050000AE361E00CE0000000500405032304005000000426F7A
      656E0449323036045000AF361E00CF0000000449323037054000B0361E00CF00
      000006004053313335400449323037045000B1361E00D0000000044932303805
      4000B2361E00D000000006004053333031400449323038045000B3361E00D100
      00000449323039050000B4361E00D10000000500405034364008000000467265
      69627572670449323039045000B5361E00D20000000449323130054000B6361E
      00D2000000050040533932400449323130045000B7361E00D300000004493231
      31054000B8361E00D3000000050040533131400449323131045000B9361E00D4
      0000000449323132045000BA361E00D50000000449323133045000BB361E00D6
      0000000449323134045000BC361E00D70000000449323135045000BD361E00D8
      0000000449323136054000BE361E00D800000006004053313633400449323136
      050000BF361E00D8000000050040503630401A0000004772C3BC6E7468616C20
      6A65747A742057656E7A656E626163680449323136045000C0361E00D9000000
      0449323137054000C1361E00D900000006004053313839400449323137045000
      C2361E00DA0000000449323138045000C3361E00DB0000000449323139050000
      C4361E00DB00000006004050313231400D000000522E2053742E20456D657261
      6D0449323139045000C5361E00DC0000000449323230045000C6361E00DD0000
      000449323231045000C7361E00DE0000000449323232045000C8361E00DF0000
      000449323233054000C9361E00DF000000050040533838400449323233054000
      CA361E00DF00000006004053323933400449323233054000CB361E00DF000000
      06004053323836400449323233045000CC361E00E00000000449323234054000
      CD361E00E000000006004053313131400449323234054000CE361E00E0000000
      06004053323932400449323234054000CF361E00E00000000600405332383740
      0449323234045000D0361E00E10000000449323235054000D1361E00E1000000
      06004053313138400449323235054000D2361E00E10000000600405331383440
      0449323235045000D3361E00E20000000449323236045000D4361E00E3000000
      0449323237054000D5361E00E300000006004053313432400449323237054000
      D6361E00E300000006004053323438400449323237045000D7361E00E4000000
      0449323238045000D8361E00E50000000449323239045000D9361E00E6000000
      0449323330054000DA361E00E600000006004053323737400449323330045000
      DB361E00E70000000449323331054000DC361E00E70000000600405332373240
      0449323331045000DD361E00E80000000449323332054000DE361E00E8000000
      06004053313439400449323332054000DF361E00E80000000600405332323840
      0449323332054000E0361E00E800000006004053323639400449323332054000
      E1361E00E800000006004053323733400449323332045000E2361E00E9000000
      0449323333045000E3361E00EA0000000449323334045000E4361E00EB000000
      0449323335045000E5361E00EC0000000449323336045000E6361E00ED000000
      0449323337054000E7361E00ED00000006004053313237400449323337054000
      E8361E00ED00000006004053313836400449323337045000E9361E00EE000000
      0449323338050000EA361E00EE0000000600405031323840090000005361616C
      68617570740449323338054000EB361E00EE0000000600405331373140044932
      3338054000EC361E00EE00000006004053313835400449323338045000ED361E
      00EF0000000449323339045000EE361E00F00000000449323430045000EF361E
      00F10000000449323431045000F0361E00F20000000449323432045000F1361E
      00F30000000449323433054000F2361E00F30000000500405334344004493234
      33054000F3361E00F300000006004053323333400449323433054000F4361E00
      F300000006004053323532400449323433054000F5361E00F300000006004053
      323330400449323433054000F6361E00F3000000060040533236384004493234
      33045000F7361E00F40000000449323434054000F8361E00F400000006004053
      313234400449323434050000F9361E00F4000000060040503134304007000000
      53696E7A696E670449323434054000FA361E00F4000000060040533137324004
      49323434045000FB361E00F50000000449323435045000FC361E00F600000004
      49323436050000FD361E00F60000000600405031373840080000005765696C6C
      6F68650449323436045000FE361E00F70000000449323437045000FF361E00F8
      000000044932343804500000371E00F9000000044932343904500001371E00FA
      000000044932353004500002371E00FB000000044932353104500003371E00FC
      000000044932353205000004371E00FC00000006004050313230400A00000050
      72C3BC66656E696E67044932353205400005371E00FC00000006004053323938
      40044932353204500006371E00FD000000044932353304500007371E00FE0000
      00044932353404500008371E00FF000000044932353505400009371E00FF0000
      00060040533139314004493235350450000A371E000001000004493235360500
      000B371E0000010000050040503434400A00000046726175656E626572670449
      3235360450000C371E000101000004493235370500000D371E00010100000500
      4050373740090000004B69746368656E657204493235370450000E371E000201
      000004493235380500000F371E0002010000050040503239400A000000446567
      67656E646F7266044932353804500010371E0003010000044932353905000011
      371E0003010000060040503135344009000000537472617562696E6704493235
      3904500012371E0004010000044932363004500013371E000501000004493236
      3104500014371E0006010000044932363204500015371E000701000004493236
      3304500016371E0008010000044932363404500017371E000901000004493236
      3504500018371E000A010000044932363604500019371E000B01000004493236
      370450001A371E000C01000004493236380450001B371E000D01000004493236
      390450001C371E000E01000004493237300540001D371E000E01000005004053
      31364004493237300450001E371E000F01000004493237310450001F371E0010
      010000044932373204500020371E0011010000044932373304500021371E0012
      010000044932373404500022371E0013010000044932373504500023371E0014
      010000044932373604500024371E0015010000044932373704500025371E0016
      010000044932373804500026371E0017010000044932373904500027371E0018
      010000044932383005000028371E001801000006004050313539400500000054
      6F6B696F044932383004500029371E001901000004493238310500002A371E00
      190100000600405031333940080000005368616E676861690449323831045000
      2B371E001A01000004493238320450002C371E001B0100000449323833045000
      2D371E001C01000004493238340450002E371E001D0100000449323835045000
      2F371E001E010000044932383604500030371E001F0100000449323837045000
      31371E0020010000044932383804500032371E00210100000449323839045000
      33371E0022010000044932393004500034371E00230100000449323931045000
      35371E0024010000044932393205400036371E00240100000500405335394004
      4932393204500037371E0025010000044932393304500038371E002601000004
      4932393404500039371E002701000004493239350450003A371E002801000004
      493239360500003B371E00280100000600405031313740210000005066656966
      666572205265696E686F6C642054656C20303934343339393230393004493239
      360540003C371E0028010000060040533236364004493239360450003D371E00
      2901000004493239370540003E371E0029010000050040533437400449323937
      0540003F371E00290100000600405332323540044932393704500040371E002A
      010000044932393804500041371E002B010000044932393905400042371E002B
      0100000600405332323940044932393905400043371E002B0100000600405332
      353140044932393904500044371E002C010000044933303005400045371E002C
      0100000600405333313940044933303004500046371E002D0100000449333031
      05400047371E002D0100000600405331313340044933303105400048371E002D
      0100000600405332343940044933303105000049371E002D0100000600405031
      3037400A0000004F6265726E64736F726604493330310450004A371E002E0100
      0004493330320450004B371E002F01000004493330330540004C371E002F0100
      00060040533234344004493330330500004D371E002F01000005004050383540
      080000004C6F68737461647404493330330450004E371E003001000004493330
      340540004F371E00300100000600405331303140044933303405400050371E00
      300100000600405332343540044933303404500051371E003101000004493330
      3504500052371E0032010000044933303604500053371E003301000004493330
      3704500054371E0034010000044933303804500055371E003501000004493330
      3904500056371E0036010000044933313005000057371E003601000006004050
      313131400700000050656973696E67044933313004500058371E003701000004
      4933313105400059371E00370100000500405336304004493331310540005A37
      1E0037010000060040533234304004493331310450005B371E00380100000449
      3331320450005C371E003901000004493331330540005D371E00390100000600
      40533234314004493331330450005E371E003A01000004493331340450005F37
      1E003B010000044933313504500060371E003C01000004493331360540006137
      1E003C01000005004053333240044933313604500062371E003D010000044933
      313705000063371E003D010000050040503633400A00000047756E64656C6865
      696D044933313705400064371E003D0100000400405331400449333137050000
      65371E003D010000050040503634400B00000047756E64656C736865696D0449
      33313705400066371E003D010000060040533230324004493331370450006737
      1E003E010000044933313804500068371E003F01000004493331390450006937
      1E004001000004493332300540006A371E004001000006004053333137400449
      3332300450006B371E004101000004493332310450006C371E00420100000449
      3332320450006D371E004301000004493332330450006E371E00440100000449
      3332340450006F371E0045010000044933323504500070371E00460100000449
      33323604500071371E0047010000044933323705400072371E00470100000600
      405333313640044933323705400073371E004701000006004053313730400449
      33323704500074371E0048010000044933323804500075371E00490100000449
      33323904500076371E004A010000044933333004500077371E004B0100000449
      33333104500078371E004C010000044933333204500079371E004D0100000449
      3333330450007A371E004E01000004493333340450007B371E004F0100000449
      3333350450007C371E005001000004493333360450007D371E00510100000449
      3333370450007E371E005201000004493333380450007F371E00530100000449
      33333904500080371E0054010000044933343004500081371E00550100000449
      33343104500082371E0056010000044933343204500083371E00570100000449
      33343304500084371E0058010000044933343404500085371E00590100000449
      33343504500086371E005A010000044933343604500087371E005B0100000449
      33343705000088371E005B01000006004050313332400B0000005363686E6569
      6468617274044933343704500089371E005C01000004493334380450008A371E
      005D01000004493334390450008B371E005E01000004493335300450008C371E
      005F01000004493335310540008D371E005F0100000600405331303740044933
      35310500008E371E005F010000050040503838400D0000004D616E74656C6B69
      726368656E04493335310450008F371E0060010000044933353205400090371E
      006001000005004053393740044933353204500091371E006101000004493335
      3305400092371E006101000005004053373740044933353305000093371E0061
      01000005004050373640090000004B69726368646F7266044933353304500094
      371E0062010000044933353404500095371E0063010000044933353505400096
      371E006301000005004053333040044933353504500097371E00640100000449
      33353605000098371E006401000005004050383140090000004C616E67717561
      6964044933353604500099371E006501000004493335370450009A371E006601
      000004493335380540009B371E00660100000500405333334004493335380500
      009C371E00660100000600405031373740170000005765696C6865696D206F64
      2E20526F7474656E6265726704493335380540009D371E006601000006004053
      3231384004493335380500009E371E006601000006004050313335400D000000
      5363687765696E73706F696E7404493335380450009F371E0067010000044933
      3539045000A0371E00680100000449333630054000A1371E0068010000060040
      53323433400449333630045000A2371E00690100000449333631054000A3371E
      006901000006004053313330400449333631045000A4371E006A010000044933
      3632045000A5371E006B0100000449333633045000A6371E006C010000044933
      3634045000A7371E006D0100000449333635045000A8371E006E010000044933
      3636045000A9371E006F0100000449333637045000AA371E0070010000044933
      3638045000AB371E00710100000449333639054000AC371E0071010000060040
      53323034400449333639050000AD371E00710100000400405032400A0000003F
      205765696C6865696D0449333639054000AE371E007101000006004053323037
      400449333639045000AF371E00720100000449333730045000B0371E00730100
      000449333731045000B1371E00740100000449333732054000B2371E00740100
      0006004053313933400449333732045000B3371E007501000004493337330450
      00B4371E00760100000449333734054000B5371E007601000006004053323332
      400449333734054000B6371E0076010000060040533230364004493337340450
      00B7371E00770100000449333735054000B8371E007701000005004053383140
      0449333735054000B9371E007701000006004053313938400449333735054000
      BA371E007701000006004053323039400449333735045000BB371E0078010000
      0449333736054000BC371E0078010000050040533439400449333736050000BD
      371E007801000006004050313833400B000000576F6C66657273746164740449
      333736054000BE371E007801000006004053323031400449333736054000BF37
      1E007801000006004053323033400449333736045000C0371E00790100000449
      333737054000C1371E0079010000050040533235400449333737050000C2371E
      0079010000050040503938400B0000004DC3B6636B656E6C6F68650449333737
      054000C3371E007901000006004053313934400449333737054000C4371E0079
      01000006004053313937400449333737045000C5371E007A0100000449333738
      054000C6371E007A010000050040533132400449333738054000C7371E007A01
      000006004053313935400449333738050000C8371E007A010000060040503138
      31400A0000005769747465736865696D0449333738054000C9371E007A010000
      06004053323038400449333738045000CA371E007B0100000449333739045000
      CB371E007C0100000449333830045000CC371E007D0100000449333831045000
      CD371E007E0100000449333832045000CE371E007F0100000449333833045000
      CF371E00800100000449333834045000D0371E00810100000449333835054000
      D1371E0081010000050040533939400449333835054000D2371E008101000006
      004053323130400449333835045000D3371E00820100000449333836054000D4
      371E008201000006004053323131400449333836045000D5371E008301000004
      49333837045000D6371E00840100000449333838045000D7371E008501000004
      49333839054000D8371E008501000006004053323139400449333839045000D9
      371E00860100000449333930045000DA371E00870100000449333931045000DB
      371E00880100000449333932054000DC371E0088010000060040533130354004
      49333932054000DD371E008801000006004053323437400449333932045000DE
      371E00890100000449333933054000DF371E0089010000050040533538400449
      333933045000E0371E008A0100000449333934054000E1371E008A0100000500
      40533230400449333934054000E2371E008A0100000600405331383140044933
      3934045000E3371E008B0100000449333935054000E4371E008B010000050040
      533535400449333935050000E5371E008B01000006004050313333400E000000
      536368726F62656E68617573656E0449333935045000E6371E008C0100000449
      333936054000E7371E008C01000006004053333035400449333936045000E837
      1E008D0100000449333937054000E9371E008D01000005004053323140044933
      3937050000EA371E008D010000050040503135400B0000004261747A656E686F
      66656E0449333937045000EB371E008E0100000449333938050000EC371E008E
      01000005004050343940090000004761626C696E67656E0449333938045000ED
      371E008F0100000449333939054000EE371E008F010000060040533133374004
      49333939045000EF371E00900100000449343030054000F0371E009001000005
      0040533833400449343030050000F1371E009001000005004050373840080000
      004B7275696368656E0449343030045000F2371E009101000004493430310450
      00F3371E00920100000449343032045000F4371E009301000004493430330450
      00F5371E00940100000449343034050000F6371E009401000005004050363540
      0600000048616D6D656C0449343034045000F7371E0095010000044934303504
      5000F8371E00960100000449343036045000F9371E0097010000044934303704
      5000FA371E00980100000449343038050000FB371E0098010000050040503131
      400900000041797374657474656E0449343038045000FC371E00990100000449
      343039045000FD371E009A0100000449343130050000FE371E009A0100000600
      4050313436401A00000053742E204B6174686172696E61204B72732E204B6C61
      747461750449343130050000FF371E009A01000006004050313435400D000000
      53742E204B6174686172696E61044934313004500000381E009B010000044934
      313104500001381E009C010000044934313204500002381E009D010000044934
      313304500003381E009E010000044934313404500004381E009F010000044934
      313504500005381E00A0010000044934313605400006381E00A0010000060040
      5332393740044934313605400007381E00A00100000600405332333140044934
      313605400008381E00A00100000600405332353340044934313604500009381E
      00A101000004493431370540000A381E00A10100000600405332323640044934
      31370450000B381E00A201000004493431380540000C381E00A2010000060040
      533237354004493431380450000D381E00A301000004493431390540000E381E
      00A3010000060040533232374004493431390540000F381E00A3010000060040
      5332373640044934313904500010381E00A4010000044934323005400011381E
      00A40100000600405331303340044934323005400012381E00A4010000060040
      5333303640044934323004500013381E00A5010000044934323105400014381E
      00A50100000600405331323540044934323104500015381E00A6010000044934
      323204500016381E00A7010000044934323305400017381E00A7010000050040
      53323840044934323304500018381E00A8010000044934323405400019381E00
      A8010000060040533131394004493432340450001A381E00A901000004493432
      350540001B381E00A9010000060040533130324004493432350450001C381E00
      AA01000004493432360450001D381E00AB01000004493432370450001E381E00
      AC01000004493432380540001F381E00AC010000040040533240044934323804
      500020381E00AD010000044934323905400021381E00AD010000060040533131
      3640044934323904500022381E00AE010000044934333005400023381E00AE01
      000005004053313340044934333004500024381E00AF01000004493433310540
      0025381E00AF01000005004053373140044934333104500026381E00B0010000
      044934333204500027381E00B1010000044934333304500028381E00B2010000
      044934333404500029381E00B301000004493433350450002A381E00B4010000
      04493433360450002B381E00B501000004493433370540002C381E00B5010000
      060040533131324004493433370450002D381E00B60100000449343338054000
      2E381E00B6010000060040533332344004493433380450002F381E00B7010000
      044934333904500030381E00B8010000044934343004500031381E00B9010000
      044934343104500032381E00BA010000044934343204500033381E00BB010000
      044934343304500034381E00BC010000044934343404500035381E00BD010000
      044934343504500036381E00BE010000044934343604500037381E00BF010000
      044934343704500038381E00C0010000044934343805000039381E00C0010000
      05004050313440090000004261642054C3B66C7A04493434380450003A381E00
      C101000004493434390450003B381E00C201000004493435300500003C381E00
      C2010000050040503830400D0000004C616E67656E7265696368656E04493435
      300450003D381E00C301000004493435310450003E381E00C401000004493435
      320450003F381E00C5010000044934353304500040381E00C601000004493435
      3404500041381E00C7010000044934353504500042381E00C801000004493435
      3604500043381E00C9010000044934353704500044381E00CA01000004493435
      3804500045381E00CB010000044934353904500046381E00CC01000004493436
      3005400047381E00CC0100000600405331323040044934363004500048381E00
      CD010000044934363104500049381E00CE01000004493436320450004A381E00
      CF01000004493436330450004B381E00D001000004493436340540004C381E00
      D00100000500405333314004493436340450004D381E00D10100000449343635
      0540004E381E00D10100000500405333394004493436350450004F381E00D201
      0000044934363605400050381E00D20100000500405333354004493436360450
      0051381E00D3010000044934363705400052381E00D301000005004053373440
      044934363705000053381E00D30100000600405031303540080000004F626572
      646F7266044934363704500054381E00D4010000044934363805400055381E00
      D401000005004053383040044934363804500056381E00D50100000449343639
      05000057381E00D501000006004050313636400A000000566965686861757365
      6E044934363904500058381E00D6010000044934373005400059381E00D60100
      000500405337394004493437300500005A381E00D60100000600405031323940
      070000005361786265726704493437300450005B381E00D70100000449343731
      0540005C381E00D70100000500405336364004493437310500005D381E00D701
      0000060040503136324006000000556E646F726604493437310450005E381E00
      D801000004493437320540005F381E00D8010000060040533134314004493437
      3204500060381E00D9010000044934373305400061381E00D901000006004053
      31353940044934373305000062381E00D901000006004050313336400B000000
      536368C3B66E686F66656E044934373304500063381E00DA0100000449343734
      05400064381E00DA01000005004053333640044934373404500065381E00DB01
      0000044934373505400066381E00DB0100000500405338394004493437350450
      0067381E00DC010000044934373605400068381E00DC01000005004053353140
      044934373604500069381E00DD01000004493437370450006A381E00DE010000
      04493437380450006B381E00DF01000004493437390450006C381E00E0010000
      04493438300500006D381E00E001000005004050383440090000004C656E696E
      6772616404493438300450006E381E00E101000004493438310450006F381E00
      E2010000044934383204500070381E00E3010000044934383304500071381E00
      E4010000044934383404500072381E00E5010000044934383504500073381E00
      E6010000044934383604500074381E00E7010000044934383704500075381E00
      E8010000044934383804500076381E00E9010000044934383904500077381E00
      EA010000044934393004500078381E00EB010000044934393104500079381E00
      EC01000004493439320450007A381E00ED01000004493439330450007B381E00
      EE01000004493439340450007C381E00EF01000004493439350450007D381E00
      F001000004493439360500007E381E00F0010000050040503132400A00000042
      61636862C3BC67656C04493439360450007F381E00F101000004493439370450
      0080381E00F2010000044934393804500081381E00F301000004493439390450
      0082381E00F4010000044935303004500083381E00F501000004493530310450
      0084381E00F6010000044935303204500085381E00F701000004493530330450
      0086381E00F8010000044935303405000087381E00F801000006004050313439
      4009000000537461726E62657267044935303404500088381E00F90100000449
      35303505400089381E00F90100000500405335374004493530350540008A381E
      00F9010000060040533231374004493530350450008B381E00FA010000044935
      30360540008C381E00FA010000060040533231364004493530360450008D381E
      00FB01000004493530370450008E381E00FC01000004493530380540008F381E
      00FC01000005004053313840044935303805400090381E00FC01000006004053
      31373640044935303804500091381E00FD010000044935303905400092381E00
      FD01000005004053323340044935303904500093381E00FE0100000449353130
      05400094381E00FE0100000600405331323140044935313005000095381E00FE
      010000060040503135354017000000537472656974646F72662F506661666665
      6E686F66656E044935313004500096381E00FF01000004493531310540009738
      1E00FF01000005004053363540044935313105000098381E00FF010000060040
      50313530400A000000537465696E6772696666044935313104500099381E0000
      02000004493531320540009A381E000002000005004053343540044935313205
      00009B381E00000200000400405035400700000041726573696E670449353132
      0450009C381E000102000004493531330450009D381E00020200000449353134
      0450009E381E000302000004493531350500009F381E00030200000600405031
      3633400B000000556E74657262657267656E0449353135054000A0381E000302
      000006004053313739400449353135045000A1381E0004020000044935313605
      0000A2381E000402000006004050313531401C000000537465696E6772696666
      20622E20536368726F62656E68617573656E0449353136045000A3381E000502
      00000449353137045000A4381E00060200000449353138045000A5381E000702
      00000449353139045000A6381E00080200000449353230045000A7381E000902
      00000449353231054000A8381E00090200000600405331313540044935323105
      0000A9381E000902000005004050393240140000004D69747465727363686579
      65726E204E722E31300449353231050000AA381E000902000006004050313732
      400E0000005765696C656E626163682F4F62620449353231045000AB381E000A
      0200000449353232054000AC381E000A02000006004053313036400449353232
      050000AD381E000A020000050040503139400E000000426F64656E7265757468
      2F4F70660449353232045000AE381E000B0200000449353233045000AF381E00
      0C0200000449353234045000B0381E000D0200000449353235045000B1381E00
      0E0200000449353236045000B2381E000F0200000449353237050000B3381E00
      0F02000005004050333540090000004562657273626572670449353237045000
      B4381E00100200000449353238045000B5381E00110200000449353239045000
      B6381E00120200000449353330050000B7381E0012020000050040503236400B
      00000044616E67656C73646F72660449353330045000B8381E00130200000449
      353331045000B9381E00140200000449353332050000BA381E00140200000500
      40503233400E000000427572676C656E67656E66656C640449353332045000BB
      381E00150200000449353333045000BC381E00160200000449353334045000BD
      381E00170200000449353335045000BE381E00180200000449353336050000BF
      381E0018020000050040503530400D00000047656C73656E6B69726368656E04
      49353336045000C0381E00190200000449353337045000C1381E001A02000004
      49353338050000C2381E001A0200000600405031313040080000005061727362
      6572670449353338045000C3381E001B0200000449353339050000C4381E001B
      02000006004050313331400A0000005363686965726C696E6704493533390450
      00C5381E001C0200000449353430045000C6381E001D02000004493534310450
      00C7381E001E0200000449353433054000C8381E001E02000006004053313232
      400449353433050000C9381E001E0200000500405033344006000000446F7266
      656E0449353433050000CA381E001E0200000600405031353340210000005374
      65726C696E67204865696768747320446574726F6974204D6963686967616E04
      49353433045000CB381E001F0200000449353434045000CC381E002002000004
      49353435054000CD381E002002000006004053313030400449353435050000CE
      381E002002000005004050383240060000004C61706565720449353435045000
      CF381E00210200000449353436054000D0381E00210200000600405331393040
      0449353436045000D1381E00220200000449353437045000D2381E0023020000
      0449353438045000D3381E00240200000449353439045000D4381E0025020000
      0449353530045000D5381E00260200000449353531045000D6381E0027020000
      0449353532045000D7381E00280200000449353533045000D8381E0029020000
      0449353534054000D9381E002902000006004053313137400449353534045000
      DA381E002A0200000449353535054000DB381E002A0200000500405336344004
      49353535045000DC381E002B0200000449353536045000DD381E002C02000004
      49353537054000DE381E002C02000006004053313433400449353537045000DF
      381E002D0200000449353538045000E0381E002E0200000449353539054000E1
      381E002E02000006004053313437400449353539045000E2381E002F02000004
      49353630054000E3381E002F020000050040533836400449353630045000E438
      1E00300200000449353631045000E5381E00310200000449353632054000E638
      1E0031020000050040533530400449353632045000E7381E0032020000044935
      3633045000E8381E00330200000449353634054000E9381E0033020000050040
      533239400449353634045000EA381E00340200000449353635054000EB381E00
      34020000050040533139400449353635045000EC381E00350200000449353636
      054000ED381E0035020000050040533933400449353636045000EE381E003602
      00000449353637045000EF381E00370200000449353638045000F0381E003802
      00000449353639054000F1381E00380200000600405331333940044935363904
      5000F2381E00390200000449353730045000F3381E003A020000044935373105
      0000F4381E003A02000006004050313338400800000053656C746D616E730449
      353731045000F5381E003B0200000449353732054000F6381E003B0200000500
      40533534400449353732045000F7381E003C0200000449353733045000F8381E
      003D0200000449353734054000F9381E003D0200000600405331343040044935
      3734050000FA381E003D02000006004050313431400A000000536D6974687669
      6C6C650449353734054000FB381E003D02000006004053313838400449353734
      045000FC381E003E0200000449353735045000FD381E003F0200000449353736
      045000FE381E00400200000449353737045000FF381E00410200000449353738
      05000000391E00410200000600405031303240090000004E61736876696C6C65
      044935373804500001391E0042020000044935373905400002391E0042020000
      05004053323640044935373905000003391E0042020000060040503130314013
      0000004E61736876696C6C652054656E6E657373656504493537390500000439
      1E0042020000060040503134324012000000536E656C6C76696C6C652047656F
      72676961044935373905000005391E0042020000050040503234400F00000043
      756D6D696E672047656F72676961044935373904500006391E00430200000449
      35383005000007391E00430200000400405037400700000041746C616E746104
      4935383004500008391E0044020000044935383105000009391E004402000006
      004050313639400B00000057656174686572666F726404493538310450000A39
      1E004502000004493538320450000B391E004602000004493538330450000C39
      1E004702000004493538340450000D391E004802000004493538350450000E39
      1E004902000004493538360450000F391E004A02000004493538370450001039
      1E004B020000044935383804500011391E004C02000004493538390450001239
      1E004D020000044935393004500013391E004E02000004493539310450001439
      1E004F020000044935393204500015391E005002000004493539330450001639
      1E0051020000044935393404500017391E005202000004493539350450001839
      1E0053020000044935393604500019391E005402000004493539370450001A39
      1E005502000004493539380450001B391E005602000004493539390450001C39
      1E005702000004493630300450001D391E005802000004493630310450001E39
      1E005902000004493630320500001F391E0059020000050040503631400A0000
      004772C3A4666C66696E67044936303205400020391E00590200000600405333
      313540044936303205400021391E005902000006004053323436400449363032
      05000022391E005902000005004050393540130000004DC3BC6E6368656E2053
      742E20527570657274044936303205000023391E00590200000400405039400B
      0000004175677362757267203F3F044936303205400024391E00590200000600
      405331383240044936303205400025391E005902000006004053323133400449
      36303205400026391E0059020000060040533137384004493630320500002739
      1E005902000005004050393640080000004DC3BC6E6368656E04493630320500
      0028391E005902000006004050313135401200000050666172726569205072C3
      BC66656E696E67044936303205400029391E0059020000060040533236324004
      493630320540002A391E0059020000060040533235384004493630320540002B
      391E0059020000060040533236314004493630320500002C391E005902000005
      0040503939400A0000004DC3B6726E736865696D04493630320500002D391E00
      5902000006004050313030400C0000004DC3B6736368656E66656C6404493630
      320500002E391E005902000006004050313634400C0000005661746572737465
      7474656E04493630320500002F391E0059020000050040503232400F00000042
      756368656E2F4F64656E77616C64044936303205000030391E00590200000600
      4050313635400A0000005665656E68617573656E044936303205400031391E00
      590200000600405333323140044936303205000032391E005902000006004050
      313532400C000000537465696E68C3B672696E67044936303205000033391E00
      5902000006004050313538400B0000005468616C6D617373696E670449363032
      05000034391E0059020000050040503538400A000000477261C39F6C66756E67
      044936303205000035391E005902000005004050333140090000004465756572
      6C696E67044936303205000036391E005902000006004050313033400A000000
      4E697474656E646F7266044936303205000037391E0059020000050040503133
      400A00000042616420416262616368044936303205000038391E005902000006
      004050313434401500000053742E204A616B2E204465667265672E5469726F6C
      044936303205000039391E005902000005004050393740080000004DC3BC6E63
      68656E04493630320500003A391E005902000006004050313739400A00000057
      656C74656E6275726704493630320500003B391E005902000006004050313836
      400C0000005A69656765747364736F726604493630320500003C391E00590200
      00060040503133304028000000536368656964672E55726B2E20416D74734720
      526567656E73622E20417A2E20322046203134303104493630320540003D391E
      0059020000060040533238344004493630320540003E391E0059020000060040
      533236374004493630320540003F391E00590200000600405332373140044936
      303205400040391E00590200000600405331383740044936303205400041391E
      00590200000600405332373040044936303205000042391E0059020000060040
      50313039400A0000004F73746572686F66656E044936303205000043391E0059
      02000004004050334006000000416262616368044936303205400044391E0059
      0200000600405332343240044936303205000045391E00590200000500405037
      32400A0000004B617066656C62657267044936303205000046391E0059020000
      05004050383940080000004D6172786865696D044936303205400047391E0059
      0200000600405331393940044936303205400048391E00590200000600405332
      303040044936303205400049391E005902000006004053323132400449363032
      0500004A391E005902000006004050313136401D000000506665696666657220
      5265696E686F6C6420303934343339393230393004493630320500004B391E00
      59020000050040503432400B00000046616C6B656E737465696E044936303205
      00004C391E005902000005004050393140080000004D61747474696E67044936
      30320500004D391E0059020000050040503338400900000045696C736272756E
      6E04493630320500004E391E005902000006004050313438400D00000053742E
      2050657465726275726704493630320500004F391E0059020000060040503133
      34400D000000536368726F62656E686175736E044936303205000050391E0059
      020000050040503438400900000046C3B6726E62616368044936303205000051
      391E005902000006004050313637400400000057616C64044936303205000052
      391E00590200000600405031363140060000005475636B657204493630320500
      0053391E0059020000050040503730400F000000486F6C69646179204F6E204C
      616B65044936303205000054391E005902000006004050313433400A00000053
      6E656C6C76696C6C65044936303204000055391E005902000004004050364007
      00000041746C616E746104493630320C000008351E0001000000050040503934
      40070000004DFC6E6368656E0249310C00000C351E0002000000050040503536
      4010000000477261DF6C66696E67204E722E2031350249320C00000E351E0002
      0000000500405035344008000000477261DF66696E670249320C00000F351E00
      020000000500405035354009000000477261DF6C66696E670249320C00001435
      1E000300000005004050393040070000004D617474696E670249330C00001935
      1E0004000000060040503135374005000000546575676E0249340C00001E351E
      0005000000050040503533401000000047726173736C66696E67204E722E2034
      0249350C000020351E000500000006004050313834400B0000005A6965676574
      73646F72660249350C000026351E0007000000050040503531400A0000004765
      727374686F66656E0249370C00002D351E000900000005004050343040070000
      00456E7366656C640249390C000031351E000A00000006004050313536400B00
      00005461676D6572736865696D034931300C000036351E000B00000005004050
      3237400C00000044617474656E68617573656E034931310C000039351E000C00
      0000040040503840080000004175677362757267034931320C00003A351E000C
      00000005004050373540070000004B656D7074656E034931320C00003D351E00
      0D00000006004050313236400700000052F6676C696E67034931330C00003E35
      1E000D00000005004050393340070000004D6F6E6865696D034931330C000042
      351E000E00000006004050313830400900000057657274696E67656E03493134
      0C00004B351E00110000000600405031303840090000004F686D656E6865696D
      034931370C000050351E0012000000050040503332400900000044696C6C696E
      67656E034931380C00005B351E00180000000500405035324011000000476572
      7374686F66656E20284D4B644629034932340C00005E351E0019000000060040
      50313832400C0000005769747469736C696E67656E034932350C000062351E00
      1A0000000500405031374008000000426572676865696D034932360C00006535
      1E001B000000050040503437400A000000467269636B696E67656E034932370C
      00006B351E001D0000000600405031373640140000005765696C6865696D2062
      6569204D6F6E6865696D034932390C00006F351E001E00000006004050313734
      40080000005765696C6865696D034933300C000078351E002000000006004050
      313735400B0000005765696C6865696D202A29034933320C00007A351E002000
      0000050040503235400700000044616974696E67034933320C000088351E0027
      000000050040503632400C00000047756E64656C66696E67656E034933390C00
      0091351E002A00000006004050313232400800000052616D7362657267034934
      320C000095351E002B0000000600405031363840080000005761726368696E67
      034934330C00009E351E002E000000040040503140010000003F034934360C00
      00B1351E00390000000400405034400A000000416C747374657474656E034935
      370C0000B5351E003C000000050040503136400400000042657267034936300C
      0000BC351E004100000006004050313234400A000000526567656E7362757267
      034936350C0000BD351E0041000000050040503836400B0000004D616C6C6572
      73646F7266034936350C0000C3351E0043000000060040503138354014000000
      5A696567657473646F72662048732E4E722E2036034936370C0000D9351E004C
      000000050040503238400A0000004465636862657474656E034937360C0000DA
      351E004C00000006004050313630400D00000054726F792D204F616B6C616E64
      034937360C0000DB351E004C0000000500405033304007000000446574726F69
      74034937360C0000E0351E004E000000060040503131384006000000506F696B
      616D034937380C0000E4351E004F00000006004050313133401000000050656E
      746C696E672048732E4E722E35034937390C0000EC351E005100000006004050
      313730400D000000576569636873656C6DFC686C65034938310C0000EE351E00
      5100000006004050313132400800000050656E746C696E67034938310C0000F1
      351E005200000006004050313731400B0000005765696368736DFC686C650349
      38320C0000F4351E0053000000050040503731400700000049726E73696E6703
      4938330C0000F6351E005400000005004050373940060000004C616162657203
      4938340C0000FA351E00550000000500405033374009000000456963687374E4
      7474034938350C000002361E005A00000006004050313337400B00000053656C
      696E677374616474034939300C00000C361E0063000000050040503333400A00
      0000446F6E617577F6727468034939390C000018361E006A0000000500405036
      36400A0000004861727468617573656E04493130360C000020361E006E000000
      0600405031373340060000005765696C657204493131300C000022361E006F00
      0000050040503130401200000041756773627572672053742E20416E746F6E04
      493131310C000028361E007300000005004050373340090000004B61726C7372
      75686504493131350C000031361E007A00000006004050313134400C00000050
      66616666656E686F66656E04493132320C000035361E007D0000000600405031
      3034400A0000004EF672646C696E67656E04493132350C000037361E007E0000
      0005004050323140060000004272656D656E04493132360C000039361E007F00
      00000500405033394005000000456D64656E04493132370C00003B361E008000
      0000050040503639400B000000486F68656E6B616D6D657204493132380C0000
      3F361E008200000005004050333640070000004568696E67656E04493133300C
      000042361E0084000000050040503638400A00000048696E7465727269656404
      493133320C000048361E0089000000050040503435400D00000046726175656E
      7374657474656E04493133370C000062361E009D000000060040503130364009
      0000004F6265726E646F726604493135370C000067361E00A000000006004050
      3132354013000000526567656E73627572672D4B65696C626572670449313630
      0C00006E361E00A3000000060040503131394005000000506F696E6704493136
      330C000073361E00A600000005004050343340070000004661796B7572740449
      3136360C00007B361E00AD00000005004050383340080000004C656E6766656C
      6404493137330C00007D361E00AE000000060040503132334009000000526567
      656E6275726704493137340C00007F361E00AF000000050040503637400A0000
      0048617567656E7269656404493137350C000083361E00B20000000500405037
      3440070000004B656C6865696D04493137380C00008E361E00B8000000050040
      503537400F000000477261DF6C66696E67204E722E203404493138340C000094
      361E00BD000000050040503539400800000047726FDF6265726704493138390C
      000098361E00C000000005004050383740080000004D616E6E6865696D044931
      39320C00009B361E00C20000000500405031384008000000426F62696E67656E
      04493139340C0000AA361E00CC000000050040503431400F000000457070616E
      2F53742E205061756C7304493230340C0000AE361E00CE000000050040503230
      4005000000426F7A656E04493230360C0000B4361E00D1000000050040503436
      4008000000467265696275726704493230390C0000BF361E00D8000000050040
      50363040190000004772FC6E7468616C206A65747A742057656E7A656E626163
      6804493231360C0000C4361E00DB00000006004050313231400D000000522E20
      53742E20456D6572616D04493231390C0000EA361E00EE000000060040503132
      3840090000005361616C686175707404493233380C0000F9361E00F400000006
      004050313430400700000053696E7A696E6704493234340C0000FD361E00F600
      00000600405031373840080000005765696C6C6F686504493234360C00000437
      1E00FC0000000600405031323040090000005072FC66656E696E670449323532
      0C00000B371E0000010000050040503434400A00000046726175656E62657267
      04493235360C00000D371E000101000005004050373740090000004B69746368
      656E657204493235370C00000F371E0002010000050040503239400A00000044
      656767656E646F726604493235380C000011371E000301000006004050313534
      4009000000537472617562696E6704493235390C000028371E00180100000600
      40503135394005000000546F6B696F04493238300C00002A371E001901000006
      00405031333940080000005368616E6768616904493238310C00003B371E0028
      0100000600405031313740210000005066656966666572205265696E686F6C64
      2054656C20303934343339393230393004493239360C000049371E002D010000
      06004050313037400A0000004F6265726E64736F726604493330310C00004D37
      1E002F01000005004050383540080000004C6F68737461647404493330330C00
      0057371E003601000006004050313131400700000050656973696E6704493331
      300C000063371E003D010000050040503633400A00000047756E64656C686569
      6D04493331370C000065371E003D010000050040503634400B00000047756E64
      656C736865696D04493331370C000088371E005B01000006004050313332400B
      0000005363686E6569646861727404493334370C00008E371E005F0100000500
      40503838400D0000004D616E74656C6B69726368656E04493335310C00009337
      1E006101000005004050373640090000004B69726368646F726604493335330C
      000098371E006401000005004050383140090000004C616E6771756169640449
      3335360C00009C371E00660100000600405031373740170000005765696C6865
      696D206F642E20526F7474656E6265726704493335380C00009E371E00660100
      0006004050313335400D0000005363687765696E73706F696E7404493335380C
      0000AD371E00710100000400405032400A0000003F205765696C6865696D0449
      3336390C0000BD371E007801000006004050313833400B000000576F6C666572
      737461647404493337360C0000C2371E0079010000050040503938400A000000
      4DF6636B656E6C6F686504493337370C0000C8371E007A010000060040503138
      31400A0000005769747465736865696D04493337380C0000E5371E008B010000
      06004050313333400E000000536368726F62656E68617573656E04493339350C
      0000EA371E008D010000050040503135400B0000004261747A656E686F66656E
      04493339370C0000EC371E008E01000005004050343940090000004761626C69
      6E67656E04493339380C0000F1371E009001000005004050373840080000004B
      7275696368656E04493430300C0000F6371E0094010000050040503635400600
      000048616D6D656C04493430340C0000FB371E00980100000500405031314009
      00000041797374657474656E04493430380C0000FE371E009A01000006004050
      313436401A00000053742E204B6174686172696E61204B72732E204B6C617474
      617504493431300C0000FF371E009A01000006004050313435400D0000005374
      2E204B6174686172696E6104493431300C000039381E00C00100000500405031
      3440080000004261642054F66C7A04493434380C00003C381E00C20100000500
      40503830400D0000004C616E67656E7265696368656E04493435300C00005338
      1E00D30100000600405031303540080000004F626572646F726604493436370C
      000057381E00D501000006004050313636400A0000005669656868617573656E
      04493436390C00005A381E00D601000006004050313239400700000053617862
      65726704493437300C00005D381E00D701000006004050313632400600000055
      6E646F726604493437310C000062381E00D901000006004050313336400A0000
      00536368F66E686F66656E04493437330C00006D381E00E00100000500405038
      3440090000004C656E696E6772616404493438300C00007E381E00F001000005
      004050313240090000004261636862FC67656C04493439360C000087381E00F8
      010000060040503134394009000000537461726E6265726704493530340C0000
      95381E00FE010000060040503135354017000000537472656974646F72662F50
      66616666656E686F66656E04493531300C000098381E00FF0100000600405031
      3530400A000000537465696E677269666604493531310C00009B381E00000200
      000400405035400700000041726573696E6704493531320C00009F381E000302
      000006004050313633400B000000556E74657262657267656E04493531350C00
      00A2381E000402000006004050313531401C000000537465696E677269666620
      622E20536368726F62656E68617573656E04493531360C0000A9381E00090200
      0005004050393240140000004D6974746572736368657965726E204E722E3130
      04493532310C0000AA381E000902000006004050313732400E0000005765696C
      656E626163682F4F626204493532310C0000AD381E000A020000050040503139
      400E000000426F64656E72657574682F4F706604493532320C0000B3381E000F
      020000050040503335400900000045626572736265726704493532370C0000B7
      381E0012020000050040503236400B00000044616E67656C73646F7266044935
      33300C0000BA381E0014020000050040503233400E000000427572676C656E67
      656E66656C6404493533320C0000BF381E0018020000050040503530400D0000
      0047656C73656E6B69726368656E04493533360C0000C2381E001A0200000600
      40503131304008000000506172736265726704493533380C0000C4381E001B02
      000006004050313331400A0000005363686965726C696E6704493533390C0000
      C9381E001E0200000500405033344006000000446F7266656E04493534330C00
      00CA381E001E020000060040503135334021000000537465726C696E67204865
      696768747320446574726F6974204D6963686967616E04493534330C0000CE38
      1E002002000005004050383240060000004C617065657204493534350C0000F4
      381E003A02000006004050313338400800000053656C746D616E730449353731
      0C0000FA381E003D02000006004050313431400A000000536D69746876696C6C
      6504493537340C000000391E00410200000600405031303240090000004E6173
      6876696C6C6504493537380C000003391E004202000006004050313031401300
      00004E61736876696C6C652054656E6E657373656504493537390C000004391E
      0042020000060040503134324012000000536E656C6C76696C6C652047656F72
      67696104493537390C000005391E0042020000050040503234400F0000004375
      6D6D696E672047656F7267696104493537390C000007391E0043020000040040
      5037400700000041746C616E746104493538300C000009391E00440200000600
      4050313639400B00000057656174686572666F726404493538310C00001F391E
      005902000005004050363140090000004772E4666C66696E6704493630320C00
      0022391E005902000005004050393540120000004DFC6E6368656E2053742E20
      52757065727404493630320C000023391E00590200000400405039400B000000
      4175677362757267203F3F04493630320C000027391E00590200000500405039
      3640070000004DFC6E6368656E04493630320C000028391E0059020000060040
      50313135401100000050666172726569205072FC66656E696E6704493630320C
      00002C391E005902000005004050393940090000004DF6726E736865696D0449
      3630320C00002D391E005902000006004050313030400B0000004DF673636865
      6E66656C6404493630320C00002E391E005902000006004050313634400C0000
      0056617465727374657474656E04493630320C00002F391E0059020000050040
      503232400F00000042756368656E2F4F64656E77616C6404493630320C000030
      391E005902000006004050313635400A0000005665656E68617573656E044936
      30320C000032391E005902000006004050313532400B000000537465696E68F6
      72696E6704493630320C000033391E005902000006004050313538400B000000
      5468616C6D617373696E6704493630320C000034391E00590200000500405035
      384009000000477261DF6C66756E6704493630320C000035391E005902000005
      0040503331400900000044657565726C696E6704493630320C000036391E0059
      02000006004050313033400A0000004E697474656E646F726604493630320C00
      0037391E0059020000050040503133400A000000426164204162626163680449
      3630320C000038391E005902000006004050313434401500000053742E204A61
      6B2E204465667265672E5469726F6C04493630320C000039391E005902000005
      004050393740070000004DFC6E6368656E04493630320C00003A391E00590200
      0006004050313739400A00000057656C74656E6275726704493630320C00003B
      391E005902000006004050313836400C0000005A69656765747364736F726604
      493630320C00003C391E00590200000600405031333040280000005363686569
      64672E55726B2E20416D74734720526567656E73622E20417A2E203220462031
      34303104493630320C000042391E005902000006004050313039400A0000004F
      73746572686F66656E04493630320C000043391E005902000004004050334006
      00000041626261636804493630320C000045391E005902000005004050373240
      0A0000004B617066656C6265726704493630320C000046391E00590200000500
      4050383940080000004D6172786865696D04493630320C00004A391E00590200
      0006004050313136401D0000005066656966666572205265696E686F6C642030
      3934343339393230393004493630320C00004B391E0059020000050040503432
      400B00000046616C6B656E737465696E04493630320C00004C391E0059020000
      05004050393140080000004D61747474696E6704493630320C00004D391E0059
      020000050040503338400900000045696C736272756E6E04493630320C00004E
      391E005902000006004050313438400D00000053742E20506574657262757267
      04493630320C00004F391E005902000006004050313334400D00000053636872
      6F62656E686175736E04493630320C000050391E005902000005004050343840
      0800000046F6726E6261636804493630320C000051391E005902000006004050
      313637400400000057616C6404493630320C000052391E005902000006004050
      31363140060000005475636B657204493630320C000053391E00590200000500
      40503730400F000000486F6C69646179204F6E204C616B6504493630320C0000
      54391E005902000006004050313433400A000000536E656C6C76696C6C650449
      3630320C000064371E003D010000040040533140080000002866696B74697629
      04493331370C00001F381E00AC01000004004053324003000000312054044934
      32380C000080351E00230000000400405333400400000031342054034933350C
      00008A351E00280000000400405334400D0000003135204A2031204D20313920
      54034934300C0000AB351E003500000004004053354004000000313520540349
      35330C0000A9351E00340000000400405336400400000031362054034935320C
      0000AD351E00360000000400405337400B00000032204A2033204D2033205403
      4935340C000055361E00930000000400405338400D0000003230204A2033204D
      203231205404493134370C0000FF351E00580000000400405339400D00000032
      30204A2038204D2032332054034938380C000085351E00260000000500405331
      30400C0000003232204A2037204D20312054034933380C0000B8361E00D30000
      00050040533131400D0000003236204A2039204D203137205404493231310C00
      00C6371E007A010000050040533132400D0000003237204A2037204D20313520
      5404493337380C000023381E00AE010000050040533133400400000032372054
      04493433300C00007D351E0021000000050040533134400D0000003331204A20
      38204D2031342054034933330C0000AC361E00CD000000050040533135400E00
      00003336204A203131204D203132205404493230350C00001D371E000E010000
      050040533136400D0000003336204A203131204D2033205404493237300C0000
      D5351E004B000000050040533137400D0000003337204A2038204D2031392054
      034937350C00008F381E00FC010000050040533138400E0000003339204A2031
      31204D203135205404493530380C0000EB381E0034020000050040533139400D
      0000003339204A2038204D203135205404493536350C0000E1371E008A010000
      050040533230400D0000003431204A2035204D203130205404493339340C0000
      E9371E008D010000050040533231400C0000003433204A2034204D2033205404
      493339370C000086361E00B4000000050040533232400D0000003435204A2032
      204D203134205404493138300C000092381E00FD010000050040533233400800
      00003436204A2031205404493530390C000068351E001C000000050040533234
      400D0000003436204A2035204D2031382054034932380C0000C1371E00790100
      00050040533235400C0000003436204A2039204D2034205404493337370C0000
      02391E004202000005004053323640090000003438204A203238205404493537
      390C000089361E00B6000000050040533237400E0000003439204A203130204D
      203231205404493138320C000017381E00A70100000500405332384008000000
      35204D203136205404493432330C0000E9381E0033020000050040533239400D
      0000003531204A2039204D203138205404493536340C000096371E0063010000
      050040533330400D0000003532204A2034204D203134205404493335350C0000
      4C381E00D0010000050040533331400C0000003532204A2039204D2031205404
      493436340C000061371E003C010000050040533332400D0000003532204A2039
      204D203230205404493331360C00009B371E0066010000050040533333400C00
      00003533204A2031204D2035205404493335380C00001C361E006C0000000500
      40533334400D0000003533204A2034204D203130205404493130380C00005038
      1E00D2010000050040533335400C0000003533204A2038204D20372054044934
      36360C000064381E00DA01000005004053333640090000003534204A20313420
      5404493437340C000022351E0006000000050040533337400C0000003534204A
      2035204D203220540249360C00000B351E0002000000050040533338400D0000
      003534204A2038204D20323320540249320C00004E381E00D101000005004053
      3339400D0000003534204A2038204D203236205404493436350C0000A3361E00
      C8000000050040533430400C0000003535204A2031204D203520540449323030
      0C00005A361E0097000000050040533431400E0000003536204A203131204D20
      3135205404493135310C00008C351E0029000000050040533432400D00000035
      36204A2037204D2032382054034934310C000097351E002C0000000500405334
      33400D0000003536204A2038204D2031392054034934340C0000F2361E00F300
      0000050040533434400C0000003537204A2038204D2034205404493234330C00
      009A381E0000020000050040533435400D0000003538204A2037204D20323520
      5404493531320C000054351E001400000005004053343640080000003539204A
      20372054034932300C00003E371E0029010000050040533437400E0000003630
      204A203131204D203137205404493239370C00001D351E000500000005004053
      3438400C0000003630204A2036204D203820540249350C0000BC371E00780100
      00050040533439400D0000003630204A2037204D203236205404493337360C00
      00E6381E0031020000050040533530400C0000003631204A2031204D20332054
      04493536320C000068381E00DC010000050040533531400D0000003631204A20
      33204D203235205404493437360C0000C6351E0044000000050040533532400D
      0000003631204A2034204D2031362054034936380C0000D3351E004A00000005
      0040533533400C0000003631204A2038204D20322054034937340C0000F6381E
      003B020000050040533534400D0000003631204A2039204D2032362054044935
      37320C0000E4371E008B010000050040533535400D0000003632204A2035204D
      203133205404493339350C000083351E0025000000050040533536400D000000
      3632204A2038204D2032332054034933370C000089381E00F901000005004053
      3537400E0000003633204A203130204D203130205404493530350C0000DF371E
      0089010000050040533538400C0000003633204A2033204D2034205404493339
      330C000036371E002401000005004053353940080000003633204A2033205404
      493239320C000059371E0037010000050040533630400D0000003633204A2035
      204D203233205404493331310C000094351E002B000000050040533631400C00
      00003633204A2037204D20372054034934330C000064351E001B000000050040
      533632400D0000003633204A2039204D2031362054034932370C00009D361E00
      C3000000050040533633400D0000003634204A2033204D203138205404493139
      350C0000DB381E002A020000050040533634400D0000003634204A2036204D20
      3136205404493535350C000097381E00FF010000050040533635400D00000036
      34204A2036204D203237205404493531310C00005C381E00D701000005004053
      363640080000003634204A2037204D04493437310C000061351E001A00000005
      0040533637400D0000003634204A2038204D2031342054034932360C00009A35
      1E002D00000005004053363840080000003636204A20312054034934350C0000
      8D361E00B8000000050040533639400C0000003636204A2032204D2032205404
      493138340C00003E361E0082000000050040533730400D0000003636204A2035
      204D203138205404493133300C000025381E00AF010000050040533731400D00
      00003636204A2037204D203234205404493433310C00009D351E002E00000005
      0040533732400D0000003636204A2038204D2031342054034934360C00003035
      1E000A000000050040533733400D0000003637204A203131204D203320540349
      31300C000052381E00D301000005004053373440090000003637204A20313120
      5404493436370C0000C8351E0045000000050040533735400D0000003637204A
      2033204D2032342054034936390C0000DF351E004E000000050040533736400C
      0000003637204A2036204D20342054034937380C000092371E00610100000500
      40533737400C0000003637204A2039204D2035205404493335330C000012351E
      0003000000050040533738400E0000003638204A203130204D20333020540249
      330C000059381E00D6010000050040533739400D0000003638204A203130204D
      2037205404493437300C000055381E00D4010000050040533830400C00000036
      38204A2036204D2031205404493436380C0000B8371E00770100000500405338
      31400D0000003638204A2036204D203231205404493337350C0000BB351E0041
      000000050040533832400C0000003638204A2037204D20312054034936350C00
      00F0371E0090010000050040533833400D0000003638204A2038204D20323820
      5404493430300C000018351E0004000000050040533834400C0000003638204A
      2039204D203120540249340C0000A1351E002F00000005004053383540080000
      003639204A2036204D034934370C0000E3381E002F0200000500405338364008
      0000003639204A2037204D04493536300C0000A4351E00310000000500405338
      3740080000003730204A2032204D034934390C0000C9361E00DF000000050040
      533838400D0000003730204A2032204D203130205404493232330C000066381E
      00DB010000050040533839400D0000003730204A2032204D2031362054044934
      37350C00003C351E000D000000050040533930400C0000003730204A2035204D
      20382054034931330C000035351E000B000000050040533931400D0000003730
      204A2036204D2031352054034931310C0000B6361E00D2000000050040533932
      400D0000003730204A2039204D203131205404493231300C0000ED381E003502
      000005004053393340090000003731204A203131204D04493536360C00007335
      1E001F00000005004053393440090000003731204A2032362054034933310C00
      00A8361E00CB000000050040533935400C0000003731204A2036204D20372054
      04493230330C000041351E000E000000050040533936400C0000003731204A20
      38204D20342054034931340C000090371E0060010000050040533937400D0000
      003731204A2039204D203133205404493335320C0000F9351E00550000000500
      40533938400C0000003732204A2033204D20312054034938350C0000D1371E00
      81010000050040533939400C0000003732204A2033204D203720540449333835
      0C0000CD381E002002000006004053313030400D0000003732204A2034204D20
      3136205404493534350C00004F371E003001000006004053313031400D000000
      3732204A2035204D203237205404493330340C00001B381E00A9010000060040
      53313032400D0000003732204A2036204D203133205404493432350C00001138
      1E00A401000006004053313033400C0000003733204A2032204D203120540449
      3432300C0000E3351E004F00000006004053313034400D0000003733204A2034
      204D2031362054034937390C0000DC371E008801000006004053313035400C00
      00003733204A2035204D2035205404493339320C0000AC381E000A0200000600
      405331303640080000003733204A2035205404493532320C00008D371E005F01
      000006004053313037400D0000003734204A2031204D20323320540449333531
      0C0000CB351E004600000006004053313038400E0000003734204A203130204D
      2032302054034937300C0000A7351E003300000006004053313039400D000000
      3734204A203131204D20312054034935310C000090351E002A00000006004053
      313130400D0000003734204A2032204D2031342054034934320C0000CD361E00
      E000000006004053313131400C0000003734204A2036204D2033205404493232
      340C00002C381E00B501000006004053313132400D0000003734204A2038204D
      203130205404493433370C000047371E002D01000006004053313133400E0000
      003735204A203131204D203235205404493330310C0000A6361E00CA00000006
      004053313134400C0000003735204A2038204D2032205404493230320C0000A8
      381E000902000006004053313135400D0000003736204A2033204D2032352054
      04493532310C000021381E00AD01000006004053313136400D0000003736204A
      2035204D203132205404493432390C0000D9381E002902000006004053313137
      400D0000003736204A2035204D203232205404493535340C0000D1361E00E100
      000006004053313138400D0000003737204A2034204D20313820540449323235
      0C000019381E00A801000006004053313139400D0000003737204A2035204D20
      3134205404493432340C000047381E00CC01000006004053313230400C000000
      3737204A2036204D2038205404493436300C000094381E00FE01000006004053
      313231400D0000003737204A2037204D203130205404493531300C0000C8381E
      001E02000006004053313232400C0000003737204A2038204D20312054044935
      34330C000038351E000C00000006004053313233400D0000003738204A203120
      4D2032362054034931320C0000F8361E00F400000006004053313234400C0000
      003738204A2032204D2032205404493234340C000014381E00A5010000060040
      5331323540090000003738204A203238205404493432310C0000C2351E004300
      000006004053313236400D0000003738204A2037204D2032332054034936370C
      0000E7361E00ED0000000600405331323740080000003738204A203820540449
      3233370C00004A351E001100000006004053313238400D0000003739204A2039
      204D2031332054034931370C0000CF351E004800000006004053313239400D00
      00003739204A2039204D2032322054034937320C0000A3371E00690100000600
      4053313330400800000038204A203233205404493336310C0000E8351E005000
      00000600405331333140040000003830204A034938300C00006A351E001D0000
      0006004053313332400D0000003830204A2031204D2031392054034932390C00
      0024361E007000000006004053313333400E0000003830204A203130204D2032
      39205404493131320C00005D351E001900000006004053313334400D00000038
      30204A2036204D2031392054034932350C0000B0361E00CF0000000600405331
      3335400C0000003830204A2038204D2032205404493230370C00006B361E00A2
      00000006004053313336400C0000003830204A2038204D203820540449313632
      0C0000EE371E008F01000006004053313337400C0000003830204A2039204D20
      33205404493339390C000024351E000700000006004053313338400E00000038
      32204A203130204D20313120540249370C0000F1381E00380200000600405331
      3339400D0000003832204A2032204D203236205404493536390C0000F9381E00
      3D02000006004053313430400D0000003832204A2035204D2032372054044935
      37340C00005F381E00D801000006004053313431400C0000003832204A203720
      4D2032205404493437320C0000D5361E00E300000006004053313432400D0000
      003833204A2031204D203236205404493232370C0000DE381E002C0200000600
      4053313433400D0000003833204A2032204D203238205404493535370C00000F
      361E00650000000600405331343440080000003833204A2033204D0449313031
      0C000044351E000F00000006004053313435400C0000003833204A2033204D20
      352054034931350C000077351E002000000006004053313436400C0000003833
      204A2033204D20372054034933320C0000E1381E002E02000006004053313437
      40090000003834204A203135205404493535390C000030361E007A0000000600
      405331343840090000003834204A203233205404493132320C0000DE361E00E8
      0000000600405331343940080000003834204A2033204D04493233320C00005E
      361E009A00000006004053313530400D0000003834204A2034204D2032352054
      04493135340C000087351E002700000006004053313531400C0000003834204A
      2035204D20322054034933390C0000D1351E004900000006004053313532400D
      0000003835204A2031204D2031302054034937330C000047351E001000000006
      004053313533400C0000003835204A2031204D20342054034931360C0000CD35
      1E004700000006004053313534400C0000003835204A2032204D203820540349
      37310C0000BF351E004200000006004053313535400C0000003835204A203320
      4D20362054034936360C00006D361E00A300000006004053313536400D000000
      3835204A2034204D203331205404493136330C000066361E00A0000000060040
      53313537400D0000003835204A2038204D203230205404493136300C00004B36
      1E008B00000006004053313538400C0000003836204A2032204D203420540449
      3133390C000061381E00D901000006004053313539400D0000003836204A2033
      204D203132205404493437330C00002C351E000900000006004053313630400D
      0000003836204A2039204D20313720540249390C00001F361E006E0000000600
      4053313631400D0000003837204A2031204D203137205404493131300C000052
      351E001300000006004053313632400C0000003837204A2034204D2037205403
      4931390C0000BE361E00D800000006004053313633400D0000003838204A2031
      204D203233205404493231360C00008B361E00B700000006004053313634400C
      0000003838204A2031204D2038205404493138330C00004F351E001200000006
      004053313635400C0000003839204A2032204D20342054034931380C0000D735
      1E004C00000006004053313636400D0000003839204A2038204D203138205403
      4937360C0000FC351E005600000006004053313637400E0000003934204A2031
      31204D2032372054034938360C00006E351E001E00000006004053313638400C
      0000003934204A2039204D20312054034933300C0000DD351E004D0000000600
      4053313639400D0000003939204A2035204D2032302054034937370C00007337
      1E0047010000060040533137304013000000412E205765696E7A6965726C2C20
      546575676E04493332370C0000EB361E00EE0000000600405331373140100000
      00412E5765696E7A6965726C2C2054676E04493233380C0000FA361E00F40000
      00060040533137324011000000412E5765696E7A6965726C2C546575676E0449
      3234340C000079351E002000000006004053313733401800000041627374616D
      6D756E67736E61636877656973204E722E31034933320C00006C351E001D0000
      0006004053313734402400000041686E2E502E204D6963682E5363686C69636B
      65722C20416273742E4E772E204E722E31034932390C000066351E001B000000
      06004053313735402000000041686E656E6E61636877656973204B6174682E50
      6641204F686D656E6865696D034932370C400090381E00FC0100000600405331
      37364004493530380C40009B351E002D0000000600405331373740034934350C
      400026391E0059020000060040533137384004493630320C4000A0381E000302
      0000060040533137394004493531350C400010351E0002000000060040533138
      30400249320C4000E2371E008A010000060040533138314004493339340C0000
      24391E005902000006004053313832401B00000041686E502E204D6963682E20
      5363686C69636B6572202A3139323204493630320C00008E351E002900000006
      004053313833402300000041686E502E4D2E5363686C69636B2E2A313932322C
      2053745520537441205461676D2E034934310C0000D2361E00E1000000060040
      53313834402200000041686E546166204564657220477266672C205765696E7A
      6965726C2C20546575676E04493232350C0000EC361E00EE0000000600405331
      3835402600000041686E54662E4564657220476C66672E204F72743A20412E57
      65696E7A6965726C2C2054676E04493233380C0000E8361E00ED000000060040
      53313836402500000041686E54662E4564657220476C66672E204F72743A412E
      5765696E7A6965726C2C2054676E04493233370C000040391E00590200000600
      40533138374018000000416E6472656173205765696E7A6965726C2C20546575
      676E04493630320C0000FB381E003D020000060040533138384022000000416E
      697461204F60436F6E6E65722D5363686D69746820656D2032302E30392E3130
      04493537340C0000C1361E00D9000000060040533138394022000000416E742E
      4A6F682E205A69726E6769626C205A6569747A672E2032342E30332E30350449
      3231370C0000D0381E002102000006004053313930400E000000416E746F6E20
      5A69726E6769626C04493534360C000009371E00FF0000000600405331393140
      150000004175736B2E204D617269616E6E65205A69726E672E04493235350C00
      006F361E00A30000000600405331393240160000004175736B2E205765696368
      6D2E20546865726573696104493136330C0000B2371E00740100000600405331
      3933401C000000444145492047756E64656C736865696D20322054617566656E
      20373304493337320C4000C3371E007901000006004053313934400449333737
      0C4000C7371E007A010000060040533139354004493337380C0000C4371E0079
      010000060040533139374023000000444145492050664D61742E205765696C68
      65696D20322C20537465726265662E20313604493337370C0000B9371E007701
      000006004053313938401F000000444145492050664D61742E205765696C6865
      696D20322C54617566656E203104493337350C000047391E0059020000060040
      533139394023000000444145492050664D61742E205765696C6865696D20322C
      54726175756E67656E20323004493630320C000048391E005902000006004053
      3230304023000000444145492050664D61742E205765696C6865696D20322C54
      726175756E67656E20323404493630320C0000BE371E00780100000600405332
      3031401D000000444145492050664D61742E20576F6C6665727374647420322C
      2031323804493337360C000066371E003D010000060040533230324020000000
      444145492050664D61742E47756E64656C73682E332C2054617566656E203733
      04493331370C0000BF371E007801000006004053323033402100000044414549
      2050664D61742E5765696865696D20322C20537465726265662E203230044933
      37360C0000AC371E007101000006004053323034401D00000044414549205066
      4D61742E5765696C682E322C2054617566656E20363704493336390C00007535
      1E001F00000006004053323035401D000000444145492050664D61742E576569
      6C682E332C2054617566656E203139034933310C0000B6371E00760100000600
      40533230364020000000444145492050664D61742E5765696C6865696D20312C
      54617566656E2031313804493337340C0000AE371E0071010000060040533230
      374019000000444145492050664D61742E5765696C6865696D20362C20313204
      493336390C4000C9371E007A010000060040533230384004493337380C0000BA
      371E0077010000060040533230394022000000444145492050664D61742E5769
      747465736865696D2036205374657262662E20313504493337350C0000D2371E
      008101000006004053323130401E000000444145492050664D61742E576F6C66
      657273746164742031342C2031373504493338350C0000D4371E008201000006
      004053323131401E000000444145492050664D61742E576F6C66657273746164
      742031342C2031383004493338360C000049391E005902000006004053323132
      401C000000444145492050664D61742E576F6C666572737461647420392C2034
      3404493630320C400025391E0059020000060040533231334004493630320C40
      0070351E001E0000000600405332313440034933300C400098351E002C000000
      0600405332313540034934340C00008C381E00FA010000060040533231364010
      000000447265786C20526567656E736275726704493530360C00008A381E00F9
      010000060040533231374011000000447265786C2C20526567656E7362757267
      04493530350C00009D371E0066010000060040533231384014000000462E582E
      2042617565722C204B6169736865696D04493335380C4000D8371E0085010000
      060040533231394004493338390C000015361E00680000000600405332323040
      0A00000046616D69656E6275636804493130340C000019361E006A0000000600
      4053323231400C00000046616D696C69656E6275636804493130360C40001336
      1E0067000000060040533232324004493130330C400011361E00660000000600
      40533232334004493130320C00003F371E002901000006004053323235400400
      000066696B2E04493239370C00000A381E00A101000006004053323236401E00
      000046696B742E2061756667722E20642E2042656572646967756E676461742E
      04493431370C00000E381E00A301000006004053323237401A00000046696B74
      2E2061756667722E20642E2054617566646174756D7304493431390C0000DF36
      1E00E800000006004053323238401600000066696B742E2061756667722E642E
      546175666461742E04493233320C000042371E002B0100000600405332323940
      1F00000046696B742E206175666772642E20642E2042656572646967756E6764
      61742E04493239390C0000F5361E00F300000006004053323330401B00000066
      696B742E206175666772642E20642E2042657374617474756E6704493234330C
      000007381E00A001000006004053323331402100000046696B742E2061756667
      72756E6420642E2042656572646967756E67736461742E04493431360C0000B5
      371E007601000006004053323332400600000066696B74697604493337340C00
      00F3361E00F300000006004053323333401B00000066696B7469762C20617566
      6772642E20642E20546175666461742E04493234330C00004C351E0011000000
      0600405332333540240000004765622E2D752E5461756662657363682E4B6174
      682E20506641204F686D656E6865696D034931370C000056351E001500000006
      00405332333640150000004765622E55726B2E20537441204175677362757267
      034932310C000029351E000800000006004053323337400C0000004765627572
      7473636865696E0249380C000025351E000700000006004053323338401C0000
      004765627572747373636865696E20537441204465636862657474656E024937
      0C000032351E000A00000006004053323339400E000000476562757274737572
      6B756E6465034931300C00005A371E003701000006004053323430401D000000
      482E2057656C746D6169657220284772616273742E20506F696B616D29044933
      31310C00005D371E003901000006004053323431400E000000482E2057656C74
      6D61696572204D04493331330C000044391E0059020000060040533234324026
      000000482E57656C746D61696572204D2C204162622E42642E33204669636865
      20343420532031373804493630320C4000A1371E006801000006004053323433
      4004493336300C40004C371E002F010000060040533234344004493330330C40
      0050371E0030010000060040533234354004493330340C000021391E00590200
      0006004053323436400C00000048656972617473636865696E04493630320C00
      00DD371E00880100000600405332343740270000004865697261747375726B2E
      4B65727363682E2F4272616E746C20762E2032332E30332E3139343604493339
      320C4000D6361E00E3000000060040533234384004493232370C000048371E00
      2D01000006004053323439401F00000048656C6D75742057656C746D61696572
      2C204E6163686B6F6D6D4C6973746504493330310C000043371E002B01000006
      004053323531401F000000486F68656E67656272616368696E672042642E3120
      532E313220425A41205204493239390C0000F4361E00F3000000060040533235
      32401F000000486F68656E67656272616368696E672042642E3120532E343020
      425A41205204493234330C000008381E00A001000006004053323533401E0000
      00486F68656E67656272616368696E672042642E3120532E3520425A41205204
      493431360C00008D351E00290000000600405332353440160000004B6174682E
      205066617272616D742044616974696E67034934310C000048351E0010000000
      0600405332353540210000004B6174682E205066617272616D74205A69657274
      6865696D2D44617474656E682E034931360C40002A351E000800000006004053
      323536400249380C000057351E00150000000600405332353740140000004B61
      74682E20537450412053742E20416E746F6E034932310C40002A391E00590200
      00060040533235384004493630320C0000E5351E004F00000006004053323539
      40110000004B692E546652672E426449494920533537034937390C4000E6351E
      004F0000000600405332363040034937390C40002B391E005902000006004053
      3236314004493630320C400029391E0059020000060040533236324004493630
      320C0000ED351E005100000006004053323633401D0000004B697263686C2E20
      546175667265672E2042642E20494920532E203935034938310C4000EF351E00
      510000000600405332363440034938310C00009F351E002E0000000600405332
      363540150000004B6C6175732042696265722062617661726961204C03493436
      0C40003C371E0028010000060040533236364004493239360C40003E391E0059
      020000060040533236374004493630320C0000F6361E00F30000000600405332
      3638401F0000004D617474696E672042642E203620532E20313120464E203830
      20425A41205204493234330C0000E0361E00E800000006004053323639401F00
      00004D617474696E672042642E203620532E20333920464E20373720425A4120
      5204493233320C000041391E005902000006004053323730401F0000004D6174
      74696E672042642E203620532E20383220464E20373920425A41205204493630
      320C00003F391E00590200000600405332373140200000004D617474696E6720
      42642E203620532E20393220464E2038302C20425A41205204493630320C0000
      DC361E00E700000006004053323732401F0000004D617474696E672042642E20
      3720532E20323620464E20383920425A41205204493233310C0000E1361E00E8
      00000006004053323733401F0000004D617474696E672042642E203720532E20
      323720464E20383920425A41205204493233320C40000C381E00A20100000600
      40533237354004493431380C40000F381E00A301000006004053323736400449
      3431390C4000DA361E00E6000000060040533237374004493233300C00007435
      1E001F0000000600405332373840210000004D6963682E5363686C69636B6572
      202A3138383620416273742E4E772E4E722E31034933310C00004D361E008C00
      00000600405332373940140000004E6F74697A2053696D6F6E205A69726E6769
      626C04493134300C00001F351E00050000000600405332383040200000004E72
      2E203720486569726174736275636820537441204465636862657474656E0249
      350C0000E1351E004E0000000600405332383140150000004F72743A20576569
      6E7A6965726C2C20546575676E034937380C00002E351E000900000006004053
      323832400A000000506572732E417573772E0249390C00001A351E0004000000
      06004053323833402700000050662E4D61742E204D617474696E672042642E34
      2C20532E32332C20464E20343920425A4120520249340C00003D391E00590200
      0006004053323834402800000050662E4D61742E4D617474696E672042642E20
      372C20532E31302C20464E2038372C20425A41205204493630320C00000D351E
      000200000006004053323835402700000050662E4D61742E4D617474696E6720
      42642E342C20532E34302C20464E2034342C20425A4120520249320C0000CB36
      1E00DF00000006004053323836402700000050662E4D61742E4D617474696E67
      2042642E342C20532E35302C20464E2035392C20425A41205204493232330C00
      00CF361E00E000000006004053323837402600000050662E4D61742E4D617474
      696E672042642E342C20532E353620464E2035392C20425A4120520449323234
      0C000013351E000300000006004053323838402600000050662E4D61742E4D61
      7474696E672042642E342C20532E392C20464E2034382C20425A412052024933
      0C00001B351E000400000006004053323839402700000050662E4D61742E4D61
      7474696E672042642E372031393034204E722E312C2045696E73696368740249
      340C000015351E000300000006004053323930402700000050662E4D61742E4D
      617474696E672042642E372C20532E32362C20464E2038342C20425A41205202
      49330C000069361E00A100000006004053323931402700000050662E4D61742E
      4D617474696E672042642E372C20532E33302C20464E2038342C20425A412052
      04493136310C0000CE361E00E000000006004053323932402500000050662E4D
      61742E4D617474696E672042642E372C20532E3620464E2038332C20425A4120
      5204493232340C0000CA361E00DF00000006004053323933402600000050662E
      4D61742E4D617474696E672042642E372C20532E372C20464E2038332C20425A
      41205204493232330C000016351E000300000006004053323934401800000050
      662E4D61742E4D617474696E672C2045696E73696368740249330C00004D351E
      001100000006004053323935401500000050662E4D6174722E2044617474656E
      68617573656E034931370C000006381E00A001000006004053323937401D0000
      005066656966666572205265696E686F6C642030393434333939323039300449
      3431360C400005371E00FC000000060040533239384004493235320C4000F235
      1E00520000000600405332393940034938320C4000F7351E0054000000060040
      5333303040034938340C0000B2361E00D000000006004053333031400E000000
      53656C6273746175736B756E667404493230380C00007B351E00200000000600
      4053333032400E000000537441205647204D6F6E6865696D034933320C000092
      351E002A000000060040533330334014000000537441205647204D6F6E686569
      6D204E722E2034034934320C00005F351E001900000006004053333034401D00
      0000537441205769747469736C696E67656E20762E32302E30322E3230303703
      4932350C4000E7371E008C010000060040533330354004493339360C00001238
      1E00A40100000600405333303640180000005374616D6D622E205A656C6C6572
      2053656261737469616E04493432300C000071351E001E000000060040533330
      37401B0000005374616E6465736265616D74652045696E74726167204E722E20
      31034933300C00003F351E000D00000006004053333038400A00000053746572
      626562696C64034931330C0000C0351E00420000000600405333303940220000
      0053746572626562696C642C204175736B756E66742057696C6C682E205A6972
      6E672E034936360C0000C4351E004300000006004053333130401F0000005374
      6572626562696C642C20537441204465636862657474656E204E722E35034936
      370C000033351E000A0000000600405333313140190000005374657262657572
      6B2E20537441204765727374686F66656E034931300C000027351E0007000000
      06004053333132401C00000053746572626575726B756E646520537441204765
      727374686F66656E0249370C4000EA351E005000000006004053333133400349
      38300C0000E9351E005000000006004053333134401500000054666D61742E42
      642E494949203138333720533537034938300C000020391E0059020000060040
      53333135400A0000005472617573636865696E04493630320C000072371E0047
      01000006004053333136401A000000756E6765662E20412E205765696E7A6965
      726C2C20546575676E04493332370C40006A371E004001000006004053333137
      4004493332300C0000C9351E0045000000060040533331384010000000576569
      6E7A6965726C2C20546575676E034936390C400045371E002C01000006004053
      3331394004493330300C000009351E0001000000060040533332304009000000
      5A6569747A657567650249310C000031391E0059020000060040533332314019
      0000005A6569747A657567652C2048656972617473616E7A6569676504493630
      320C0000D8351E004C0000000600405333323240170000005A6569747A657567
      653A20572E472E4B2E5363686D6964034937360C000045351E000F0000000600
      4053333233400A0000005A6569747A657567656E034931350C00002E381E00B6
      0100000600405333323440140000005A742E5A657567652045726E6120537465
      69626C0449343338}
    object Repso2z: TAutoIncField
      FieldName = 'z'
    end
    object Repso2nr: TIntegerField
      FieldName = 'nr'
    end
    object Repso2inh: TStringField
      FieldName = 'inh'
      Size = 255
    end
    object Repso2inh2: TMemoField
      FieldName = 'inh2'
      BlobType = ftMemo
      Size = 10
    end
    object Repso2alt: TStringField
      FieldName = 'alt'
      Size = 30
    end
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 480
    Top = 216
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 560
    Top = 264
  end
end
