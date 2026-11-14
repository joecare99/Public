unit Unit22;

{-------------------------------------------------------------------------------
  Unit22 - TOKBottomDlg, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit22.pas and the original resource
  Source\Projects_AhnenWin\OKBottomDlg.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls, Grids, DB;

type
  TOKBottomDlg = class(TForm)
  published
    Bevel2: TBevel; //2F0
    Label1: TLabel; //2F4
    Label2: TLabel; //2F8
    Label3: TLabel; //2FC
    Label4: TLabel; //300
    Label5: TLabel; //304
    Label6: TLabel; //308
    Label7: TLabel; //30C
    Label8: TLabel; //310
    Label9: TLabel; //314
    Label10: TLabel; //318
    Label11: TLabel; //31C
    Label12: TLabel; //320
    Label13: TLabel; //324
    Label14: TLabel; //328
    Edit1: TEdit; //32C
    Edit2: TEdit; //330
    Edit3: TEdit; //334
    Edit4: TEdit; //338
    Edit5: TEdit; //33C
    Edit6: TEdit; //340
    Edit7: TEdit; //344
    Edit8: TEdit; //348
    Edit9: TEdit; //34C
    Edit10: TEdit; //350
    Edit11: TEdit; //354
    Edit12: TEdit; //358
    Edit13: TEdit; //35C
    Edit14: TEdit; //360
    SpeedButton1: TSpeedButton; //364
    SpeedButton2: TSpeedButton; //368
    procedure SpeedButton2Click(Sender: TObject); //0054F568
    procedure SpeedButton1Click(Sender: TObject); //0054E0D4
  end;

var
  Form22: TOKBottomDlg;

implementation

{$R ..\Forms\OKBottomDlg.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TOKBottomDlg.SpeedButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TOKBottomDlg.SpeedButton1Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;


end.
