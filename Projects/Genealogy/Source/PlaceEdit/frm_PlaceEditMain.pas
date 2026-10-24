unit frm_PlaceEditMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  fra_PlaceEdit;

type

  { TFrmPlaceEditMain }

  TFrmPlaceEditMain = class(TForm)
    procedure FormCreate(Sender: TObject);

  private
    FraPlaceEdit1: TFraPlaceEdit;

  public

  end;

var
  FrmPlaceEditMain: TFrmPlaceEditMain;

implementation

uses dm_RNZAnzeigen;
{$R *.lfm}

{ TFrmPlaceEditMain }

procedure TFrmPlaceEditMain.FormCreate(Sender: TObject);
begin
  FraPlaceEdit1:= TFraPlaceEdit.Create(self);
  FraPlaceEdit1.Parent:= self;
  FraPlaceEdit1.Align:=alClient;
  FraPlaceEdit1.DataSource1.DataSet:=dmRNZAnzeigen.qryTableOrte;
end;

end.
