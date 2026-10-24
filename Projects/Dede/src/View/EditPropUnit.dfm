object EditPropForm: TEditPropForm
  Left = 363
  Top = 177
  BorderStyle = bsToolWindow
  Caption = 'DFM Property Value Editor'
  ClientHeight = 392
  ClientWidth = 424
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
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Property:'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 30
    Height = 13
    Caption = 'Value:'
  end
  object PropNameLbl: TLabel
    Left = 64
    Top = 8
    Width = 76
    Height = 13
    Caption = 'PropNameLbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 40
    Width = 57
    Height = 13
    Caption = 'Value Type:'
  end
  object BitBtn1: TBitBtn
    Left = 256
    Top = 361
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = BitBtn1Click
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 336
    Top = 361
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    NumGlyphs = 2
  end
  object TypeCB: TComboBox
    Left = 80
    Top = 37
    Width = 209
    Height = 21
    Style = csDropDownList
    Color = 15584973
    Enabled = False
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      '<unknown>'
      'Value List'
      'Byte'
      'Word'
      'Double Word'
      'Double Word List'
      'Short String'
      'Custom Type'
      'Boolean'
      'Boolean'
      'Binary Data'
      'Set of Items'
      'String'
      '<unknown>'
      'Name/Value List'
      '')
  end
  object ValueNotebook: TNotebook
    Left = 16
    Top = 80
    Width = 393
    Height = 273
    TabOrder = 3
    object TPage
      Left = 0
      Top = 0
      Caption = 'Default'
      object ValueMemo: TMemo
        Left = 0
        Top = 0
        Width = 393
        Height = 273
        Align = alClient
        Color = 15584973
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'StringList'
      object SG: TStringGrid
        Left = 0
        Top = 0
        Width = 393
        Height = 273
        Align = alClient
        Color = 15584973
        ColCount = 1
        DefaultColWidth = 385
        DefaultRowHeight = 16
        FixedCols = 0
        RowCount = 4
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goEditing]
        TabOrder = 0
        OnClick = SGClick
        OnKeyDown = SGKeyDown
        OnSelectCell = SGSelectCell
        OnSetEditText = SGSetEditText
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'ValueList'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 393
        Height = 248
        Align = alClient
        Color = 15584973
        DataSource = MemoryDataSource
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEditButtonClick = DBGrid1EditButtonClick
        Columns = <
          item
            Expanded = False
            FieldName = 'sType'
            PickList.Strings = (
              'Byte'
              'Word'
              'Double Word'
              'Short String'
              'Custom Type'
              'Boolean'
              'Boolean'
              'Binary Data'
              'Set of Items'
              'String'
              '')
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'btType'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'Name'
            Visible = False
          end
          item
            ButtonStyle = cbsEllipsis
            Expanded = False
            FieldName = 'Value'
            ReadOnly = True
            Visible = True
          end>
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 248
        Width = 393
        Height = 25
        DataSource = MemoryDataSource
        VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
        Align = alBottom
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'ValuePairs'
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 393
        Height = 248
        Align = alClient
        Color = 15584973
        DataSource = MemoryDataSource
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnEditButtonClick = DBGrid1EditButtonClick
        Columns = <
          item
            Expanded = False
            FieldName = 'Subitem'
            Width = 43
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'sType'
            PickList.Strings = (
              'Byte'
              'Word'
              'Double Word'
              'Short String'
              'Custom Type'
              'Boolean'
              'Boolean'
              'Binary Data'
              'Set of Items'
              'String'
              '')
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'btType'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'Name'
            Visible = True
          end
          item
            ButtonStyle = cbsEllipsis
            Expanded = False
            FieldName = 'Value'
            ReadOnly = True
            Visible = True
          end>
      end
      object DBNavigator2: TDBNavigator
        Left = 0
        Top = 248
        Width = 393
        Height = 25
        DataSource = MemoryDataSource
        VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
        Align = alBottom
        TabOrder = 1
      end
    end
  end
  object RxMemoryData: TRxMemoryData
    Active = True
    FieldDefs = <
      item
        Name = 'sType'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'btType'
        DataType = ftInteger
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 256
      end
      item
        Name = 'Value'
        DataType = ftString
        Size = 256
      end
      item
        Name = 'Subitem'
        DataType = ftSmallint
      end>
    Left = 376
    Top = 8
  end
  object MemoryDataSource: TDataSource
    DataSet = RxMemoryData
    Left = 336
    Top = 8
  end
  object ValueMemoPopUp: TPopupMenu
    Left = 304
    Top = 8
    object SelectAll1: TMenuItem
      Caption = 'Select All'
      ShortCut = 16449
      OnClick = SelectAll1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Copy1: TMenuItem
      Caption = 'Copy binary data to clipboard'
    end
    object Copytextdatatoclipboard1: TMenuItem
      Caption = 'Copy text data to clip board'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Pastbinarydatafromclipboard1: TMenuItem
      Caption = 'Paste binary data from clipboard'
    end
    object Paste1: TMenuItem
      Caption = 'Paste text data from clipboard'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Loadbinarydatafromfile1: TMenuItem
      Caption = 'Load binary data from file'
    end
    object Savebinarydatatofile1: TMenuItem
      Caption = 'Save binary data to file'
    end
  end
end
