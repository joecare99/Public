unit Frm_MessageDialogsMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Dialogs, Buttons, StdCtrls, LazLogger;

  type
    TMainForm = class(TForm)
    private
    protected
    public
       button1 : TButton;
       constructor Create(AOwner: TComponent); override;
       procedure button1Click(Sender : TObject);
    end;

  var
    MainForm : TMainForm;

implementation


constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner, 1);
  Caption := 'Message Show';
  Width   := 200;
  Height  := 75;
  Left    := 200;
  Top     := 200;

  button1 := TButton.Create(Self);
  button1.OnClick := @button1click;
  button1.Parent  := Self;
  button1.left    := (width - 85) div 2 ;
  button1.top     := (height - 32) div 2;
  button1.width   := 85;
  button1.height  := 32;
  button1.caption := 'Start Show';
  button1.Show;
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  ShowMessage ('First simple test!');
  DebugLn('Go to second dialog');
  MessageDlg  ('Caption', 'Two buttons now ...', mtError, [mbOK,mbCancel], 0);
  MessageDlg  ('Warning, not fully implemented', mtWarning, [mbYes, mbNo, mbOK,mbCancel], 0);
  ShowMessageFmt ('The show will end now'+LineEnding+'%s'+LineEnding+'Good bye!!!', [MainForm.Caption]);
  close;
end;

end.

