unit Frm_AboutTabedit;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Classes,
 Graphics,
 Forms,
 Controls,
 StdCtrls,

  Buttons,
 ExtCtrls,
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages
{$ENDIF};

type
  TfrmAboutForm = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Rights: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAboutForm: TfrmAboutForm;

implementation

{$IFnDEF FPC}

  {$R *.dfm}

{$ELSE}

  {$R *.lfm}

{$ENDIF}
end.

