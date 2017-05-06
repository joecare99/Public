unit Frm_MDIDemo2MAIN;

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
  Forms, Dialogs, Menus, CHILD2, Childbmp;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileOpen: TMenuItem;
    FileSave: TMenuItem;
    FileSaveAs: TMenuItem;
    FileNew: TMenuItem;
    N1: TMenuItem;
    FileExit: TMenuItem;
    WindowMenu: TMenuItem;
    WindowCascade: TMenuItem;
    WindowTile: TMenuItem;
    WindowArrangeIcons: TMenuItem;
    N2: TMenuItem;
    WindowCloseAll: TMenuItem;
    WindowMinimizeAll: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    OpenDialog: TOpenDialog;
    FileClose: TMenuItem;
    N3: TMenuItem;
    SaveDialog: TSaveDialog;
    procedure FileNewClick(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FileCloseClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure WindowCascadeClick(Sender: TObject);
    procedure WindowTileClick(Sender: TObject);
    procedure WindowArrangeIconsClick(Sender: TObject);
    procedure WindowMinimizeAllClick(Sender: TObject);
    procedure WindowCloseAllClick(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure WindowMenuClick(Sender: TObject);
  private
  {- Private declarations }
    procedure CreateChild(const Name: string);
  public
  {- Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses frm_MDIDemo2ABOUT;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  maxChildren = 10;  { Optional: No maximum required }

(* This procedure is replaced by the new CreateChild following,
   which opens text or bitmap files depending on the filename
   extension.
procedure TMainForm.CreateChild(const Name: String);
var
  Child: TChildForm;
begin
  Child := TChildForm.Create(Application);
  Child.Caption := Name;
end;
*)

{ The new CreateChild creates a child window object based
  on the filename extension. All files that don't end with
  the extension .bmp are assumed to be text files. In practice,
  you'll probably need other code to ensure that users open
  the correct types of files. }
procedure TMainForm.CreateChild(const Name: String);
var
  Child: TChildForm;
  FExt: String[4];
begin
  FExt := ExtractFileExt(Name);
  if FExt = '.bmp' then
    Child := TChildBmpForm.Create(Application)
  else
    Child := TChildForm.Create(Application);
  Child.Caption := Name;
end;

procedure TMainForm.FileNewClick(Sender: TObject);
begin
  CreateChild('Untitled' + IntToStr(MDIChildCount + 1));
end;

procedure TMainForm.FileOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    CreateChild(Lowercase(OpenDialog.FileName));
    with ActiveMDIChild as TChildForm do
      LoadData(OpenDialog.FileName);
  end;
end;

procedure TMainForm.FileCloseClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
    ActiveMDIChild.Close;
end;

procedure TMainForm.FileSaveClick(Sender: TObject);
begin
  if Pos('Untitled', ActiveMDIChild.Caption) = 1 then
    FileSaveAsClick(Sender)
  else with ActiveMDIChild as TChildForm do
    SaveData(Caption);
end;

procedure TMainForm.FileSaveAsClick(Sender: TObject);
var
  FExt: String[4];
begin
  with SaveDialog do
  begin
    FileName := ActiveMDIChild.Caption;
    FExt := ExtractFileExt(FileName);
    if Length(FExt) = 0 then
      FExt := '.*';
    Filter := 'Files (*' + FExt + ')|*' + FExt;
    if Execute then
    with ActiveMDIChild as TChildForm do
      SaveData(FileName);
  end;
end;

procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.WindowCascadeClick(Sender: TObject);
begin
  Cascade;
end;

procedure TMainForm.WindowTileClick(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.WindowArrangeIconsClick(Sender: TObject);
begin
  {$IFNDEF FPC} ArrangeIcons;  {$ENDIF}
end;

procedure TMainForm.WindowMinimizeAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TMainForm.WindowCloseAllClick(Sender: TObject);
var
  I: Integer;
begin
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].Close;
end;

procedure TMainForm.HelpAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.FileMenuClick(Sender: TObject);
begin
  FileNew.Enabled := MDIChildCount < maxChildren;
  FileOpen.Enabled := FileNew.Enabled;
  FileClose.Enabled := MDIChildCount > 0;
  FileSave.Enabled := FileClose.Enabled;
  FileSaveAs.Enabled := FileClose.Enabled;
end;

procedure TMainForm.WindowMenuClick(Sender: TObject);
var
  I: Integer;
begin
  with WindowMenu do
  for I := 0 to Count - 1 do
    with Items[I] as TMenuItem do
      Enabled := MDIChildCount > 0;
end;

end.
