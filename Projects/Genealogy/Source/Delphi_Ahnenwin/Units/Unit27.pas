unit Unit27;

{-------------------------------------------------------------------------------
  Unit27 - TOKBottomDlg1, the "GEDCOM output" dialog of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit27.pas and the original resource
  Source\Projects_AhnenWin\OKBottomDlg1.dfm.

  The dialog collects the parameters of a GEDCOM export; the actual export
  is done by TForm3 (Unit3), which is called from the OK button.

  Method addresses (original binary):
    0054DBDC  FormShow
    0054DC00  SpeedButton1Click
    0054DD2C  SpeedButton2Click
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, ExtCtrls, StdCtrls, Buttons, Forms, Controls;

type
  TOKBottomDlg1 = class(TForm)
  published
    Bevel1: TBevel; //2F0
    Label1: TLabel; //2F4
    Label2: TLabel; //2F8
    Label3: TLabel; //2FC
    Label5: TLabel; //300
    Edit1: TEdit; //304
    Edit2: TEdit; //308
    Edit3: TEdit; //30C
    Edit4: TEdit; //310
    Panel1: TPanel; //314
    CheckBox1: TCheckBox; //318
    SpeedButton1: TSpeedButton; //31C
    SpeedButton2: TSpeedButton; //320
    Panel2: TPanel; //324
    RadioButton1: TRadioButton; //328
    RadioButton2: TRadioButton; //32C
    Label4: TLabel; //330
    RadioButton3: TRadioButton; //334
    Label6: TLabel; //338
    Label7: TLabel; //33C
    Edit5: TEdit; //340
    Label8: TLabel; //344
    Edit6: TEdit; //348
    procedure SpeedButton2Click(Sender: TObject); //0054DD2C
    procedure SpeedButton1Click(Sender: TObject); //0054DC00
    procedure FormShow(Sender: TObject); //0054DBDC
  end;

var
  Form27: TOKBottomDlg1;

implementation

uses
  AHNGlobals, Unit1, Unit3, Unit26;

{$R ..\Forms\OKBottomDlg1.DFM}

// 0054DBDC
procedure TOKBottomDlg1.FormShow(Sender: TObject);
begin
  { The listing sets the second radio button via the virtual SetChecked
    (VMT slot $C8) with dl = 1, and then makes Edit1 the active control. }
  RadioButton2.Checked := True;
  ActiveControl := Edit1;
end;

// 0054DC00
procedure TOKBottomDlg1.SpeedButton1Click(Sender: TObject);
begin
  { The listing shows the hour glass cursor for the duration of the export.
    The value $FFF5 in the cursor register is -11, which is crHourGlass. }
  Screen.Cursor := crHourGlass;
  try
    { The main form is refreshed so that the user sees the effect of the
      change before the export starts. }
    Form1.Refresh;
    Hide;

    { The global string at $0061F008 holds the kind of the export. }
    if gvar_0061F008 = 'Alle' then
      Form3.gedaus
    else if gvar_0061F008 = 'vorged' then
      Form3.gedausv
    else if gvar_0061F008 = 'nachged' then
      Form3.gedausv;

    { The global string at $0061EFE0 holds the "overwrite" flag. }
    if gvar_0061EFE0 = 'over' then
      Form3.gedausv;
  finally
    Screen.Cursor := crDefault;
    { The value 2 in the ModalResult field is idCancel - the dialog is
      closed with the cancel result, the export itself has already run. }
    ModalResult := 2;
  end;
end;

// 0054DD2C
procedure TOKBottomDlg1.SpeedButton2Click(Sender: TObject);
begin
  { The cancel button closes the GEDCOM dialog (Unit26) and then the dialog
    itself. }
  Form26.Close;
  Close;
end;

end.
