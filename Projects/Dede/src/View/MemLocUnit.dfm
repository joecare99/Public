object ChooseMemLocForm: TChooseMemLocForm
  Left = 283
  Top = 217
  Width = 419
  Height = 150
  Caption = 'Disassemble from memory location'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label16: TLabel
    Left = 16
    Top = 62
    Width = 90
    Height = 13
    Caption = 'Start Offset (in hex)'
  end
  object Label15: TLabel
    Left = 16
    Top = 14
    Width = 71
    Height = 13
    Caption = 'Select Process'
  end
  object StartOffsEdit: TEdit
    Left = 16
    Top = 78
    Width = 121
    Height = 21
    Color = 15584973
    TabOrder = 0
  end
  object ProcsCB: TComboBox
    Left = 16
    Top = 30
    Width = 377
    Height = 22
    Style = csDropDownList
    Color = 15584973
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    OnDropDown = ProcsCBDropDown
  end
  object BitBtn1: TBitBtn
    Left = 240
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 320
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
