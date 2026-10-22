unit TODO_Frm_ABOUT;

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
  TAboutForm = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$IFnDEF FPC}

  {$R *.dfm}

{$ELSE}

  {$R *.lfm}

{$ENDIF}
end.
 
