object frmThumbnails: TfrmThumbnails
  Left = 130
  Top = 180
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Thumbnail viewer'
  ClientHeight = 316
  ClientWidth = 799
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 697
    Height = 316
    Align = alLeft
    Color = clWhite
    Columns = <>
    ColumnClick = False
    IconOptions.WrapText = False
    LargeImages = LevelImages
    ReadOnly = True
    TabOrder = 0
  end
  object LoadBut: TButton
    Left = 712
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Load Level'
    TabOrder = 1
    OnClick = LoadButClick
  end
  object CancelBut: TButton
    Left = 712
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = CancelButClick
  end
  object LevelImages: TImageList
    Height = 50
    Width = 50
    Left = 24
    Top = 24
  end
end
