unit frm_TestBtekMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmTestBtekMain }

  TfrmTestBtekMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public

  end;

var
  frmTestBtekMain: TfrmTestBtekMain;

implementation

uses Unt_Btek_Fpl;
{$R *.lfm}

{TfrmTestBtekMain }

procedure TfrmTestBtekMain.Button1Click(Sender: TObject);
begin
  SimpleMessage;
end;

procedure TfrmTestBtekMain.Button2Click(Sender: TObject);
begin
  ShowForm;
end;

procedure TfrmTestBtekMain.Button3Click(Sender: TObject);
begin
  ShowForm2(Application);
end;

end.

