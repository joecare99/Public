unit Frm_OdfCreateMain;

{ View des ODF-Demos: Button "Dokument erzeugen", Vorschau-Memo,
  Schliessen-Knopf. Die eigentliche Arbeit leistet das ViewModel
  (OdfViewModel). }

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
  Forms, Dialogs, StdCtrls, Buttons;

type
  TfrmOdfCreateMain = class(TForm)
    Memo1: TMemo;
    btnCreate: TButton;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    procedure btnCreateClick(Sender: TObject);
  private
    FLastFile: string;
  public
    property LastFile: string read FLastFile;
  end;

var
  frmOdfCreateMain: TfrmOdfCreateMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses OdfViewModel;

procedure TfrmOdfCreateMain.btnCreateClick(Sender: TObject);
begin
  { Zielort unter Linux persistens - /tmp ist fuer die Demo gut. }
  FLastFile := '/tmp/BibleOdfDemo.odt';
  Memo1.Lines.Clear;
  if GlobalOdfDocBuilder.Build(FLastFile, Memo1.Lines) then
    Memo1.Lines.Add('Fertig. Oeffnen mit LibreOffice o.ae.');
end;

end.
