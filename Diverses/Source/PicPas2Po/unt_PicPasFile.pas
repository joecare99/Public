unit unt_PicPasFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

    Tidx = record
        lnNrStart,  // LineNumber Of the Start
        iStartOffset,
        lnNrEnd,    // LineNumber
        iEndOffset,
        iIdTrans,   // Id of the Expression
        iIdLang: integer; // Id of the Language
        iStr: string;  //
      end;
    TIdxArray = array of Tidx;

{ TPicPasFile }
 TPicPasFile=class(TComponent)
  private
    Flines: TStringList;
    FChanged:boolean;
    FAoIndex:array of Tidx;
    FIdentifyers: array of string;
    FFilename:String;
    FFileEncoding:string;
    procedure AppendIndex(PrioIdx, id, Lang: integer; Value: String);
    function GetLineCount: integer;
  {$ifdef Debug}
  public
  {$endIf}
    procedure UpdateIndex(Idx: integer; Value: String);
    procedure SetFileName(Filename:string;Encoding:String='');
    function GetLine(aIndex: integer): string;
    function FindTransIndex(Id, LangId: integer; out iIdx: integer): boolean;
    function GetTranslation(Id, LangId: integer): string;
    function GetTranslCount: integer;
    procedure LinesChange(Sender: TObject);
    function ParseLineForString(var ActLine: integer; var idLang: integer;
      const idTrans: integer; var CharIdx: integer; var AoIdx: TIdxArray; out
  Ident: string): integer;
    procedure SetLine(aIndex: integer; AValue: string);
    procedure SetLines(AValue: TStringList);
    Procedure ParseFile;
    procedure ClearChanged;
    procedure SetTranslation(Id, LangId: integer; AValue: string);
  public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     procedure Clear;
     class function QuotedStr2(aStr:String):String;
     function GetIdentifyer(Idx:Integer):string;
     procedure LoadFromFile(Filename: string);
     procedure SaveToFile(const aFilename: string);
     property TranslCount: integer read GetTranslCount;
     property Translation[Id,LangId:integer]:string read GetTranslation write SetTranslation;
     property Lines: TStringList read FLines write SetLines;
     property Line[aIndex: integer]: string read GetLine write SetLine;
     property LineCount:integer read GetLineCount;
     property Changed:boolean read FChanged;
  end;

implementation

uses LazFileUtils,LConvEncoding;
{ TPicPasFile }

function TPicPasFile.GetLineCount: integer;
begin
  result := Flines.Count;
end;

procedure TPicPasFile.SetFileName(Filename: string; Encoding: String);
begin
  FFilename:=Filename;
  if Encoding='' then
    FFileEncoding:=EncodingUTF8
  else
    FFileEncoding:=Encoding;
end;

function TPicPasFile.GetLine(aIndex: integer): string;
begin
   Result := Flines.Strings[aIndex];
end;

function TPicPasFile.FindTransIndex(Id, LangId: integer;out iIdx: integer):boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to high(FAoIndex) do
    if (FAoIndex[i].iIdTrans = Id) and (FAoIndex[i].iIdLang = LangId) then
      begin
        iIdx := i;
        exit(true);
      end;
end;

function TPicPasFile.GetTranslation(Id, LangId: integer): string;
var
  lIdx: integer;
begin
  result := '';
  if (LangId=0) and FindTransIndex(id,1,lIdx) then
     Exit(FAoIndex[lIdx].iStr) ;
  if FindTransIndex(id,LangId,lIdx) then
     Exit(FAoIndex[lIdx].iStr) ;
end;

function TPicPasFile.GetTranslCount: integer;
begin
  result := Length(FIdentifyers);
end;

procedure TPicPasFile.LinesChange(Sender: TObject);
begin
  FChanged:=true;
end;

procedure TPicPasFile.SetLine(aIndex: integer; AValue: string);
begin
   Flines[aIndex] := AValue;
end;

procedure TPicPasFile.SetLines(AValue: TStringList);
begin
  if FLines=AValue then Exit;
  FLines:=AValue;
end;

procedure TPicPasFile.ParseFile;
var
  I, lpp, lLangId, lppn: Integer;
  lLine , lsTmp, lIdentifyer: string;

