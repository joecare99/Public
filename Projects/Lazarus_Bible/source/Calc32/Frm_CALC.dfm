object CalcForm: TCalcForm
  Left = 198
  Top = 100
  Caption = 'Calculator 32'
  ClientHeight = 309
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000007770000000000000000077700000000
    0777000000000000000007770000000007770000000000000000077700000000
    0000777777777777777770000000000000007700700799977999700000000000
    0000770070079997799970000000000000007777777777777777700000000000
    0000770070070070070070000000000000007700700700700700700000000000
    0000777777777777777770000000000000007700700700700700700000000000
    0000770070070070070070000000000000007777777777777777700000000000
    0000770070070070070070000000000000007700700700700700700000000000
    0000777777777777777770000000000000007700700700700700700000000000
    0000770070070070070070000000000000007777777777777777700000000000
    0000777777777777777770000000000000007700000000000000700000000000
    000077000000EE000EE0700000000000000077000000EE000EE0700000000000
    0000770000000000000070000000000000007777777777777777700000000000
    0000777777777777777770000000000000007777777777777777700000000000
    0777000000000000000007770000000007770000000000000000077700000000
    077700000000000000000777000000000000000000000000000000000000FFFF
    FFFFF800000FF800000FF800000FF800000FF800000FF800000FF800000FF800
    000FF800000FF800000FF800000FF800000FF800000FF800000FF800000FF800
    000FF800000FF800000FF800000FF800000FF800000FF800000FF800000FF800
    000FF800000FF800000FF800000FF800000FF800000FF800000FFFFFFFFF}
  KeyPreview = True
  Menu = CalcMainMenu
  OldCreateOrder = True
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object MemButton: TSpeedButton
    Left = 8
    Top = 8
    Width = 25
    Height = 25
    Caption = 'M'
    Enabled = False
  end
  object DecButton: TSpeedButton
    Left = 8
    Top = 40
    Width = 25
    Height = 25
    GroupIndex = 1
    Down = True
    Caption = '&D'
    OnClick = DecHexBinButtonClick
  end
  object HexButton: TSpeedButton
    Left = 8
    Top = 72
    Width = 25
    Height = 25
    GroupIndex = 1
    Caption = '&H'
    OnClick = DecHexBinButtonClick
  end
  object BinButton: TSpeedButton
    Left = 8
    Top = 104
    Width = 25
    Height = 25
    GroupIndex = 1
    Caption = '&B'
    OnClick = DecHexBinButtonClick
  end
  object btn7: TSpeedButton
    Tag = 7
    Left = 184
    Top = 144
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '7'
    OnClick = ButtonDigitClick
  end
  object btn8: TSpeedButton
    Tag = 8
    Left = 224
    Top = 144
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '8'
    OnClick = ButtonDigitClick
  end
  object btn9: TSpeedButton
    Tag = 9
    Left = 264
    Top = 144
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '9'
    OnClick = ButtonDigitClick
  end
  object btn4: TSpeedButton
    Tag = 4
    Left = 184
    Top = 176
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '4'
    OnClick = ButtonDigitClick
  end
  object btn5: TSpeedButton
    Tag = 5
    Left = 224
    Top = 176
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '5'
    OnClick = ButtonDigitClick
  end
  object btn6: TSpeedButton
    Tag = 6
    Left = 264
    Top = 176
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '6'
    OnClick = ButtonDigitClick
  end
  object btn1: TSpeedButton
    Tag = 1
    Left = 184
    Top = 208
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '1'
    OnClick = ButtonDigitClick
  end
  object btn2: TSpeedButton
    Tag = 2
    Left = 224
    Top = 208
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '2'
    OnClick = ButtonDigitClick
  end
  object btn3: TSpeedButton
    Tag = 3
    Left = 264
    Top = 208
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '3'
    OnClick = ButtonDigitClick
  end
  object btn0: TSpeedButton
    Left = 184
    Top = 240
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '0'
    OnClick = ButtonDigitClick
  end
  object btnNegate: TSpeedButton
    Left = 224
    Top = 240
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '+/-'
    OnClick = btnNegateClick
  end
  object btnEquals: TSpeedButton
    Left = 264
    Top = 240
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '='
    OnClick = btnEqualsClick
  end
  object btnA: TSpeedButton
    Tag = 10
    Left = 184
    Top = 272
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = 'A'
    Enabled = False
    OnClick = ButtonDigitClick
  end
  object btnB: TSpeedButton
    Tag = 11
    Left = 224
    Top = 272
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = 'B'
    Enabled = False
    OnClick = ButtonDigitClick
  end
  object btnC: TSpeedButton
    Tag = 12
    Left = 264
    Top = 272
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = 'C'
    Enabled = False
    OnClick = ButtonDigitClick
  end
  object btnD: TSpeedButton
    Tag = 13
    Left = 304
    Top = 272
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = 'D'
    Enabled = False
    OnClick = ButtonDigitClick
  end
  object btnE: TSpeedButton
    Tag = 14
    Left = 344
    Top = 272
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = 'E'
    Enabled = False
    OnClick = ButtonDigitClick
  end
  object btnF: TSpeedButton
    Tag = 15
    Left = 384
    Top = 272
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = 'F'
    Enabled = False
    OnClick = ButtonDigitClick
  end
  object btnDivide: TSpeedButton
    Tag = -2
    Left = 304
    Top = 176
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '/'
    OnClick = OpButtonClick
  end
  object btnMultiply: TSpeedButton
    Tag = -1
    Left = 304
    Top = 144
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '*'
    OnClick = OpButtonClick
  end
  object btnMinus: TSpeedButton
    Tag = -4
    Left = 304
    Top = 240
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '-'
    OnClick = OpButtonClick
  end
  object btnPlus: TSpeedButton
    Tag = -3
    Left = 304
    Top = 208
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '+'
    OnClick = OpButtonClick
  end
  object btnAND: TSpeedButton
    Tag = -5
    Left = 344
    Top = 144
    Width = 75
    Height = 30
    AllowAllUp = True
    Caption = 'AND'
    OnClick = OpButtonClick
  end
  object btnOR: TSpeedButton
    Tag = -6
    Left = 344
    Top = 176
    Width = 75
    Height = 30
    AllowAllUp = True
    Caption = 'OR'
    OnClick = OpButtonClick
  end
  object btnXOR: TSpeedButton
    Tag = -7
    Left = 344
    Top = 208
    Width = 75
    Height = 30
    AllowAllUp = True
    Caption = 'XOR'
    OnClick = OpButtonClick
  end
  object btnNOT: TSpeedButton
    Left = 344
    Top = 240
    Width = 75
    Height = 30
    AllowAllUp = True
    Caption = 'NOT'
    OnClick = btnNotClick
  end
  object LineBevel: TBevel
    Left = 8
    Top = 129
    Width = 411
    Height = 9
    Shape = bsBottomLine
  end
  object btnClear: TSpeedButton
    Left = 104
    Top = 144
    Width = 75
    Height = 30
    Caption = 'C'
    OnClick = btnClearClick
  end
  object btnClearEntry: TSpeedButton
    Left = 104
    Top = 176
    Width = 75
    Height = 30
    Caption = '&CE'
    OnClick = btnClearEntryClick
  end
  object btnBack: TSpeedButton
    Left = 8
    Top = 144
    Width = 89
    Height = 30
    Caption = 'Back'
    OnClick = btnBackClick
  end
  object btnPoint: TSpeedButton
    Tag = 15
    Left = 143
    Top = 208
    Width = 35
    Height = 30
    AllowAllUp = True
    Caption = '.'
    Enabled = False
  end
  object MemBevel: TPanel
    Left = 40
    Top = 8
    Width = 379
    Height = 25
    BevelOuter = bvLowered
    TabOrder = 1
    object MemLabel: TLabel
      Left = 344
      Top = 2
      Width = 22
      Height = 22
      Alignment = taRightJustify
      Caption = '0 '
      Color = clScrollBar
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object DecBevel: TPanel
    Left = 40
    Top = 40
    Width = 379
    Height = 25
    BevelOuter = bvLowered
    TabOrder = 2
    object DecLabel: TLabel
      Left = 245
      Top = 2
      Width = 121
      Height = 22
      Alignment = taRightJustify
      Caption = '-2147483648'
      Color = clScrollBar
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object HexBevel: TPanel
    Left = 40
    Top = 72
    Width = 379
    Height = 25
    BevelOuter = bvLowered
    TabOrder = 3
    object HexLabel: TLabel
      Left = 278
      Top = 2
      Width = 88
      Height = 22
      Alignment = taRightJustify
      Caption = '7FFFFFFF'
      Color = clScrollBar
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object BinBevel: TPanel
    Left = 40
    Top = 104
    Width = 379
    Height = 25
    BevelOuter = bvLowered
    TabOrder = 4
    object BinLabel: TLabel
      Left = 14
      Top = 2
      Width = 352
      Height = 22
      Alignment = taRightJustify
      Caption = '10000000000000000000000000000000'
      Color = clScrollBar
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 248
    Width = 107
    Height = 46
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 0
  end
  object CalcMainMenu: TMainMenu
    Left = 27
    Top = 177
    object CalcMenuItem: TMenuItem
      Caption = 'C&alc'
      object CalcExitMenuItem: TMenuItem
        Caption = 'E&xit'
        ShortCut = 32856
        OnClick = CalcExitMenuItemClick
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Copy1: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = Copy1Click
      end
      object Paste1: TMenuItem
        Caption = '&Paste'
        ShortCut = 16470
        OnClick = Paste1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'He&lp'
      object About1: TMenuItem
        Caption = '&About...'
        OnClick = About1Click
      end
    end
  end
  object ActionList1: TActionList
    Left = 64
    Top = 176
  end
end
