object frmAboutSwat: TfrmAboutSwat
  Left = 192
  Top = 110
  BorderStyle = bsDialog
  Caption = 'About Swat!...'
  ClientHeight = 213
  ClientWidth = 209
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
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 193
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    ParentColor = True
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 80
      Top = 24
      Width = 33
      Height = 33
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000000020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000000000000000000000000000000000000000000000000
        0000000000000000000AA00A00000000000000000000000000AA000AA0000000
        00000000000000000A200000A00000000000000000000000A2000000A0000000
        000000000000000A20000000A0000000000000000000000A2000000A20000000
        000000000000004A2000000A20000000000000000006040A2000002200000000
        000000000004604AA200002200000000000000000006460AAA40022200000000
        0000000004406464222042200000000000000000040646464604000000000000
        00000000044460006460400000000000000000004666111006440000F0000000
        0000000064691911006040000FF000000000000046999991104601000FFF0000
        000000006499B9991464910000FF000000000000669BBB911640910000FFF000
        000000000469B9996404900000FFF0000000000000669996000900000FFFFF00
        0000000000006660400000FFFFFFFFFFFFFFFF0000000054400000FFF00FFF0F
        0FF0FF000000004045000FFF0FF0F0F0F0FFFFF00000005450000FFF0FF0F0F0
        F0F0FFF00000005545000FFF0FF0F0FFF0F0FFF00500045004000FFF0FF0F0FF
        F0F0FFF00500550045000FFF0FF0FFFFFFF0FFF044445000500000FFF00FFFFF
        FFF0FF0000500005400000FFFFFFFFFFFFFFFF00000545450000000000000000
        00000000FFFFFFFFFFFFFFFFFFE6FFFFFFCE7FFFFF9F7FFFFF3F7FFFFE7F7FFF
        FC3E7FFFF81E7FFFE00CFFFFE00CFFFFC000FFFF8001FFFF8007FFFF80047FFF
        00061FFF00070FFF000307FF000387FF000383FF800783FFC00C0003F0380001
        FC380001FC300000FC300000FC300000B9B00000B330000007780001DE780001
        E0FC0003}
      Stretch = True
      IsControl = True
    end
    object ProductName: TLabel
      Left = 83
      Top = 8
      Width = 27
      Height = 13
      Caption = 'Swat!'
      IsControl = True
    end
    object Hits: TLabel
      Left = 69
      Top = 56
      Width = 55
      Height = 13
      Alignment = taCenter
      Caption = '5 pts per hit'
      IsControl = True
    end
    object Copyright: TLabel
      Left = 55
      Top = 120
      Width = 83
      Height = 13
      Alignment = taCenter
      Caption = 'Copyright © 1998'
      IsControl = True
    end
    object Comments: TLabel
      Left = 61
      Top = 104
      Width = 73
      Height = 13
      Alignment = taCenter
      Caption = 'Delphi Example'
      WordWrap = True
      IsControl = True
    end
    object Escape: TLabel
      Left = 55
      Top = 72
      Width = 82
      Height = 13
      Alignment = taCenter
      Caption = '-1 pts per escape'
      IsControl = True
    end
    object Miss: TLabel
      Left = 63
      Top = 88
      Width = 67
      Height = 13
      Alignment = taCenter
      Caption = '-2 pts per miss'
      IsControl = True
    end
    object Label1: TLabel
      Left = 48
      Top = 136
      Width = 97
      Height = 13
      Alignment = taCenter
      Caption = 'Borland International'
      IsControl = True
    end
  end
  object OKButton: TButton
    Left = 67
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
