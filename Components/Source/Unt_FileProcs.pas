Unit Unt_FileProcs;

{*v 1.00.07 }
{*h 1.00.06 CleanPath}
{*h 1.00.05 Class of CFileInfo }
{*h 1.00.04 Anpassungen an FPC, Testcase }
{*h 1.00.02 Erweitere CFileInfo um Displayname und Extensions& entsp. Register-Proc}
{*h 1.00.01 GetBackupPath}
{*h 1.00.00 IsEmpty, File In Use}

{$i jedi.inc}
Interface

Uses
  {$IFNDEF FPC}
  Windows,
  {$ELSE}
 {$IFNDEF UNIX}
  Windows,
  comObj,
  {$ELSE}
 // Windows,
  {$ENDIF}
  {$ENDIF}
  // Stringprocs,
  classes,
  SysUtils,

  //     filectrl,
  registry,
  Unt_LinList;

Type
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  ///  <info>CallBack-Delegate with the Persentage,
  ///the actual file and the ability to break the
  ///process by returning false</info>
  TSuccess = Function(Perc: real; Afile: String): boolean Of Object;

{$ifndef SUPPORTS_GENERICS}
{$if declared(TStringArray)}
  TStringArray = SysUtils.TStringArray;
  {$ELSE}
  TStringArray = array of string;
  {$ENDIF}
{$endif ~SUPPORTS_GENERICS}

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  TFiles {= TStringList;
  TFilesEntry }= Class(TNamedList)
    pfad: String;
    attr: integer;
    size : integer;
    time: TDateTime;
  End;
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  TFileinfo = Function(pfad: String; Force: boolean = false): String Of Object;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  TGetInfo {= TStringLIst;
  TGetInfoEntry }= Class(TNamedList)
  public
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
    FInfoProc: TFileInfo;
  End;

Type
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>

  { CFileInfo }

  CFileInfo = Class
    abstract
    private
    public
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
    class Function GetFileInfoStr(Path: String; Force: boolean = false): String;
      virtual; abstract;
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
    class Function DisplayName: String;
      virtual; abstract;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
    class Function Extensions:{$ifdef SUPPORTS_GENERICS}Tarray<String>{$else}TStringArray{$endif};
      virtual; abstract;

    /// <author>Joe Care</author>
    /// <since>26.10.2012</since>
    ///  <version>1.00.06</version>
    class function FileOpenFilter: STRING;
  End;
  TFileInfoClass=class of CFileInfo;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Erstelle falls noetig den npath
Procedure Makepath(npath: String);

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // erzeugt aus dem angegebenen Datei-Pfad einen Backup-Datei-Pfad.
Function GetBackupPath(Path: String): String;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Benenne oder Verschiebe mehrere dateien
Procedure MultiReName(OldName, NewName: String; repl: TSuccess = Nil; minp:
  integer = 0; maxp: integer = 100);

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Gibt TRUE zurueck wenn das Verzeichniss leer ist.
Function IsEmptyDir(path: String): boolean;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Durchsuche Verzeichnisbaum ~path~ recursiv nach ~mask~
Function GetFiles(mask, path: String; repl: TSuccess = Nil; minp: integer = 0;
  maxp: integer = 100): Tfiles;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Hole Directory
Function GetDir(path: String; Sattr, FAttr: integer): TFiles;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Hole weitere Infos UEber Datei ein;
Function GetFileInfo(path: String; force: Boolean = false): String;

///<author>Joe Care</author>
///  <version>1.00.07</version>
// Bereinigt einen Pfad von '/..'-Einträgen.
Function CleanPath(path: String): String;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  // Hole Dateiversion
Function GetVersion(filename: String): String;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  ///  <tested>true</Tested>
  ///  <info>Pruefe ob datei Schon benutzt wird</info>
  // Pruefe ob datei schon benutzt wird
Function FileInUse(FileName: String): boolean;

