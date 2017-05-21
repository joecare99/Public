unit Frm_TestMPlayerMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LResources,
  ComCtrls, Buttons, ExtCtrls, MPlayerCtrl, Frm_Aboutbox, IniFiles,
  files;

type

  { TForm1 }

  TForm1 = class(TForm)
    AboutBox1: TAboutBox;
    LabeledEdit1: TLabeledEdit;
    LazComponentQueue1: TLazComponentQueue;
    MPlayerControl1: TMPlayerControl;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    TrackBar1: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure MPlayerControl1Playing(ASender: TObject; APosition: single);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MPlayerControl1Playing(ASender: TObject; APosition: single);
begin
  TrackBar1.Max := trunc(MPlayerControl1.Duration*100);
  TrackBar1.Position := trunc(APosition*100);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MPlayerControl1.MPlayerPath := GetEnvironmentVariable('ProgramFiles(x86)')+'\Windows Media Player\wmplayer.exe';
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
 // MPlayerControl1.;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  MPlayerControl1.Play;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  MPlayerControl1.Stop;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  AboutBox1.Show;
  SysUtils.GetAppConfigFile();
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      LabeledEdit1.Text := OpenDialog1.FileName;
      MPlayerControl1.Filename:=LabeledEdit1.text;
    end;
end;

end.

