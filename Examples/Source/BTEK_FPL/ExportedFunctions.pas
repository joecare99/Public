unit ExportedFunctions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, fmKeypad, fmSample;

procedure ShowForm; stdcall;
procedure SimpleMessage; stdcall;

implementation

uses Forms,Buttons,Controls;

procedure SimpleMessage; stdcall;
begin
  ShowMessage('Yay!');
end;


procedure ShowForm; stdcall;
var
  Form: TForm1;
  lButton: TBitBtn;
begin
  Form := TForm1.Create(nil);
  form.Height := form.Height + 60;
  lButton := TBitBtn.Create(Form);
  with lButton do
  begin
    Parent := Form;
    height := 56;
    Align:=alBottom;
    Kind:=bkClose;
    BorderSpacing.Around:=6;
  end;
  try
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

var
  Form: TForm;

procedure ShowForm2(const App:TApplication); stdcall;
var
  lButton: TBitBtn;
begin
  if not assigned(form) or (Form.Owner <> App) then
    begin
    app.CreateForm(TForm1,Form);
    form.Height := form.Height + 60;
  lButton := TBitBtn.Create(Form);
  with lButton do
  begin
    Parent := Form;
    height := 56;
    Align:=alBottom;
    Kind:=bkClose;
    BorderSpacing.Around:=6;
  end;
   end;
  form.show;
end;

exports
  ShowForm,
  ShowForm2,
  SimpleMessage;

end.