Type
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  TGDD_Area = (gdda_Network, gdda_System, gdda_Group, gdda_User);
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  TGDD_DataType = (gddt_Ini, gddt_Dok, gddt_Music, gddt_Pictures, gddt_Misc);

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
Function GetDefaultDataDir(Area: TGDD_Area; DataType: TGDD_DataType): String;

  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
Procedure RegisterGetInfoProc(name: String; PinfoProc: TFileInfo);overload;
Procedure RegisterGetInfoProc(FIClass: CFileInfo);overload;
Procedure RegisterGetInfoProc(TFIClass: TFileInfoClass);overload;
// Trage eine GetFileInfo-Procedur in die test-Liste ein.

///<author>Joe Care</author>
///  <version>1.00.02</version>
Procedure UnRegisterGetInfoProc(FIClass: CFileInfo);overload;
// Trage eine GetFileInfo-Procedur in die test-Liste ein.

Var
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  GetInfoList: TGetInfo; // Globale Get_File-Info-Liste.
  ///<author>Joe Care</author>
  ///  <version>1.00.02</version>
  dbg: TGetInfo;

const
   DirSep = {$IFNDEF FPC} '\'{$else ~FPC}DirectorySeparator{$endIF ~FPC};

resourcestring
  rsAllFilesFilter = 'Alle Dateien (*.*)|*.*';

Implementation

{$IFNDEF UNIX}
uses shFolder;
{$ELSE}
//uses shFolder;
{$ENDIF}

resourcestring
  rsJCSoft = 'JC-Soft';

function FileInUse(FileName: String): boolean;

Var
  HFileRes: {$IFNDEF UNIX} HFILE {$ELSE} THandle {$ENDIF};

Begin
  Result := false;
  If FileExists(FileName) Then
    Begin
      HFileRes := FileOpen(pchar(FileName),fmOpenReadWrite or fmShareExclusive);
      Result := (HFileRes = {$IFNDEF UNIX} INVALID_HANDLE_VALUE {$ELSE} 0 {$ENDIF});
      If Not Result Then
        FileClose(HFileRes);
    End;
End;

function GetFiles(mask, path: String; repl: TSuccess; minp: integer;
  maxp: integer): Tfiles;
// Benutzt GetDir

Var
  fls, fls2, p: Tfiles;
  break: boolean;
  cnt, i, dif, lmn, lmx: integer;

Const
  FSAttr = faAnyfile - faDirectory;

Begin
  fls2 := Nil;
  break := false;

  // Füge zum Pfad ein '\' Zeichen Hinzu, Falls es nicht auf ein '\' endet.
  If path[length(path)] <> DirSep Then
    path := path + DirSep;

  // Hole Directorys
  fls := getdir(path + '*', faAnyFile, faDirectory);

  cnt := fls.Count;
  i := 0;
  p := fls;
  dif := maxp - minp;

  // Rufe die Reply - Function mit dem Aktellen Pfad auf.
  If assigned(repl) And (dif > 1) Then
    break := repl(minp, path);
  lmn := minp;

  While assigned(p) And (Not break) Do
    Begin
      inc(i);
      lmx := minp + (i * dif) Div cnt;
      If assigned(fls2) Then
        fls2 := fls2.addto(getfiles(mask, p.pfad, repl, lmn, lmx)) As Tfiles
      Else
        fls2 := getfiles(mask, p.pfad, repl, lmn, lmx);
      If assigned(repl) And (dif > 1) Then
        break := repl(lmx, p.pfad);

      p := p.getnext As Tfiles;
      lmn := lmx
    End;
  If assigned(fls2) Then
    fls2 := fls2.addto(getdir(path + mask, FSAttr, 0)) As Tfiles
  Else
    fls2 := getdir(path + mask, FSAttr, 0);
  {
    if assigned(fls2) then
      fls:=fls2.addto(fls) as Tfiles;}
  fls.free;

  result := fls2;
End;

function IsEmptyDir(path: String): boolean;

Var
  sr: TSearchRec;

