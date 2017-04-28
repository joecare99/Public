Unit Unt_Config;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{*V 2.00.07 }
{*H 2.00.06 Procedur Register entfernt}
{*H 2.00.05 Tconfig.SetValue Public + overloaded}
{*H 2.00.04 Vorberreitung für WinXP-Compatibilität}
{*H 2.00.03 Problems with deinitialisation}
{*H 2.00.02 Issue with overload - flag}
{*H 2.00.01 }

Interface

Uses
//  Windows,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs, {$IFDEF FPC}FileUtil,{$ENDIF}
  inifiles;

Type
  TCustomConfig = Class(TComponent)
    // interface deklaration
  private
    Function GetValueP(index: TObject; name: String): variant;
  protected
    Function getsection(RObject: TObject): String;
    Function getvalue(index: TObject; name: String): variant; overload; virtual;
      abstract;
    Procedure setvalue(index: TObject; name: String; newval: variant); overload;
      virtual; abstract;
  published
    Function EnableRollBack: word; virtual; abstract;
    Function getvalue(index: TObject; name: String; defaul: variant): variant;
      overload; virtual; abstract;
  public
    Procedure RBCommit(RBLevel: Word); virtual; abstract;
    Procedure RBUndo(RBLevel: Word); virtual; abstract;
    Procedure setvalue(Section: String; name: String; newval: variant); overload;
      virtual; abstract;
    Property Value[index: TObject; name: String]: variant read GetValueP write
      setvalue;
    Function getvalue(Section: String; name: String; defaul: variant): variant;
      overload; virtual; abstract;
  End;

  TPrvConfig = Class(TObject)
  private
    { Private-Deklarationen }
    FIniFile: TCustomIniFile;
    Frollbacklist:array of TCustomIniFile;
    FINIFname: String;
    FRBLevel: word;
  protected
    { Protected-Deklarationen }
  public
    ClientCnt: integer;
    { Public-Deklarationen }
    Constructor Create({%H-}AOwner: TComponent);
    Destructor Destroy; override;
    Function getvalue(Section: String; name: String; defaul: variant): variant;
    Procedure setvalue(Section: String; name: String; newval: variant);
    Function EnableRollBack: word;
    Procedure RBCommit(RBLevel: Word);
    Procedure RBUndo(RBLevel: Word);
    Property FileName: String read FINIFname;
  End;

  TConfig = Class(TCustomConfig)
  private
    { Private-Deklarationen }
    FPrvConfig: TPrvConfig;

  protected
    { Protected-Deklarationen }
    Function getvalue(index: TObject; name: String): variant; overload;
      override;
    Procedure setvalue(index: TObject; name: String; newval: variant); override;
    Function GetFilename: String;

  public
    { Public-Deklarationen }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Function getvalue(Section: String; name: String; defaul: variant): variant;
      overload; override;
    Procedure setvalue(Section: String; name: String; newval: variant);
      override;
    Property value;

    Procedure RBCommit(RBLevel: Word); override;
    Procedure RBUndo(RBLevel: Word); override;
  published
    { Published-Deklarationen }
    Function EnableRollBack: word; override;
    Function getvalue(index: TObject; name: String; defaul: variant): variant;
      overload; override;
    Property FileName: String read getfilename;

  End;

Var
  Config: TCustomConfig;

Implementation
{$IFDEF FPC}
{$R *.dcr}
{$ENDIF}
Uses Variants;

Var
  GlobalInipath: String;
  SystemINIpath: String;
  UserINIpath: String;
  ApplINIpath: String;
  PrvConfig: TPrvConfig;

//---------------------------------------------------------------

Function deci(value: integer; Sze: integer = 0): String;
// aus Inttostr
// Wandelt eine Zahl in Decimal-String um

Const
  hexcode = '0123456789ABCDEF';

Var
  i: integer;
  v: longint;
  h: String;

Begin
  i := 1;
  v := value;
  h := '';
  While (i <= Sze) Or (v <> 0) Do
    Begin
      h := hexcode[(v Mod 10)+1] + h;
      v := v Div 10;
      inc(i);
    End;
  deci := h
End;

//---------------------------------------------------------------

Function TCustomConfig.getsection(RObject: TObject): String;
Var
  upper: Tcomponent;

