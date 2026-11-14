unit Frm_Date2StrMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses dateutils;
{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  edit1.Text:= FormatSettings.LongDateFormat;
end;

procedure TForm1.Button1Click(Sender: TObject);
var

  lStr: string;
begin
  DateTimeToString(lStr,edit1.Text,Now,[]);
  memo1.Append('D:'+lStr);
end;

end.

