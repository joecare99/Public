unit frm_OdfBrowserMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, fra_OdfFile;

type

  { TFrmBrowseOdfMain }

  TFrmBrowseOdfMain = class(TForm)
    FraOdfBrowser: TFraOdfBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private

  public

  end;

var
  FrmBrowseOdfMain: TFrmBrowseOdfMain;

implementation

{$R *.lfm}

{ TFrmBrowseOdfMain }

procedure TFrmBrowseOdfMain.FormCreate(Sender: TObject);
begin
  FraOdfBrowser := TFraOdfBrowser.create(self);
  FraOdfBrowser.parent := self;
  FraOdfBrowser.Align:=alClient;
end;

procedure TFrmBrowseOdfMain.FormDestroy(Sender: TObject);
begin

end;

end.