Begin
  result := DirectoryExists(Path); { *Converted from DirectoryExists*  }
  If path[length(path)] <> DirSep Then
    path := path + DirSep;
  If result Then
    Begin
      result := false;
      FindFirst(path + '*.*', faAnyFile, sr); { *Converted from FindFirst*  }
      If (sr.name <> '.') And (sr.name <> '..') Then
        Begin
          exit
        End;
      FindNext(sr); { *Converted from FindNext*  }
      If (sr.name <> '.') And (sr.name <> '..') Then
        Begin
          exit
        End;
      result := FindNext(sr) { *Converted from FindNext*  } <> 0;
      sysutils.FindClose(sr); { *Converted from FindClose*  }
    End;
End;

function GetDir(path: String; Sattr, FAttr: integer): TFiles;

Var
  sr: TSearchRec;
  FPath: String;
  res: integer;
  nl1: TFiles;

Begin
  nl1 := Nil;
  fpath := ExpandFileName(path); { *Converted from ExpandFileName*  }
  fpath := ExtractFilePath(fpath);
  res := FindFirst(path, Sattr, sr); { *Converted from FindFirst*  }
  While res = 0 Do
    Begin
      If ((sr.attr And Fattr) = Fattr) And (sr.name <> '.') And (sr.name <> '..')
        Then
        Begin
          If (sr.Attr And fadirectory) <> 0 Then
            sr.Name := sr.name + DirSep;
          nl1 := TFiles.create(sr.name, nl1);
          nl1.attr := sr.attr;
          nl1.pfad := fpath + sr.name;
          {$ifdef FPC}
          nl1.time := FileDateToDateTime( sr.Time);
          {$else ~FPC}
{$ifdef Compiler15_up}
          nl1.time := sr.TimeStamp;
{$else ~Compiler15_up}
     nl1.time := FileDateToDateTime( sr.Time);
{$endif Compiler15_up}
        {$EndIF ~FPC}
        nl1.size := sr.Size;
        End;
      res := FindNext(sr); { *Converted from FindNext*  }
    End;
  result := nl1;
  sysutils.FindClose(sr); { *Converted from FindClose*  }
End;

// erzeugt aus dem angegebenen Datei-Pfad einen Backup-Datei-Pfad.
function GetBackupPath(Path: String): String;

{$ifndef RTL100_UP}
Var
  Dir: String;
{$ENDIF}

Begin
{$ifndef RTL100_UP}
  dir := copy(path, 1, length(path) - length(ExtractFileext(Path)));
  result := dir + '.BAK';
{$ELSE}
  result := ChangeFileExt(Path,'.BAK');
{$ENDIF}
End;

procedure Makepath(npath: String);
// Erstelle falls nötig den npath

Var
  CPath: String;
  flag: boolean;

Begin
  If npath[length(npath)] <> DirSep Then
    npath := npath + DirSep;
  CPath := '';
  flag := True;
  While (CPath + DirSep <> npath) And (CPath <> npath) And flag Do
    Begin
      CPath := copy(npath, 1, pos(DirSep, copy(npath, Length(CPath) + 2,
        length(npath))) + Length(CPath) + 1);
      flag := DirectoryExists(CPath); { *Converted from DirectoryExists*  }
    End;
  If Not flag Then
    Begin
      MkDir(CPath);
      While (CPath + DirSep <> npath) And (CPath <> npath) Do
        Begin
          CPath := copy(npath, 1, pos(DirSep, copy(npath, Length(CPath) + 2,
            length(npath))) + Length(CPath) + 1);
          MkDir(CPath);
        End;
    End;

End;

// Falls die Datei schon vorhanden ist wird nach einem neuen Namen Gesucht.

Procedure FindOtherNewName(Var NewFname: String);
Var
  j: Integer;
