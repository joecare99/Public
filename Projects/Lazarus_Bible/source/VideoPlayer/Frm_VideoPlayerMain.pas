unit Frm_VideoPlayerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, MPlayer, ComCtrls;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    OpenBitBtn: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialog1: TOpenDialog;
    AutoPlayCheckBox: TCheckBox;
    procedure OpenBitBtnClick(Sender: TObject);
    procedure MediaPlayer1Notify(Sender: TObject);
    procedure MediaPlayer1Click(Sender: TObject;
      Button: TMPBtnType; var DoDefault: Boolean);
    procedure AutoPlayCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

(* Note: Set the MediaPlayer1 object properties as follows
     AutoEnable        False    All buttons always enabled
     AutoOpen          True     Doesn't really matter
     AutoRewind        True     Rewinds media when it stops
     Other properties  Default settings
*)

{ Responds to user selection of the Open file button. }
{ Opens media file and starts playing immediately. }
{ Also sets the window caption to the filename. }
procedure TForm1.OpenBitBtnClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Form1.Caption := OpenDialog1.FileName;
    MediaPlayer1.FileName := OpenDialog1.FileName;
    MediaPlayer1.Notify := True;  // Wants media event notify
    MediaPlayer1.Open;            // Opens assigned file
    MediaPlayer1.Frames := 1;     // Sets single step frames
    MediaPlayer1.Play;            // Start playing the file
  end;
end;

{ Responds to media event notifications. This gives us the
  chance to check whether the auto-replay checkbox is set, and
  if so, and if the media is stopped, to restart play. Despite
  the control's documentation, it is necessary to check whether
  Notify is true. Even if this flag is false, the procedure is
  called when the user clicks the stop button. }
procedure TForm1.MediaPlayer1Notify(Sender: TObject);
begin
  if (MediaPlayer1.Notify) and            // If flag is true
     (MediaPlayer1.Mode = mpStopped) and  // and play's stopped
     (AutoPlayCheckBox.Checked) then      // & checkbox enabled
  begin
    MediaPlayer1.Rewind;                  // rewind to start
    MediaPlayer1.Play;                    // and begin playing
  end;
  { You must set Notify to True so that the next media event
    will generate a notification; otherwise, this procedure
    would be called only once. }
  MediaPlayer1.Notify := True;  // Request next notification
end;

{ Responds to user clicking in the MediaPlayer object. We need
  to check for this because, if the auto-replay checkbox is
  enabled, stopping the media would generate a notification,
  which would start playing again! In other words, this
  procedure allows the media to be stopped regardless of the
  auto-replay checkbox setting. }
procedure TForm1.MediaPlayer1Click(Sender: TObject;
  Button: TMPBtnType; var DoDefault: Boolean);
begin
  if (Button = btStop) or (Button = btPause) then
    MediaPlayer1.Notify := False   // Do not continue replay
  else
    MediaPlayer1.Notify := True;   // Replay if checkbox is set
end;

{ Responds to user changing the state of the auto-replay
  checkbox. If the checkbox is being enabled, this procedure
  turns on notifications so that, when the media stops, the
  Notify event handler can restart the media playing. }
procedure TForm1.AutoPlayCheckBoxClick(Sender: TObject);
begin
  if AutoPlayCheckBox.Checked then
    MediaPlayer1.Notify := True;  // Triggers notifications
end;

end.
