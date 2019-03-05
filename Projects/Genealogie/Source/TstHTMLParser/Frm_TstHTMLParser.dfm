object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 539
  ClientWidth = 991
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    991
    539)
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBoxEx1: TComboBoxEx
    Left = 8
    Top = 28
    Width = 449
    Height = 22
    ItemsEx = <>
    TabOrder = 0
    Text = 
      'V:\Daten\dokumente\HTML\Genealogie H'#252'bner\gendata.huebner-row.de' +
      '\huebner\1.html'
  end
  object BitBtn1: TBitBtn
    Left = 544
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Parse'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 56
    Width = 321
    Height = 433
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      '<TAG>Memo1</TAG>')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 463
    Top = 26
    Width = 75
    Height = 25
    Caption = 'Open'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object Memo2: TMemo
    Left = 335
    Top = 57
    Width = 290
    Height = 433
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object Memo3: TMemo
    Left = 631
    Top = 56
    Width = 290
    Height = 433
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      ']TM: META,name="author"'
      '[TS: base'
      ']TS: iframe'
      '[TM: DIV,id="spArticleSection"'
      '[TS: div'
      ']TS: div'
      '[TE: div'
      ']TS: div'
      ']S: Alle'
      ']TE: div'
      '[TS: br'
      '[TM: DIV,id="gutenb"'
      '[TE: div'
      ']TS: script'
      '[TE: div'
      ']TS: br'
      '[TE: body')
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object Memo4: TMemo
    Left = 927
    Top = 56
    Width = 290
    Height = 433
    Anchors = [akLeft, akTop, akBottom]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 6
  end
  object BitBtn3: TBitBtn
    Left = 927
    Top = 495
    Width = 75
    Height = 25
    Caption = 'Save'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 7
    OnClick = BitBtn3Click
  end
  object SaveDialog1: TSaveDialog
    Left = 888
    Top = 496
  end
end
