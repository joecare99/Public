unit Frm_YesNoMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, YesNo;

type
  TMainForm = class(TForm)
    TestButton: TButton;
    ExitButton: TButton;
    procedure TestButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
//  private
    { Private declarations }
//  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.TestButtonClick(Sender: TObject);
{ Add following two lines to create a variable for
  storing the result of the YesNo dialog. }
var
  Result: Integer;
begin
  { Make the dialog caption match the application's for
    easier switching away then back. }
  YesNoDlg.Caption := MainForm.Caption;
  { Use following statement to change prompt at runtime,
    or you can set the dialog's Caption property. }
  YesNoDlg.PromptLabel.Caption := 'Click any button. Okay?';
  { Display the dialog and save its result, which equals
    the ModalResult property of the button clicked to close
    the YesNo dialog.}
  Result := YesNoDlg.ShowModal;
  if Result = mrYes
  then
    ShowMessage('You selected the Yes button!')
  else if Result = mrNo
  then
    ShowMessage('You selected the No button!')
  else
    ShowMessage('Unknown button!');  { Never shown }
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

end.

