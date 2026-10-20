object LoginDialog: TLoginDialog
  Left = 323
  Top = 227
  Width = 280
  Height = 160
  ActiveControl = Password
  BorderStyle = bsDialog
  Caption = 'Datenbank-Login'
  ClientHeight = 147
  ClientWidth = 273
  Color = clBtnFace
  Scaled = False
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 75
  TextHeight = 13
  object OKButton: TButton
    Left = 99
    Top = 114
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 180
    Top = 114
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel: TPanel
    Left = 8
    Top = 7
    Width = 257
    Height = 98
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label3: TLabel
      Left = 10
      Top = 6
      Width = 120
      Height = 13
      AutoSize = False
      Caption = 'Datenbank:'
      Layout = tlCenter
    end
    object DatabaseName: TLabel
      Left = 91
      Top = 6
      Width = 150
      Height = 13
      AutoSize = False
      Layout = tlCenter
    end
    object Bevel: TBevel
      Left = 1
      Top = 24
      Width = 254
      Height = 9
      Shape = bsTopLine
    end
    object Panel1: TPanel
      Left = 3
      Top = 30
      Width = 251
      Height = 65
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 60
        Height = 13
        AutoSize = False
        Caption = '&Benutzername:'
        FocusControl = UserName
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 8
        Top = 36
        Width = 60
        Height = 13
        AutoSize = False
        Caption = '&Paßwort:'
        FocusControl = Password
        Layout = tlCenter
      end
      object UserName: TEdit
        Left = 86
        Top = 5
        Width = 153
        Height = 23
        Cursor = -4
        AutoSelect = False
        MaxLength = 31
        TabOrder = 0
      end
      object Password: TEdit
        Left = 86
        Top = 33
        Width = 153
        Height = 23
        MaxLength = 31
        PasswordChar = '*'
        TabOrder = 1
      end
    end
  end
end
