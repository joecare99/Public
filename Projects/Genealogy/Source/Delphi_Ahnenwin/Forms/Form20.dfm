object Form20: TForm20
  Left = 192
  Top = 114
  BorderStyle = bsSingle
  Caption = 'FOKO-Datei erstellen'
  ClientHeight = 236
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 433
    Height = 177
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 187
      Height = 16
      Caption = 'Ihre genealogische Vereinigung :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 88
      Width = 132
      Height = 16
      Caption = 'Ihre Mitgliedsnummer :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object dblookupcombobox1: TDBLookupComboBox
      Left = 8
      Top = 40
      Width = 401
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      KeyField = 'TX'
      ListField = 'TX'
      ParentFont = False
      TabOrder = 0
      OnClick = dblookupcombobox1Click
    end
    object Edit1: TEdit
      Left = 8
      Top = 112
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object BitBtn1: TBitBtn
    Left = 86
    Top = 196
    Width = 80
    Height = 25
    Caption = 'Fertig'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 254
    Top = 196
    Width = 94
    Height = 25
    Caption = 'Abbruch'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = BitBtn2Click
    Kind = bkAbort
  end
end
