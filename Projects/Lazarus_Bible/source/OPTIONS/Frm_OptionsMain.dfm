object MainForm: TMainForm
  Left = 298
  Top = 176
  Caption = 'Options Dialog Demonstration'
  ClientHeight = 278
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object TabbedNotebook1: TPageControl
    Left = 0
    Top = 0
    Width = 425
    Height = 278
    ActivePage = ts3
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object ts1: TTabSheet
      Caption = 'First'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 419
      ExplicitHeight = 242
      object CheckBox1: TCheckBox
        Left = 128
        Top = 56
        Width = 97
        Height = 17
        AllowGrayed = True
        Caption = 'CheckBox1'
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 128
        Top = 80
        Width = 97
        Height = 17
        AllowGrayed = True
        Caption = 'CheckBox2'
        TabOrder = 1
      end
      object CheckBox3: TCheckBox
        Left = 128
        Top = 104
        Width = 97
        Height = 17
        AllowGrayed = True
        Caption = 'CheckBox3'
        TabOrder = 2
      end
    end
    object ts2: TTabSheet
      Caption = 'Second'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 419
      ExplicitHeight = 242
      object RadioButton1: TRadioButton
        Left = 112
        Top = 48
        Width = 113
        Height = 17
        Caption = 'RadioButton1'
        TabOrder = 0
      end
      object RadioButton2: TRadioButton
        Left = 112
        Top = 80
        Width = 113
        Height = 17
        Caption = 'RadioButton2'
        TabOrder = 1
      end
      object RadioButton3: TRadioButton
        Left = 112
        Top = 112
        Width = 113
        Height = 17
        Caption = 'RadioButton3'
        TabOrder = 2
      end
    end
    object ts3: TTabSheet
      Caption = 'Third'
      object Edit1: TEdit
        Left = 96
        Top = 48
        Width = 121
        Height = 24
        TabOrder = 0
        Text = 'Edit1'
      end
      object Edit2: TEdit
        Left = 96
        Top = 88
        Width = 121
        Height = 24
        TabOrder = 1
        Text = 'Edit2'
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 208
    Top = 228
    Width = 89
    Height = 33
    Caption = 'Save...'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 303
    Top = 228
    Width = 89
    Height = 33
    DoubleBuffered = True
    Kind = bkClose
    ParentDoubleBuffered = False
    TabOrder = 0
  end
end