Begin
  If FileExists(NewFName) { *Converted from FileExists*  } Then
    Begin
      j := 2;
      While FileExists(copy(Newfname, 1, length(NewFname) -
        length(ExtractFileExt(NewFName))) + '_' + inttostr(j) +
        ExtractFileExt(NewFName)) { *Converted from FileExists*  } Do
        inc(j);
      newfname := copy(Newfname, 1, length(NewFname) -
        length(ExtractFileExt(NewFName))) + '_' + inttostr(j) +
        ExtractFileExt(NewFName);
    End;
End;

// Diese Procedure Hat Die Aufgabe Mehrere Dateien Umzubenennen

procedure MultiReName(OldName, NewName: String; repl: TSuccess; minp: integer;
  maxp: integer);
// benutzt DIR --> unterbricht vorhergehende dir - Abfragen

Var
  OldFName, NewFname, oFp, //oFn, oFe,  NFn, NFe
    NFp: String;
  //    NFAttr:integer;
  DirectoryMode: boolean;
  dimc, I {,j}: integer;
  files: Array Of String;
  sr: TSearchRec;

Begin
  If (pos('*', OldName) > 0) Or
    (pos('?', OldName) > 0) Or
    (pos('*', newName) > 0) Or
    (pos('?', newName) > 0) Then
    Begin
      // Joker-zeichen angegeben --> Multi ren erforderlich
      ofp := ExtractFilePath(oldname);
//      ofn := ExtractFileName(oldname);
//      ofe := ExtractFileExt(oldname);
      nfp := ExtractFilePath(newname);
