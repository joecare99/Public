object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 562
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 8
    Top = 32
    Width = 361
    Height = 497
    Indent = 19
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 760
    Height = 19
    Panels = <>
  end
  object BitBtn1: TBitBtn
    Left = 663
    Top = 8
    Width = 42
    Height = 25
    Caption = '...'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 649
    Height = 21
    TabOrder = 3
    Text = 'ComboBox1'
  end
  object BitBtn2: TBitBtn
    Left = 711
    Top = 8
    Width = 43
    Height = 25
    Caption = 'Open'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    OnClick = BitBtn2Click
  end
  object Memo1: TMemo
    Left = 376
    Top = 304
    Width = 377
    Height = 233
    Lines.Strings = (
      'Memo1')
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    Left = 472
    Top = 56
  end
  object Config1: TConfig
    Left = 560
    Top = 136
  end
  object GestureManager1: TGestureManager
    Left = 512
    Top = 248
    CustomGestures = <
      item
        Deviation = 29
        ErrorMargin = 35
        GestureID = -1
        Name = 'Zickzackvor'
        Options = 9
        Points = {0105000000000064000F0000001E0064002D0000003C006400}
      end
      item
        Deviation = 27
        ErrorMargin = 31
        GestureID = -2
        Name = 'Unbenannt'
        Options = 9
        Points = {0103000000310000006400000000000000}
      end>
  end
end
