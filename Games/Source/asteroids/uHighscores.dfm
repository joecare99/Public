object Highscores: THighscores
  Left = 400
  Top = 341
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'highscores'
  ClientHeight = 288
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = Form_Create
  OnDestroy = Form_Destroy
  OnKeyPress = Form_KeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PanelList: TPanel
    Left = 16
    Top = 16
    Width = 352
    Height = 256
    BevelOuter = bvLowered
    TabOrder = 0
    object ListView: TListView
      Left = 1
      Top = 1
      Width = 350
      Height = 254
      Align = alClient
      BorderStyle = bsNone
      Columns = <
        item
          Caption = 'player'
          Width = 128
        end
        item
          Alignment = taRightJustify
          Caption = 'score'
          Width = 96
        end
        item
          Alignment = taRightJustify
          Caption = 'levels'
          Width = 96
        end>
      ColumnClick = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = []
      ReadOnly = True
      RowSelect = True
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