//      nfn := ExtractFileName(newname);
//      nfe := ExtractFileExt(newname);

      If FindFirst(OldName, faDirectory, sr) { *Converted from FindFirst*  } = 0 Then
        OldFName := sr.Name
      Else
        oldfname := '';

      // Bestimme Anzahl
      dimc := 0;
      While OldFName <> '' Do
        Begin
          If (OldFName <> '.') And (OldFName <> '..') Then
            dimc := dimc + 1;
          If FindNext(sr) { *Converted from FindNext*  } = 0 Then
            OldFName := sr.Name
          Else
            oldfname := '';
        End; //  wend
      sysutils.FindClose(sr); { *Converted from FindClose*  }

      // Hole Dateien
      setlength(files, dimc);
      If FindFirst(OldName, faDirectory, sr) { *Converted from FindFirst*  } = 0 Then
        OldFName := sr.Name
      Else
        oldfname := '';
      I := 0;
      While OldFName <> '' Do
        Begin
          If (OldFName <> '.') And (OldFName <> '..') Then
            Begin
              files[I] := OldFName;
              I := I + 1;
            End; //  If ...
          If FindNext(sr) { *Converted from FindNext*  } = 0 Then
            OldFName := sr.Name
          Else
            oldfname := '';
        End; //  wend
      sysutils.FindClose(sr); { *Converted from FindClose*  }
      // Mylist.Show

      If (Not FileExists(NewName) { *Converted from FileExists*  }) And (Not DirectoryExists(Newname) { *Converted from DirectoryExists*  }) Then
        Begin
          If NewName[length(newname)] = DirSep Then
            Begin
              makepath(NewName);
              DirectoryMode := True
            End
          Else
            Begin
              DirectoryMode := False
            End; //  If ...
        End
      Else
        Begin
          DirectoryMode := DirectoryExists(Newname); { *Converted from DirectoryExists*  }
          If Not DirectoryMode Then
            runerror(255);
        End; //  If ...

      If DirectoryMode Then
        Begin
          If NewName[length(newname)] <> DirSep Then
            NewName := NewName + DirSep;
          For I := low(files) To high(files) Do
            Begin
              newFname := NewName + files[I];
              FindOtherNewName(NewFname);
              If assigned(repl) Then
                Begin
                  If repl((i - low(files)) / (high(files) - low(files)) * 100,
                    oFp + files[I] + #9 + newFname) Then
                    multiReName(oFp + files[I], newFname);
                End
              Else
                multiReName(oFp + files[I], newFname)
            End;
        End
      Else
        Begin
          runerror(255);
        End; //  If ...
    End //  If ...
  Else
    Begin
      If newname[length(newname)] = DirSep Then
        Begin
          Try
            If Not DirectoryExists(NewName) { *Converted from DirectoryExists*  } Then
              makepath(NewName);
          Except
          End;
          If DirectoryExists(Newname + DirSep + ExtractFileName(oldname)) { *Converted from DirectoryExists*  } Then
            Begin
              MultiReName(oldname + '\*.*', Newname + DirSep +
                ExtractFileName(oldname) + DirSep);
              If isemptydir(oldname) Then
                RmDir(oldname)
            End
          Else
            Begin
              newFname := Newname + DirSep + ExtractFileName(oldname);
              FindOtherNewName(NewFname);
              RenameFile(oldname, newFname); { *Converted from RenameFile*  }
            End
        End
      Else
        Begin
          Try
            nfp := ExtractFilePath(newname);
            If Not DirectoryExists(nfp) { *Converted from DirectoryExists*  } Then
              makepath(nfp);
          Except
          End;
          If DirectoryExists(Newname) { *Converted from DirectoryExists*  } Then
            Begin
              If DirectoryExists(oldname) { *Converted from DirectoryExists*  } And (oldname[length(oldname)] <> DirSep)
                Then
                MultiReName(oldname + '\*.*', Newname + DirSep)
              Else
                MultiReName(oldname + '*.*', Newname + DirSep);
              If isemptydir(oldname) Then
                Try
                  If oldname[length(oldname)] = DirSep Then
                    oldname := copy(oldname, 1, length(oldname) - 1);
                  RmDir(oldname)
                Except
                End;
            End
          Else
            RenameFile(oldname, Newname); { *Converted from RenameFile*  }
        End

    End
End;

function GetDefaultDataDir(Area: TGDD_Area; DataType: TGDD_DataType): String;

Var
  AppData,
  AllUserprofile,
    //    AllUserAppdata,
//  ProgPath,
  AreaBase,
    Documents: String;
    p:PChar;
  MyFilesPath: string;
  CommonFilesPath: string;
  MyMusicPath: String;
  MyPicturesPath: string;
  UserProfile: String;

Begin
//  Progpath := ExtractFilePath(paramstr(0));
  UserProfile := GetEnvironmentVariable('USERPROFILE');
  Appdata := copy(GetEnvironmentVariable ('APPDATA'),
    length(UserProfile)+2, 40);
  AllUserprofile := GetEnvironmentVariable('ALLUSERSPROFILE');
  Case Area Of
    gdda_User: AreaBase := UserProfile + DirSep;
    gdda_Group: AreaBase := AllUserprofile + DirSep;
    gdda_system: AreaBase := ExtractFilePath(paramstr(0));
    gdda_Network: AreaBase := GetEnvironmentVariable('HomeDrive') +
      GetEnvironmentVariable('HomePath') + DirSep
  End;
{$if defined(Win32) or defined(win64)}
  P := nil;
  try
    P := AllocMem(MAX_PATH);
    if SHGetFolderPath(0, CSIDL_PERSONAL, 0, 0, P) = S_OK then
      MyFilesPath := P;
    if SHGetFolderPath(0, CSIDL_COMMON_DOCUMENTS, 0, 0, P) = S_OK then
      CommonFilesPath := P;
    if SHGetFolderPath(0, CSIDL_MYMUSIC, 0, 0, P) = S_OK then
      MyMusicPath := P;
    if SHGetFolderPath(0, CSIDL_MYPICTURES, 0, 0, P) = S_OK then
      MyPicturesPath := P;
  finally
    FreeMem(P);
  end;
  Documents:='Documents';
  if (Area = gdda_user) and (myfilesPath<>'') then
    Documents := extractfilename(myfilesPath)
  else
    if CommonFilesPath<>'' then
      Documents := extractfilename(CommonFilesPath);
{$else}
  Documents:='Documents';
{$ifend}

  Case DataType Of
    gddt_Ini: If area <> gdda_System Then
        result := AreaBase + Appdata + dirsep +rsJCSoft+ dirsep
      Else
        result := areabase;
    gddt_Dok: If area <> gdda_System Then
      if area = gdda_User then
        result := MyFilesPath
      else
        result := AreaBase + Documents+dirsep
      Else
        result := areabase;
    gddt_Pictures: If area <> gdda_System Then
      if area = gdda_User then
        result := MyPicturesPath
      else
        result := AreaBase + Documents+dirsep+'Eigene Bilder' + DirSep
      Else
        result := areabase + 'Bilder'+dirsep;
    gddt_Music: If area <> gdda_System Then
      if area = gdda_User then
        result := MyMusicPath
      else
        result := AreaBase + Documents+Dirsep+'Eigene Musik' + DirSep
      Else
        result := areabase + 'Musik'+dirsep;
    gddt_Misc: If area <> gdda_System Then
      if area = gdda_User then
        result := MyFilesPath
      else
        result := AreaBase + Documents + DirSep
      Else
        result := areabase;

  End;
End;

Function GetExtInfo(path: String): String;
// Hole Infos Über Datei-extension ein;

Var
  ext, extClass: String;
  keys: Tstrings;
  reg: TRegistry;
  i: integer;

Begin
  extClass:='Unknown';
  reg := TRegistry.Create;
  keys := TStringlist.Create;
  reg.RootKey := {$IFNDEF UNIX} $80000000 {$ELSE} $00000000 {$ENDIF};
  result := '[ExtInfo]';
  if (copy(path,1,1) = '.' ) then
    ext := ExtractFileExt('?'+path)
  else
    ext := ExtractFileExt(path);
  result := result + #13#10 + 'Extension=' + ext;
  // Get Class
  If reg.OpenKeyReadOnly(ext) Then
    Begin
      extClass := reg.ReadString('');
      result := result + #13#10 + 'Class=' + extClass;
    End;
  reg.CloseKey;
  // Get Classinfo
  If reg.OpenKeyReadOnly(extClass) Then
    Begin
      result := result + #13#10 + 'info=' +
        reg.ReadString('');
      reg.CloseKey;
      // get Shellinfo
      If reg.OpenKeyReadOnly(extClass + '\shell') Then
        Begin
          result := result + #13#10 + 'defaultshell=' +
            reg.ReadString('');
          reg.getkeynames(keys);
          result := result + #13#10 + 'shellCount=' + inttostr(keys.count);
          For i := 0 To keys.count - 1 Do
            Begin
              result := result + #13#10 + 'shell' + inttostr(i) + '=' +
                keys.strings[i];
              reg.CloseKey;
              reg.OpenKeyReadOnly(extClass + '\shell\' + keys.strings[i]);
              result := result + #13#10 + 'info' + inttostr(i) + '=' +
                reg.ReadString('');
              reg.CloseKey;
              reg.OpenKeyReadOnly(extClass + '\shell\' + keys.strings[i] +
                '\command');
              result := result + #13#10 + 'cmd' + inttostr(i) + '=' +
                reg.ReadString('');
            End;
          reg.CloseKey;
        End;
    End;
  reg.free;
  keys.Free;
  If length(ext) = 4 Then
    If ('.' + upcase(ext[2]) + upcase(ext[3]) + upcase(ext[4]) = '.EXE') Or
      ('.' + upcase(ext[2]) + upcase(ext[3]) + upcase(ext[4]) = '.DLL') Then
      Try
        result := result + #13#10#13#10 + '[GetVersion]';
        result := result + #13#10 + 'Version=' + GetVersion(path);
      Except
      End;
End;

function CleanPath(path: String): String;
const BackPath =DirectorySeparator+'..';
var
  pp: Integer;
begin
  Result := path;
  pp:=Pos(BackPath,result);
  while pp<> 0 do
    begin
      if pp< 4 then
        result:=copy(result,1,pp)+copy(result,pp+length(BackPath)+1,length(Result)-pp)
      else
        result:=ExtractFilePath(copy(result,1,pp-1))+copy(result,pp+length(BackPath)+1,length(Result)-pp);
      pp:=Pos(BackPath,result);
    end;
end;

function GetVersion(filename: String): String;
Var
  VerInfoSize: DWord;
  VerInfo: Pointer;
  VerValueSize: DWord;
  {$IFNDEF UNIX}
  VerValue: PVSFixedFileInfo;
  {$ELSE}
//  VerValue: PVSFixedFileInfo;
  {$ENDIF}
  Dummy: DWord;
Begin
  {$IFNDEF UNIX}
  Dummy := 0;
  VerValueSize := 0;
  VerValue:=nil;
VerInfoSize := GetFileVersionInfoSize(PChar(Filename), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(Filename), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '', Pointer(VerValue), VerValueSize);
  With VerValue^ Do
    Begin
      result := IntTostr(dwFileVersionMS Shr 16);
      result := result + '.' + IntTostr(dwFileVersionMS And $FFFF);

      result := result + '.' + IntTostr(dwFileVersionLS Shr 16);
      result := result + '.' + IntTostr(dwFileVersionLS And $FFFF);

    End;
  FreeMem(VerInfo, VerInfoSize);
{$ELSE}
  result := '0.0.0.0';
{$ENDIF}
End;

function GetFileInfo(path: String; force: Boolean): String;

Var
  p: TGetInfo;
  info: String;

Begin
  result := getextInfo(path);
  p := GetInfoList;
  While assigned(p) Do
    Begin
      If assigned(p.FInfoProc) Then
        Try
          dbg := p;
          info := p.FInfoProc(path, force);
          result := result + #13#10 + info;
        Except
        End;
      p := p.getnext As TGetInfo;
    End;
End;

procedure RegisterGetInfoProc(name: String; PinfoProc: TFileInfo);

Var
  p: TGetInfo;

Begin
  If assigned(PinfoProc) Then
    Begin
      p := Tgetinfo.create(name, Nil);
      p.FInfoProc := PinfoProc;
      GetInfoList := p.addto(GetInfoList) As Tgetinfo;
    End;
End;

procedure RegisterGetInfoProc(FIClass: CFileInfo);

Var
  p: TGetInfo;

Begin
  If assigned(FIClass) Then
    Begin
      p := Tgetinfo.create(FIClass.DisplayName, Nil);
      p.FInfoProc := FIClass.GetFileInfoStr;
      GetInfoList := p.addto(GetInfoList) As Tgetinfo;
    End;
End;

procedure RegisterGetInfoProc(TFIClass: TFileInfoClass);
var
  p: TGetInfo;
begin
      p := Tgetinfo.create(TFIClass.DisplayName, Nil);
      p.FInfoProc := TFIClass.GetFileInfoStr;
      GetInfoList := p.addto(GetInfoList) As Tgetinfo;
end;

procedure UnRegisterGetInfoProc(FIClass: CFileInfo);

Var
  p: TGetInfo;

begin
   If assigned(FIClass) Then
    Begin
      p := GetInfoList;
      while assigned(p) and (p.Name <> FIClass.DisplayName) do
        p := Tgetinfo(p.GetNext);
      if assigned(p) then
        GetInfoList := Tgetinfo(GetInfoList.Delete(p));
    end;
end;

{ CFileInfo }

class function CFileInfo.FileOpenFilter: STRING;
VAR
  ext: STRING;
BEGIN
  result := '';
  FOR ext IN Extensions DO
    BEGIN
      IF result <> '' THEN
        result := result + '|';
      result := result + DisplayName + ' (*' + ext + ')|*' + ext;
    END;
end;


Initialization

  GetInfoList := Nil;

Finalization
  Try
    If assigned(getInfoList) Then
      GetInfoList.free;
  Except
  End
End.
