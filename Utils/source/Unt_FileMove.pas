unit Unt_FileMove;
// Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;Winapi;System;Xml;Data;Datasnap;Web;Soap
interface

uses Classes;

type

  { TMyApplication }

  TMyApplication = class(TComponent)
  private
    FTitle: string;
    procedure SetTitle(val: string);
  public
    procedure Init;
    procedure Run;
    function SvnMoveFile(SourcePath, DestPath: string): boolean;
    property Title: string read FTitle write SetTitle;
  end;

var
  Application: TMyApplication;

implementation

uses
{$ifndef fpc}
  Windows,
{$else}
  process,
{$endif}
  SysUtils,
  Unt_FileProcs,
  unt_Stringprocs,
  unt_cdate,
  cmp_SEWFile;

resourcestring
  /// <author>Rosewich</author>
  /// <user>admin</user>
  /// <since>30.10.2012</since>
  /// <version>1.00.00</version>
  /// <info>Hilfetext zum Anzeigen</info>
  StrHelpText =
    '%0:s ist ein Programm um SEW-Export-Dateien anhand ihrer Daten zu verschieben. '#10#13 + #10#13 + 'Aufruf: %0:s <Datei> <Ziel>'#10#13#10#13 +
    '<Datei>'#9' steht fuer die zu verschiebende Datei' + #10#13 +
    '<Ziel> '#9' fuer das Ziel: Funktionen werden mit $[a-z] angesprochen'#10#13#10#13 +
    'Beispiel: %0:s  test.exp .$p\$t\ '#10#13 +
    'Das Beispiel schiebt die "test.exp" in den Ordner .\SEWPfad\Blocks\'#10#13#10#13 +
    'Compiliert am %1:s'#10#13#10#13 + 'Weiter mit <Enter>';

procedure TMyApplication.Init;
begin
  // Init - Routine
end;

function TMyApplication.SvnMoveFile(SourcePath, DestPath: string): boolean;
var
  SvnMoveProcess: TProcess;
  Buffer: string;
  {%H-}ResultStr: string; // To Debug
  n: longint;

begin
  Result := False;
  SvnMoveProcess := TProcess.Create(nil);
  try
    with SvnMoveProcess do
    begin
      Executable:= 'svn';
      Parameters.Add('move');
      Parameters.Add(SourcePath);
      Parameters.Add(DestPath);
      Options := [poUsePipes, poWaitOnExit, poNoConsole];
      try
        Execute;
        SetLength(Buffer, 400);
        n := OutPut.Read(Buffer[1], 400);
        ResultStr := Copy(Buffer, 1, n);

        SetLength(Buffer, 1024);
        n := Stderr.Read(Buffer[1], 1024);
        result := (n = 0);
      except
        // ignore error, default result is false
      end;
    end;
  finally
    SvnMoveProcess.Free;
  end;
end;

procedure TMyApplication.Run;
var
  FI, NewName: string;
  Filenameparam: integer;
  FormatCode: boolean;
  bakfile: string;
  lSvnPath: string;
  lMoveLogFile: string;
  lTt: Text;
  lOldFilename: string;
  SVN: boolean;

begin
  Filenameparam := 1;
  SVN := True;
  if paramcount = 0 then
  begin
    FI := extractfilename(ParamStr(0));
    Writeln(ansi2ascii(format(StrHelpText, [fi, CDate])));
    readln;
  end
  else if (paramcount = 1) and FileExists(ParamStr(1)) then
  begin
    Writeln(getFileInfo(ParamStr(1)));
    readln;
  end
  else if (paramcount >= 2) then
  begin
    FormatCode := False;
    if uppercase(ParamStr(1)) = '/F' then
    begin
      Filenameparam := 2;
      FormatCode := True;
    end;
    if FileExists(ParamStr(Filenameparam)) then
    begin
      FI := getFileInfo(ParamStr(Filenameparam));
      if (paramcount >= 3) then
      begin
        NewName := BuildStringByFunction(ParamStr(Filenameparam + 1), FI);
        if copy(NewNAme, length(NewName), 1) = DirectorySeparator then
          NewName := NewName + ExtractFileName(ParamStr(Filenameparam));
        Writeln(NewName);
        Makepath(ExtractFilePath(NewName));
      end
      else
        Newname := ParamStr(Filenameparam);

      if FileExists(NewName) then
      begin
        if newname <> ParamStr(Filenameparam) then
        begin
          bakfile := ChangeFileExt(Newname, '.BAK');
          if fileexists(bakfile) then
            deleteFile(bakfile);
          RenameFile(NewName, Bakfile);
        end;
      end;

      lOldFilename := NewName;
      if SVN then
      begin
        lSvnPath := ExtractFilePath(ParamStr(Filenameparam));
        if lSvnPath = '' then
          lSvnPath := '.';
        lSvnPath := lSvnPath + DirectorySeparator + '.MoveLog';
        Makepath(lSvnPath);
        lMoveLogFile := lSvnPath + DirectorySeparator + ChangeFileExt(
          ParamStr(Filenameparam), '.movelog');
        AssignFile(lTt, lMoveLogFile);
        try
          if FileExists(lMoveLogFile) then
          begin
            reset(lTt);
            readln(lTt, lOldFilename);
            if copy(lOldFilename,1,1)='"' then
               lOldFilename:=copy(lOldFilename,2,length(trim(lOldFilename))-2);
            lOldFilename:='.\'+ExtractRelativepath(GetCurrentDir+'\',lOldFilename);
          end
          else
            lOldFilename := '';
          if lOldFilename <> NewName then
          begin
            if lOldFilename = '' then
              lOldFilename := NewName
            else
              Makepath(ExtractFilePath(lOldFilename));
            rewrite(lTt);
            writeln(lTt, NewName);
          end;
        finally
          CloseFile(lTt);
        end;
      end;

      if FormatCode then
      begin
        sewfile.loadfromfile(ParamStr(Filenameparam));
        try
        sewfile.autoformat;
        sewfile.savetofile(lOldFilename);
        except
        end;
        if fileexists(lOldFilename) and (lOldFilename <> ParamStr(Filenameparam)) then
          DeleteFile(ParamStr(Filenameparam))
        else
          RenameFile(bakfile,ParamStr(Filenameparam))
      end
      else
      if (lOldFilename <> ParamStr(Filenameparam)) and not
        RenameFile(ParamStr(Filenameparam), lOldFilename) then
        readln;

      if (lOldFilename <> NewName) then
      begin
        //SVN - Move
        SvnMoveFile(lOldFilename, NewName);
        if FileExists(lOldFilename) then
          begin
            Makepath(ExtractFilePath(NewName));
            RenameFile(lOldFilename, NewName)
          end;
      end;

    end;
  end;
end;

procedure TMyApplication.SetTitle(val: string);
begin
  FTitle := Val;
end;

initialization
  Application := TMyApplication.Create(nil);

finalization
  FreeAndNil(Application);
end.
