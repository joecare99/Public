unit fv2dos deprecated 'use sysutils';

{$mode objfpc}

interface

uses
  Classes, SysUtils;

type
  PathStr=string deprecated 'use String';
  DirStr=string deprecated 'use String';
  NameStr=string deprecated 'use String';
  FNameStr=string deprecated 'use String';
  ExtStr=string deprecated 'use String';
  SearchRec=TSearchRec  deprecated 'use TSearchRec';

function Fexpand(p:string):string; deprecated 'use ExpandFileName';
procedure Fsplit(p:string;out d,n,e:String);deprecated 'use ExtractFile... and ChangeFile...';
function FSearch(p,path:string):string;deprecated 'use FileSearch';

Procedure Assign(out F:File;s:String);deprecated 'use FileOpen';
Procedure Erase(var F:File);deprecated 'use DeleteFile';
Procedure Rename(var F:File;s:String);deprecated 'use RenameFile';

Procedure GetDate(out year, month, mday, wday: word);deprecated 'use now';
Procedure GetTime(out hour, minute, second, sec100: word);deprecated 'use now';

var dosError:integer;

const Directory=faDirectory  deprecated 'use faDirectory';

implementation

uses dateutils;

function Fexpand(p: string): string;
begin
  result := ExpandFileName(p);
end;

procedure Fsplit(p: string; out d, n, e: String);
begin
  d:=ExtractFilePath(p);
  E:=ExtractFileext(p);
  n:=ExtractFilename(p);
  n:=copy(n,1,length(n)-length(e));
end;

function FSearch(p, path: string): string;
begin
  result := FileSearch(p,path);
end;

procedure Assign(out F: File; s: String);
begin
  system.Assign(f,s);
end;

procedure Erase(var F: File);
begin
  CloseFile(f);
  system.erase(F);
end;

procedure Rename(var F: File; s: String);
begin
  CloseFile(f);
  system.Rename(F,s);
end;

procedure GetDate(out year, month, mday, wday: word);
var
  lNow: TDateTime;
begin
  lNow:=Now;
  year:=yearof(lNow);
  month:=MonthOf(lNow);
  mday:=DayOf(lNow);
  wday:=DayOfTheWeek(lNow);
end;

procedure GetTime(out hour, minute, second, sec100: word);
var
  lNow: TDateTime;
begin
  lNow:=Now;
  hour:=HourOf(lNow);
  minute:=MinuteOf(lNow);
  second:=SecondOf(lNow);
  sec100:=MilliSecondOf(lNow) div 10;
end;

end.

