object Main: TMain
  Left = 320
  Top = 168
  HorzScrollBar.Smooth = True
  HorzScrollBar.Tracking = True
  VertScrollBar.Smooth = True
  VertScrollBar.Tracking = True
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Asteroids'
  ClientHeight = 768
  ClientWidth = 1024
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = App_Continue
  OnDeactivate = App_Pause
  OnKeyDown = Form_KeyDown
  OnKeyPress = Form_KeyPress
  OnKeyUp = Form_KeyUp
  OnPaint = Form_Paint
  OnShow = Form_Show
  PixelsPerInch = 96
  TextHeight = 13
  object Timer_Start: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Handle_Start
    Left = 96
    Top = 16
  end
  object AppEvents: TApplicationEvents
    OnActivate = App_Continue
    OnDeactivate = App_Pause
    OnIdle = AppEventsIdle
    OnMinimize = App_Pause
    OnRestore = App_Continue
    Left = 32
    Top = 16
  end
  object Timer_FPS: TTimer
    Enabled = False
    OnTimer = Handle_FPS
    Left = 160
    Top = 16
  end
end
