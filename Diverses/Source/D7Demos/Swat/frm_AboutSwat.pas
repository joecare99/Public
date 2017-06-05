unit frm_AboutSwat;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
   SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmAboutSwat = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Hits: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Escape: TLabel;
    Miss: TLabel;
    Label1: TLabel;
    OKButton: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAboutSwat: TfrmAboutSwat;

implementation

{$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

end.
