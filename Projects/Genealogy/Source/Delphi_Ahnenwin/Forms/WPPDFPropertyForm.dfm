object WPPDFPropertyForm: TWPPDFPropertyForm
  Left = 285
  Top = 203
  BorderStyle = bsDialog
  Caption = 'PDF Creation Properties'
  ClientHeight = 322
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 543
    Height = 282
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label4: TLabel
        Left = 11
        Top = 4
        Width = 58
        Height = 16
        Caption = 'Outputfile:'
      end
      object Label1: TLabel
        Left = 10
        Top = 145
        Width = 74
        Height = 16
        Caption = 'Show Mode:'
      end
      object Label11: TLabel
        Left = 10
        Top = 175
        Width = 71
        Height = 16
        Caption = 'Fonts Mode'
      end
      object TextToOutlineLab: TLabel
        Left = 8
        Top = 208
        Width = 155
        Height = 16
        Caption = 'Text to Outline Conversion'
      end
      object CompressionGroup: TRadioGroup
        Left = 6
        Top = 26
        Width = 512
        Height = 43
        Caption = ' Compression '
        Columns = 4
        ItemIndex = 3
        Items.Strings = (
          'none'
          'run length'
          'deflate text'
          'fast deflate text')
        TabOrder = 1
      end
      object EncodeGroup: TRadioGroup
        Left = 6
        Top = 70
        Width = 515
        Height = 43
        Caption = ' encode binary '
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'no encoding'
          'ASCII85'
          'HEX')
        TabOrder = 2
      end
      object CheckBox1: TCheckBox
        Left = 336
        Top = 145
        Width = 151
        Height = 21
        Caption = 'Create Thumbnails'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object CheckBox2: TCheckBox
        Left = 336
        Top = 175
        Width = 182
        Height = 21
        Caption = 'Create Bookmarks'
        Checked = True
        State = cbChecked
        TabOrder = 7
        Visible = False
      end
      object Edit1: TEdit
        Left = 86
        Top = 0
        Width = 433
        Height = 24
        TabOrder = 0
        Text = 'c:\test.PDF'
      end
      object PageMode: TComboBox
        Left = 93
        Top = 143
        Width = 236
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 3
        Items.Strings = (
          'Use None'
          'Use Outlines'
          'Use Thumbs'
          'Full Screen')
      end
      object FontMode: TComboBox
        Left = 93
        Top = 172
        Width = 236
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 4
        Items.Strings = (
          'Use TrueType Fonts'
          'Embed TrueType Fonts'
          'Embed only Symbol TrueType Fonts'
          'Use 14 Base Type1 Fonts'
          'TTF Subsets: only used codepages'
          'TTF Subsets: only used chars')
      end
      object ConvJPEG: TCheckBox
        Left = 8
        Top = 118
        Width = 316
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Convert JPEG image to regular bitmap'
        TabOrder = 8
        Visible = False
      end
      object CIDFonts: TCheckBox
        Left = 8
        Top = 232
        Width = 316
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Embed Fonts using character IDs (CID)'
        TabOrder = 9
        OnClick = CIDFontsClick
      end
      object PDFAMode: TCheckBox
        Left = 336
        Top = 232
        Width = 131
        Height = 17
        Caption = 'PDF/A Mode'
        TabOrder = 10
        OnClick = CIDFontsClick
      end
      object TextToOutline: TComboBox
        Left = 184
        Top = 200
        Width = 145
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 5
        Items.Strings = (
          'off'
          'auto'
          'always')
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'PDF File Info'
      object Label5: TLabel
        Left = 25
        Top = 28
        Width = 47
        Height = 16
        Caption = 'Creator:'
      end
      object Label6: TLabel
        Left = 25
        Top = 59
        Width = 58
        Height = 16
        Caption = 'Producer:'
      end
      object Label7: TLabel
        Left = 25
        Top = 151
        Width = 48
        Height = 16
        Caption = 'Subject:'
      end
      object Label8: TLabel
        Left = 25
        Top = 182
        Width = 62
        Height = 16
        Caption = 'Keywords:'
      end
      object Label9: TLabel
        Left = 25
        Top = 90
        Width = 41
        Height = 16
        Caption = 'Author:'
      end
      object Label10: TLabel
        Left = 25
        Top = 121
        Width = 29
        Height = 16
        Caption = 'Title:'
      end
      object Edit2: TEdit
        Left = 98
        Top = 23
        Width = 424
        Height = 24
        Hint = 'This text may not be changed.'
        Color = clBtnFace
        ReadOnly = True
        TabOrder = 0
        Text = 'wPDF - www.wptools.com'
      end
      object Edit3: TEdit
        Left = 98
        Top = 54
        Width = 423
        Height = 24
        TabOrder = 1
      end
      object Edit4: TEdit
        Left = 98
        Top = 85
        Width = 423
        Height = 24
        TabOrder = 2
      end
      object Edit5: TEdit
        Left = 98
        Top = 116
        Width = 423
        Height = 24
        TabOrder = 3
      end
      object Edit6: TEdit
        Left = 98
        Top = 146
        Width = 423
        Height = 24
        TabOrder = 4
      end
      object Edit7: TEdit
        Left = 98
        Top = 177
        Width = 423
        Height = 24
        TabOrder = 5
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'PDF Security'
      object GroupBox1: TGroupBox
        Left = 25
        Top = 33
        Width = 403
        Height = 190
        TabOrder = 1
        object Label14: TLabel
          Left = 18
          Top = 59
          Width = 92
          Height = 16
          Caption = 'User Password'
        end
        object Label13: TLabel
          Left = 18
          Top = 28
          Width = 100
          Height = 16
          Caption = 'Owner password'
        end
        object EncryptOpt4: TCheckBox
          Left = 230
          Top = 130
          Width = 120
          Height = 21
          Caption = 'Enable Forms'
          TabOrder = 5
        end
        object EncryptOpt3: TCheckBox
          Left = 230
          Top = 106
          Width = 120
          Height = 21
          Caption = 'Enable Change'
          TabOrder = 4
        end
        object EncryptOpt2: TCheckBox
          Left = 58
          Top = 130
          Width = 119
          Height = 21
          Caption = 'Enable Copying'
          TabOrder = 3
        end
        object EncryptOpt1: TCheckBox
          Left = 58
          Top = 106
          Width = 119
          Height = 21
          Caption = 'Enable Printing'
          TabOrder = 2
        end
        object UserPW: TEdit
          Left = 127
          Top = 58
          Width = 261
          Height = 24
          TabOrder = 1
        end
        object OwnerPW: TEdit
          Left = 127
          Top = 25
          Width = 261
          Height = 24
          TabOrder = 0
        end
        object HighSecurity: TCheckBox
          Left = 20
          Top = 160
          Width = 119
          Height = 21
          Caption = '128 bit security'
          TabOrder = 6
        end
      end
      object EncryptIt: TCheckBox
        Left = 26
        Top = 6
        Width = 279
        Height = 21
        Caption = 'Encrypt PDF File'
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'PDF Reading'
      TabVisible = False
      object Label2: TLabel
        Left = 20
        Top = 26
        Width = 83
        Height = 16
        Caption = 'Input PDF File'
      end
      object InputPDF: TEdit
        Left = 123
        Top = 26
        Width = 375
        Height = 24
        TabOrder = 0
        Text = 'c:\input.PDF'
      end
      object InputPDFMode: TRadioGroup
        Left = 20
        Top = 69
        Width = 483
        Height = 149
        Caption = ' Input PDF Mode '
        ItemIndex = 0
        Items.Strings = (
          'Ignore input PDF file'
          'Copy existing file and append new pages to it'
          'Convert pages in existing file into watermarks'
          'Automatically use the pages in the PDF file as watermarks')
        TabOrder = 1
      end
    end
  end
  object Button4: TButton
    Left = 400
    Top = 292
    Width = 135
    Height = 27
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 252
    Top = 292
    Width = 136
    Height = 27
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button5Click
  end
end
