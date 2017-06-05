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
  OldCreateOrder = False
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
  end
  object lblFast: TLabel
    Left = 241
    Top = 72
    Width = 20
    Height = 13
    Caption = 'Fast'
  end
  object lblLow: TLabel
    Left = 36
    Top = 144
    Width = 20
    Height = 13
    Caption = 'Low'
  end
  object lblHigh: TLabel
    Left = 239
    Top = 144
    Width = 22
    Height = 13
    Caption = 'High'
  end
  object lblSpeed: TLabel
    Left = 133
    Top = 24
    Width = 31
    Height = 13
    Caption = '&Speed'
    FocusControl = SpeedSet
  end
  object lblPopulation: TLabel
    Left = 123
    Top = 96
    Width = 50
    Height = 13
    Caption = '&Population'
    FocusControl = PopulationSet
  end
  object lblGameTime: TLabel
    Left = 121
    Top = 168
    Width = 54
    Height = 13
    Caption = '&Game Time'
    FocusControl = GameTimeSet
  end
  object SpeedSet: TTrackBar
    Left = 36
    Top = 40
    Width = 225
    Height = 25
    Max = 30
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 2
    ThumbLength = 20
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object PopulationSet: TTrackBar
    Left = 36
    Top = 112
    Width = 225
    Height = 25
    Max = 35
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 3
    ThumbLength = 20
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object GameTimeSet: TEdit
    Left = 116
    Top = 184
    Width = 65
    Height = 21
    TabOrder = 4
    Text = '150'
 end
 object pnlRight: TPanel
    Left = 286
    Height = 233
    Top = 0
    Width = 98
    Align = alRight
    BevelOuter = bvNone
    ClientHeight = 233
    ClientWidth = 98
    TabOrder = 3
    object btnOK: TBitBtn
      Left = 6
      Height = 60
      Top = 6
      Width = 86
      Align = alTop
      Default = True
      DefaultCaption = True
      Kind = bkOK
      Layout = blGlyphTop
      ModalResult = 1
      OnClick = btnOKClick
      TabOrder = 0
    end
    object CancelBtn: TBitBtn
      Left = 6
      Height = 60
      Top = 72
      Width = 86
      Align = alTop
      Cancel = True
      DefaultCaption = True
      Kind = bkCancel
      Layout = blGlyphTop
      ModalResult = 2
      TabOrder = 1
    end

end
