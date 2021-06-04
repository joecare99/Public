unit Unt_GNameHandler;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils;

type

{ TGNameHandler }
 TSendMsg = Procedure(Msg:String;aType:integer) of object;

 TGNameHandler=record
     private
       FcfgLearnUnknown: boolean ;
       FGNameFile: string;
       FGNameListChanged: boolean;
       FGNameList: TStringList;
       FonError: TSendMsg;
       procedure SetcfgLearnUnknown(AValue: boolean);
       procedure SetChanged(const AValue: boolean);
       procedure SetonError(AValue: TSendMsg);

     public
        Procedure Init;
        Procedure Done;
        procedure LoadGNameList(aFilename: string);
        procedure SaveGNameList(aFilename: string = '');
        procedure SetGNLFilename(aFilename: string = '');
        procedure LearnSexOfGivnName(aName: string; aSex: char);
        function GuessSexOfGivnName(aName: string; bLearn: boolean = True): char;

        property onError:TSendMsg read FonError write SetonError;
        property cfgLearnUnknown:boolean read FcfgLearnUnknown write SetcfgLearnUnknown;
        Property Changed:boolean read FGNameListChanged write SetChanged;
 end;

Const
    csUnknown = '…';
    csUnknown2 = '...';

implementation

uses Unt_FileProcs;

(* Maybe put to unt_StringProcs *)
function TestFor(const aText: string; pPos: int64;
  const aTest: string): boolean; overload;
begin
    Result := copy(aText, pPos, length(aTest)) = aTest;
end;

function TestFor(const aText: string; pPos: int64;
    const aTest: array of string; out Found: integer): boolean; overload;
var
    i: integer;
begin
    Found := -1;
    Result := False;
    for i := 0 to high(Atest) do
        if TestFor(aText, ppos, atest[i]) then
          begin
            Found := i;
            exit(True);
          end;
end;

function TestFor(const aText: string; pPos: int64;
    const aTest: array of string): boolean; overload;
var
    lFound: integer;
begin
    Result := TestFor(aText, ppos, atest, lFound);
end;

{ TGNameHandler }

procedure TGNameHandler.SetonError(AValue: TSendMsg);
begin
  if @FonError=@AValue then Exit;
  FonError:=AValue;
end;

procedure TGNameHandler.Init;
begin
   FGNameList:=TStringList.Create;
   FGNameList.Sorted := True;
   FcfgLearnUnknown:=True;
   FGNameListChanged:=false;
end;

procedure TGNameHandler.Done;
begin
  if FGNameListChanged and (FGNameFile <> '') then
    begin
      if FileExists(FGNameFile) then
          DeleteFile(FGNameFile);
      FGNameList.SaveToFile(FGNameFile);
    end;
  freeandnil(FGNameList);
end;

procedure TGNameHandler.SetcfgLearnUnknown(AValue: boolean);
begin
  if FcfgLearnUnknown=AValue then Exit;
  FcfgLearnUnknown:=AValue;
end;

procedure TGNameHandler.SetChanged(const AValue: boolean);
begin
  if FGNameListChanged=AValue then Exit;
  FGNameListChanged:=AValue;
end;

procedure TGNameHandler.LoadGNameList(aFilename: string);
begin
     if FileExists(aFilename) then
        FGNameList.LoadFromFile(aFilename)
    else
        FGNameList.Clear; // Todo: Load Defaults
    FGNameFile := aFilename;
    FGNameListChanged := False;
end;

procedure TGNameHandler.SaveGNameList(aFilename: string);

begin
    if (aFilename = '') and (FGNameFile = '') then
        exit;
    if aFilename <> '' then
        FGNameFile := aFilename;
    SaveFile(FGNameList.SaveToFile,FGNameFile);
    FGNameListChanged := False;
end;

procedure TGNameHandler.SetGNLFilename(aFilename: string);
begin
    if (aFilename = '') and (FGNameFile = '') then
        exit;
    if aFilename <> '' then
        FGNameFile := aFilename;
end;

procedure TGNameHandler.LearnSexOfGivnName(aName: string; aSex: char);
var
    lName: string;
begin
    {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}
    for lName in aName.split([' ']) do
        if (length(lName) = 2) and lname.EndsWith('.') and (lName[1] in ['A'..'Z']) then
            Continue // Ignoriere abgekürzte Namen
        else
        if testfor(lName, 1, [csUnknown, csUnknown2]) then
            Continue // Ignoriere abgekürzte Namen
        else
        if ((length(lName) < 3) and (uppercase(lName) <> 'NN')) or
            lname.EndsWith('.') or lname.EndsWith('=') then
          begin
            if (lName <>'') and assigned(FonError) then
               FonError('"' + lName + '" is not a valid Name',0);
          end
        else
        if (lName <> '') and (copy(lName, 1, 1) <> '(') and
            (copy(lName, 1, 1) <> '"') and
            ((FGNameList.Values[lName] = '') or
            (FGNameList.Values[lName] = '_')) then
          begin
            FGNameList.Sorted := False;
            FGNameList.Values[lName] := aSex;
            FGNameList.Sorted := True;
            FGNameListChanged := True;
          end
        else
        if (copy(lName, 1, 1) <> '(') then
            break;
end;

function TGNameHandler.GuessSexOfGivnName(aName: string; bLearn: boolean): char;
var
    lName: string;
begin
    Result := 'U';
    {$if FPC_FULLVERSION = 30200 }
    {$Warning 'Split produces wrong results in 3.2.0' }
    {$ENDIF}
    for lName in aName.split([' ']) do
      begin
        if (length(lName) = 2) and lname.EndsWith('.') and (lName[1] in ['A'..'Z']) then
            Continue  // Ignoriere abgekürzte Namen
        else
        if ((length(lName) < 3) and (uppercase(lName) <> 'NN')) or
            lname.EndsWith('.') or lname.EndsWith('=') then
          begin
            if (lName <>'')
                and bLearn
                and assigned(FonError) then
               FonError('"' + lName + '" is not a valid Name',0);
          end
        else
        if (copy(lName, 1, 1) <> '(') and (copy(lName, 1, 1) <> '"') and
            (FGNameList.Values[lName] <> '') and
            (FGNameList.Values[lName] <> '_') then
            exit(FGNameList.Values[lName][1])
        else
        if FcfgLearnUnknown and bLearn then
            LearnSexOfGivnName(lName, '_');
      end;
end;

end.

