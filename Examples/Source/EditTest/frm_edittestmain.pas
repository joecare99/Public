unit Frm_EditTestMain;

{$mode objfpc}{$H+}

interface

uses
  StdCtrls, Buttons, Classes, Forms, Controls, SysUtils, Graphics,
  SynEdit, SynHighlighterPas, SynGutterLineNumber;

type
  TEditTestForm = class(TForm)
  public
    FText: TEdit;
    FEdit: TSynEdit;
    FHighlighter: TSynPasSyn;
    constructor Create(AOwner: TComponent); override;
  end;

var
  EditTestForm: TEditTestForm;


implementation


{------------------------------------------------------------------------------}
{  TEditTestorm                                          }
{------------------------------------------------------------------------------}
constructor TEditTestForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 1);
  Width := 300;
  Height := 250;
  Left := 200;
  Top := 200;
  Caption := 'Editor tester';

  FHighlighter := TSynPasSyn.Create(Self);
  FHighlighter.CommentAttri.Foreground := clNavy;
  FHighlighter.NumberAttri.Foreground := clRed;
  FHighlighter.KeyAttri.Foreground := clGreen;

  FEdit := TSynEdit.Create(Self);
  with FEdit
  do begin
    Parent := Self;
		Width := 300;
		Height := 200;
    Gutter.Color := clBtnface;
    Gutter.LineNumberPart.Visible := True;
    Color := clWindow;
    Visible := True;
    Font.Name := 'courier';
    Font.Size := 12;
    HighLighter := Self.FHighLighter;
    Anchors:=[akTop, akLeft, akRight, akBottom];
  end;

  FText := TEdit.Create(Self);
  with FText do
  begin
    Parent := Self;
    Top := 208;
		Width := 300;
		Height := 25;
    Visible := True;
    Font.Name := 'courier';
    Font.Size := 12;
    Anchors:=[ akLeft, akRight, akBottom];
  end;
end;
end.

