object MainForm: TMainForm
  Left = 164
  Top = 78
  BorderStyle = bsSingle
  Caption = 'Controls and Components'
  ClientHeight = 262
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 44
    Height = 13
    Caption = 'ScrollBox'
  end
  object Label2: TLabel
    Left = 16
    Top = 136
    Width = 106
    Height = 13
    Caption = 'ScrollBox Components'
  end
  object Label3: TLabel
    Left = 152
    Top = 136
    Width = 85
    Height = 13
    Caption = 'ScrollBox Controls'
  end
  object Label4: TLabel
    Left = 288
    Top = 136
    Width = 85
    Height = 13
    Caption = 'Form Components'
  end
  object Label5: TLabel
    Left = 424
    Top = 136
    Width = 64
    Height = 13
    Caption = 'Form Controls'
  end
  object ScrollBox1: TScrollBox
    Left = 16
    Top = 24
    Width = 177
    Height = 97
    TabOrder = 0
    object RadioButton1: TRadioButton
      Left = 32
      Top = 16
      Width = 113
      Height = 17
      Caption = 'RadioButton1'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 32
      Top = 40
      Width = 113
      Height = 17
      Caption = 'RadioButton2'
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 32
      Top = 64
      Width = 113
      Height = 17
      Caption = 'RadioButton3'
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 216
    Top = 32
    Width = 89
    Height = 33
    Caption = 'Button1'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 216
    Top = 80
    Width = 89
    Height = 33
    Caption = 'Button2'
    TabOrder = 2
  end
  object ScrollBoxComponents: TListBox
    Left = 16
    Top = 152
    Width = 129
    Height = 97
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
  end
  object ScrollBoxControls: TListBox
    Left = 152
    Top = 152
    Width = 129
    Height = 97
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
  end
  object FormComponents: TListBox
    Left = 288
    Top = 152
    Width = 129
    Height = 97
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
  end
  object FormControls: TListBox
    Left = 424
    Top = 152
    Width = 129
    Height = 97
    ItemHeight = 13
    Sorted = True
    TabOrder = 6
  end
  object CloseBitBtn: TBitBtn
    Left = 376
    Top = 56
    Width = 89
    Height = 33
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 7
  end
end
