object frmYesNoMain: TfrmYesNoMain
  Left = 232
  Top = 131
  ActiveControl = btnTest
  Caption = 'Test YesNo Dialog'
  ClientHeight = 166
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 16
  object btnTest: TButton
    Left = 150
    Top = 40
    Width = 111
    Height = 41
    Hint = 'This will open the Test-Dialog'
    Caption = 'Test'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnTestClick
  end
  object btnExit: TButton
    Left = 150
    Top = 110
    Width = 111
    Height = 41
    Hint = 'This will close the Application'
    Caption = 'Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnExitClick
  end
end
