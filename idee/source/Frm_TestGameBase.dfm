object FrmTestGamebaseMain: TFrmTestGamebaseMain
  Left = 0
  Top = 0
  Caption = 'FrmTestGamebaseMain'
  ClientHeight = 592
  ClientWidth = 930
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 677
    Top = 41
    Height = 488
    Align = alRight
    ExplicitLeft = 336
    ExplicitTop = 208
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 529
    Width = 930
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 300
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 573
    Width = 930
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 677
    Height = 488
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 675
      Height = 486
      Align = alClient
      ExplicitLeft = 192
      ExplicitTop = 120
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object Panel2: TPanel
    Left = 680
    Top = 41
    Width = 250
    Height = 488
    Align = alRight
    Caption = 'Panel2'
    TabOrder = 1
    object Memo1: TMemo
      Left = 6
      Top = 285
      Width = 235
      Height = 197
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 532
    Width = 930
    Height = 41
    Align = alBottom
    Caption = 'Panel3'
    TabOrder = 2
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 930
    Height = 41
    Align = alTop
    Caption = 'Panel4'
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 184
  end
end
