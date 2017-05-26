object GraphForm: TGraphForm
  Left = 726
  Top = 411
  Caption = 'GraphForm'
  ClientHeight = 448
  ClientWidth = 632
  Color = clNavy
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 392
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
    object BildSpeichern1: TMenuItem
      Caption = 'Bild Speichern'
      OnClick = BildSpeichern1Click
    end
    object Aktualisieren1: TMenuItem
      Caption = 'Aktualisieren'
      OnClick = Aktualisieren1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Schliessen1: TMenuItem
      Caption = 'Schliessen'
      OnClick = Schliessen1Click
    end
    object est1: TMenuItem
      Caption = 'Test'
      OnClick = Test1Click
    end
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = '.bmp'
    Left = 408
    Top = 232
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 440
    Top = 296
  end
end
