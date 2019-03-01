object frmConvertLevelData: TfrmConvertLevelData
  Left = 269
  Top = 92
  Caption = 'Sokoban-Level-Converter'
  ClientHeight = 829
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    929
    829)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCompileInfo: TLabel
    Left = 881
    Top = 24
    Width = 39
    Height = 6
    Anchors = [akTop, akRight]
    Caption = 'lblCompileInfo'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 7
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object edtLevelFile: TLabeledEdit
    Left = 7
    Top = 24
    Width = 489
    Height = 23
    EditLabel.Width = 57
    EditLabel.Height = 13
    EditLabel.Caption = 'edtLevelFile'
    TabOrder = 0
    OnClick = btnSaveDataClick
  end
  object btnLoadData: TButton
    Left = 89
    Top = 576
    Width = 75
    Height = 25
    Caption = 'Load...'
    TabOrder = 1
    OnClick = btnLoadDataClick
  end
  object Button1: TButton
    Left = 11
    Top = 608
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 89
    Top = 608
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ValueListEditor1: TValueListEditor
    Left = 552
    Top = 8
    Width = 288
    Height = 128
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Strings.Strings = (
      '')
    TabOrder = 4
    ColWidths = (
      64
      220)
  end
  object edtShowData1: TMemo
    Left = 928
    Top = 144
    Width = 464
    Height = 672
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'edtShowData')
    ParentFont = False
    TabOrder = 5
  end
  object dlgOpenLevelFile: TOpenDialog
    Left = 520
    Top = 24
  end
  object iglLevelTiles: TImageList
    Height = 25
    Width = 25
    Left = 568
    Top = 176
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.bin'
    Left = 57
    Top = 576
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.bin'
    Left = 137
    Top = 576
  end
end
