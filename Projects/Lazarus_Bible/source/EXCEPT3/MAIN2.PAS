unit Main;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.Button1Click(Sender: TObject);
var
  N: Integer;

  function GetInteger: Integer;
  begin
    Result := StrToInt(Edit1.Text);
    if (Result < 0) or (Result > 99) then
      raise ERangeError.Create('Value out of range!')
    else begin
      ShowMessage('Success! Click Ok to end program');
      Close;
    end;
  end;

begin
  try
    N := GetInteger;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message + ' Try again.');
      Edit1.SetFocus;
    end;
  end;
end;

end.
