object Form18: TForm18
  Left = 171
  Top = 140
  BorderStyle = bsSingle
  Caption = 'Globale Suche'
  ClientHeight = 317
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 8
    Top = 288
    Width = 150
    Height = 13
    Caption = 'Ort (Suche in allen Ortsfeldern): '
  end
  object SpeedButton1: TSpeedButton
    Left = 555
    Top = 5
    Width = 75
    Height = 25
    Caption = '&Suchen'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
    OnClick = SpeedButton1Click
  end
  object Memo1: TMemo
    Left = 176
    Top = 174
    Width = 185
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = -1
    Top = -1
    Width = 551
    Height = 277
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 11
      Width = 54
      Height = 16
      Caption = 'und/oder '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 339
      Top = 11
      Width = 28
      Height = 16
      Caption = 'Wert'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 257
      Top = 11
      Width = 61
      Height = 16
      Caption = 'Bedingung'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 87
      Top = 11
      Width = 25
      Height = 16
      Caption = 'Feld'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Shape1: TShape
      Left = 11
      Top = 35
      Width = 504
      Height = 1
    end
    object SpeedButton2: TSpeedButton
      Left = 521
      Top = 49
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 521
      Top = 73
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 521
      Top = 97
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 521
      Top = 121
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton5Click
    end
    object SpeedButton6: TSpeedButton
      Left = 521
      Top = 145
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton6Click
    end
    object SpeedButton7: TSpeedButton
      Left = 521
      Top = 169
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton7Click
    end
    object SpeedButton8: TSpeedButton
      Left = 521
      Top = 193
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton8Click
    end
    object SpeedButton9: TSpeedButton
      Left = 521
      Top = 217
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton9Click
    end
    object SpeedButton10: TSpeedButton
      Left = 521
      Top = 241
      Width = 22
      Height = 21
      Hint = 'Zeile l'#246'schen'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
        555557777F777555F55500000000555055557777777755F75555005500055055
        555577F5777F57555555005550055555555577FF577F5FF55555500550050055
        5555577FF77577FF555555005050110555555577F757777FF555555505099910
        555555FF75777777FF555005550999910555577F5F77777775F5500505509990
        3055577F75F77777575F55005055090B030555775755777575755555555550B0
        B03055555F555757575755550555550B0B335555755555757555555555555550
        BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
        50BB555555555555575F555555555555550B5555555555555575}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton10Click
    end
  end
  object ComboBox1: TComboBox
    Left = 87
    Top = 47
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnExit = ComboBox1Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox2: TComboBox
    Left = 257
    Top = 47
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit1: TEdit
    Left = 339
    Top = 47
    Width = 160
    Height = 21
    TabOrder = 4
  end
  object ComboBox3: TComboBox
    Left = 87
    Top = 71
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    OnExit = ComboBox3Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox4: TComboBox
    Left = 257
    Top = 71
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit2: TEdit
    Left = 339
    Top = 71
    Width = 160
    Height = 21
    TabOrder = 7
  end
  object ComboBox5: TComboBox
    Left = 87
    Top = 95
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    OnExit = ComboBox5Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox6: TComboBox
    Left = 257
    Top = 95
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit3: TEdit
    Left = 339
    Top = 95
    Width = 160
    Height = 21
    TabOrder = 10
  end
  object ComboBox7: TComboBox
    Left = 87
    Top = 119
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 11
    OnExit = ComboBox7Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox8: TComboBox
    Left = 257
    Top = 119
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 12
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit4: TEdit
    Left = 339
    Top = 119
    Width = 160
    Height = 21
    TabOrder = 13
  end
  object ComboBox9: TComboBox
    Left = 87
    Top = 143
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 14
    OnExit = ComboBox9Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox10: TComboBox
    Left = 257
    Top = 143
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 15
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit5: TEdit
    Left = 339
    Top = 143
    Width = 160
    Height = 21
    TabOrder = 16
  end
  object ComboBox11: TComboBox
    Left = 87
    Top = 167
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 17
    OnExit = ComboBox11Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox12: TComboBox
    Left = 257
    Top = 167
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 18
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit6: TEdit
    Left = 339
    Top = 167
    Width = 160
    Height = 21
    TabOrder = 19
  end
  object ComboBox13: TComboBox
    Left = 87
    Top = 191
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 20
    OnExit = ComboBox13Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox14: TComboBox
    Left = 257
    Top = 191
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 21
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit7: TEdit
    Left = 339
    Top = 191
    Width = 160
    Height = 21
    TabOrder = 22
  end
  object ComboBox15: TComboBox
    Left = 10
    Top = 71
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 26
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox16: TComboBox
    Left = 10
    Top = 95
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 27
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox17: TComboBox
    Left = 10
    Top = 119
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 32
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox18: TComboBox
    Left = 10
    Top = 143
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 31
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox19: TComboBox
    Left = 10
    Top = 167
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 33
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox20: TComboBox
    Left = 10
    Top = 191
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 34
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object Edit8: TEdit
    Left = 339
    Top = 215
    Width = 160
    Height = 21
    TabOrder = 25
  end
  object ComboBox21: TComboBox
    Left = 257
    Top = 215
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 24
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object ComboBox22: TComboBox
    Left = 87
    Top = 215
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 23
    OnExit = ComboBox22Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox23: TComboBox
    Left = 10
    Top = 215
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 35
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox24: TComboBox
    Left = 10
    Top = 239
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 36
    TabStop = False
    Items.Strings = (
      'und'
      'oder'
      'nicht')
  end
  object ComboBox25: TComboBox
    Left = 87
    Top = 239
    Width = 143
    Height = 21
    ItemHeight = 13
    TabOrder = 28
    OnExit = ComboBox25Exit
    Items.Strings = (
      'Name'
      'and.Namensschreibw.'
      'Vornamen'
      'Rufname'
      'Geschlecht'
      'lebt'
      'Bekenntnis'
      'Beruf'
      'Hofname'
      'ID-Nr.'
      'Geburt: Tag'
      'Geburt: Monat'
      'Geburt: Jahr'
      'Geburtsort'
      'Taufe: Tag'
      'Taufe: Monat'
      'Taufe: Jahr'
      'Taufort'
      'Taufpate'
      'Lebensort'
      'Tod: Tag'
      'Tod: Monat'
      'Tod: Jahr'
      'Sterbeort'
      'Todesursache'
      'Bestattung: Tag'
      'Bestattung: Monat'
      'Bestattung: Jahr'
      'Bestattungsort'
      'Text'
      'Verbindung'
      'K.Heirat: Tag'
      'K.Heirat: Monat'
      'K.Heirat: Jahr'
      'K.Heiratsort'
      'K.Trauzeuge'
      'S.Heirat: Tag'
      'S.Heirat: Monat'
      'S.Heirat: Jahr'
      'S.Heiratsort'
      'S.Trauzeuge'
      'Scheidung: Tag'
      'Scheidung: Monat'
      'Scheidung: Jahr'
      'Scheidungsort'
      'Datensatz-Nr.'
      'Partner-Name')
  end
  object ComboBox26: TComboBox
    Left = 257
    Top = 239
    Width = 51
    Height = 21
    Hint = #39'in'#39' = enthalten in'
    ItemHeight = 13
    TabOrder = 29
    Items.Strings = (
      '='
      '>'
      '<'
      '>='
      '<='
      '<>'
      'in')
  end
  object Edit9: TEdit
    Left = 339
    Top = 239
    Width = 160
    Height = 21
    TabOrder = 30
  end
  object Button5: TButton
    Left = 555
    Top = 40
    Width = 75
    Height = 25
    Caption = 'alle &l'#246'schen'
    TabOrder = 37
    TabStop = False
    OnClick = Button5Click
  end
  object Button7: TButton
    Left = 555
    Top = 73
    Width = 75
    Height = 25
    Caption = 'S&peichern'
    Enabled = False
    TabOrder = 38
    TabStop = False
    OnClick = Button7Click
  end
  object Edit23: TEdit
    Left = 161
    Top = 286
    Width = 192
    Height = 19
    TabStop = False
    AutoSize = False
    MaxLength = 40
    TabOrder = 39
  end
  object BitBtn2: TBitBtn
    Left = 555
    Top = 251
    Width = 75
    Height = 25
    Caption = '&Ende'
    TabOrder = 40
    TabStop = False
    OnClick = BitBtn2Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object Button1: TButton
    Left = 556
    Top = 108
    Width = 75
    Height = 25
    Caption = 'Gedcom schr.'
    TabOrder = 41
    TabStop = False
    OnClick = Button1Click
  end
  object Query1: TQuery
    Left = 560
    Top = 72
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Textdateien (*.txt)|*.txt'
    Left = 600
    Top = 72
  end
end
