object frmEnumWinMain: TfrmEnumWinMain
  Left = 200
  Top = 99
  ActiveControl = lbxWindows
  Caption = 'Enumerate Window Titles'
  ClientHeight = 524
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  DesignSize = (
    768
    524)
  PixelsPerInch = 96
  TextHeight = 16
  object lblWinTitles: TLabel
    Left = 40
    Top = 24
    Width = 77
    Height = 16
    Caption = 'Window titles'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lblInfo: TLabel
    Left = 42
    Top = 497
    Width = 57
    Height = 16
    Caption = '<Handle>'
    Color = clBtnFace
    ParentColor = False
  end
  object lbxWindows: TListBox
    Left = 40
    Top = 40
    Width = 582
    Height = 456
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnClick = lbxWindowsClick
  end
  object btnClose: TBitBtn
    Left = 653
    Top = 475
    Width = 89
    Height = 33
    Anchors = [akRight, akBottom]
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 1
  end
end
