unit fra_Page1;

{$mode objfpc}{$H+}

interface

uses
  LCLType,Classes, SysUtils, FileUtil, Forms, Controls, DBGrids, GenealogyDataModule;

type

  { TFrame1 }

  TFrame1 = class(TFrame)
    DBGrid1:TDBGrid;
    Procedure DBGrid1KeyDown(Sender:TObject;var Key:Word;SHift:TShiftState);
    Procedure DBGrid1DblClick(Sender:Tobject);
    procedure TabSheet1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

implementation

{$R *.lfm}

{ TFrame1 }

procedure TFrame1.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  SHift: TShiftState);
begin
  if key= vk_escape then

end;

procedure TFrame1.DBGrid1DblClick(Sender: Tobject);
begin

end;

procedure TFrame1.TabSheet1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

end;


end.

