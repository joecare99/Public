unit frm_About;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLIntf, Buttons;

type

  { Tapropos }

  Tapropos = class(TForm)
    btnClose: TBitBtn;
    imgTree: TImage;
    lblProgname: TLabel;
    lblVersion: TLabel;
    lblDate: TLabel;
    lblAuthor: TLabel;
    lblWebAdress: TLabel;
    lblActVersion: TLabel;
    lblCompDate: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblWebAdressClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  apropos: Tapropos;

implementation

uses
  Traduction;

{$R *.lfm}

{ Tapropos }

procedure Tapropos.Button1Click(Sender: TObject);
begin
  apropos.close;
end;

procedure Tapropos.FormShow(Sender: TObject);
begin
  Caption:=Traduction.Items[142];
  lblVersion.Caption:=Traduction.Items[143];
  lblDate.Caption:=Traduction.Items[144];
  lblAuthor.Caption:=Traduction.Items[145];
//  btnClose.Caption:=Traduction.Items[148];
  lblActVersion.caption:='0.9.5';
  lblCompDate.caption:='2012/2/17';
end;

procedure Tapropos.lblWebAdressClick(Sender: TObject);
begin
  OpenURL('http://sourceforge.net/p/stemma/wiki/Home/');
end;

end.

