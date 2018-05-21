unit Frm_YesNoMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Frm_YesNo;

type
  TfrmYesNoMain = class(TForm)
    btnTest: TButton;
    btnExit: TButton;
    procedure btnTestClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
//  private
    { Private declarations }
//  public
    { Public declarations }
  end;

var
  frmYesNoMain: TfrmYesNoMain;

implementation

{$R *.DFM}

procedure TfrmYesNoMain.btnTestClick(Sender: TObject);
{ Add following two lines to create a variable for
  storing the result of the YesNo dialog. }
var
  Result: Integer;
begin
  { Make the dialog caption match the application's for
    easier switching away then back. }
  frmYesNoDlg.Caption := frmYesNoMain.Caption;
  { Use following statement to change prompt at runtime,
    or you can set the dialog's Caption property. }
  frmYesNoDlg.lblPrompt.Caption := 'Click any button. Okay?';
  { Display the dialog and save its result, which equals
    the ModalResult property of the button clicked to close
    the YesNo dialog.}
  Result := frmYesNoDlg.ShowModal;
  if Result = mrYes
  then
    ShowMessage('You selected the Yes button!')
  else if Result = mrNo
  then
    ShowMessage('You selected the No button!')
  else
    ShowMessage('Unknown button!');  { Never shown }
end;

procedure TfrmYesNoMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

end.

