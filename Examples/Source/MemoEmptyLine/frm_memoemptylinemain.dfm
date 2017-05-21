object Form1: TForm1
  Left = 207
  Top = 361
  Caption = 'Form1'
  ClientHeight = 242
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblShowText: TLabel
    Left = 325
    Top = 8
    Width = 58
    Height = 13
    Caption = 'lblShowText'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLineCount: TLabel
    Left = 331
    Top = 167
    Width = 58
    Height = 13
    Caption = 'lblLineCount'
    Color = clBtnFace
    ParentColor = False
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 320
    Height = 176
    Lines.Strings = (
      'This is a default Text in Memo1')
    TabOrder = 0
    OnChange = Memo1Change
  end
  object btnClearMemo: TButton
    Left = 8
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 1
    OnClick = btnClearMemoClick
  end
  object btnMemoAdd: TButton
    Left = 95
    Top = 182
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = btnMemoAddClick
  end
  object btnSetText: TButton
    Left = 176
    Top = 184
    Width = 75
    Height = 25
    Caption = 'set Text'
    TabOrder = 3
    OnClick = btnSetTextClick
  end
  object btnAddText: TButton
    Left = 256
    Top = 184
    Width = 75
    Height = 25
    Caption = 'AddText'
    TabOrder = 4
    OnClick = btnAddTextClick
  end
  object btnInsertText: TButton
    Left = 335
    Top = 186
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 5
    OnClick = btnInsertTextClick
  end
  object btnTrimText: TButton
    Left = 416
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Trim !!'
    TabOrder = 6
    OnClick = btnTrimTextClick
  end
  object btnClearTS: TButton
    Left = 8
    Top = 212
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 7
    OnClick = btnClearTSClick
  end
  object btnTSAdd: TButton
    Left = 92
    Top = 212
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 8
    OnClick = btnTSAddClick
  end
  object btnSetTextTS: TButton
    Left = 176
    Top = 212
    Width = 75
    Height = 25
    Caption = 'set Text'
    TabOrder = 9
    OnClick = btnSetTextTSClick
  end
  object btnAddTextTS: TButton
    Left = 256
    Top = 212
    Width = 75
    Height = 25
    Caption = 'AddText'
    TabOrder = 10
    OnClick = btnAddTextTSClick
  end
  object btnInsertTextTS: TButton
    Left = 336
    Top = 212
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 11
    OnClick = btnInsertTextTSClick
  end
  object btnTrimTextTS: TButton
    Left = 416
    Top = 212
    Width = 75
    Height = 25
    Caption = 'Trim !!'
    TabOrder = 12
    OnClick = btnTrimTextTSClick
  end
  object btnUpdate: TButton
    Left = 519
    Top = 184
    Width = 75
    Height = 25
    Caption = 'btnUpdate'
    TabOrder = 13
    OnClick = Memo1Change
  end
end