begin
  setlength(FAoIndex, 0);
  i := 0;
  while I < Flines.Count do
     begin
       lline := Flines[i];
        // Get Identifyer
        lpp := pos(':=', lline);
        if lpp > 0 then
            lIdentifyer := trim(copy(lline, 1, lpp - 1))
        else
          lIdentifyer:='';
        lpp := pos('TRANS(', uppercase(lline));
        if lpp > 0 then
          begin
            lLangId := 1;
            setlength(FIdentifyers,high(FIdentifyers)+2);
            FIdentifyers[high(FIdentifyers)]:= copy(ExtractFileNameWithoutExt(
               ExtractFileName(FFilename)), 5) + '.' + lIdentifyer;
            lppn := ParseLineForString(i, lLangId,high(FIdentifyers), lpp, FAoIndex, lsTmp);
            repeat
                lppn := ParseLineForString(i, lLangId,high(FIdentifyers), lpp, FAoIndex, lsTmp);
                if lpp > length(Flines[i]) then
                  begin
                    Inc(i);
                    lpp := 1;
                  end;
            until (lppn = 3) or (i>=FLines.Count);
          end;
        inc(i);
     end;
end;

procedure TPicPasFile.ClearChanged;
begin
  FChanged:=false;
end;

procedure TPicPasFile.UpdateIndex(Idx:integer;Value:String);
var
  QStr: String;
  UIdx, LDiff: Integer;
begin
  FAoIndex[Idx].iStr:=Value;
  QStr := QuotedStr2(Value);
  LDiff := -FAoIndex[Idx].iEndOffset + FAoIndex[Idx].iStartOffset+length(QStr);
  FAoIndex[Idx].iEndOffset:=FAoIndex[Idx].iEndOffset+LDiff;
  UIdx := Idx+1;
  while (UIdx <= high(FAoIndex)) and (FAoIndex[UIdx].lnNrStart=FAoIndex[Idx].lnNrEnd) do
     begin
        FAoIndex[UIdx].iStartOffset:=FAoIndex[UIdx].iStartOffset+LDiff;
        if FAoIndex[UIdx].lnNrEnd=FAoIndex[Idx].lnNrEnd then
            FAoIndex[UIdx].iEndOffset:=FAoIndex[UIdx].iEndOffset+LDiff;
        inc(UIdx)
     end;
end;

procedure TPicPasFile.AppendIndex(PrioIdx,id,Lang:integer;Value:String);
var
  QStr: String;
  i: Integer;
begin
  // Make Room for Data
  setlength(FAoIndex,high(FAoIndex)+2);
  for i := high(FAoIndex) downto PrioIdx+2 do
    FAoIndex[i] := FAoIndex[i-1];
  // New Data
  with FAoIndex[PrioIdx+1] do
    begin
      iStr:=Value;
      QStr := QuotedStr2(Value);
      iIdTrans:=id;
      iIdLang:=Lang;
      lnNrStart:=FAoIndex[PrioIdx].lnNrEnd;
      iStartOffset:=FAoIndex[PrioIdx].iEndOffset + 1;
      lnNrEnd:=FAoIndex[PrioIdx].lnNrEnd;
      iEndOffset:=iStartOffset+Length(QStr);
    end;
end;

procedure TPicPasFile.SetTranslation(Id, LangId: integer; AValue: string);
var
  lIdx: integer;
  lline: String;
begin
  if FindTransIndex(id,LangId,lIdx) then

          with FAoIndex[lIdx] do
            begin
              lline := FLines[lnNrStart];
              if (lnNrStart=lnNrEnd) then
                begin
                  Delete(lline, iStartOffset, iEndOffset - iStartOffset );
                  insert(QuotedStr2(AValue), lline, iStartOffset);
              if FLines[lnNrStart] <> lline then
                FLines[lnNrStart] := lline;
              UpdateIndex(lIdx,AValue);
                end
              else
                begin

                  // Not Implemented yet
                end
            end
    else if FindTransIndex(id,LangId-1,lIdx) then
          with FAoIndex[lIdx] do
            begin
              lline := FLines[lnNrEnd];
              insert(','+QuotedStr2(AValue), lline, iEndOffset);
              if FLines[lnNrEnd] <> lline then
                FLines[lnNrEnd] := lline;
              AppendIndex(lIdx,id,LangId,AValue);
            end;
end;

constructor TPicPasFile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Flines := TStringList.Create;
  Flines.OnChange:=@LinesChange;
end;

destructor TPicPasFile.Destroy;
begin
  FreeAndNil(Flines);
    inherited Destroy;
end;

procedure TPicPasFile.Clear;
begin
  Flines.Clear;
  FFilename:='';
  FFileEncoding := EncodingUTF8;
  FChanged:=false;
end;

class function TPicPasFile.QuotedStr2(aStr: String): String;

