unit AHW52PersonSelectionFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, DBGrids;

type
  TAHW52PersonSelectionFrame = class(TFrame)
  published
    DBGrid1: TDBGrid;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
  public
    procedure SelectionTabExit(Sender: TObject);
    procedure SelectionTabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SelectionTabShow(Sender: TObject);
  end;

implementation

{$R *.lfm}

procedure TAHW52PersonSelectionFrame.DBGrid1DblClick(Sender: TObject);
begin
end;

procedure TAHW52PersonSelectionFrame.DBGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
end;

procedure TAHW52PersonSelectionFrame.SelectionTabExit(Sender: TObject);
begin
end;

procedure TAHW52PersonSelectionFrame.SelectionTabMouseDown(Sender: TObject;
  Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAHW52PersonSelectionFrame.SelectionTabShow(Sender: TObject);
begin
end;

end.
