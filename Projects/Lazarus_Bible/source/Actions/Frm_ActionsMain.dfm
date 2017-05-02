object FrmActionsMain: TFrmActionsMain
  Left = 192
  Top = 107
  Caption = 'Action Lists'
  ClientHeight = 180
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 104
    Width = 166
    Height = 48
    Alignment = taCenter
    Caption = 'Enter Quit above to enable actions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 104
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 128
    Top = 16
    Width = 75
    Height = 25
    Action = ExitAction
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 8
    object Demo1: TMenuItem
      Caption = 'Demo'
      object Exit1: TMenuItem
        Action = ExitAction
      end
    end
  end
  object ActionList1: TActionList
    Left = 272
    Top = 8
    object ExitAction: TAction
      Caption = 'E&xit'
      OnExecute = ExitActionExecute
      OnUpdate = ExitActionUpdate
    end
  end
end
