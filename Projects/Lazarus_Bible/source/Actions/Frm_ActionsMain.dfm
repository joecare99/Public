object FrmActionsMain: TFrmActionsMain
  Left = 192
  Top = 107
  Caption = 'Action Lists'
  ClientHeight = 103
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mnuMain
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblHint: TLabel
    Left = 0
    Top = 79
    Width = 338
    Height = 24
    Align = alBottom
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enter Quit above to enable actions'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
    ExplicitTop = 99
    ExplicitWidth = 288
  end
  object edtEnterQuit: TEdit
    Left = 104
    Top = 64
    Width = 121
    Height = 21
    Hint = 'To exit enter '#39'quit'#39
    TabOrder = 0
  end
  object btnDemoQuit: TBitBtn
    Left = 128
    Top = 16
    Width = 75
    Height = 25
    Action = actDemoExit
    Caption = '&Schlie'#223'en'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
      F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
      000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
      338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
      45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
      3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
      F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
      000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
      338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
      4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
      8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
      333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
      0000}
    ModalResult = 11
    NumGlyphs = 2
    TabOrder = 1
  end
  object mnuMain: TMainMenu
    Left = 16
    Top = 8
    object mniDemo: TMenuItem
      Caption = 'Demo'
      object mniDemoExit: TMenuItem
        Action = actDemoExit
      end
    end
  end
  object alsDemoActions: TActionList
    Left = 272
    Top = 8
    object actDemoExit: TAction
      Category = 'Demo'
      Caption = 'E&xit'
      OnExecute = actDemoExitExecute
      OnUpdate = actDemoExitUpdate
    end
  end
end