const SpecialChar=[#10,#13,#8];
var
  ch:Char;
begin
  result := Quotedstr(aStr.Replace('+','/+'));
  for ch in SpecialChar do
    result := result.Replace(ch,'''+#'+inttostr(byte(ch))+'+''');
  if result.StartsWith('''''+') then
    result := result.Remove(0,3);
  if result.EndsWith('+''''') then
    result := result.Remove(result.Length-3);
  result := result.Replace('+''''+','+');
  for ch in SpecialChar do
    result := result.Replace('#'+inttostr(byte(ch))+'+#','#'+inttostr(byte(ch))+'#');
  result := result.Replace('/+','+');
end;

function TPicPasFile.GetIdentifyer(Idx: Integer): string;
begin
  result := FIdentifyers[Idx];
end;

procedure TPicPasFile.LoadFromFile(Filename: string);
begin
  FFileEncoding := EncodingUTF8; // Todo: Guessencoding.
  Flines.LoadFromFile(Filename);
  FFilename:=Filename;
  ParseFile;
  FChanged:=false;
end;

function TPicPasFile.ParseLineForString(var ActLine: integer;
  var idLang: integer; const idTrans: integer; var CharIdx: integer;
  var AoIdx: TIdxArray; out Ident: string): integer;

var
    lppn: SizeInt;
    cc: char;
    lLine:string;
    lParseMode: Integer;
    Lv: Byte;

begin
    Ident := '';
    lLine := FLines[ActLine];
    lppn := pos('''', copy(lline, CharIdx, length(lline)));
    lParseMode := 0; //String
    if lppn > 0 then
      begin
        // Resize Array
        setlength(AoIdx, high(AoIdx) + 2);
        AoIdx[high(AoIdx)].iIdLang := idLang;
        AoIdx[high(AoIdx)].iIdTrans := idTrans;
        AoIdx[high(AoIdx)].lnNrStart := ActLine;
        CharIdx := CharIdx + lppn;
        AoIdx[high(AoIdx)].iStartOffset := CharIdx - 1;
       while (lParseMode < 2) and (length(lline) >= CharIdx) do
          begin
            cc := lline[CharIdx];
            if (cc = '''')  then
               begin
                if (lParseMode=0) and (copy(lline, CharIdx + 1, 1) = '''') then
                   begin Inc(CharIdx);Ident := Ident + cc end
                else
                    lParseMode := 1-lParseMode;
               end
            else
            if (lParseMode = 0) then
                Ident := Ident + cc
            else if cc='#' then
               begin
                 inc(CharIdx);
                 if lline[CharIdx] ='$' then
                   begin
                     inc(CharIdx);
                     Lv := pos(UpCase(lline[CharIdx]),'0123456789ABCDEF')-1;
                     // Hexmode
                     if UpCase(lline[CharIdx+1]) in ['0'..'9','A'..'F'] then
                        begin
                         Lv :=lv*16+ (pos(UpCase(lline[CharIdx+1]),'0123456789ABCDEF')-1);
                        inc(CharIdx)
                        end;
                     ident := ident + char(lv);
                   end
                 else
                   begin
                     Lv := byte(lline[CharIdx])-byte('0');
                     while lline[CharIdx+1] in ['0'..'9'] do
                        begin
                          Lv :=lv*10+ (byte(lline[CharIdx+1])-byte('0'));
                          inc(CharIdx)
                        end;
                     ident := Ident+char(lv);
                   end
                 end
               else  // Todo: Well known Identifyer Like DirectorySeparator & LineEnding;
            if (cc = ',') then
               begin
                  lParseMode := 2;
                  AoIdx[high(AoIdx)].lnNrEnd := ActLine;
                  AoIdx[high(AoIdx)].iEndOffset := CharIdx;
                  AoIdx[high(AoIdx)].iStr := Ident;
               end
            else
            if (cc = ')') and
                (trim(copy(lline, CharIdx + 1, length(lline) - CharIdx)) = ';') then
                begin
                   lParseMode := 3;
                   AoIdx[high(AoIdx)].lnNrEnd := ActLine;
                   AoIdx[high(AoIdx)].iEndOffset := CharIdx;
                   AoIdx[high(AoIdx)].iStr := Ident;
                end;
            Inc(CharIdx);
            if (lParseMode=1) and (CharIdx>length(lLine)) and (ActLine < Flines.Count-1 )then
                begin
                  inc(ActLine);
                  lLine:=Flines[ActLine];
                  CharIdx := 1
                end;
          end; {While}
        inc(idLang);
      end
    else
        CharIdx := length(lline) + 1;
    Result := lParseMode;
end;

procedure TPicPasFile.SaveToFile(const aFilename: string);
var
  sf: TFileStream;
  s: string;

begin
  sf := TFileStream.Create(aFilename, fmCreate);
    try
      s := ConvertEncoding(FLines.Text, EncodingUTF8, FFileEncoding);
      sf.WriteBuffer(s[1], Length(s));
    finally
      FreeAndNil(sf);
    end;
  FFilename:=FFilename;
  FChanged:=false;
end;

end.

