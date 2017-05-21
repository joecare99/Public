object frmAES: TfrmAES
  Left = 350
  Top = 206
  ActiveControl = memKey
  Caption = 'AES Verschl'#195#188'sselung'
  ClientHeight = 461
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Schl'#195#188'ssel'
    Color = clBtnFace
    ParentColor = False
  end
  object Label2: TLabel
    Left = 16
    Top = 95
    Width = 22
    Height = 13
    Caption = 'Text'
    Color = clBtnFace
    ParentColor = False
  end
  object Label3: TLabel
    Left = 16
    Top = 209
    Width = 74
    Height = 13
    Caption = 'Verschl'#195#188'sselt'
    Color = clBtnFace
    ParentColor = False
  end
  object Label4: TLabel
    Left = 16
    Top = 323
    Width = 74
    Height = 13
    Caption = 'Entschl'#195#188'sselt'
    Color = clBtnFace
    ParentColor = False
  end
  object memKey: TMemo
    Left = 16
    Top = 27
    Width = 473
    Height = 62
    Lines.Strings = (
      '000102030405060708090a0b0c0d0e0f')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object memText: TMemo
    Left = 16
    Top = 114
    Width = 473
    Height = 89
    Lines.Strings = (
      '00112233445566778899aabbccddeeff')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object memEncrypt: TMemo
    Left = 16
    Top = 228
    Width = 473
    Height = 89
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object memDecrypt: TMemo
    Left = 16
    Top = 342
    Width = 473
    Height = 89
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object cmdStart: TButton
    Left = 504
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Starten'
    TabOrder = 4
    OnClick = cmdStartClick
  end
  object cmdEncrypt: TButton
    Left = 504
    Top = 56
    Width = 105
    Height = 25
    Caption = 'Datei verschl'#252'sseln'
    TabOrder = 5
    OnClick = cmdEncryptClick
  end
  object oOpen: TOpenDialog
    Left = 520
    Top = 120
  end
  object oSave: TSaveDialog
    Left = 520
    Top = 168
  end
end
