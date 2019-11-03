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

{$R *.lfm}

{ TFrmPlaceEditMain }

procedure TFrmPlaceEditMain.FormCreate(Sender: TObject);
begin
  FraPlaceEdit1:= TFraPlaceEdit.Create(self);
  FraPlaceEdit1.Parent:= self;
  FraPlaceEdit1.Align:=alClient;
end;

end.
