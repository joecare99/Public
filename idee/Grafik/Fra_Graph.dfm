object FraGraph: TFraGraph
  Left = 0
  Top = 0
  Width = 458
  Height = 336
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  PopupMenu = PopupMenu1
  TabOrder = 0
  OnResize = FrameResize
  object PopupMenu1: TPopupMenu
    Left = 208
    Top = 256
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click1
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
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    Left = 224
    Top = 96
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 256
    Top = 160
  end
end
