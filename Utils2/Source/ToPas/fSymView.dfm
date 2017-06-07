object SymView: TSymView
  Left = 342
  Height = 382
  Top = 116
  Width = 551
  Caption = 'Symbol Viewer'
  ClientHeight = 382
  ClientWidth = 551
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  LCLVersion = '1.8.0.1'
  Visible = False
  object Splitter1: TSplitter
    Left = 161
    Height = 349
    Top = 33
    Width = 5
  end
  object lbSyms: TListBox
    Left = 0
    Height = 349
    Top = 33
    Width = 161
    Align = alLeft
    ItemHeight = 0
    OnClick = lbSymsClick
    Options = [lboDrawFocusRect]
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Height = 33
    Top = 0
    Width = 551
    Align = alTop
    ClientHeight = 33
    ClientWidth = 551
    TabOrder = 1
    object swSorted: TCheckBox
      Left = 8
      Height = 19
      Top = 8
      Width = 49
      Caption = 'sorted'
      OnClick = swSortedClick
      TabOrder = 0
    end
    object buTestMacro: TButton
      Left = 88
      Height = 21
      Top = 4
      Width = 73
      Caption = 'TestMacro'
      OnClick = buTestMacroClick
      TabOrder = 1
    end
  end
  object edDef: TMemo
    Left = 166
    Height = 349
    Top = 33
    Width = 385
    Align = alClient
    Font.CharSet = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    ParentFont = False
    TabOrder = 2
  end
end
