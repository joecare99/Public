unit frm_OpenHTML;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpwebdata, FileUtil, IpHtml, Ipfilebroker, Forms, Controls,
  Graphics, Dialogs, fphttpclient;

type

  { TForm1 }

  TForm1 = class(TForm)
    FPWebDataProvider1: TFPWebDataProvider;
    IpFileDataProvider1: TIpFileDataProvider;
    IpHtmlPanel1: TIpHtmlPanel;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
begin
  IpHtmlPanel1.OpenURL('http://www.jc99.de');
end;

end.

