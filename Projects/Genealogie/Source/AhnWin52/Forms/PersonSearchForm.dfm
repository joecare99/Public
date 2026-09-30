object PersonSearchDialog: TPersonSearchForm
  Left = 241
  Top = 153
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Auswahl'
  ClientHeight = 147
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 25
    Width = 55
    Height = 13
    Caption = 'Name  oder'
  end
  object Label3: TLabel
    Left = 24
    Top = 39
    Width = 65
    Height = 13
    Caption = 'Datensatz-Nr.'
  end
  object Label2: TLabel
    Left = 24
    Top = 64
    Width = 48
    Height = 13
    Caption = 'Vornamen'
  end
  object Edit1: TEdit
    Left = 112
    Top = 29
    Width = 241
    Height = 21
    TabOrder = 0
    OnExit = Edit1Exit
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
  end
  object BitBtn2: TBitBtn
    Left = 219
    Top = 96
    Width = 135
    Height = 25
    Caption = 'schon gefunden'
    TabOrder = 3
    OnClick = BitBtn2Click
    Kind = bkAbort
  end
  object Edit2: TEdit
    Left = 112
    Top = 60
    Width = 241
    Height = 21
    TabOrder = 1
    OnExit = Edit2Exit
    OnKeyDown = Edit2KeyDown
    OnKeyPress = Edit2KeyPress
  end
  object Button1: TButton
    Left = 112
    Top = 96
    Width = 75
    Height = 25
    Caption = 'suchen'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Query1: TQuery
    Left = 8
    Top = 104
  end
  object OpenDialog1: TOpenDialog
    Left = 40
    Top = 103
  end
  object SaveDialog1: TSaveDialog
    Left = 72
    Top = 104
  end
end
