object Form21: TForm21
  Left = 192
  Top = 114
  HelpContext = 7
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FOKO-Datei editieren (PLZ unbedingt vollst'#228'ndig eingeben !)'
  ClientHeight = 566
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 19
    Width = 241
    Height = 16
    Caption = 'sortieren: klicken auf Titel (Name, Ort)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = PopupMenu1
  end
  object SpeedButton1: TSpeedButton
    Left = 584
    Top = 16
    Width = 74
    Height = 25
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
    Left = 416
    Top = 17
    Width = 23
    Height = 22
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
    OnClick = SpeedButton2Click
  end
  object DBGrid1: TDBGrid
    Left = 1
    Top = 56
    Width = 789
    Height = 505
    DataSource = DataModule2.DataSource20
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    PopupMenu = PopupMenu1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnTitleClick = DBGrid1TitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'NAME'
        Width = 212
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BEKENN'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'STAAT'
        Width = 53
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PLZ_KZ'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ORT'
        Width = 199
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TER'
        Width = 52
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VON'
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'BIS'
        Width = 35
        Visible = True
      end>
  end
  object Button2: TButton
    Left = 472
    Top = 16
    Width = 105
    Height = 25
    Hint = 'zum Einreichen bei ComGen'
    Caption = 'Textdatei speichern'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = Button2Click
  end
  object PopupMenu1: TPopupMenu
    Left = 272
    Top = 16
    object Zeilelschen1: TMenuItem
      Caption = 'Zeile l'#246'schen'
      OnClick = Zeilelschen1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Textdatei|*.txt'
    Left = 328
    Top = 16
  end
end
