unit frm_SynColors;
// Project Full Name: OpenC2Pas
// CVS Server:        cvs.c2pas.sourceforge.net
// Home page:         http:/c2pas.sourceforge.net
// -----------------------------------------------------------------------------
// Syntax color dialog
// -----------------------------------------------------------------------------
//
// Copyright (C) 2002 Alberto Berardi
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

interface

uses
  {$IFNDEF FPC} Windows, Messages, ColorGrd,ImgList,  {$ENDIF}SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,  SynEditHighlighter, Menus;

const
   MaxAttri = 7;

type

  { TForm_SynColors }

  TForm_SynColors = class(TForm)
    GroupBox1: TGroupBox;
    CB_Bold: TCheckBox;
    CB_Italic: TCheckBox;
    CB_Underline: TCheckBox;
    CB_StrikeOut: TCheckBox;
    Panel1: TPanel;
    LblPreview: TLabel;
    CancelBtn: TButton;
    OKBtn: TButton;
    LB_Attri: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    PnlBgCol: TPanel;
    PnlFgCol: TPanel;
    ColorDialog1: TColorDialog;
    PopupMenu_Colors: TPopupMenu;
    None1: TMenuItem;
    Black1: TMenuItem;
    Red1: TMenuItem;
    Green1: TMenuItem;
    Olive1: TMenuItem;
    Navy1: TMenuItem;
    Purple1: TMenuItem;
    Teal1: TMenuItem;
    Gray1: TMenuItem;
    Silver1: TMenuItem;
    Red2: TMenuItem;
    Lime1: TMenuItem;
    Yellow1: TMenuItem;
    Fuchsia1: TMenuItem;
    N2: TMenuItem;
    Aqua1: TMenuItem;
    Blue1: TMenuItem;
    White1: TMenuItem;
    ImageList1: TImageList;
    N1: TMenuItem;
    Cancel1: TMenuItem;
    procedure CB_BoldClick(Sender: TObject);
    procedure CB_ItalicClick(Sender: TObject);
    procedure CB_UnderlineClick(Sender: TObject);
    procedure CB_StrikeOutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LB_AttriClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PnlFgColClick(Sender: TObject);
    procedure White1Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    TrgPnl : TPanel; // see PnlFgColClick() and White1Click()
    // Temp. values. If the user presses OK, they are assigned to SynPas
    procedure SetPnlColor(Panel:TPanel; aColor:TColor);
  public
    { Public declarations }
    Attri: array [0..MaxAttri] of TSynHighlighterAttributes;
    class procedure CopyAttri(const Src, Dest: TSynHighlighterAttributes);
  end;

var
  Form_SynColors: TForm_SynColors;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

const
   PredefColor: array [0..16] of TColor =
   (clNone,
    clBlack, clMaroon, clGreen, clOlive,  clNavy, clPurple,  clTeal,  clSilver,
    clGray,  clRed,    clLime,  clYellow, clBlue, clFuchsia, clAqua, clWhite);

procedure TForm_SynColors.SetPnlColor(Panel:TPanel; aColor:TColor);
begin
   if aColor = clNone then
   begin
      Panel.Color := clBtnFace;
      Panel.Caption := 'X';
      if Panel = PnlBgCol then
         LblPreview.Color := clWindow
      else
         LblPreview.Font.Color := clWindowText;
   end else begin
      Panel.Color := aColor;
      Panel.Caption := '';
      if Panel = PnlBgCol then
         LblPreview.Color := aColor
      else
         LblPreview.Font.Color := aColor;
   end;
end;

class procedure TForm_SynColors.CopyAttri(const Src, Dest: TSynHighlighterAttributes);
begin
     Dest.Background := Src.Background;
     Dest.Foreground := Src.Foreground;
     Dest.Style := Src.Style;
end;

