object QRProgressForm: TQRProgressForm
  Left = 316
  Top = 272
  BorderStyle = bsDialog
  Caption = 'Drucken'
  ClientHeight = 97
  ClientWidth = 149
  ParentFont = True
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Info: TLabel
    Left = 0
    Top = 44
    Width = 145
    Height = 13
    Alignment = taCenter
    AutoSize = False
  end
  object CancelButton: TButton
    Left = 36
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 0
    OnClick = CancelButtonClick
  end
  object Gauge: TProgressBar
    Left = 16
    Top = 18
    Width = 114
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 1
  end
end
