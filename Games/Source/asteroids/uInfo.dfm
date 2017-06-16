object Info: TInfo
  Left = 380
  Top = 393
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'info'
  ClientHeight = 296
  ClientWidth = 449
  Color = clBackground
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = Form_Create
  OnDestroy = Form_Destroy
  OnKeyDown = Form_KeyDown
  OnKeyUp = Form_KeyUp
  OnPaint = Form_Paint
  OnShow = Form_Show
  PixelsPerInch = 96
  TextHeight = 14
  object Timer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Handle_Timer
    Left = 16
    Top = 16
  end
end
