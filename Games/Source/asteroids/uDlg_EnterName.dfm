object Dlg_EnterName: TDlg_EnterName
  Left = 320
  Top = 512
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'enter your name'
  ClientHeight = 112
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = Form_Show
  PixelsPerInch = 96
  TextHeight = 13
  object PanelName: TPanel
    Left = 16
    Top = 16
    Width = 480
    Height = 32
    BevelOuter = bvLowered
    TabOrder = 0
    object EditName: TEdit
      Left = 1
      Top = 1
      Width = 478
      Height = 30
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 0
    end
  end
  object PanelOk: TPanel
    Left = 16
    Top = 64
    Width = 232
    Height = 32
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 1
    object BtnOk: TButton
      Left = 0
      Top = 0
      Width = 228
      Height = 28
      Caption = '&ok'
      Default = True
      TabOrder = 0
      OnClick = Click_OK
    end
  end
  object PanelCancel: TPanel
    Left = 264
    Top = 64
    Width = 232
    Height = 32
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 2
    object BtnCancel: TButton
      Left = 0
      Top = 0
      Width = 228
      Height = 28
      Cancel = True
      Caption = '&cancel'
      TabOrder = 0
      OnClick = Click_Cancel
    end
  end
end
