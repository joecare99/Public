unit Frm_TstFileUnt;

{$ifdef FPC}
{$mode delphi}
{$endif}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, unt_fileprocs,
  Dialogs,  StdCtrls,unt_stringprocs, unt_allgfunklib;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Edit3: TEdit;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
     function OnReply(perc: real; apath: string):boolean;
   public
   { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}


procedure TForm1.Button1Click(Sender: TObject);

var fls,p:Tfiles;

begin
  button2.Enabled := true;
  fls:=getfiles(edit1.text,edit2.text,onreply,0,20000);
  memo1.lines.Clear;
  p:=fls;
  while assigned(p) do
    begin
      memo1.lines.Add(p.Name +#9+p.pfad);
      p:=p.getnext as TFiles;
    end;
  label3.caption:=inttostr(fls.count);
  fls.free;
end;

function TForm1.OnReply;
begin
  label1.caption:=apath;
  label2.caption:=inttostr(trunc(perc / 200))+','+inttostr(trunc(perc/2) mod 100) +'%';
  Application.ProcessMessages;
  result := not button2.enabled;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 memo1.lines.Add(GetBackupPath(Application.exename ));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  label1.caption:= GetSoundex (edit3.text);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  label3.Caption := bool2str[isemptydir(edit3.Text)];
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Makepath(edit3.text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  label2.Caption := getversion(Application.exename);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  memo1.Text := getFileInfo(Application.exename)
end;

end.
