unit FrmTestFpvHTTPClient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, VisualHTTPClient, fphttpclient;

type

  { TTestFpHTTPClientMain }

  TTestFpHTTPClientMain = class(TForm)
    btnOpenURL: TButton;
    EdtURL: TEdit;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    VisualHTTPClient1: TVisualHTTPClient;
    procedure btnOpenURLClick(Sender: TObject);
    procedure VisualHTTPClient1DataReceived(Sender: TObject;
      const ContentLength, CurrentPos: Int64);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  TestFpHTTPClientMain: TTestFpHTTPClientMain;

implementation

{$R *.lfm}

{ TTestFpHTTPClientMain }

procedure TTestFpHTTPClientMain.VisualHTTPClient1DataReceived(Sender: TObject;
  const ContentLength, CurrentPos: Int64);
begin

end;

procedure TTestFpHTTPClientMain.btnOpenURLClick(Sender: TObject);
begin
  memo1.Lines.text:=VisualHTTPClient1.Get(EdtURL.text);
end;

end.

