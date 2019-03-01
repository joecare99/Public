object frmWinCub: TfrmWinCub
  Left = 0
  Top = 0
  ActiveControl = btnUp1
  Caption = 'ColorCub for Lazarus inspired by E. I. Simay'
  ClientHeight = 401
  ClientWidth = 397
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblComplett: TLabel
    Left = 16
    Top = 336
    Width = 237
    Height = 37
    Caption = 'Congratulation!!!'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -32
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object pnlHost: TPanel
    Left = 16
    Top = 16
    Width = 255
    Height = 255
    Color = clSilver
    ParentBackground = False
    TabOrder = 0
    object btnUp1: TButton
      Left = 40
      Top = 15
      Width = 40
      Height = 20
      Caption = '^'
      TabOrder = 0
      OnClick = btnUp1Click
    end
    object btnDown1: TButton
      Left = 40
      Top = 220
      Width = 40
      Height = 20
      Caption = 'v'
      TabOrder = 1
      OnClick = btnDown1Click
    end
    object btnLeft1: TButton
      Left = 15
      Top = 40
      Width = 20
      Height = 40
      Caption = '<'
      TabOrder = 2
      OnClick = btnLeft1Click
    end
    object btnRight1: TButton
      Left = 220
      Top = 40
      Width = 20
      Height = 40
      Caption = '>'
      TabOrder = 3
      OnClick = btnRight1Click
    end
    object btnUp2: TButton
      Tag = 1
      Left = 85
      Top = 15
      Width = 40
      Height = 20
      Caption = '^'
      TabOrder = 4
      OnClick = btnUp1Click
    end
    object btnDown2: TButton
      Tag = 1
      Left = 85
      Top = 220
      Width = 40
      Height = 20
      Caption = 'v'
      TabOrder = 5
      OnClick = btnDown1Click
    end
    object btnLeft2: TButton
      Tag = 1
      Left = 15
      Top = 85
      Width = 20
      Height = 40
      Caption = '<'
      TabOrder = 6
      OnClick = btnLeft1Click
    end
    object btnRight2: TButton
      Tag = 1
      Left = 220
      Top = 85
      Width = 20
      Height = 40
      Caption = '>'
      TabOrder = 7
      OnClick = btnRight1Click
    end
    object btnUp3: TButton
      Tag = 2
      Left = 130
      Top = 15
      Width = 40
      Height = 20
      Caption = '^'
      TabOrder = 12
      OnClick = btnUp1Click
    end
    object btnDown3: TButton
      Tag = 2
      Left = 130
      Top = 220
      Width = 40
      Height = 20
      Caption = 'v'
      TabOrder = 13
      OnClick = btnDown1Click
    end
    object btnLeft3: TButton
      Tag = 2
      Left = 15
      Top = 130
      Width = 20
      Height = 40
      Caption = '<'
      TabOrder = 14
      OnClick = btnLeft1Click
    end
    object btnRight3: TButton
      Tag = 2
      Left = 220
      Top = 130
      Width = 20
      Height = 40
      Caption = '>'
      TabOrder = 15
      OnClick = btnRight1Click
    end
    object btnUp4: TButton
      Tag = 3
      Left = 175
      Top = 15
      Width = 40
      Height = 20
      Caption = '^'
      TabOrder = 8
      OnClick = btnUp1Click
    end
    object btnDown4: TButton
      Tag = 3
      Left = 175
      Top = 220
      Width = 40
      Height = 20
      Caption = 'v'
      TabOrder = 9
      OnClick = btnDown1Click
    end
    object btnLeft4: TButton
      Tag = 3
      Left = 15
      Top = 175
      Width = 20
      Height = 40
      Caption = '<'
      TabOrder = 10
      OnClick = btnLeft1Click
    end
    object btnRight4: TButton
      Tag = 3
      Left = 220
      Top = 175
      Width = 20
      Height = 40
      Caption = '>'
      TabOrder = 11
      OnClick = btnRight1Click
    end
  end
  object btnShuffle: TButton
    Left = 298
    Top = 16
    Width = 72
    Height = 24
    Caption = 'Shuffle'
    TabOrder = 1
    OnClick = btnShuffle_Click
  end
  object pnlSteps: TPanel
    Left = 16
    Top = 291
    Width = 255
    Height = 33
    TabOrder = 2
    object lblStep1: TLabel
      Left = 8
      Top = 8
      Width = 90
      Height = 17
      AutoSize = False
      Caption = ' Number of steps: '
      Color = clBtnFace
      ParentColor = False
    end
    object lblStep2: TLabel
      Left = 108
      Top = 8
      Width = 6
      Height = 13
      Caption = '0'
      Color = clBtnFace
      ParentColor = False
    end
  end
end
