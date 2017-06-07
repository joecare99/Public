object FrmTxtEdit: TFrmTxtEdit
  Left = 0
  Top = 0
  Caption = 'Editor'
  ClientHeight = 348
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 329
    Width = 535
    Height = 19
    Panels = <>
  end
  object Panel1: TPanel
    Left = 424
    Top = 0
    Width = 111
    Height = 329
    Align = alRight
    TabOrder = 1
    DesignSize = (
      111
      329)
    object BitBtn1: TBitBtn
      Left = 6
      Top = 282
      Width = 97
      Height = 41
      Anchors = [akLeft, akBottom]
      DoubleBuffered = True
      Kind = bkOK
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 6
      Top = 233
      Width = 99
      Height = 43
      Anchors = [akLeft, akBottom]
      DoubleBuffered = True
      Kind = bkCancel
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
    end
    object BitBtn3: TBitBtn
      Left = 6
      Top = 178
      Width = 99
      Height = 49
      Anchors = [akLeft, akBottom]
      DoubleBuffered = True
      Kind = bkHelp
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 6
      Top = 155
      Width = 97
      Height = 17
      Caption = 'Autom. Umbruch'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = CheckBox1Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 424
    Height = 329
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
