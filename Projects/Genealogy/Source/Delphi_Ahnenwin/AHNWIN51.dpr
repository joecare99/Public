program AHNWIN51;

{-------------------------------------------------------------------------------
  AHNWIN51 - AHNENWIN 5.1, reconstructed from the IDR disassembly.

  This project is a from-scratch Delphi reconstruction of the original
  AHNENWIN 5.1 genealogy program, based exclusively on the IDR
  (Interactive Delphi Reconstructor) disassembly in
  Source\Projects_AhnenWin\.

  Structure:
    Units\                the application units (Unit1 .. Unit40)
    Forms\                the original DFM resources, unchanged
    Compat\QuickReport\   QuickReport compatibility stubs
    Compat\WPPDF\         WPPDFDelphi compatibility stubs
    tools\                StreamCheck (resource verification) and gen-unit
    docs\                 cross reference and reconstruction evidence

  The order in which the forms are created is the order of the original
  program (Source\Projects_AhnenWin\AHNWIN51.dpr).

  Build with build.cmd (Delphi 9 / RAD Studio 3.0 + BDE 5.2).
-------------------------------------------------------------------------------}

uses
  SysUtils, Classes, Forms, DBTables,
  AHNStart,
  { The JPEG unit registers the JPEG graphic format at run time. A graphic
    that is stored in a DFM as "Picture.Data" is loaded through
    TBitmap.LoadFromStream, which dispatches over the registered graphic
    formats - without this unit every JPEG picture of the program would be
    silently dropped. The original binary links the unit as well (it is
    present in the decompilation as jpeg.pas). }
  JPEG,
  Unit1  in 'Units\Unit1.pas',
  Unit2  in 'Units\Unit2.pas',
  Unit3  in 'Units\Unit3.pas',
  Unit4  in 'Units\Unit4.pas',
  Unit5  in 'Units\Unit5.pas',
  Unit6  in 'Units\Unit6.pas',
  Unit7  in 'Units\Unit7.pas',
  Unit8  in 'Units\Unit8.pas',
  Unit9  in 'Units\Unit9.pas',
  Unit10 in 'Units\Unit10.pas',
  Unit11 in 'Units\Unit11.pas',
  Unit12 in 'Units\Unit12.pas',
  Unit13 in 'Units\Unit13.pas',
  Unit14 in 'Units\Unit14.pas',
  Unit15 in 'Units\Unit15.pas',
  Unit16 in 'Units\Unit16.pas',
  Unit17 in 'Units\Unit17.pas',
  Unit18 in 'Units\Unit18.pas',
  Unit19 in 'Units\Unit19.pas',
  Unit20 in 'Units\Unit20.pas',
  Unit21 in 'Units\Unit21.pas',
  Unit22 in 'Units\Unit22.pas',
  Unit23 in 'Units\Unit23.pas',
  Unit24 in 'Units\Unit24.pas',
  Unit25 in 'Units\Unit25.pas',
  Unit26 in 'Units\Unit26.pas',
  Unit27 in 'Units\Unit27.pas',
  Unit28 in 'Units\Unit28.pas',
  Unit29 in 'Units\Unit29.pas',
  Unit30 in 'Units\Unit30.pas',
  Unit31 in 'Units\Unit31.pas',
  Unit32 in 'Units\Unit32.pas',
  Unit33 in 'Units\Unit33.pas',
  Unit34 in 'Units\Unit34.pas',
  Unit35 in 'Units\Unit35.pas',
  Unit36 in 'Units\Unit36.pas',
  Unit37 in 'Units\Unit37.pas',
  Unit38 in 'Units\Unit38.pas',
  Unit39 in 'Units\Unit39.pas',
  Unit40 in 'Units\Unit40.pas';

{$R *.res}

begin
  { The program works with relative paths (the picture directory "Bilder",
    the BDE alias, par.cfg, style.css) and with the BDE, which creates
    its PDOXUSRS.NET in the current directory. The original program
    therefore has to be started from the directory that holds its data.

    The reconstruction is more flexible: the directory of the data is
    looked for by AHNStart (parameter, AHNWIN51.ini, the directory of the
    program file, the current directory). The current directory is then
    set to it, so that the data is found no matter from where the program
    was started. }
  DatenVerzeichnisSetzen;

  { The BDE of Delphi 9 places its net file in the root of the drive when
    it has no configuration file, and a normal user may not write there
    ("Fehler beim Initialisieren des Netzwerkes / Zugriff verweigert").
    The net file belongs next to the data, so its directory is set
    explicitly. The session is not yet active at this point. }
  Session.NetFileDir := DatenVerzeichnis;

  Application.Initialize;
  Application.Title := 'AHNENWIN 5.1';

  { The splash screen is created and shown before the main form; the main
    form closes it again in its OnCreate.

    The original calls a *virtual* method of the splash form here (the
    listing shows "call dword ptr [edx+88]"). The method cannot be
    identified from the disassembly, because the VMT layout of the VCL
    version the original was built with is not preserved in the IDR output.
    The purpose is to let the splash screen paint before the main form
    appears, and Update has exactly that effect. }
  SplashZeigen;

  { The order of the forms is the order of the original program. The data
    module is NOT created here: TForm1.FormCreate creates it, exactly as
    the original does. }
  { The data module is created before the forms. The original program
    creates it in TForm1.FormCreate, but the resources of the forms refer
    to it by name ("DataSource = DataModule2.DataSource1"), and the
    reader of the resources dereferences the global variable while it
    streams. If the data module does not exist yet, that is an access
    violation. TForm1.FormCreate only creates the data module when it
    does not exist yet, so that there is always exactly one. }
  Application.CreateForm(TDataModule2, DataModule2);

  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm16, Form16);
  Application.CreateForm(TForm17, Form17);
  Application.CreateForm(TForm20, Form20);
  Application.CreateForm(TForm21, Form21);
  Application.CreateForm(TOKBottomDlg, Form22);
  Application.CreateForm(TForm23, Form23);
  Application.CreateForm(TForm24, Form24);
  Application.CreateForm(TForm25, Form25);
  Application.CreateForm(TForm26, Form26);
  Application.CreateForm(TOKBottomDlg1, Form27);
  Application.CreateForm(TForm31, Form31);
  Application.CreateForm(TForm32, Form32);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm28, Form28);
  Application.CreateForm(TForm29, Form29);
  Application.CreateForm(TForm33, Form33);
  Application.CreateForm(TForm34, Form34);
  Application.CreateForm(TForm35, Form35);
  Application.CreateForm(TForm36, Form36);
  Application.CreateForm(TForm37, Form37);
  Application.CreateForm(TForm30, Form30);
  Application.CreateForm(TForm38, Form38);
  Application.CreateForm(TForm39, Form39);
  Application.CreateForm(TForm40, Form40);

  Application.Run;
end.
