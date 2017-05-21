unit frm_TestLocalTimeMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses dateutils;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var NowTime: TDateTime;
begin
  NowTime :=Now;                                                                //Save nowtime
  Memo1.Lines.Add('Now: ' + FormatDateTime('c',NowTime));
  Memo1.Lines.Add('UTC: ' + FormatDateTime('c',LocalTimeToUniversal(NowTime)));
  Memo1.Lines.Add('Local: ' + FormatDateTime('c',UniversalTimeToLocal(LocalTimeToUniversal(NowTime))));
end;


end.