Begin
  If assigned(RObject) Then
    Begin
      If RObject.InheritsFrom(TComponent) Then
        Begin
          upper := RObject As TComponent;
          If upper.GetParentComponent <> Nil Then
            getsection := getsection(upper.GetParentComponent) + '\' + (RObject
              As TComponent).name
          Else
            getsection := getsection(upper.Owner) + '\' + (RObject As
              TComponent).name
        End
      Else
        Begin
          If RObject.InheritsFrom(TPersistent) Then
            Begin
              upper := Tcomponent(RObject);
              getsection := getsection(upper.Owner) + '\' + RObject.ClassName;
            End
          Else
            Begin
              getsection := RObject.ClassName;
            End;

        End;
    End
  Else
    getsection := 'root';
End;

Function TCustomConfig.GetValueP(index: TObject; name: String): variant;
Var
  TmpStr: Variant;
Begin
  TmpStr := getvalue(index, name);
  If TmpStr = null Then
    Result := ''
  Else
    Result := TmpStr;
End;

// ---------------------------------------------------

Constructor TPrvConfig.create;

Var
  name: String;

Begin
  FINIFname := ParamStr(0);
  name := ExtractFileName(FINIFname);
  name := copy(name, 1, length(name) - length(ExtractFileext(name)));
  FINIFname := ExtractFilePath(FINIFname);
  If copy(FINIFname, length(FINIFname), 1) <> '\' Then
    FINIFname := FINIFname + '\' + name
  Else
    FINIFname := FINIFname + name;
  //  inherited ;
  FIniFile := TMemIniFile.create(FINIFname + '.ini');
  FRBLevel := 0;
  setlength(Frollbacklist,0);
  If Not assigned(Prvconfig) Then
    Prvconfig := self;
  ClientCnt := 1;
End;

//---------------------------------------------------------------

Destructor TPrvConfig.destroy;

Begin
  Try
    RBUndo(0);
    If assigned(FIniFile) Then
      Begin
        finifile.UpdateFile;
        Finifile.Free;
        Finifile := Nil;
      End;
    If assigned(Prvconfig) And (prvconfig = self) Then
      Prvconfig := Nil;
  Except
  End;
  Inherited
End;

Function TPrvConfig.getvalue(Section: String; name: String; defaul: variant):
  variant;

var
  rblev: Integer;
Begin
  result := Finifile.ReadString(section, name, '');
  rblev:=FRBLevel-1;
  while (result = '') and (rblev>=0) do
    begin
      result := Frollbacklist[rblev].ReadString(section, name, '');
      dec(rblev);
    end;
  If (result = '') And (defaul <> Null) Then
    Begin
      result := VarToStr(defaul);
      If result <> '' Then
        Finifile.WriteString(section, name, result)
    End
  Else If (result = '') Then
    result := defaul;
End;

Procedure TPrvConfig.setvalue(section, name: String; newval: variant);

Begin
  //
  Finifile.WriteString(section, name, vartostr(newval));
End;

Function TPrvConfig.EnableRollBack: word;

Begin
  result := FRBLevel;
  inc(FRBLevel);
  Setlength(FRollbackList,FRBLevel);
  Frollbacklist[FRBLevel-1]:= FIniFile;
  FIniFile.UpdateFile;
  FiniFile := TIniFile.create(FINIFname + deci(FRBLevel, 4) + '.ini')
End;

Procedure TPrvConfig.RBCommit(RBLevel: Word);

Var
  i, s, e: integer;
  NFini: TCustomIniFile;
  Sections, section: TStrings;

Begin
  If (rblevel < FRBLevel) Then
    Begin
      NFini := Frollbacklist[rblevel];
      setlength(Frollbacklist,FrbLevel+1);
      Frollbacklist[FrbLevel]:= FIniFile;
      Sections := TStringList.Create;
      Section := TStringList.Create;
      For i := rblevel + 1 To FrbLevel Do
        Try
          FIniFile := Frollbacklist[i];
          FIniFile.ReadSections(Sections);
          For s := 0 To Sections.Count - 1 Do
            Begin
              FIniFile.ReadSection(sections[s], Section);
              For e := 0 To Section.Count - 1 Do
                NFini.WriteString(sections[s], section[e],
                  Finifile.ReadString(sections[s], section[e], ''));
            End;
          FIniFile.Free;
          DeleteFile(FINIFname + deci(I, 4) + '.ini'); { *Konvertiert von DeleteFile* }
        Except
        End;
      Section.Free;
      Sections.Free;
      FRBLevel := rblevel;
      setlength(Frollbacklist,FRBLevel+1);
      FiniFile := NFini;
    End;
