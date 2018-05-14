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
  object lblPath_Sx: TLabel
    Left = 640
    Top = 64
    Width = 32
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'lblPath_Sx'
  end
  object lblVersion: TLabel
    Left = 640
    Top = 88
    Width = 32
    Height = 13
    Anchors = [akTop, akRight]
    Caption = '<Version>'
  end
  object lblCount: TLabel
    Left = 640
    Top = 112
    Width = 32
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'lblCount'
  end
  object edtOutput: TMemo
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
  object btnFindFiles: TButton
    Left = 424
    Top = 16
    Width = 75
    Height = 25
    Caption = 'btnFindFiles'
    TabOrder = 1
    OnClick = btnFindFilesClick
  end
  object edtFilter: TEdit
    Left = 16
    Top = 16
    Width = 81
    Height = 21
    TabOrder = 2
    Text = '*.mp3'
  end
  object edtPfad: TEdit
    Left = 104
    Top = 16
    Width = 313
    Height = 21
    TabOrder = 3
    Text = 'v:\daten\accustic'
  end
  object btnGetBackupPath: TButton
    Left = 640
    Top = 144
    Width = 185
    Height = 25
    Caption = 'GetBackupPath'
    TabOrder = 4
    OnClick = btnGetBackupPathClick
  end
  object edtText_Pfad: TEdit
    Left = 624
    Top = 184
    Width = 137
    Height = 21
    TabOrder = 5
    Text = '<Text/Pfad>'
  end
  object btnCalcSoundex: TButton
    Left = 768
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Soundex'
    TabOrder = 6
    OnClick = btnCalcSoundexClick
  end
  object btnIsEmptyDir: TButton
    Left = 624
    Top = 211
    Width = 75
    Height = 25
    Caption = 'IsEmptyDir'
    TabOrder = 7
    OnClick = btnIsEmptyDirClick
  end
  object btnMakeDir: TButton
    Left = 705
    Top = 211
    Width = 75
    Height = 25
    Caption = 'MakeDir'
    TabOrder = 8
    OnClick = btnMakeDirClick
  end
  object btnGetVersion: TButton
    Left = 623
    Top = 242
    Width = 75
    Height = 25
    Caption = 'GetVersion'
    TabOrder = 9
    OnClick = btnGetVersionClick
  end
  object btnGetFileInfo: TButton
    Left = 704
    Top = 240
    Width = 75
    Height = 25
    Caption = 'getFileInfo'
    TabOrder = 10
    OnClick = btnGetFileInfoClick
  end
end