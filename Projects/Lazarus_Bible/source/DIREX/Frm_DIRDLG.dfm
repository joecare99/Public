object DirDlgForm: TDirDlgForm
  Left = 203
  Top = 109
  Caption = 'Directory Dialog'
  ClientHeight = 238
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  DesignSize = (
    502
    238)
  PixelsPerInch = 96
  TextHeight = 14
  object FileNameLabel: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 14
    Caption = 'File &Name'
    Color = clBtnFace
    FocusControl = FileNameEdit
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object DirectoriesLabel: TLabel
    Left = 221
    Top = 8
    Width = 61
    Height = 14
    Anchors = [akTop, akRight]
    Caption = '&Directories'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object DirLabel: TLabel
    Left = 221
    Top = 27
    Width = 169
    Height = 14
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'V:\...\Delphi\Delphi Bible\DXE2'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object ListFilesLabel: TLabel
    Left = 8
    Top = 169
    Width = 94
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = 'List files of &Type:'
    Color = clBtnFace
    FocusControl = FilterComboBox
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object DrivesLabel: TLabel
    Left = 221
    Top = 169
    Width = 35
    Height = 14
    Anchors = [akRight, akBottom]
    Caption = 'Dri&ves'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object FilterComboBox: TFilterComboBox
    Left = 8
    Top = 185
    Width = 200
    Height = 22
    Anchors = [akLeft, akRight, akBottom]
    Filter = 
      'All files (*.*)|*.*|Executable files (*.exe)|*.exe|Executable fi' +
      'les (*.com)|*.com|Dos batch files (*.bat)|*.bat|Dos Pif files (*' +
      '.pif)|*.pif|Windows help files (*.hlp)|*.hlp|Windows bitmap file' +
      's (*.bmp)|*.bmp|Text files (*.txt)|*.txt'
    TabOrder = 1
  end
  object FileNameEdit: TEdit
    Left = 8
    Top = 24
    Width = 200
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '*.*'
  end
  object OkBitBtn: TBitBtn
    Left = 405
    Top = 16
    Width = 89
    Height = 49
    Anchors = [akTop, akRight]
    Caption = 'O&k'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
  end
  object CancelBitBtn: TBitBtn
    Left = 405
    Top = 80
    Width = 89
    Height = 49
    Anchors = [akTop, akRight]
    Caption = '&Cancel'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 5
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 215
    Width = 502
    Height = 23
    Panels = <>
  end
  object FileListBox: TFileListBox
    Left = 8
    Top = 52
    Width = 200
    Height = 105
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 14
    TabOrder = 3
    OnDblClick = FileListBoxDblClick
  end
  object DirectoryListBox: TDirectoryListBox
    Left = 212
    Top = 50
    Width = 172
    Height = 107
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 6
  end
  object DriveComboBox: TDriveComboBox
    Left = 211
    Top = 185
    Width = 171
    Height = 20
    Anchors = [akRight, akBottom]
    TabOrder = 7
    OnChange = DriveComboBoxChange
  end
end
