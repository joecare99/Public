unit Frm_MDIDemoMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 Windows, {$IFnDEF FPC}

{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, frm_MDIChild1;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileOpen: TMenuItem;
    FileSave: TMenuItem;
    FileSaveAs: TMenuItem;
    FileNew: TMenuItem;
    N1: TMenuItem;
    FileExit: TMenuItem;
    ScrollBox1: TScrollBox;
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
    procedure wmSize(var Msg: TLMSize);message LM_Size;
  public
  {- Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Frm_MDIDemoABOUT;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  maxChildren = 10;  { Optional: No maximum required }

procedure TMainForm.CreateChild(const Name: String);
var
  Child: TChildForm;
begin
  Child := TChildForm.Create(Application);
  Child.Caption := Name;
  {$IFDEF FPC}
   Child.Parent := self;
  {$ENDIF}
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
  FExt: String;
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
  {$IFNDEF FPC}
  ArrangeIcons;
  {$ELSE}

  {$ENDIF}
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

procedure TMainForm.wmSize(var Msg: TLMSize);

Type  WINDOWPLACEMENT = record
          length : UINT;
          flags : UINT;
          showCmd : UINT;
          ptMinPosition : TPOINT;
          ptMaxPosition : TPOINT;
          rcNormalPosition : TRECT;
       end;

Var
 L,H :integer;
 WS :WINDOWPLACEMENT;
begin
  Inherited wmsize(Msg);
  H := GetSystemMetrics(SM_CYMINSPACING);
  If H and $0F <> 0 Then H := (H and $FFFFFFF0)+$10;//Seems we need to abey 16 byte page size in heitgh;
  For L := 0 To ScrollBox1.ComponentCount-1 do
  Begin
   if (ScrollBox1.Components[L] is Tform) Then
    With TForm(ScrollBox1.Components[l]) do
     Begin
      Ws.Length := SizeOf(WS);
      GetWindowPlaceMent(Handle, @WS);
      If WindowState= wsMinimized then
       Begin
        WS.ptMinPosition.y := ScrollBox1.Height-H;
        WS.Flags := WPF_SETMINPOSITION;
        Ws.ShowCmd := SW_MINIMIZE;
        SetWindowPlacement(Handle, @WS);
       End Else
      if WS.rcNormalPosition.Top > ScrollBox1.Height Then
       Begin
        WS.rcNormalPosition.Top := ScrollBox1.Height-H;
        Ws.RCNormalPosition.Bottom -=H;
        SetWindowPlacement(Handle, @Ws);
       end;
     end;
  end;
End;

end.
