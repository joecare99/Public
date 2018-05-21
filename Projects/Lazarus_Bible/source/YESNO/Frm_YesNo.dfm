object frmYesNoDlg: TfrmYesNoDlg
  Left = 193
  Top = 99
  ActiveControl = btnYes
  BorderStyle = bsDialog
  Caption = 'YesNo Dialog'
  ClientHeight = 87
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object bvlPromptFrame: TBevel
    Left = 8
    Top = 8
    Width = 300
    Height = 33
    Shape = bsFrame
  end
  object lblPrompt: TLabel
    Left = 16
    Top = 16
    Width = 47
    Height = 13
    Caption = 'Prompt?'
    Color = clBtnFace
    ParentColor = False
  end
  object btnYes: TBitBtn
    Left = 64
    Top = 52
    Width = 77
    Height = 27
    Kind = bkYes
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 0
  end
  object btnCancel: TBitBtn
    Left = 148
    Top = 52
    Width = 77
    Height = 27
    Kind = bkNo
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 1
  end
  object btnHelp: TBitBtn
    Left = 232
    Top = 52
    Width = 77
    Height = 27
    Kind = bkHelp
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    TabOrder = 2
  end
end
