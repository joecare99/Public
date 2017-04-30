object frmSkinInfo: TfrmSkinInfo
  Left = 412
  Top = 281
  BorderStyle = bsDialog
  Caption = 'Skin information'
  ClientHeight = 273
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 53
    Height = 13
    Caption = 'Skin name:'
  end
  object SkinName: TLabel
    Left = 144
    Top = 24
    Width = 3
    Height = 13
  end
  object Label3: TLabel
    Left = 24
    Top = 48
    Width = 57
    Height = 13
    Caption = 'Skin author:'
  end
  object SkinAuthor: TLabel
    Left = 144
    Top = 48
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 24
    Top = 72
    Width = 70
    Height = 13
    Caption = 'Skin copyright:'
  end
  object SkinCopyright: TLabel
    Left = 144
    Top = 72
    Width = 3
    Height = 13
  end
  object Label7: TLabel
    Left = 24
    Top = 96
    Width = 42
    Height = 13
    Caption = 'Website:'
  end
  object Label8: TLabel
    Left = 24
    Top = 120
    Width = 31
    Height = 13
    Caption = 'E-mail:'
  end
  object SkinWebsite: TLabel
    Left = 144
    Top = 96
    Width = 3
    Height = 13
  end
  object SkinMail: TLabel
    Left = 144
    Top = 120
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 24
    Top = 144
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object Button1: TButton
    Left = 216
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object DescMem: TMemo
    Left = 24
    Top = 168
    Width = 185
    Height = 65
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
