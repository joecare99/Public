object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 535
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 209
    Height = 535
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object Button1: TButton
      Left = 56
      Top = 488
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 209
    Top = 0
    Width = 405
    Height = 535
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitLeft = 203
    object Button2: TButton
      Left = 162
      Top = 488
      Width = 75
      Height = 25
      Caption = 'Button2'
      TabOrder = 0
      OnClick = Button2Click
    end
  end
  object Panel3: TPanel
    Left = 614
    Top = 0
    Width = 257
    Height = 535
    Align = alRight
    Caption = 'Panel3'
    TabOrder = 2
    object Button3: TButton
      Left = 102
      Top = 488
      Width = 75
      Height = 25
      Caption = 'Button3'
      TabOrder = 0
      OnClick = Button3Click
    end
  end
end