procedure TForm_SynColors.CB_BoldClick(Sender: TObject);
begin
   if CB_Bold.Checked then begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style + [fsBold];
      LblPreview.Font.Style := LblPreview.Font.Style + [fsBold];
   end else begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style - [fsBold];
      LblPreview.Font.Style := LblPreview.Font.Style - [fsBold];
   end;
end;

procedure TForm_SynColors.CB_ItalicClick(Sender: TObject);
begin
   if CB_Italic.Checked then begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style + [fsItalic];
      LblPreview.Font.Style := LblPreview.Font.Style + [fsItalic];
   end else begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style - [fsItalic];
      LblPreview.Font.Style := LblPreview.Font.Style - [fsItalic];
   end;
end;

procedure TForm_SynColors.CB_UnderlineClick(Sender: TObject);
begin
   if CB_Underline.Checked then begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style + [fsUnderline];
      LblPreview.Font.Style := LblPreview.Font.Style + [fsUnderline];
   end else begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style - [fsUnderline];
      LblPreview.Font.Style := LblPreview.Font.Style - [fsUnderline];
   end;
end;

procedure TForm_SynColors.CB_StrikeOutClick(Sender: TObject);
begin
   if CB_StrikeOut.Checked then begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style + [fsStrikeOut];
      LblPreview.Font.Style := LblPreview.Font.Style + [fsStrikeOut];
   end else begin
      Attri[LB_Attri.ItemIndex].Style := Attri[LB_Attri.ItemIndex].Style - [fsStrikeOut];
      LblPreview.Font.Style := LblPreview.Font.Style - [fsStrikeOut];
   end;
end;

procedure TForm_SynColors.FormShow(Sender: TObject);
begin
   // Load values from Form1 (main.pas)
   LB_Attri.ItemIndex := 0;
   LB_AttriClick(nil);
end;

procedure TForm_SynColors.LB_AttriClick(Sender: TObject);
begin
   if(LB_Attri.ItemIndex >= 0) then
   begin
      LblPreview.Caption := LB_Attri.Items[LB_Attri.ItemIndex];
      SetPnlColor(PnlFgCol, Attri[LB_Attri.ItemIndex].Foreground);
      SetPnlColor(PnlBgCol, Attri[LB_Attri.ItemIndex].Background);
      CB_Bold.Checked := fsBold in Attri[LB_Attri.ItemIndex].Style;
      CB_Italic.Checked := fsItalic in Attri[LB_Attri.ItemIndex].Style;
      CB_Underline.Checked := fsUnderline in Attri[LB_Attri.ItemIndex].Style;
      CB_StrikeOut.Checked := fsStrikeOut in Attri[LB_Attri.ItemIndex].Style;
   end;
end;

procedure TForm_SynColors.FormCreate(Sender: TObject);
var
   n:Integer;
begin
   for n:=0 to MaxAttri do
      Attri[n] := TSynHighlighterAttributes.Create(LB_Attri.Items[n]);
end;

procedure TForm_SynColors.PnlFgColClick(Sender: TObject);
var
   P:TPoint;
begin
   TrgPnl := Sender as TPanel;
   P.X := 0; P.Y := 0;
   P := TrgPnl.ClientToScreen(P);
   PopupMenu_Colors.Popup(P.X, P.Y);
end;

procedure TForm_SynColors.White1Click(Sender: TObject);
begin
   With Sender as TMenuItem do
   begin
      SetPnlColor(TrgPnl, PredefColor[ImageIndex]);
      if TrgPnl = PnlBgCol then
         Attri[LB_Attri.ItemIndex].Background := PredefColor[ImageIndex]
      else
         Attri[LB_Attri.ItemIndex].Foreground := PredefColor[ImageIndex];
   end;
end;

procedure TForm_SynColors.OKBtnClick(Sender: TObject);
begin
   // Copy values to Form1 (main.pas)
   Close;
end;

procedure TForm_SynColors.FormDestroy(Sender: TObject);
var
   n:Integer;
begin
   for n:=0 to MaxAttri do
      Attri[n].Free;
end;

end.
