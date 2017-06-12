{  $Id: notebooktest.pp 54031 2017-01-29 21:04:32Z joost $  }
{
 /***************************************************************************
                               NoteBookTest.pp
                             -------------------




 ***************************************************************************/

 ***************************************************************************
 *                                                                         *
 *   This source is free software; you can redistribute it and/or modify   *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This code is distributed in the hope that it will be useful, but      *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   General Public License for more details.                              *
 *                                                                         *
 *   A copy of the GNU General Public License is available on the World    *
 *   Wide Web at <http://www.gnu.org/copyleft/gpl.html>. You can also      *
 *   obtain it by writing to the Free Software Foundation,                 *
 *   Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.   *
 *                                                                         *
 ***************************************************************************
}
{
@abstract(An example application for TNotebook)
@author(NoteBookTest.pp - Marc Weustink <weus@quicknet.nl>)
}
unit frm_NotebookTestMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, Forms, Buttons, SysUtils, StdCtrls,
  Graphics, ExtCtrls, LclProc;

type
  TFrmNoteBookTestMain = class(TForm)
    Notebook1 : TNotebook;
    btnCreatePage: TButton;
    btnPageBack: TButton;
    btnPageForward: TButton;
    lblPageCount: TLabel;
    procedure Button1CLick(Sender : TObject);
    procedure Button2CLick(Sender : TObject);
    procedure Button3CLick(Sender : TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  FrmNoteBookTestMain: TFrmNoteBookTestMain;

implementation


constructor TFrmNoteBookTestMain.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 1);
  Caption := 'Notebook testing';
  Left := 0;
  Top := 0;
  Width := 700;
  Height := 300;
  Position:= poMainFormCenter;

  btnCreatePage := TButton.Create(Self);
  with btnCreatePage do begin
    Top:= 0;
    Left:= 0;
    AutoSize := true;
    Parent:= Self;
    Caption := 'Create page';
    OnClick := @Button1Click;
  end;

  btnPageBack := TButton.Create(Self);
  with btnPageBack do begin
    AnchorSide[akLeft].Side := asrRight;
    AnchorSide[akLeft].Control := btnCreatePage;
    AnchorSide[akTop].Side := asrCenter;
    AnchorSide[akTop].Control := btnCreatePage;
    AutoSize := true;
    Parent:= Self;
    Caption := 'Back';
    OnClick := @Button2Click;
  end;

  btnPageForward := TButton.Create(Self);
  with btnPageForward do begin
    AnchorSide[akLeft].Side := asrRight;
    AnchorSide[akLeft].Control := btnPageBack;
    AnchorSide[akTop].Side := asrCenter;
    AnchorSide[akTop].Control := btnPageBack;
    AutoSize := true;
    Parent:= Self;
    Caption := 'Forward';
    OnClick := @Button3Click;
  end;

  lblPageCount := TLabel.Create(Self);
  with lblPageCount do begin
    AnchorSide[akLeft].Side := asrRight;
    BorderSpacing.Left := 6;
    AnchorSide[akLeft].Control := btnPageForward;
    AnchorSide[akTop].Side := asrCenter;
    AnchorSide[akTop].Control := btnPageForward;
    Parent:= Self;
    Caption := '0 pages total';
  end;

  NoteBook1 := TNoteBook.Create(Self);
  with NoteBook1 do
  begin
    AnchorSide[akTop].Side := asrBottom;
    AnchorSide[akTop].Control := btnCreatePage;
    Align := alBottom;
    Anchors := Anchors + [akTop];
    Parent:= Self;
  end;
end;

procedure TFrmNoteBookTestMain.Button1Click(Sender : TObject);
var
  NewPageIndex: integer;
  NewPage: TPage;
  PageLabel: TLabel;
begin
  NewPageIndex := Notebook1.Pages.Add(Format('[Page %d]', [Notebook1.Pages.Count]));
  NewPage := Notebook1.Page[NewPageIndex];
  PageLabel := TLabel.Create(Self);
  with PageLabel do
  begin
    Left := 20;
    Top := 10 + NewPageIndex * 20;
    Width := 500;
    Height := 20;
    Caption := Format('This is page [%d]',[NewPageIndex]);
    Parent := NewPage;
  end;
  lblPageCount.Caption := IntToStr(Notebook1.PageCount)+ ' pages total';
end;

procedure TFrmNoteBookTestMain.Button2Click(Sender : TObject);
begin
  if Notebook1.PageIndex>0 then
    Notebook1.PageIndex:=Notebook1.PageIndex-1;
end;

procedure TFrmNoteBookTestMain.Button3Click(Sender : TObject);
begin
  if Notebook1.PageIndex<Notebook1.PageCount-1 then
    Notebook1.PageIndex:=Notebook1.PageIndex+1;
end;


end.


