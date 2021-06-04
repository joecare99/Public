{$ifdef fpc}
  {$mode delphi}
{$endif}
unit Unt_FileMove;
// Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;Winapi;System;Xml;Data;Datasnap;Web;Soap
interface

uses Classes;

type
    TTextOutProc = procedure(str :string) of object;
    { TFileMoveApp }

    TFileMoveApp = class(TComponent)
    private
        FTitle :string;
        procedure HandleParameters(out FormatCode :boolean;
            out Filename, MovePattern :string);
        procedure SetTitle(val :string);
        procedure ConsoleTextOut(str :string);
    public
        procedure DoFileProcessing(const lFileName :string;
            const lMovePattern :string; const FormatCode :boolean;
            const SVN :boolean = False; const lTextOut :TTextOutProc = nil);
        procedure Init;
        procedure Run;
        function SvnMoveFile(SourcePath, DestPath :string) :boolean;
        property Title :string read FTitle write SetTitle;

    end;

var
    Application :TFileMoveApp;

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
        '<Ziel> '#9' fuer das Ziel: Funktionen werden mit $[a-z] angesprochen'#10#13#10#13 + 'Beispiel: %0:s  test.exp .$p\$t\ '#10#13 +
        'Das Beispiel schiebt die "test.exp" in den Ordner .\SEWPfad\Blocks\'#10#13#10#13
        + 'Compiliert am %1:s'#10#13#10#13 + 'Weiter mit <Enter>';

procedure TFileMoveApp.Init;
begin
    // Init - Routine
end;


function TFileMoveApp.SvnMoveFile(SourcePath, DestPath :string) :boolean;
var
    SvnMoveProcess :TProcess;
    Buffer :string;
    {%H-}ResultStr :string; // To Debug
    n      :longint;

begin
    Result := False;
    SvnMoveProcess := TProcess.Create(nil);
      try
        with SvnMoveProcess do
          begin
            Executable := 'svn';
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
                n      := Stderr.Read(Buffer[1], 1024);
                Result := (n = 0);
              except
                // ignore error, default result is false
              end;
          end;
      finally
        SvnMoveProcess.Free;
      end;
end;

procedure TFileMoveApp.Run;
var
    lFileName, lMovePattern :string;
    FormatCode :boolean;
    SVN :boolean;

begin
    SVN := True;

    HandleParameters(FormatCode, lFileName, lMovePattern);

    if (lFileName <> '') and FileExists(lFileName) then
        DoFileProcessing(lFileName, lMovePattern, FormatCode, SVN, ConsoleTextOut);

end;

procedure TFileMoveApp.SetTitle(val :string);
begin
    FTitle := Val;
end;

procedure TFileMoveApp.ConsoleTextOut(str :string);
begin
    Writeln(Str);
end;

procedure TFileMoveApp.DoFileProcessing(const lFileName :string;
    const lMovePattern :string; const FormatCode :boolean;
    const SVN :boolean = False; const lTextOut :TTextOutProc = nil);

var
    lOldFilename :string;
    lTt      :Text;
    lMoveLogFile :string;
    lSvnPath :string;
    bakfile  :string;
    NewName  :string;
    lFileInfo :string;
begin
    if FileInUse(lFileName) then
      begin
        if assigned(lTextOut) then
            lTextOut(#7'File ' + lFileName + ' in use!');
        exit;
      end;
    lFileInfo := getFileInfo(lFileName);
    if lMovePattern <> '' then
      begin
        NewName := BuildStringByFunction(lMovePattern, lFileInfo);
        if copy(NewNAme, length(NewName), 1) = DirectorySeparator then
            NewName := NewName + ExtractFileName(lFileName);
        if assigned(lTextOut) then
            lTextOut(NewName);
        Makepath(ExtractFilePath(NewName));
      end
    else
        Newname := lFileName;

    if FileExists(NewName) then
      begin
        if newname <> lFileName then
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
        lSvnPath := ExtractFilePath(lFileName);
        if lSvnPath = '' then
            lSvnPath := '.';
        lSvnPath     := IncludeTrailingPathDelimiter(lSvnPath) + '.MoveLog';
        Makepath(lSvnPath);
        lMoveLogFile :=
            lSvnPath + DirectorySeparator + ChangeFileExt(
            extractfilename(lFileName), '.movelog');
        AssignFile(lTt, lMoveLogFile);
          try
            if FileExists(lMoveLogFile) then
              begin
                reset(lTt);
                readln(lTt, lOldFilename);
                if copy(lOldFilename, 1, 1) = '"' then
                    lOldFilename :=
                        copy(lOldFilename, 2, length(trim(lOldFilename)) - 2);
                lOldFilename     :=
                    '.\' + ExtractRelativepath(GetCurrentDir + '\',
                    lOldFilename);
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
          try
            sewfile.loadfromfile(lFileName);
            sewfile.autoformat;
            sewfile.savetofile(lOldFilename);
          except
          end;
        if fileexists(lOldFilename) and (lOldFilename <> lFileName) then
            DeleteFile(lFileName)
        else
            RenameFile(bakfile, lFileName);
      end
    else if (lOldFilename <> lFileName) and not
        RenameFile(lFileName, lOldFilename) then
        readln;

    if (lOldFilename <> NewName) then
      begin
        //SVN - Move
        SvnMoveFile(lOldFilename, NewName);
        if FileExists(lOldFilename) then
          begin
            Makepath(ExtractFilePath(NewName));
            RenameFile(lOldFilename, NewName);
          end;
      end;
end;

procedure TFileMoveApp.HandleParameters(out FormatCode :boolean;
    out Filename, MovePattern :string);
var
    FI :string;
begin
    Filename    := '';
    MovePattern := '';
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
        if uppercase(ParamStr(1)) = '/F' then
          begin
            Filename   := ParamStr(2);
            FormatCode := True;
            if (paramcount >= 3) then
                MovePattern := ParamStr(3);
          end
        else
          begin
            Filename    := ParamStr(1);
            MovePattern := ParamStr(2);
            FormatCode  := False;

          end;
      end;
end;

initialization
    Application := TFileMoveApp.Create(nil);

finalization
    FreeAndNil(Application);
end.
