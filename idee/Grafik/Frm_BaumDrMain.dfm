object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 227
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 49
    Top = 75
    Width = 161
    Height = 16
    Caption = 'Anzahl Iterationen  (z.B. 12)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 49
    Top = 97
    Width = 82
    Height = 16
    Caption = 'Reduktion (%)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object SpinEdit1: TSpinEdit
    Left = 320
    Top = 72
    Width = 121
    Height = 22
    MaxLength = 3
    MaxValue = 179
    MinValue = 3
    TabOrder = 0
    Value = 12
  end
  object SpinEdit2: TSpinEdit
    Left = 320
    Top = 100
    Width = 121
    Height = 22
    MaxLength = 2
    MaxValue = 99
    MinValue = 50
    TabOrder = 1
    Value = 87
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 451
    Height = 49
    BevelInner = bvLowered
    BevelKind = bkSoft
    BevelWidth = 3
    BorderStyle = bsSingle
    Caption = 'Baum Dreh'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 2
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 128
    Width = 425
    Height = 16
    Position = 100
    TabOrder = 3
  end
  object ScrollBar1: TScrollBar
    Left = 16
    Top = 168
    Width = 425
    Height = 16
    PageSize = 0
    TabOrder = 4
  end
  object BitBtn1: TBitBtn
    Left = 328
    Top = 190
    Width = 113
    Height = 35
    DoubleBuffered = True
    Kind = bkClose
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 190
    Width = 106
    Height = 35
    Caption = 'BitBtn2'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = BitBtn2Click
  end
  object XPManifest1: TXPManifest
    Left = 416
    Top = 184
  end
end
