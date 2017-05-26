unit frm_DummyMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, frm_Aboutbox, Unt_UserRechte, Cmp_DBConfig, Unt_Config;

type
  TForm1 = class(TForm)
    Config1: TConfig;
    DBConfig1: TDBConfig;
    User1: TUser;
    AboutBox1: TAboutBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  AboutBox1.show;
end;

end.
