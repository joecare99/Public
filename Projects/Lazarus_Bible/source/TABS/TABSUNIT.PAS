{ Tabsunit.Pas -- Support procedures for Tabs program }

unit TabsUnit;

interface

uses SysUtils, Controls, Dialogs;

procedure ErrorMessage(N: Integer; const S: string);
procedure FSplit(const Path: TFileName;
  var Dir, Name, Ext: TFileName);
function Yes(S: string): Boolean;
function ProcessTabs(const FileName: TFileName;
  Inserting, BackingUp: Boolean): Boolean;

implementation

uses Frm_Options;

const

  tabChar   = #9;
  blankChar = #32;

var

  InFile, OutFile: Text;
  InName, OutName, BakName: TFileName;

procedure ErrorMessage(N: Integer; const S: string);
begin
  MessageDlg('Error #' + IntToStr(N) + ':' + S, mtError, [mbOK], 0);
end;

function Yes(S: string): Boolean;
begin
  Yes := MessageDlg(S, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure FSplit(const Path: TFileName;
  var Dir, Name, Ext: TFileName);
begin
  Dir := ExtractFilePath(Path);
  Name := ExtractFileName(Path);
  System.Delete(Name, Pos('.', Name), 4);
  Ext := ExtractFileExt(Path);
end;

function OpenFiles(const FileName: TFileName): Boolean;
var
  D: TFileName;
  N: TFileName;
  E: TFileName;
begin
  OpenFiles := false;
  InName := FileName;
  FSplit(FileName, D, N, E);
  OutName := D + N + '.$$$';
  BakName := D + N + '.' + OptionsDialog.BackupExtEdit.Text;
  Assign(InFile, FileName);
  Assign(OutFile, OutName);
  {$I-} Reset(InFile); {$I+}
  if IoResult <> 0 then Exit;
  {$I-} Rewrite(OutFile); {$I+}
  if IoResult <> 0 then
  begin
    Close(Infile);
    Exit
  end;
  OpenFiles := true
end;

procedure ExpandLine(var Line: String);
var
  I, TabWidth, Ignore: Integer;
  C: Char;
  NewLine: String;
begin
  Val(OptionsDialog.InTabEdit.Text, TabWidth, Ignore);
  if TabWidth < 2 then TabWidth := 2;
  NewLine := '';
  for I := 1 to Length(Line) do
  begin
    C := Line[I];
    if C = tabChar
    then
      repeat
        NewLine := NewLine + blankChar
      until (Length(NewLine) mod TabWidth) = 0
    else
      NewLine := NewLine + C
  end;
  Line := NewLine
end;

procedure CompressLine(var Line: String);
var
  C: Char;
  Col, TabCol, TabWidth, Ignore: Integer;
  EndOfLine: Boolean;
  NewLine: String;

  function NextChar(var C: Char): Char;
  begin
    C := Line[Succ(TabCol)];
    NextChar := C;
    EndOfLine := C = #0
  end;

begin
  Val(OptionsDialog.OutTabEdit.Text, TabWidth, Ignore);
  if TabWidth < 2 then TabWidth := 2;
  NewLine := '';
  Line := Line + #0;
  Col := 0;
  repeat
    TabCol := Col;
    while NextChar(C) = blankChar do
    begin
      Inc(TabCol);
      if TabCol mod TabWidth = 0 then
      begin
        NewLine := NewLine + tabChar;
        Col := TabCol
      end
    end;
    while (Col < TabCol) do
    begin
      NewLine := NewLine + blankChar;
      Inc(Col)
    end;
    if not EndOfLine then
    begin
      NewLine := NewLine + C;
      Inc(Col)
    end
  until EndOfLine;
  Line := NewLine
end;

procedure StripLine(var Line: String);
var
  I: Integer;
begin
  for I := 1 to Length(Line) do
    Line[I] := Chr(Ord(Line[I]) and $7F)
end;

procedure UpperLine(var Line: String);
var
  I: Integer;
begin
  for I := 1 to Length(Line) do
    Line[I] := UpCase(Line[I])
end;

{- Because this program is a Turbo Vision conversion, error control
in this unit is less than ideal. Eventually should update to use
exceptions, but this works for now. }
function ErrorDetected: Boolean;
var
  Q: Integer;
begin
  Q := IoResult;
  if Q <> 0 then
  begin
    ErrorMessage(Q, 'I/O Error');
    ErrorDetected := true;
    Close(InFile);
    Close(OutFile)
  end else
    ErrorDetected := false
end;

procedure CloseFiles(BackingUp: Boolean);
var
  BakFile: File;
begin
  Close(InFile);
  Close(OutFile);
  if BackingUp then
  begin
    if FileExists(BakName) then
    begin
      Assign(BakFile, BakName); { Prepare to create backup }
      Erase(BakFile)            { Delete old backup if any }
    end;
    Rename(InFile, BakName)     { Original file --> file.bak }
  end else
  begin
    Assign(InFile, InName);     { Prepare to delete original }
    Erase(InFile)               { Delete file }
  end;
  Rename(OutFile, InName)       { Rename temp file --> original }
end;

{- Insert tabs if Inserting = true; else remove tabs from file }
function ProcessTabs(const FileName: TFileName;
  Inserting, BackingUp: Boolean): Boolean;
var
  Line: String;
begin
  ProcessTabs := false;
  if OpenFiles(FileName) then
  begin
    while not eof(InFile) do
    begin
      {$I-} Readln(InFile, Line); {$I+}
      if ErrorDetected then Exit;
      if Inserting then CompressLine(Line) else ExpandLine(Line);
      if OptionsDialog.StripCheckbox.Checked then StripLine(Line);
      if OptionsDialog.ConvertCheckbox.Checked then UpperLine(Line);
      {$I-} Writeln(OutFile, Line); {$I+}
      if ErrorDetected then Exit
    end;
    CloseFiles(BackingUp);
    ProcessTabs := true
  end else
    ErrorMessage(0, 'Error opening files')
end;

end.

{--------------------------------------------------------------
  Copyright (c) 1991,1995 by Tom Swan. All rights reserved.
  Revision 1.00    Date: 2/24/1991
  Revision 2.00    Date: 5/13/1995
---------------------------------------------------------------}