End;

Procedure TPrvConfig.RBUndo(RBLevel: Word);

Var
  i: integer;

Begin
  If (rblevel < FRBLevel) Then
    Begin
      FIniFile.free;
      For i := frblevel Downto rblevel + 1 Do
        Try
          if i< frblevel then
            Frollbacklist[i].Free;
          DeleteFile(FINIFname + deci(i, 4) + '.ini'); { *Konvertiert von DeleteFile* }
        Except
        End;
      FRBLevel := rblevel;
      setlength(Frollbacklist,FRBLevel+1);
      FiniFile := Frollbacklist[FRBLevel]
    End;
End;
{----------------------------------------------------------}

Constructor TConfig.create;

Begin
  Inherited;
  If csDesigning In Componentstate Then
    Begin
      FPrvConfig := Nil;
      exit;
    End;
  If assigned(Prvconfig) Then
    Begin
      FPrvConfig := PrvConfig;
      inc(FprvConfig.ClientCnt)
    End
  Else
    Begin
      FPrvConfig := TPrvConfig.Create(self);
      Prvconfig := FPrvConfig;
    End;
  If Not assigned(config) Then
    config := self;
End;

//---------------------------------------------------------------

Destructor TConfig.destroy;

Begin
  Try
    If assigned(FPrvConfig) Then
      Begin
        dec(FprvConfig.ClientCnt);
        If FprvConfig.ClientCnt = 0 Then // Keine weiteren Clients
          Begin
            PrvConfig.Free;
            PrvConfig := Nil;
          End
      End;
    If assigned(config) And (config = self) Then
      config := Nil;
  Except
  End;
  Inherited
End;

//---------------------------------------------------------------

Function TConfig.getFilename;

Begin
  If assigned(FPrvConfig) Then
    result := FprvConfig.Filename
  Else
    result := 'Configfile.ini';
End;
//---------------------------------------------------------------

Function TConfig.getvalue(index: TObject; name: String): variant;
Var
  section: String;
Begin
  section := getsection(index);
  If assigned(FprvConfig) Then
    result := FprvConfig.getvalue(section, name, NULL);
End;

Function TConfig.getvalue(Section: String; name: String; defaul: variant):
  variant;

Begin
  If assigned(FprvConfig) Then
    result := FprvConfig.getvalue(Section, name, defaul);
End;

Function TConfig.getvalue(index: TObject; name: String; defaul: variant):
  variant;
Var
  section: String;
Begin
  section := getsection(index);
  If assigned(FprvConfig) Then
    result := FprvConfig.getvalue(section, name, defaul);
End;

Procedure TConfig.setvalue(index: TObject; name: String; newval: variant);
Var
  section: String;
Begin
  section := getsection(index);
  If assigned(FprvConfig) Then
    FprvConfig.Setvalue(section, name, newval);
End;

Procedure TConfig.setvalue(section, name: String; newval: variant);
Begin
  If assigned(FprvConfig) Then
    FprvConfig.Setvalue(section, name, newval);
End;

Function TConfig.EnableRollBack: word;

Begin
  result := FPrvConfig.EnableRollBack
End;

Procedure TConfig.RBCommit(RBLevel: Word);

Begin
  FPrvConfig.RBCommit(RBLevel);
End;

Procedure TConfig.RBUndo(RBLevel: Word);

Begin
  FPrvConfig.RBUndo(RBLevel);
End;

Initialization
  // Unit-Initialisierungscode...
  config := Nil;
  PrvConfig := Nil;
  UserINIpath := GetEnvironmentVariable('APPDATA') + '\KG-Soft\';
  SystemINIpath := GetEnvironmentVariable('ProgramFiles') + '\KG-Soft\';
  ApplINIPath := paramstr(0);
  GlobalInipath := paramstr(0);
Finalization
  // Unit-Finalisierungscode...
  If assigned(config) Then
    Try
      config.free;
    Finally
      config := Nil;
    End;
  If assigned(prvconfig) Then
    Try
      prvconfig.free;
    Finally
      prvconfig := Nil;
    End
End.

