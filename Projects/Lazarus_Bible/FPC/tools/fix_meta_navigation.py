"""Stellt die Meta-App auf TPageControl um und ergaenzt die Navigation.

Der Reiter-Balken des TTabControl wird vom Widgetset gezeichnet und ist
weder im gerenderten Bild noch zuverlaessig sichtbar. Mit dem TPageControl
gibt es eine echte, in LCL gezeichnete Reiterleiste. Zusaetzlich entsteht
unten eine Navigationsleiste (wie bei einem Assistenten).

  python3 FPC/tools/fix_meta_navigation.py
"""

import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
LFM = os.path.join(ROOT, 'FPC', 'meta', 'units', 'BibleExplorerMain.lfm')
PAS = os.path.join(ROOT, 'FPC', 'meta', 'units', 'BibleExplorerMain.pas')

# --- LFM ------------------------------------------------------------------
with open(LFM, 'r', encoding='utf-8', errors='replace') as fh:
    lfm = fh.read()

lfm = lfm.replace("""  object PageControl: TPageControl
    Left = 256
    Top = 0
    Width = 724
    Height = 620""", """  object PageControl: TPageControl
    Left = 256
    Top = 0
    Width = 724
    Height = 572""")
lfm = lfm.replace("      ClientHeight = 590\n", "      ClientHeight = 542\n")

nav = """  object pnlNav: TPanel
    Left = 256
    Top = 576
    Width = 724
    Height = 44
    Anchors = [akLeft, akRight, akBottom]
    BevelOuter = bvLowered
    object btnPrev: TButton
      Left = 8
      Top = 8
      Width = 90
      Height = 25
      Caption = '< Zurueck'
      TabOrder = 0
      OnClick = btnPrevClick
    end
    object btnNextPage: TButton
      Left = 104
      Top = 8
      Width = 90
      Height = 25
      Caption = 'Weiter >'
      TabOrder = 1
      OnClick = btnNextPageClick
    end
    object lblPage: TLabel
      Left = 208
      Top = 12
      Width = 300
      Height = 17
      Caption = 'Ueberblick'
    end
  end
"""
lfm = lfm.replace("  object lblStatus: TLabel\n    Left = 256\n    Top = 600\n",
                  nav + "  object lblStatus: TLabel\n    Left = 516\n    Top = 588\n")

with open(LFM, 'w', encoding='utf-8', errors='replace', newline='') as fh:
    fh.write(lfm)

# --- Pascal ---------------------------------------------------------------
with open(PAS, 'r', encoding='utf-8', errors='replace') as fh:
    pas = fh.read()

pas = pas.replace('TabControl: TTabControl;', 'PageControl: TPageControl;')
pas = pas.replace('procedure TabControlChange(Sender: TObject);',
                  'procedure PageControlChange(Sender: TObject);')
pas = pas.replace('procedure TBibleExplorerForm.TabControlChange(Sender: TObject);',
                  'procedure TBibleExplorerForm.PageControlChange(Sender: TObject);')
pas = pas.replace('TabControl.ActivePage', 'PageControl.ActivePage')
pas = pas.replace('TabControl.TabIndex', 'PageControl.ActivePageIndex')
pas = pas.replace('PageControl.ActivePageIndex := 2;', 'PageControl.ActivePage := tabBehavior;')
pas = pas.replace('PageControl.ActivePageIndex := 1;', 'PageControl.ActivePage := tabCode;')

# Felder und Ereignisse
pas = pas.replace("""    btnNext: TButton;
    btnPrevious: TButton;""",
                  """    btnNext: TButton;
    btnPrevious: TButton;
    btnPrev: TButton;
    btnNextPage: TButton;
    lblPage: TLabel;
    pnlNav: TPanel;""")
pas = pas.replace("""    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);""",
                  """    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure UpdatePageInfo;""")

# Methoden
pas = pas.replace("""procedure TBibleExplorerForm.btnNextClick(Sender: TObject);
begin
  codeView.NextMarker;
end;""",
                  """procedure TBibleExplorerForm.btnNextClick(Sender: TObject);
begin
  codeView.NextMarker;
end;

{ Wechselt zur vorherigen Seite (wie bei einem Assistenten). }
procedure TBibleExplorerForm.btnPrevClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := PageControl.ActivePageIndex - 1;
  if Index < 0 then
    Index := PageControl.PageCount - 1;
  PageControl.ActivePageIndex := Index;
  UpdatePageInfo;
end;

{ Wechselt zur naechsten Seite. }
procedure TBibleExplorerForm.btnNextPageClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := PageControl.ActivePageIndex + 1;
  if Index >= PageControl.PageCount then
    Index := 0;
  PageControl.ActivePageIndex := Index;
  UpdatePageInfo;
end;

{ Zeigt den Namen der aktuellen Seite in der Navigationsleiste. }
procedure TBibleExplorerForm.UpdatePageInfo;
begin
  if PageControl.ActivePage <> nil then
    lblPage.Caption := PageControl.ActivePage.Caption
  else
    lblPage.Caption := '';
end;""")

# Seitenwechsel meldet die Navigation
pas = pas.replace("""  if PageControl.ActivePageIndex = 2 then
    ShowBehavior;""",
                  """  if PageControl.ActivePage = tabBehavior then
    ShowBehavior;
  UpdatePageInfo;""")

with open(PAS, 'w', encoding='utf-8', errors='replace', newline='') as fh:
    fh.write(pas)

print('Meta-Navigation angepasst')
