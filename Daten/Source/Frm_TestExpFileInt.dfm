object frmTestExpComp: TfrmTestExpComp
  Left = 0
  Top = 0
  Caption = 'Test Exp-File-Componente'
  ClientHeight = 405
  ClientWidth = 662
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 208
    Width = 3
    Height = 13
  end
  object Memo1: TMemo
    Left = 8
    Top = 224
    Width = 641
    Height = 153
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 383
    Width = 662
    Height = 22
    Panels = <>
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 649
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 576
    Top = 48
    Width = 80
    Height = 22
    Caption = 'Format'
    TabOrder = 3
    OnClick = Button1Click
  end
end
