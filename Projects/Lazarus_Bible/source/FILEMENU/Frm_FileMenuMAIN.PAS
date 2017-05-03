unit Frm_FileMenuMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Menus, Buttons;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileExit: TMenuItem;
    OpenButton: TButton;
    OpenDialog: TOpenDialog;
    FileOpen: TMenuItem;
    FileSep1: TMenuItem;
    FileSep2: TMenuItem;
    FileName1: TMenuItem;
    FileName2: TMenuItem;
    FileName3: TMenuItem;
    FileName4: TMenuItem;
    BitBtn1: TBitBtn;
    procedure FileExitClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure FileName1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

{ - Prompt for filename and add name to File menu }
procedure TMainForm.OpenButtonClick(Sender: TObject);
var
  S: string;
  I, K: Integer;
begin
  if OpenDialog.Execute then
    with FileMenu do
      begin
        if not FileSep2.Visible then
          FileSep2.Visible := True; { Make separator visible }
        K := IndexOf(FileName1);
        for I := Count - 1 downto K + 1 do
          begin { Move current filenames down one position }
            S := Items[I - 1].Caption;
            S[2] := Chr(Ord('0') + (I - K + 1)); { Alt-Shortcut }
            Items[I].Caption := S;
            Items[I].Visible := Items[I - 1].Visible;
          end;
        FileName1.Caption := '&1 ' + OpenDialog.Filename;
        FileName1.Visible := True;
        ShowMessage('Adding: ' + OpenDialog.Filename);
      end;
end;

{ - Get filename selected from File menu }
procedure TMainForm.FileName1Click(Sender: TObject);
var
  Filename: string;
begin
  with Sender as TMenuItem do
    begin
      Filename := Caption;
      System.Delete(Filename, 1, 2);
    end;
  ShowMessage('Selected: ' + Filename);
end;

end.
