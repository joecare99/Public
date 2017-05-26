object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 445
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline FraGraph1: TFraGraph
    Left = 24
    Top = 32
    Width = 281
    Height = 241
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = FraGraph1.PopupMenu1
    TabOrder = 0
    ExplicitLeft = 24
    ExplicitTop = 32
    ExplicitWidth = 281
    ExplicitHeight = 241
    inherited PopupMenu1: TPopupMenu
      inherited BildSpeichern1: TMenuItem
        OnClick = nil
      end
      inherited Aktualisieren1: TMenuItem
        OnClick = nil
      end
      inherited Schliessen1: TMenuItem
        OnClick = nil
      end
    end
    inherited SavePictureDialog1: TSavePictureDialog
      Left = 40
      Top = 32
    end
    inherited Timer1: TTimer
      Left = 96
      Top = 104
    end
  end
end
