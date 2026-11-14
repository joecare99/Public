object QREnvironmentEditor: TQREnvironmentEditor
  Left = 269
  Top = 193
  BorderStyle = bsDialog
  Caption = 'Editor f'#252'r benutzerdefinierte Funktionen'
  ClientHeight = 269
  ClientWidth = 376
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NewEntryGB: TGroupBox
    Left = 18
    Top = 12
    Width = 343
    Height = 205
    Caption = 'Neuer Eintrag'
    TabOrder = 5
    object Label1: TLabel
      Left = 20
      Top = 32
      Width = 47
      Height = 13
      Caption = 'Name :'
    end
    object Label2: TLabel
      Left = 20
      Top = 66
      Width = 69
      Height = 13
      Caption = 'Ausdruck:'
    end
    object SpeedButton1: TSpeedButton
      Left = 302
      Top = 62
      Width = 23
      Height = 23
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Name: TEdit
      Left = 94
      Top = 30
      Width = 204
      Height = 21
      TabOrder = 0
    end
    object Expression: TEdit
      Left = 94
      Top = 62
      Width = 204
      Height = 21
      TabOrder = 1
    end
    object NewOKBtn: TButton
      Left = 169
      Top = 120
      Width = 75
      Height = 21
      Caption = '&OK'
      TabOrder = 2
      OnClick = NewOKBtnClick
    end
    object NewCancelBtn: TButton
      Left = 250
      Top = 120
      Width = 75
      Height = 21
      Caption = '&Abbrechen'
      TabOrder = 3
      OnClick = NewCancelBtnClick
    end
  end
  object AvailableGB: TGroupBox
    Left = 18
    Top = 12
    Width = 343
    Height = 205
    Caption = 'Verf'#252'gbare UDF-Funktionen'
    TabOrder = 1
    object UDFGrid: TStringGrid
      Left = 16
      Top = 42
      Width = 311
      Height = 151
      ColCount = 2
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goEditing]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = EditBtnClick
      OnSetEditText = UDFGridSetEditText
      ColWidths = (
        123
        165)
    end
    object LocalCB: TRadioButton
      Left = 18
      Top = 18
      Width = 113
      Height = 17
      Caption = 'Lo&kal-Definition'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = LocalCBClick
    end
    object GlobalCB: TRadioButton
      Left = 134
      Top = 18
      Width = 127
      Height = 17
      Caption = '&Global-Definition'
      TabOrder = 2
      OnClick = LocalCBClick
    end
  end
  object VariableOKBtn: TButton
    Left = 300
    Top = 233
    Width = 59
    Height = 21
    Caption = 'Schlie'#223'en'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = VariableOKBtnClick
  end
  object DeleteBtn: TButton
    Left = 168
    Top = 233
    Width = 67
    Height = 21
    Caption = '&L'#246'schen'
    TabOrder = 2
  end
  object EditBtn: TButton
    Left = 94
    Top = 233
    Width = 67
    Height = 21
    Caption = '&Bearbeiten'
    TabOrder = 3
    OnClick = EditBtnClick
  end
  object AddBtn: TButton
    Left = 20
    Top = 233
    Width = 67
    Height = 21
    Caption = 'Hinzu&f'#252'gen'
    TabOrder = 4
    OnClick = AddBtnClick
  end
end
