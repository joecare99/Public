object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 548
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MenuBar1
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 529
    Width = 606
    Height = 19
    Panels = <>
  end
  object Memo2: TMemo
    Left = 296
    Top = 192
    Width = 297
    Height = 289
    ReadOnly = True
    TabOrder = 2
    WordWrap = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 281
    Height = 449
    TabOrder = 0
    WordWrap = False
    OnChange = Memo1Change
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 606
    Height = 33
    Align = alTop
    TabOrder = 3
    object btnFileOpen: TSpeedButton
      Left = 296
      Top = 8
      Width = 25
      Height = 22
      OnClick = btnFileOpenClick
    end
    object btnFileSaveAs: TSpeedButton
      Left = 327
      Top = 8
      Width = 25
      Height = 22
      OnClick = mniFileSaveAsClick
    end
    object btnExecute: TSpeedButton
      Left = 358
      Top = 8
      Width = 25
      Height = 22
      OnClick = btnExecuteClick
    end
    object Label1: TLabel
      Left = 531
      Top = 8
      Width = 3
      Height = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 8
      Top = 8
      Width = 281
      Height = 21
      TabOrder = 0
    end
  end
  object ListBox1: TListBox
    Left = 312
    Top = 56
    Width = 185
    Height = 113
    ItemHeight = 13
    TabOrder = 4
  end
  object OpenDialog1: TOpenDialog
    Left = 208
    Top = 216
  end
  object MenuBar1: TMainMenu
    Left = 336
    Top = 48
    object mniFile: TMenuItem
      Caption = 'File'
      object mniFileNew: TMenuItem
        Caption = 'New'
        OnClick = mniFileNewClick
      end
      object mniFileOpen: TMenuItem
        Caption = 'Open ...'
        OnClick = btnFileOpenClick
      end
      object mniFileSave: TMenuItem
        Caption = 'Save'
        Enabled = False
        OnClick = mniFileSaveClick
      end
      object mniFileClose: TMenuItem
        Caption = 'Close'
      end
      object mniFileSaveAs: TMenuItem
        Caption = 'Save As ...'
        OnClick = mniFileSaveAsClick
      end
      object mniBreaker: TMenuItem
        Caption = '-'
      end
      object mniFileExit: TMenuItem
        Caption = 'Exit'
        OnClick = mniFileExitClick
      end
    end
    object mniEdit: TMenuItem
      Caption = 'Edit'
      object mniEditFormat: TMenuItem
        Caption = 'Autoformat'
        OnClick = btnExecuteClick
      end
    end
    object mniOptions: TMenuItem
      Caption = 'Options'
      object mniLang: TMenuItem
        Caption = 'Language'
        object mniLang_en: TMenuItem
          Caption = 'en'
          OnClick = mniLang_enClick
        end
      end
      object mniTestForm: TMenuItem
        Caption = #214'ffne Test-Dialog'
        OnClick = mniTestFormClick
      end
    end
    object mniHelp: TMenuItem
      Caption = '?'
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 256
    Top = 217
  end
  object PopupMenu1: TPopupMenu
    Left = 376
    Top = 219
  end
end
