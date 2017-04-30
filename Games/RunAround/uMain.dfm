object frm_game: Tfrm_game
  Left = 183
  Top = 50
  Caption = 'Run Around'
  ClientHeight = 547
  ClientWidth = 872
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_enemy: TLabel
    Left = 576
    Top = 333
    Width = 162
    Height = 13
    Caption = 'Avoid this block.  It is your enemy'
  end
  object lbl_player: TLabel
    Left = 61
    Top = 33
    Width = 180
    Height = 13
    Caption = 'This block is controlled by your mouse'
  end
  object lbl_6: TLabel
    Left = 312
    Top = 208
    Width = 199
    Height = 23
    Caption = 'Enter your name below:'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object shp_player: TShape
    Left = 224
    Top = 64
    Width = 17
    Height = 17
  end
  object shp_enemy: TShape
    Left = 696
    Top = 360
    Width = 42
    Height = 41
  end
  object Label1: TLabel
    Left = 8
    Top = 421
    Width = 114
    Height = 13
    Caption = 'www.delphibasics.co.nr'
  end
  object Game_panel: TPanel
    Left = 0
    Top = 448
    Width = 873
    Height = 113
    TabOrder = 0
    object lbl1: TLabel
      Left = 24
      Top = 16
      Width = 85
      Height = 36
      Caption = 'Level:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 328
      Top = 16
      Width = 87
      Height = 36
      Caption = 'Score:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_level: TLabel
      Tag = 1
      Left = 127
      Top = 16
      Width = 16
      Height = 36
      Caption = '1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_score: TLabel
      Left = 433
      Top = 16
      Width = 16
      Height = 36
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbl_scoremax: TLabel
      Left = 491
      Top = 64
      Width = 14
      Height = 31
      Caption = '0'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbl_levelmax: TLabel
      Tag = 1
      Left = 185
      Top = 64
      Width = 14
      Height = 33
      Caption = '1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbl_3: TLabel
      Left = 24
      Top = 66
      Width = 155
      Height = 31
      Caption = 'Highest Level:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbl_4: TLabel
      Left = 328
      Top = 67
      Width = 157
      Height = 31
      Caption = 'Highest Score:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbl_5: TLabel
      Left = 592
      Top = 16
      Width = 199
      Height = 27
      Caption = 'The record holder is:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object lbl_name: TLabel
      Left = 592
      Top = 72
      Width = 187
      Height = 21
      Caption = 'Nobody at the moment...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
  end
  object btn_start: TButton
    Left = 360
    Top = 28
    Width = 89
    Height = 25
    Caption = 'Start the Game'
    TabOrder = 1
    OnClick = btn_startClick
  end
  object btn_restart: TButton
    Left = 352
    Top = 28
    Width = 105
    Height = 25
    Caption = 'Restart the Game'
    TabOrder = 2
    OnClick = btn_restartClick
  end
  object edt_name: TEdit
    Left = 312
    Top = 248
    Width = 209
    Height = 21
    TabOrder = 3
  end
  object tmr_enemy: TTimer
    Enabled = False
    Interval = 5
    OnTimer = tmr_enemyTimer
    Left = 24
    Top = 312
  end
  object tmr_level: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = tmr_levelTimer
    Left = 24
    Top = 272
  end
  object tmr_score: TTimer
    Enabled = False
    Interval = 150
    OnTimer = tmr_scoreTimer
    Left = 24
    Top = 232
  end
end
