object Form1: TForm1
  Left = 267
  Top = 208
  Caption = 'Form1'
  ClientHeight = 613
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    862
    613
  )
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 640
    Top = 64
    Width = 32
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 640
    Top = 88
    Width = 32
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 640
    Top = 112
    Width = 32
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Label3'
  end
  object Memo1: TMemo
    Left = 16
    Top = 56
    Width = 593
    Height = 497
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1'
    )
    TabOrder = 0
  end
  object Button1: TButton
    Left = 424
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '*.mp3'
  end
  object Edit2: TEdit
    Left = 104
    Top = 16
    Width = 313
    Height = 21
    TabOrder = 3
    Text = 'w:\daten\accustic'
  end
  object Button2: TButton
    Left = 640
    Top = 144
    Width = 185
    Height = 25
    Caption = 'GetBackupPath'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 624
    Top = 184
    Width = 137
    Height = 21
    TabOrder = 5
    Text = 'Edit3'
  end
  object Button3: TButton
    Left = 768
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 624
    Top = 211
    Width = 75
    Height = 25
    Caption = 'IsEmptyDir'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 705
    Top = 211
    Width = 75
    Height = 25
    Caption = 'MakeDir'
    TabOrder = 8
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 623
    Top = 242
    Width = 75
    Height = 25
    Caption = 'GetVersion'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 704
    Top = 240
    Width = 75
    Height = 25
    Caption = 'getFileInfo'
    TabOrder = 10
    OnClick = Button7Click
  end
end