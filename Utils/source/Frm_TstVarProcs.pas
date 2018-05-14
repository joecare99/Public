unit Frm_TstVarProcs;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*v 1.00.10}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
   SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,variants,Unt_AllgFunkLib,Unt_stringprocs,Unt_VariantProcs;


type
  TTesttype  = record
        By:byte;
        wo:word;
        int:integer;
        t:packed array[0..7] of boolean;
  end;

  TfrmTstVarProcsMain = class(TForm)
    btnVar2String: TButton;
    Memo1: TMemo;
    btnGetRealSize: TButton;
    btnVar2String2: TButton;
    btnVar2Aob: TButton;
    btnMoveRandom2Aob: TButton;
    btnVar2AobOfSt: TButton;
    procedure btnVar2StringClick(Sender: TObject);
    procedure btnGetRealSizeClick(Sender: TObject);
    procedure btnVar2String2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnVar2AobClick(Sender: TObject);
    procedure btnMoveRandom2AobClick(Sender: TObject);
    procedure btnVar2AobOfStClick(Sender: TObject);
  private
    vari:variant;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmTstVarProcsMain: TfrmTstVarProcsMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TfrmTstVarProcsMain.btnVar2StringClick(Sender: TObject);

var test1:STring;
//    vari:variant;
begin
  test1:=Var2string (vari);
  memo1.Lines.text:=test1;
end;

procedure TfrmTstVarProcsMain.btnGetRealSizeClick(Sender: TObject);

var test1:STring;
//    vari:variant;

begin
  test1:=inttostr(getrealsize(vari));
  memo1.Lines.text:=test1;
  test1:=inttostr(sizeof(vari));
  memo1.Lines.add(test1);

end;

procedure TfrmTstVarProcsMain.btnVar2String2Click(Sender: TObject);
var test1:STring;
//    vari:variant;
begin
  test1:=Var2string (vari,true);
  memo1.Lines.text:=test1;
end;

procedure TfrmTstVarProcsMain.FormCreate(Sender: TObject);
begin
    vari:=vararrayof([2,word(6),true,4.0,
         vararrayof ([false,true,true,false, true,true]),
         vararrayof ([true,true,true,true, true,true,false,True,false]),
         vararrayof ([byte(1),byte(2),byte(3),byte(4),byte(5)]),$fffffff,'Dies Ist ein Test']);

end;

procedure TfrmTstVarProcsMain.btnVar2AobClick(Sender: TObject);

var aob:Taob;


begin
  aob:=var2aob(vari);
  memo1.text:=AoB2String(aob)
end;

procedure TfrmTstVarProcsMain.btnMoveRandom2AobClick(Sender: TObject);

var aob:Taob;
    tt:TTesttype;



begin
  tt.by:=random(256);
  tt.wo:=random(65535);
  tt.int:=random($FFFFFF);
  tt.t[random(8)]:=true;
  tt.t[random(8)]:=true;
  tt.t[random(8)]:=true;
  tt.t[random(8)]:=false;
  tt.t[random(8)]:=false;

  setlength(aob,sizeof(tt));
  move(tt,aob[0],sizeof(tt));
  memo1.text:=AoB2String(aob);

end;

procedure TfrmTstVarProcsMain.btnVar2AobOfStClick(Sender: TObject);
var aob:Taob;

begin
  aob:=var2aob('Dies ist ein einfacher Test !!');
  memo1.text:=AoB2String(aob)
end;

end.
