object FrmLogicConf: TFrmLogicConf
  Left = 0
  Top = 0
  Caption = 'FrmLogicConf'
  ClientHeight = 365
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 0
    Top = 41
    Width = 715
    Height = 324
    Align = alClient
    DefaultRowHeight = 14
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 715
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object Bevel1: TBevel
      Left = 112
      Top = 8
      Width = 41
      Height = 25
    end
    object SpeedButton1: TSpeedButton
      Left = 116
      Top = 11
      Width = 34
      Height = 20
      Flat = True
      OnClick = SpeedButton1Click
    end
    object StaticText1: TStaticText
      Left = 16
      Top = 2
      Width = 56
      Height = 17
      Caption = 'Kategorien'
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 16
      Top = 13
      Width = 90
      Height = 22
      MaxValue = 10
      MinValue = 1
      TabOrder = 1
      Value = 1
      OnChange = SpinEdit1Change
    end
    object StaticText2: TStaticText
      Left = 159
      Top = 2
      Width = 48
      Height = 17
      Caption = 'Elemente'
      TabOrder = 2
    end
    object SpinEdit2: TSpinEdit
      Left = 159
      Top = 13
      Width = 90
      Height = 22
      MaxValue = 15
      MinValue = 1
      TabOrder = 3
      Value = 1
      OnChange = SpinEdit2Change
    end
    object BitBtn1: TBitBtn
      Left = 599
      Top = 1
      Width = 115
      Height = 39
      Align = alRight
      TabOrder = 4
      OnClick = BitBtn1Click
      Kind = bkOK
    end
  end
end
