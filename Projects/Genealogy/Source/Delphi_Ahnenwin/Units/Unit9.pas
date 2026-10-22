unit Unit9;

{-------------------------------------------------------------------------------
  Unit9 - TForm9, the "about" / start dialog of AHNENWIN 5.1.

  Reconstructed from the IDR disassembly
  Source\Projects_AhnenWin\Unit9.pas and the original resource
  Source\Projects_AhnenWin\Form9.dfm.

  The component offsets in the comments are the addresses at which the
  original binary addressed the components. They are the reference for
  every component access in the method listings of the other units.

  Method addresses (original binary):
    005C6C1C  FormClick
    005C6C28  FormMouseDown
    005C6C3C  Timer1Timer
    005C6C48  FormKeyDown
    005C6C60  FormActivate
    005C6D74  FormShow
    005C6D80  FormCreate
-------------------------------------------------------------------------------}

interface

uses
  SysUtils, Classes, StdCtrls, ExtCtrls, Forms, Controls, Grids, DB, Windows;

type
  TForm9 = class(TForm)
  published
    Label1: TLabel; //2F0
    Image1: TImage; //2F4
    Label2: TLabel; //2F8
    Label3: TLabel; //2FC
    Label4: TLabel; //300
    Label5: TLabel; //304
    Label7: TLabel; //308
    Image2: TImage; //30C
    Label9: TLabel; //310
    Label10: TLabel; //314
    Shape1: TShape; //318
    Label8: TLabel; //31C
    Timer1: TTimer; //320
    procedure FormActivate(Sender: TObject); //005C6C60
    procedure FormShow(Sender: TObject); //005C6D74
    procedure FormCreate(Sender: TObject); //005C6D80
    procedure FormKeyDown(sender:tobject;var key:word;shift:tshiftstate); //005C6C48
    procedure FormClick(Sender: TObject); //005C6C1C
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X: Integer; Y: Integer); //005C6C28
    procedure Timer1Timer(Sender: TObject); //005C6C3C
  end;

var
  Form9: TForm9;

implementation

uses
  AHNGlobals;

{$R ..\Forms\Form9.DFM}

// 005C6C1C
procedure TForm9.FormClick(Sender: TObject);
begin
  { The listing closes the form through the global instance
    (mov eax,[gvar_02536880]; call TCustomForm.Hide). The global instance
    and Self are the same object, so Hide is the equivalent expression. }
  Hide;
end;

// 005C6C28
procedure TForm9.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X: Integer; Y: Integer);
begin
  { A mouse click anywhere on the dialog closes it. }
  Close;
end;

// 005C6C3C
procedure TForm9.Timer1Timer(Sender: TObject);
begin
  { The timer closes the dialog again - it is the fallback for the case
    that the user does not react to the mouse click. }
  Close;
end;

// 005C6C48
procedure TForm9.FormKeyDown(sender:tobject;var key:word;shift:tshiftstate);
begin
  { The listing compares the low word of the Key parameter with $1B (= 27
    = VK_ESCAPE) and closes the dialog in that case. }
  if Key = VK_ESCAPE then
    Close;
end;

// 005C6C60
procedure TForm9.FormActivate(Sender: TObject);
begin
  { The copyright line. The string of the original binary starts with the
    byte $A9, which is the copyright sign in the code page 1252 that the
    program uses. }
  Label2.Caption := '� 1998-2014';

  { The date of the output and the date of the last change are taken from
    the two global doubles at $02536924 and $0253691C. A value of 0 means
    that the file in question was not found - the program then shows no
    date at all, instead of the date of the epoch. }
  if gvar_02536924 > 0 then
    Label8.Caption := '(Ausgabe vom ' + DateToStr(gvar_02536924) + ')'
  else
    Label8.Caption := '(Ausgabe vom )';

  if gvar_0253691C > 0 then
    Label9.Caption := 'Letzte Bearbeitung am ' + DateToStr(gvar_0253691C)
  else
    Label9.Caption := 'Letzte Bearbeitung am ';
end;

// 005C6D74
procedure TForm9.FormShow(Sender: TObject);
begin
  { The listing only refreshes the form. }
  Refresh;
end;

// 005C6D80
procedure TForm9.FormCreate(Sender: TObject);
begin
  { The client width and height of the form are remembered in the two
    global integers at $02536884 and $02536888 - the listing reads them
    from the form and stores them in the globals. }
  gvar_02536884 := ClientWidth;
  gvar_02536888 := ClientHeight;
end;

end.
