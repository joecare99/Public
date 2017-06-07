object ConfigViewer: TConfigViewer
  Left = 602
  Height = 408
  Top = 117
  Width = 463
  Caption = 'Configuration'
  ClientHeight = 408
  ClientWidth = 463
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnActivate = FormActivate
  OnCreate = FormCreate
  LCLVersion = '1.8.0.1'
  Visible = False
  object lbConfig: TMemo
    Left = 0
    Height = 355
    Top = 53
    Width = 463
    Align = alClient
    OnChange = lbConfigChange
    PopupMenu = PopupMenu1
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object lbTabs: TTabControl
    Left = 0
    Height = 53
    Top = 0
    Width = 463
    OnChange = lbTabsChange
    RaggedRight = True
    TabIndex = 0
    Tabs.Strings = (
      'User'
      'Main'
    )
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Height = 13
      Top = 28
      Width = 25
      AutoSize = False
      Caption = 'File'
      ParentColor = False
    end
    object edFile: TEdit
      Left = 32
      Height = 21
      Top = 24
      Width = 417
      ReadOnly = True
      TabOrder = 0
    end
  end
  object PopupMenu1: TPopupMenu
    left = 216
    top = 220
    object Save1: TMenuItem
      Caption = '&Save'
      OnClick = Save1Click
    end
    object Undo1: TMenuItem
      Caption = '&Undo'
      OnClick = Undo1Click
    end
  end
end
