unit Unit4;

{-------------------------------------------------------------------------------
  Unit4 - TForm4, the "Kind einfuegen" selection dialog of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit4.pas and the original resource
  Source\Projects_AhnenWin\Form4.dfm.

  The form asks the user how a child is to be linked: a NEW record is
  created ("Neu"), an EXISTING person is selected ("Auswahl"), or the
  operation is cancelled ("zurueck"). The choice is returned to the caller
  through TCustomForm.ModalResult, which lives at component offset $24C and
  is read by TForm1 after ShowModal.

  Offset map (verified against the decompiled Forms.pas / StdCtrls.pas):
    $2F0  Panel1
    $2F4  RadioButton1   (Neu)
    $2F8  RadioButton2   (Auswahl)
    $2FC  RadioButton3   (zurueck)
    $24C  TCustomForm.FModalResult
    VMT $C4  TCustomRadioButton.GetChecked
    VMT $C8  TCustomRadioButton.SetChecked

  Method addresses (original binary):
    005C68D8  RadioButton1Click
    005C68E8  RadioButton2Click
    005C68F8  RadioButton3Click
    005C6904  FormCreate
    005C6908  FormActivate
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Forms;

type
  TForm4 = class(TForm)
  published
    Panel1: TPanel; //2F0
    RadioButton1: TRadioButton; //2F4
    RadioButton2: TRadioButton; //2F8
    RadioButton3: TRadioButton; //2FC
    procedure FormCreate(Sender: TObject); //005C6904
    procedure FormActivate(Sender: TObject); //005C6908
    procedure RadioButton3Click(Sender: TObject); //005C68F8
    procedure RadioButton1Click(Sender: TObject); //005C68D8
    procedure RadioButton2Click(Sender: TObject); //005C68E8
  end;

var
  Form4: TForm4;

implementation

{$R ..\Forms\Form4.DFM}

// 005C68D8
procedure TForm4.RadioButton1Click(Sender: TObject);
begin
  { The listing writes the value 1 straight into TCustomForm.FModalResult
    (component offset $24C) instead of using the ModalResult property.
    Value 1 is idOk, i.e. "a new child record is to be created".
    The global instance is dereferenced explicitly (mov eax,[gvar_...];
    mov dword ptr [eax+24C],1) - Form4 and the global pointer always refer
    to the same object, so ModalResult is the equivalent expression. }
  Form4.ModalResult := 1;
end;

// 005C68E8
procedure TForm4.RadioButton2Click(Sender: TObject);
begin
  { Value 2 is idCancel in the Windows dialog result space. In this program
    the caller distinguishes the three cases by the state of the radio
    buttons, not by the numeric result, so the literal 2 is preserved
    verbatim from the listing. }
  Form4.ModalResult := 2;
end;

// 005C68F8
procedure TForm4.RadioButton3Click(Sender: TObject);
begin
  { "zurueck" - the form is closed. The listing calls TCustomForm.Close
    through the global instance, without touching ModalResult. }
  Form4.Close;
end;

// 005C6904
procedure TForm4.FormCreate(Sender: TObject);
begin
  { The listing is a single "ret" - the method exists only because the DFM
    binds OnCreate = FormCreate. }
end;

// 005C6908
procedure TForm4.FormActivate(Sender: TObject);
begin
  { Every activation clears all three radio buttons, so the dialog always
    starts without a preselected entry. The listing calls the virtual
    SetChecked (VMT slot $C8) with edx = 0 for each of the three buttons. }
  RadioButton1.Checked := False;
  RadioButton2.Checked := False;
  RadioButton3.Checked := False;
end;

end.
