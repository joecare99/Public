object frmSwatOptionDlg: TfrmSwatOptionDlg
  Left = 194
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 233
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvlValues: TBevel
    Left = 8
    Top = 8
    Width = 281
    Height = 217
    Shape = bsFrame
  end
  object lblSlow: TLabel
    Left = 36
    Top = 72
    Width = 23
    Height = 13
    Caption = 'Slow'
    Color = clBtnFace
    ParentColor = False
  end
  object lblFast: TLabel
    Left = 241
    Top = 72
    Width = 20
    Height = 13
    Caption = 'Fast'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLow: TLabel
    Left = 36
    Top = 144
    Width = 20
    Height = 13
    Caption = 'Low'
    Color = clBtnFace
    ParentColor = False
  end
  object lblHigh: TLabel
    Left = 239
    Top = 144
    Width = 22
    Height = 13
    Caption = 'High'
    Color = clBtnFace
    ParentColor = False
  end
  object lblSpeed: TLabel
    Left = 133
    Top = 24
    Width = 31
    Height = 13
    Caption = '&Speed'
    Color = clBtnFace
    FocusControl = SpeedSet
    ParentColor = False
  end
  object lblPopulation: TLabel
    Left = 123
    Top = 96
    Width = 50
    Height = 13
    Caption = '&Population'
    Color = clBtnFace
    FocusControl = PopulationSet
    ParentColor = False
  end
  object lblGameTime: TLabel
    Left = 121
    Top = 168
    Width = 54
    Height = 13
    Caption = '&Game Time'
    Color = clBtnFace
    FocusControl = GameTimeSet
    ParentColor = False
  end
  object SpeedSet: TTrackBar
    Left = 36
    Top = 40
    Width = 225
    Height = 25
    Max = 30
    TabOrder = 0
  end
  object PopulationSet: TTrackBar
    Left = 36
    Top = 112
    Width = 225
    Height = 25
    Max = 35
    TabOrder = 1
  end
  object GameTimeSet: TEdit
    Left = 116
    Top = 184
    Width = 65
    Height = 21
    TabOrder = 2
    Text = '150'
  end
  object pnlRight: TPanel
    Left = 286
    Top = 0
    Width = 98
    Height = 233
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    object btnOK: TBitBtn
      Left = 0
      Top = 0
      Width = 98
      Height = 60
      Align = alTop
      DoubleBuffered = True
      Kind = bkOK
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object CancelBtn: TBitBtn
      Left = 0
      Top = 60
      Width = 98
      Height = 60
      Align = alTop
      DoubleBuffered = True
      Kind = bkCancel
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentDoubleBuffered = False
      TabOrder = 1
    end
  end
end
