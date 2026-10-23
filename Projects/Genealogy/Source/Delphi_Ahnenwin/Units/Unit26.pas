unit Unit26;

{-------------------------------------------------------------------------------
  Unit26 - TForm26, reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit26.pas and the original resource
  Source\Projects_AhnenWin\Form26.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, Buttons, Forms, Controls, Grids, DB;

type
  TForm26 = class(TForm)
  published
    GroupBox1: TGroupBox; //2F0
    RadioButton1: TRadioButton; //2F4
    RadioButton2: TRadioButton; //2F8
    RadioButton3: TRadioButton; //2FC
    SpeedButton1: TSpeedButton; //300
    procedure RadioButton2Click(Sender: TObject); //00550450
    procedure nach_erm; //0054FC40
    procedure FormActivate(Sender: TObject); //00550540
    procedure RadioButton1Click(Sender: TObject); //0054FA08
    procedure RadioButton3Click(Sender: TObject); //0054F9C8
    procedure los; //0054F8B4
    procedure SpeedButton1Click(Sender: TObject); //0054F9FC
  end;

var
  Form26: TForm26;

implementation

{$R ..\Forms\Form26.DFM}


{ The method bodies of this unit are reconstructed from the IDR
  listings, method by method. The bodies that are still missing are
  marked below; the address in the comment is the address of the
  original method in the AHNENWIN 5.1 binary. }

procedure TForm26.RadioButton2Click(Sender: TObject);
begin
  { TODO: Listing fehlt noch - Originaladresse siehe Deklaration. }
end;

procedure TForm26.nach_erm;
begin
  { TODO: GEDCOM engine (Unit3) not yet reconstructed - Originaladresse 0054FC40. }
end;

procedure TForm26.FormActivate(Sender: TObject);
begin
  { (00550540) When the dialog is opened, the radio buttons are not set yet. }
  RadioButton1.Checked := False;
  RadioButton2.Checked := False;
  RadioButton3.Checked := False;
end;

procedure TForm26.RadioButton1Click(Sender: TObject);
begin
  { TODO: GEDCOM engine and TForm1.vorf_erm2 not yet reconstructed
    - Originaladresse 0054FA08. }
end;

procedure TForm26.RadioButton3Click(Sender: TObject);
begin
  { TODO: GEDCOM engine (Unit3) not yet reconstructed - Originaladresse 0054F9C8.
    Sets gvar_0061F008 := 'Alle' and then calls TForm26.los. }
end;

procedure TForm26.los;
begin
  { TODO: GEDCOM engine (Unit3) not yet reconstructed - Originaladresse 0054F8B4. }
end;

procedure TForm26.SpeedButton1Click(Sender: TObject);
begin
  { (0054F9FC) The button "nichts dergleichen" closes the dialog. }
  Close;
end;


end.
