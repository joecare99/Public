unit AHW52RelatedPersonSelectionFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Forms, StdCtrls, DBGrids;

type
  TAHW52RelatedPersonSelectionFrame = class(TFrame)
  published
    Label27: TLabel;
    DBGrid2: TDBGrid;
    procedure DBGrid2DblClick(Sender: TObject);
  public
    procedure TabSheet7Enter(Sender: TObject);
    procedure TabSheet7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

implementation

uses
  PersonSearchForm;

{$R *.lfm}

procedure TAHW52RelatedPersonSelectionFrame.DBGrid2DblClick(Sender: TObject);
begin
end;

procedure TAHW52RelatedPersonSelectionFrame.TabSheet7Enter(Sender: TObject);
begin
end;

procedure TAHW52RelatedPersonSelectionFrame.TabSheet7MouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbRight then
    Exit;
  if PersonSearchDialog = nil then
    raise EInvalidOperation.Create(
      'The person-search dialog must be created before right-click selection.');
  PersonSearchDialog.ShowForSelection;
end;

end.
