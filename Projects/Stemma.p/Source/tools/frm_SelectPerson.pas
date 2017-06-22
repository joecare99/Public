unit frm_SelectPerson;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Menus, Buttons, Spin, ExtCtrls;

type

  { TFormSelectPersonne }

  TFormSelectPersonne = class(TForm)
    btnCancel: TBitBtn;
    btnOK: TBitBtn;
    edtName: TEdit;
    edtNumber: TSpinEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    mniQuit: TMenuItem;
    Liste: TStringGrid;
    pnlAllmostBottom: TPanel;
    pnlBottom: TPanel;
    procedure FormShow(Sender: TObject);
    procedure ListeSelection(Sender: TObject; {%H-}aCol, aRow: Integer);
    procedure mniQuitClick(Sender: TObject);
    procedure edtNumberEditingDone(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormSelectPersonne: TFormSelectPersonne;

implementation

uses
  cls_Translation,dm_GenData;

{$R *.lfm}

{ TFormSelectPersonne }

procedure TFormSelectPersonne.FormShow(Sender: TObject);
begin
  Caption:=Translation.Items[316];
  Label1.Caption:=Translation.Items[115];
  btnOK.Caption:=Translation.Items[152];
  btnCancel.Caption:=Translation.Items[164];
  edtNumber.value:=0;
  edtName.Text:=Translation.Items[317];
end;

procedure TFormSelectPersonne.ListeSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  edtNumber.value:=ptrint(Liste.Objects[0,aRow]);
  edtName.Text:=Liste.Cells[1,aRow];
end;

procedure TFormSelectPersonne.mniQuitClick(Sender: TObject);
begin
  modalresult:=mrok;
end;

procedure TFormSelectPersonne.edtNumberEditingDone(Sender: TObject);

begin
    edtName.Text:=dmGenData.GetIndividuumName(edtNumber.Value);
end;

end.

