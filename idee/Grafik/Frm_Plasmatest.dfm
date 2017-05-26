object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Form8'
  ClientHeight = 328
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 348
    Height = 328
    Align = alClient
    ExplicitLeft = 144
    ExplicitTop = 128
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Label1: TLabel
    Left = 32
    Top = 72
    Width = 31
    Height = 13
    Caption = 'Label1'
    Transparent = True
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 272
    Top = 264
  end
end
