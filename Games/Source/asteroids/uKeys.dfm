object Keys: TKeys
  Left = 600
  Top = 271
  HorzScrollBar.Smooth = True
  HorzScrollBar.Tracking = True
  VertScrollBar.Smooth = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'keys'
  ClientHeight = 104
  ClientWidth = 208
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
  object Label_KeyLeft: TLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'turn &left'
    FocusControl = Edit_KeyLeft
  end
  object Label_KeyRight: TLabel
    Left = 8
    Top = 32
    Width = 56
    Height = 13
    AutoSize = False
    Caption = 'turn &right'
    FocusControl = Edit_KeyRight
  end
  object Label_KeyAccel: TLabel
    Left = 8
    Top = 56
    Width = 56
    Height = 13
    AutoSize = False
    Caption = '&accelerate'
    FocusControl = Edit_KeyAccel
  end
  object Label_KeyFire: TLabel
    Left = 8
    Top = 80
    Width = 56
    Height = 13
    AutoSize = False
    Caption = '&fire'
    FocusControl = Edit_KeyFire
  end
  object Panel_KeyLeft: TPanel
    Left = 72
    Top = 8
    Width = 128
    Height = 19
    BevelOuter = bvLowered
    TabOrder = 0
    object Edit_KeyLeft: TEdit
      Left = 1
      Top = 1
      Width = 126
      Height = 17
      AutoSize = False
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      OnChange = Edit_Change
      OnKeyDown = Edit_KeyDown
      OnKeyUp = Edit_KeyUp
    end
  end
  object Panel_KeyRight: TPanel
    Left = 72
    Top = 32
    Width = 128
    Height = 19
    BevelOuter = bvLowered
    TabOrder = 1
    object Edit_KeyRight: TEdit
      Left = 1
      Top = 1
      Width = 126
      Height = 17
      AutoSize = False
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      OnChange = Edit_Change
      OnKeyDown = Edit_KeyDown
      OnKeyUp = Edit_KeyUp
    end
  end
  object Panel_KeyAccel: TPanel
    Left = 72
    Top = 56
    Width = 128
    Height = 19
    BevelOuter = bvLowered
    TabOrder = 2
    object Edit_KeyAccel: TEdit
      Left = 1
      Top = 1
      Width = 126
      Height = 17
      AutoSize = False
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      OnChange = Edit_Change
      OnKeyDown = Edit_KeyDown
      OnKeyUp = Edit_KeyUp
    end
  end
  object Panel_KeyFire: TPanel
    Left = 72
    Top = 80
    Width = 128
    Height = 19
    BevelOuter = bvLowered
    TabOrder = 3
    object Edit_KeyFire: TEdit
      Left = 1
      Top = 1
      Width = 126
      Height = 17
      AutoSize = False
      BorderStyle = bsNone
      ParentColor = True
      ReadOnly = True
      TabOrder = 0
      OnChange = Edit_Change
      OnKeyDown = Edit_KeyDown
      OnKeyUp = Edit_KeyUp
    end
  end
end
