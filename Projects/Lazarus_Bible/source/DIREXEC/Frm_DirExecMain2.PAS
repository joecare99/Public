unit Frm_DirExecMain2;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  ShellAPI, Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, ExtCtrls, StdCtrls, AsyncProcess;

type

  { TMainForm }

  TMainForm = class(TForm)
    AsyncProcess1: TAsyncProcess;
    btnRun1: TBitBtn;
    Memo1: TMemo;
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    btnClose: TBitBtn;
    procedure AsyncProcess1ReadData(Sender: TObject);
    procedure AsyncProcess1Terminate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses process;
{$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
  BUF_SIZE = 2048; // Buffer size for reading the output in chunks

var
   Buffer       : array[1..BUF_SIZE] of char;


procedure TMainForm.btnRunClick(Sender: TObject);
begin
  // see also :
  //     http://wiki.lazarus.freepascal.org/Executing_External_Programs#TProcess

  {$IFDEF Windows}
     // In Windows the dir command cannot be used directly because it's a build-in
     // shell command. Therefore cmd.exe and the extra parameters are needed.
     AsyncProcess1.Executable := GetEnvironmentVariable('COMSPEC');
     AsyncProcess1.Parameters.Add('/c');
     AsyncProcess1.Parameters.Add('dir /s c:\windows\system32');
   {$ENDIF Windows}

   {$IFDEF Unix}
     AsyncProcess1.Executable := '/bin/ls';
     AsyncProcess1.Parameters.Add('--recursive');
     AsyncProcess1.Parameters.Add('--all');
     AsyncProcess1.Parameters.Add('-l');
   {$ENDIF Unix}

   // Process option poUsePipes has to be used so the output can be captured.
    // Process option poWaitOnExit can not be used because that would block
    // this program, preventing it from reading the output data of the process.
    AsyncProcess1.Options := [poUsePipes,poNoConsole];

    // Start the process (run the dir/ls command)
    AsyncProcess1.Execute;
end;

procedure TMainForm.AsyncProcess1ReadData(Sender: TObject);

var
  aStr: String;
  BytesRead: LongInt;
begin

   BytesRead:= AsyncProcess1.Output.Read(Buffer,BUF_SIZE);
   setlength(aStr,BytesRead);
   move(Buffer,astr[1],BytesRead);
   memo1.Append(astr);
end;

procedure TMainForm.AsyncProcess1Terminate(Sender: TObject);
begin
  Memo1.Append('<------------------Terminated------------------>');
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  AsyncProcess1.Terminate(0);
end;

end.
