object Settings: TSettings
  Left = 794
  Top = 224
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'settings'
  ClientHeight = 304
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = Form_Close
  OnCreate = Form_Create
  OnDestroy = Form_Destroy
  OnKeyDown = Form_KeyDown
  OnKeyPress = Form_KeyPress
  OnShow = Form_Show
  PixelsPerInch = 96
  TextHeight = 13
  object LabelBlink: TLabel
    Left = 128
    Top = 176
    Width = 53
    Height = 13
    Alignment = taCenter
    Caption = 'bli&nk delay:'
    FocusControl = TrackBar_Blink
  end
  object LabelSparks: TLabel
    Left = 128
    Top = 208
    Width = 53
    Height = 26
    Alignment = taCenter
    AutoSize = False
    Caption = 'spa&rks:'
    FocusControl = TrackBar_Sparks
  end
  object Box_Stop: TCheckBox
    Left = 8
    Top = 8
    Width = 176
    Height = 17
    Caption = '(F1) &stop game if it looses focus'
    TabOrder = 0
    OnClick = Click_Stop
  end
  object Box_FirstP: TCheckBox
    Left = 8
    Top = 32
    Width = 176
    Height = 17
    Caption = '(F2) &first person shooter mode'
    TabOrder = 1
    OnClick = Click_FirstP
  end
  object TrackBar_Blink: TTrackBar
    Left = 0
    Top = 176
    Width = 128
    Height = 32
    Min = 1
    Position = 3
    TabOrder = 7
    OnChange = Change_Blink
  end
  object TrackBar_Sparks: TTrackBar
    Left = 0
    Top = 208
    Width = 128
    Height = 32
    Max = 256
    Position = 32
    TabOrder = 8
    TickStyle = tsManual
    OnChange = Change_Sparks
  end
  object Box_Beep: TCheckBox
    Left = 8
    Top = 56
    Width = 176
    Height = 17
    Caption = '(F3) &beep if shots launch and hit'
    TabOrder = 2
    OnClick = Click_Beep
  end
  object PanelKeys: TPanel
    Left = 8
    Top = 272
    Width = 176
    Height = 24
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 9
    object BtnKeys: TButton
      Left = 0
      Top = 0
      Width = 172
      Height = 20
      Caption = '&keys'
      TabOrder = 0
      OnClick = Click_Keys
    end
  end
  object Box_Limit: TCheckBox
    Left = 8
    Top = 80
    Width = 176
    Height = 17
    Caption = '(F4) &limit frame rate to 100 FPS'
    TabOrder = 3
    OnClick = Click_Limit
  end
  object Box_Accel: TCheckBox
    Left = 8
    Top = 104
    Width = 176
    Height = 17
    Caption = '(F5) &accelerate if FPS < 100'
    TabOrder = 4
    OnClick = Click_Accel
  end
  object Box_ShowParts: TCheckBox
    Left = 8
    Top = 128
    Width = 176
    Height = 17
    Caption = '(F6) &use partial 2D polygons'
    TabOrder = 5
    OnClick = Click_Accel
  end
  object Box_ShowFPS: TCheckBox
    Left = 8
    Top = 152
    Width = 176
    Height = 17
    Caption = '(F7) activate FPS &display'
    TabOrder = 6
    OnClick = Click_Accel
  end
  object Panel_Color1: TPanel
    Left = 8
    Top = 248
    Width = 80
    Height = 16
    BevelOuter = bvLowered
    TabOrder = 10
    OnClick = Click_Color
  end
  object Panel_Color2: TPanel
    Left = 104
    Top = 248
    Width = 80
    Height = 16
    BevelOuter = bvLowered
    TabOrder = 11
    OnClick = Click_Color
  end
  object ColorDialog: TColorDialog
    Color = clLime
    Left = 136
    Top = 224
  end
end
