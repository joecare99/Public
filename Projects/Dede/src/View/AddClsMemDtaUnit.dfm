object AddClsMemDtaForm: TAddClsMemDtaForm
  Left = 487
  Top = 363
  BorderStyle = bsDialog
  Caption = 'New Class Member'
  ClientHeight = 204
  ClientWidth = 195
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 28
    Height = 13
    Caption = 'Offset'
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 65
    Height = 13
    Caption = 'Display Name'
  end
  object Label3: TLabel
    Left = 8
    Top = 128
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Class Name'
  end
  object OffsEdit: TEdit
    Left = 8
    Top = 64
    Width = 121
    Height = 21
    Color = 15584973
    TabOrder = 0
    Text = 'OffsEdit'
  end
  object DispEdit: TEdit
    Left = 8
    Top = 104
    Width = 177
    Height = 21
    Color = 15584973
    TabOrder = 1
    Text = 'DispEdit'
  end
  object TypeEdit: TEdit
    Left = 8
    Top = 144
    Width = 177
    Height = 21
    Color = 15584973
    TabOrder = 2
    Text = 'TypeEdit'
  end
  object BitBtn1: TBitBtn
    Left = 32
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 3
  end
  object BitBtn2: TBitBtn
    Left = 112
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object ClassEdit: TEdit
    Left = 8
    Top = 24
    Width = 177
    Height = 21
    Color = 15584973
    TabOrder = 5
    Text = 'ClassEdit'
  end
end
