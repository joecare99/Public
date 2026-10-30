object PersonEntryChoiceDialog: TPersonEntryChoiceForm
  Left = 192
  Top = 114
  Width = 195
  Height = 228
  BorderIcons = [biSystemMenu]
  Caption = 'Form4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object ChoicePanel: TPanel
    Left = 0
    Top = 0
    Width = 179
    Height = 190
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object CreateNewRadioButton: TRadioButton
      Left = 48
      Top = 40
      Width = 85
      Height = 17
      Caption = '  Neu'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = CreateNewRadioButtonClick
    end
    object SelectExistingRadioButton: TRadioButton
      Left = 48
      Top = 88
      Width = 85
      Height = 17
      Caption = '  Auswahl'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = SelectExistingRadioButtonClick
    end
    object CancelRadioButton: TRadioButton
      Left = 48
      Top = 136
      Width = 85
      Height = 17
      Caption = '  zurück'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = CancelRadioButtonClick
    end
  end
end
