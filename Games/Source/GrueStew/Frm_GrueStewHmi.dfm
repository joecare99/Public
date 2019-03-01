object frmGrueStewMain: TfrmGrueStewMain
  Left = 666
  Top = 37
  Caption = 'Grue Stew'
  ClientHeight = 553
  ClientWidth = 893
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Shape2: TShape
    Left = 643
    Top = 308
    Width = 232
    Height = 229
    Brush.Color = clYellow
    Shape = stCircle
  end
  object Shape1: TShape
    Left = 691
    Top = 356
    Width = 136
    Height = 133
    Brush.Color = clLime
    Shape = stCircle
  end
  object btnMoveNorth: TSpeedButton
    Left = 739
    Top = 364
    Width = 44
    Height = 41
    Caption = 'N'
    OnClick = btnMoveClick
  end
  object btnMoveEast: TSpeedButton
    Tag = 1
    Left = 779
    Top = 404
    Width = 44
    Height = 41
    Caption = 'O'
    OnClick = btnMoveClick
  end
  object btnMoveWest: TSpeedButton
    Tag = 3
    Left = 699
    Top = 404
    Width = 44
    Height = 41
    Caption = 'W'
    OnClick = btnMoveClick
  end
  object btnMoveSouth: TSpeedButton
    Tag = 2
    Left = 739
    Top = 444
    Width = 44
    Height = 41
    Caption = 'S'
    OnClick = btnMoveClick
  end
  object btnShootNorth: TSpeedButton
    Left = 739
    Top = 316
    Width = 44
    Height = 41
    Caption = 'N'
    OnClick = btnShootClick
  end
  object btnShootEast: TSpeedButton
    Tag = 1
    Left = 827
    Top = 404
    Width = 44
    Height = 41
    Caption = 'O'
    OnClick = btnShootClick
  end
  object btnShootWest: TSpeedButton
    Tag = 3
    Left = 651
    Top = 404
    Width = 44
    Height = 41
    Caption = 'W'
    OnClick = btnShootClick
  end
  object btnShootSouth: TSpeedButton
    Tag = 2
    Left = 739
    Top = 492
    Width = 44
    Height = 41
    Caption = 'S'
    OnClick = btnShootClick
  end
  object Shoot: TLabel
    Left = 668
    Top = 347
    Width = 28
    Height = 13
    Caption = 'Shoot'
    Color = clBtnFace
    ParentColor = False
  end
  object Walk: TLabel
    Left = 790
    Top = 374
    Width = 23
    Height = 13
    Caption = 'Walk'
    Color = clBtnFace
    ParentColor = False
  end
  object lblActRoom: TLabel
    Left = 747
    Top = 413
    Width = 16
    Height = 13
    Caption = '<>'
    Color = clBtnFace
    ParentColor = False
  end
  object lblMapNorth: TLabel
    Left = 747
    Top = 280
    Width = 16
    Height = 13
    Caption = '<>'
    Color = clBtnFace
    ParentColor = False
  end
  object lblMapWest: TLabel
    Left = 611
    Top = 413
    Width = 16
    Height = 13
    Caption = '<>'
    Color = clBtnFace
    ParentColor = False
  end
  object lblMapSouth: TLabel
    Left = 747
    Top = 536
    Width = 16
    Height = 13
    Caption = '<>'
    Color = clBtnFace
    ParentColor = False
  end
  object lblMapEast: TLabel
    Left = 872
    Top = 413
    Width = 16
    Height = 13
    Caption = '<>'
    Color = clBtnFace
    ParentColor = False
  end
  object Memo1: TMemo
    Left = 18
    Top = 41
    Width = 593
    Height = 499
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 712
    Top = 50
    object mniFile: TMenuItem
      Caption = 'Datei'
      object mniNewGame: TMenuItem
        Caption = 'Neu'
        OnClick = mniNewGameClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mniExit: TMenuItem
        Caption = 'Beenden'
      end
    end
  end
end
