object FrmScreenXMain: TFrmScreenXMain
  Left = 0
  Top = 0
  Caption = 'FrmScreenXMain'
  ClientHeight = 435
  ClientWidth = 778
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    778
    435)
  PixelsPerInch = 96
  TextHeight = 13
  inline FraGraph1: TFraGraph
    Left = 151
    Top = 8
    Width = 611
    Height = 419
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBlack
    ParentBackground = False
    ParentColor = False
    PopupMenu = FraGraph1.PopupMenu1
    TabOrder = 0
    OnMouseDown = FraGraph1MouseDown
    ExplicitLeft = 151
    ExplicitTop = 8
    ExplicitWidth = 611
    ExplicitHeight = 419
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 309
    Width = 137
    Height = 81
    Anchors = [akLeft, akBottom]
    Caption = 'Muster:'
    ItemIndex = 1
    Items.Strings = (
      '1 - Mosaik'
      '2 - Farbstreifen'
      '3 - Bild (Angel)'
      '4 - Winkelfarbe')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 6
    Top = 408
    Width = 137
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Execute'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Chb_Kugel: TCheckBox
    Left = 24
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Kugel'
    TabOrder = 3
  end
  object Chb_Strudel: TCheckBox
    Left = 24
    Top = 31
    Width = 97
    Height = 17
    Caption = 'Strudel'
    TabOrder = 4
  end
  object Chb_Wobble: TCheckBox
    Left = 24
    Top = 54
    Width = 97
    Height = 17
    Caption = 'Wobble'
    TabOrder = 5
  end
  object CheckBox4: TCheckBox
    Left = 24
    Top = 392
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Invers'
    TabOrder = 6
  end
  object Chb_Ballon: TCheckBox
    Left = 24
    Top = 77
    Width = 97
    Height = 17
    Caption = 'Ballon'
    TabOrder = 7
  end
  object Chb_Tunnel: TCheckBox
    Left = 24
    Top = 100
    Width = 97
    Height = 17
    Caption = 'Tunnel'
    TabOrder = 8
  end
  object Chb_Schnecke: TCheckBox
    Left = 24
    Top = 123
    Width = 97
    Height = 17
    Caption = 'Schnecke'
    TabOrder = 9
  end
  object Chb_StrFlucht: TCheckBox
    Left = 24
    Top = 146
    Width = 97
    Height = 17
    Caption = 'Strassenflucht'
    TabOrder = 10
  end
  object Chb_Sauger: TCheckBox
    Left = 24
    Top = 169
    Width = 97
    Height = 17
    Caption = 'Sauger'
    TabOrder = 11
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 192
    Width = 65
    Height = 17
    Caption = 'Mandelbr'
    TabOrder = 12
  end
  object SpinEdit1: TSpinEdit
    Left = 88
    Top = 192
    Width = 49
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 13
    Value = 0
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 288
    Width = 65
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'X-Offset'
    TabOrder = 14
    Text = '0'
    OnExit = LabeledEdit3Exit
    OnKeyPress = LabeledEdit3KeyPress
  end
  object LabeledEdit2: TLabeledEdit
    Left = 79
    Top = 288
    Width = 66
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'Y-Offset'
    TabOrder = 15
    Text = '0'
    OnExit = LabeledEdit3Exit
    OnKeyPress = LabeledEdit3KeyPress
  end
  object LabeledEdit3: TLabeledEdit
    Left = 8
    Top = 253
    Width = 65
    Height = 21
    Anchors = [akLeft, akBottom]
    EditLabel.Width = 38
    EditLabel.Height = 13
    EditLabel.Caption = 'X-Breite'
    TabOrder = 16
    Text = '32'
    OnExit = LabeledEdit3Exit
    OnKeyPress = LabeledEdit3KeyPress
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 208
    Width = 65
    Height = 17
    Caption = 'Mandelb2'
    TabOrder = 17
  end
end
