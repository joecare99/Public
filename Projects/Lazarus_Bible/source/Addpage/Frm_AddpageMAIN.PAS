unit Frm_AddpageMAIN;

{$i jedi.inc}
interface

uses
{$IFnDEF FPC}
  TabNotBk, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls, ComCtrls;

type

  { TfrmAddPageMain }

  TfrmAddPageMain = class(TForm)
    CheckBox1: TCheckBox;
    TabbedNotebook1: TPageControl;
    AddPageButton: TButton;
    CloseBitBtn: TBitBtn;
    AddControlButton: TButton;
    ts1: TTabSheet;
    procedure AddPageButtonClick(Sender: TObject);
    procedure AddControlButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddPageMain: TfrmAddPageMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{- Insert new page into TabbedNotebook }
procedure TfrmAddPageMain.AddPageButtonClick(Sender: TObject);
{$IFNDEF FPC}
var nTabSheet:TTabsheet;
{$ENDIF}
begin
  with TabbedNotebook1 do
    begin
      {$IFDEF FPC}
      with AddTabSheet do
        Caption := Format('Page %d',[TabIndex-1]);
      {$ELSE}
      {$IFDEF RTL170_UP}
      nTabsheet := TTabSheet.Create(self);
      nTabsheet.PageControl := TabbedNotebook1;
       {$ELSE}
      pagecount := PageCount+1;
      {$ENDIF}
      with pages[PageCount-1] do
        Caption := Format('Page %d',[TabIndex-1]);
      {$ENDIF}
    end;
end;

{- Insert new control into current page }
procedure TfrmAddPageMain.AddControlButtonClick(Sender: TObject);
var
  L: TListBox;
  P: TWinControl;
begin
  L := TListBox.Create(Self);
  with TabbedNotebook1 do
  begin
    P := Pages[TabIndex] as TWinControl;
    L.Parent := P;
    L.SetBounds(10, 10, 100, 100);
{- Insert page tab label into edit control for demonstration.
   You don't have to perform this step. }
    L.Items.Add({$IFDEF FPC} TTabSheet {$ELSE} TTabPage {$ENDIF}(P).Caption);
  end;
end;


end.
