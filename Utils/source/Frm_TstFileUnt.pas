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
    edtOutput: TMemo;
    btnFindFiles: TButton;
    edtFilter: TEdit;
    edtPfad: TEdit;
    lblPath_Sx: TLabel;
    lblVersion: TLabel;
    lblCount: TLabel;
    btnGetBackupPath: TButton;
    edtText_Pfad: TEdit;
    btnCalcSoundex: TButton;
    btnIsEmptyDir: TButton;
    btnMakeDir: TButton;
    btnGetVersion: TButton;
    btnGetFileInfo: TButton;
    procedure btnGetFileInfoClick(Sender: TObject);
    procedure btnGetVersionClick(Sender: TObject);
    procedure btnMakeDirClick(Sender: TObject);
    procedure btnIsEmptyDirClick(Sender: TObject);
    procedure btnFindFilesClick(Sender: TObject);
    procedure btnGetBackupPathClick(Sender: TObject);
    procedure btnCalcSoundexClick(Sender: TObject);
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


procedure TForm1.btnFindFilesClick(Sender: TObject);

var fls,p:Tfiles;

begin
  btnGetBackupPath.Enabled := true;
  fls:=getfiles(edtFilter.text,edtPfad.text,onreply,0,20000);
  edtOutput.lines.Clear;
  p:=fls;
  while assigned(p) do
    begin
      edtOutput.lines.Add(p.Name +#9+p.pfad);
      p:=p.getnext as TFiles;
    end;
  lblCount.caption:='Count: '+inttostr(fls.count);
  fls.free;
end;

function TForm1.OnReply;
begin
  lblPath_Sx.caption:='Path: '+apath;
  lblVersion.caption:=inttostr(trunc(perc / 200))+','+inttostr(trunc(perc/2) mod 100) +'%';
  Application.ProcessMessages;
  result := not btnGetBackupPath.enabled;
end;

procedure TForm1.btnGetBackupPathClick(Sender: TObject);
begin
 edtOutput.lines.Add(GetBackupPath(Application.exename ));
end;

procedure TForm1.btnCalcSoundexClick(Sender: TObject);
begin
  lblPath_Sx.caption:= 'SoundEx: '+GetSoundex (edtText_Pfad.text);
end;

procedure TForm1.btnIsEmptyDirClick(Sender: TObject);
begin
  lblCount.Caption :='Bool2Str: '+ bool2str[isemptydir(edtText_Pfad.Text)];
end;

procedure TForm1.btnMakeDirClick(Sender: TObject);
begin
  Makepath(edtText_Pfad.text);
end;

procedure TForm1.btnGetVersionClick(Sender: TObject);
begin
  lblVersion.Caption :='Version: '+getversion(Application.exename);
end;

procedure TForm1.btnGetFileInfoClick(Sender: TObject);
begin
  edtOutput.Text := getFileInfo(Application.exename)
end;

end.
