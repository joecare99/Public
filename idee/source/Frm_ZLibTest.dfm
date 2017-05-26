object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 644
  ClientWidth = 798
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 292
    Top = 109
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Memo1: TMemo
    Left = 32
    Top = 199
    Width = 185
    Height = 250
    Lines.Strings = (
      'lorem ipsum, quia dolor sit, amet, '
      'consectetur, adipisci velit, sed '
      'quia non numquam eius modi '
      'tempora incidunt, ut labore et '
      'dolore magnam aliquam quaerat '
      'voluptatem. ut enim ad minima '
      'veniam, quis nostrum exercita-'
      'tionem ullam corporis suscipit '
      'laboriosam, nisi ut aliquid ex ea '
      'commodi consequatur? quis autem '
      'vel eum iure reprehenderit, qui in '
      'ea voluptate velit esse, quam nihil '
      'molestiae consequatur, vel illum, '
      'qui dolorem eum fugiat, quo '
      'voluptas nulla pariatur?')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 223
    Top = 200
    Width = 329
    Height = 249
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Memo3: TMemo
    Left = 558
    Top = 200
    Width = 185
    Height = 249
    Lines.Strings = (
      'Memo3')
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object btnCompress: TButton
    Left = 144
    Top = 152
    Width = 169
    Height = 41
    Caption = 'Compress'
    Style = bsCommandLink
    TabOrder = 3
    OnClick = ButtonCompressClick
  end
  object btnDecompress: TButton
    Left = 503
    Top = 152
    Width = 161
    Height = 41
    Caption = 'Decompress'
    Style = bsSplitButton
    TabOrder = 4
    OnClick = ButtonDecompressClick
  end
  object cbxComprLevel: TComboBox
    Left = 328
    Top = 162
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'cbxComprLevel'
  end
  object cbxHexBreak: TComboBox
    Left = 455
    Top = 162
    Width = 42
    Height = 21
    TabOrder = 6
    Text = 'cbxHexBreak'
  end
  object btnLoadSource: TButton
    Left = 8
    Top = 152
    Width = 81
    Height = 41
    Caption = 'Load Source'
    TabOrder = 7
    OnClick = btnLoadSourceClick
  end
  object btnLoadCompr: TButton
    Left = 224
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Load Compr'
    TabOrder = 8
    OnClick = btnLoadComprClick
  end
  object CheckBox1: TCheckBox
    Left = 224
    Top = 495
    Width = 97
    Height = 17
    Caption = 'Append Header'
    TabOrder = 9
  end
  object btnSaveCompr: TButton
    Left = 397
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Save Compr'
    TabOrder = 10
    OnClick = btnSaveComprClick
  end
  object CheckBox2: TCheckBox
    Left = 400
    Top = 495
    Width = 97
    Height = 17
    Caption = 'Strip Header'
    TabOrder = 11
  end
  object btnSaveDest: TButton
    Left = 696
    Top = 152
    Width = 81
    Height = 42
    Caption = 'Save Dest'
    TabOrder = 12
    OnClick = btnSaveDestClick
  end
  object btnCompress2: TButton
    Left = 144
    Top = 109
    Width = 169
    Height = 41
    Caption = 'Compress'
    Style = bsCommandLink
    TabOrder = 13
    OnClick = btnCompress2Click
  end
  object btnDecompress2: TButton
    Left = 503
    Top = 109
    Width = 161
    Height = 41
    Caption = 'Decompress'
    Style = bsSplitButton
    TabOrder = 14
    OnClick = btnDecompress2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 256
    Top = 56
  end
  object SaveDialog1: TSaveDialog
    Left = 304
    Top = 56
  end
  object IdCompressorZLib1: TIdCompressorZLib
    Left = 392
    Top = 80
  end
end
