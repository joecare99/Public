unit cls_GenealogieHelper;

{$mode delphi}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}

interface

uses
    Classes, SysUtils, Cmp_GedComFile, Cls_GedComExt;

type

    { TGenealogyHelper }

    TGenealogyHelper = class
    private
        FGedComFile: TGedComFile;
        FOnLongOp: TNotifyEvent;
        function AutoEstimateBirthInd(aInd: TGedIndividual): boolean;
        function AutoSetNameInd(aInd: TGedIndividual): boolean;
        function isQualifiedDate(aDateStr: string; out aYear: integer): boolean;
        procedure SetGedComFile(AValue: TGedComFile);
        procedure SetOnLongOp(AValue: TNotifyEvent);
    public
      mResult: Integer;
        pResult: integer;
        procedure AutoEstimateBirth;
        procedure AutoSetName;
        procedure AutoRemoveInds;

        property OnLongOp: TNotifyEvent read FOnLongOp write SetOnLongOp;
        property GedComFile: TGedComFile read FGedComFile write SetGedComFile;
    end;

implementation

{ TGenealogyHelper }

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

procedure TGenealogyHelper.SetGedComFile(AValue: TGedComFile);
begin
    if FGedComFile = AValue then
        Exit;
    FGedComFile := AValue;
end;

procedure TGenealogyHelper.SetOnLongOp(AValue: TNotifyEvent);
begin
    if @FOnLongOp = @AValue then
        Exit;
    FOnLongOp := AValue;
end;

function TGenealogyHelper.isQualifiedDate(aDateStr: string; out aYear: integer): boolean;

begin
    aYear := 0;
    Result := tryStrtoint(RightStr(aDateStr, 4), aYear) and (aDateStr[1] in ['0'..'9']);
end;

function TGenealogyHelper.AutoEstimateBirthInd(aInd: TGedIndividual): boolean;



var
    lYear, lSpYear, lMaxYear, lMinYear, ldYear: integer;
    lIndSex: string;
    lInds: TGedIndividual;
    lFam: TGedFamily;
    lfamLnk: TGedComObj;
    lQDeathDate: Boolean;
begin
    // If a Baptism exists the Birth is (right) before the Baptism.
    lYear := 0;
    ldYear := 0;
    Result := False;
    if assigned(aInd.Baptised) and (isQualifiedDate(aind.Baptised.Date, lYear)) then
      begin
        aInd.BirthDate := 'BEF ' + aind.Baptised.Date;
        aind.Lastchange := Now;
        exit(True);
      end
    else if lYear > 0 then
      begin
        aInd.BirthDate := 'EST ' + IntToStr(lYear);
        aind.Lastchange := Now;
        exit(True);
      end;
    lIndSex := aInd.Sex;
    lQDeathDate:= assigned(aInd.Death) and (isQualifiedDate(aind.Death.Date, ldYear));

    // if a (qualified) Spouse exists the Birth is 3 Years before/after the Birth of the spouse (rouned to 5 Y)
    lSpYear := 0;
    if (aInd.SpouseCount > 0) and assigned(aInd.Spouses[0]) and
        isQualifiedDate(aInd.Spouses[0].BirthDate, lSpYear) then
    ;
    if lSpYear > 0 then
      begin
        if lIndSex = 'M' then
            lYear := ((lSpYear + 2) div 5 - 1) * 5
        else
            lYear := ((lSpYear + 2) div 5 + 1) * 5;
        if (ldYear=0) or (ldYear>lYear) then
          begin
            aInd.BirthDate := 'EST ' + IntToStr(lYear);
            aind.Lastchange := Now;
            exit(True);
          end;
      end;
    // Iterate trough Marriages and set Birth according to first marriage
    lMinYear := -1;
    for lfamLnk in aInd.GetRevEnumerator(CLinkFamSpouse) do
      if assigned(lfamLnk.link) then
    begin
      lFam := TGedFamily(lfamLnk.link);
      isQualifiedDate(trim(lfam.MarriageDate), lYear);
      if (lYear > 0) and ((lMinYear = -1) or (lMinYear > lYear)) then
          lMinYear := lYear;
    end;
    if lMinYear <> -1 then
        begin
          if lIndSex = 'M' then
              lYear := (lMinYear div 5 - 5) * 5
          else
              lYear := (lMinYear div 5 - 4) * 5;
          aInd.BirthDate := 'EST ' + IntToStr(lYear);
          aind.Lastchange := Now;
          exit(True);
        end;
    // If (only) (qualified) Childs exists the the Birts is 30 or 25 Years before the birth of the Child average
    lMinYear := -1;
    lMaxYear := -1;
    for lInds in aInd.EnumerateChildren do
      begin
        isQualifiedDate(trim(lInds.BirthDate), lYear);
        if (lYear > 0) and ((lMinYear = -1) or (lMinYear > lYear)) then
            lMinYear := lYear;
        if (lYear > 0) and ((lMaxYear = -1) or (lMaxYear < lYear)) then
            lMaxYear := lYear;
      end;
    if lMinYear <> -1 then
      begin
        if lIndSex = 'M' then
            lYear := ((lMinYear * 2 + lMaxYear + 6) div 15 - 6) * 5
        else
            lYear := ((lMinYear * 2 + lMaxYear + 6) div 15 - 5) * 5;
        aInd.BirthDate := 'EST ' + IntToStr(lYear);
        aind.Lastchange := Now;
        exit(True);
      end;
    // If (only) (qualified) Parents exists the the Birts is 30 or 25 Years after the birth of the Parents
    if assigned(aInd.Mother) then
      begin
        isQualifiedDate(aInd.mother.BirthDate, lYear);
        if lYear > 0 then
          begin
            lYear := ((lYear + 2) div 5 + 5) * 5;
            if (ldYear=0) or (ldYear>lYear) then
              begin
                aInd.BirthDate := 'EST ' + IntToStr(lYear);
                aind.Lastchange := Now;
                exit(True);
              end
            else
              begin
                if lQDeathDate then
                   aInd.BirthDate := 'BEF ' + aind.Death.Date
                else
                   aInd.BirthDate := 'BEF ' + IntToStr(ldYear);
                aind.Lastchange := Now;
                exit(True);
              end
          end;
      end;
    // If (only) (qualified) Parents exists the the Birts is 30 or 25 Years after the birth of the Parents
    if assigned(aInd.Father) then
      begin
        isQualifiedDate(aInd.Father.BirthDate, lYear);
        if lYear > 0 then
          begin
            lYear := ((lYear + 2) div 5 + 6) * 5;
            if (ldYear=0) or (ldYear>lYear) then
              begin
                aInd.BirthDate := 'EST ' + IntToStr(lYear);
                aind.Lastchange := Now;
                exit(True);
              end
            else
              begin
                if lQDeathDate then
                   aInd.BirthDate := 'BEF ' + aind.Death.Date
                else
                   aInd.BirthDate := 'BEF ' + IntToStr(ldYear);
                aind.Lastchange := Now;
                exit(True);
              end
          end;
      end;

end;

procedure TGenealogyHelper.AutoEstimateBirth;

var
    lTime: QWord;
    lGedObj: TGedComObj;
    lCount, lMCount: integer;
begin
    lTime := GetTickCount64;
    lCount := 0;
    lMCount := 0;
    for lGedObj in FGedComFile do
        if lGedObj.InheritsFrom(TGedIndividual) and
            (trim(TGedIndividual(lGedObj).BirthDate) = '') then
          begin
            if AutoEstimateBirthInd(TGedIndividual(lGedObj)) then
                Inc(lcount)
            else
                inc(lMCount);
            if assigned(FOnLongOp) and (GetTickCount64 - ltime > 100) then
              begin
                FOnLongOp(lGedObj);
                lTime := GetTickCount64;
              end;

          end;
    pResult := lCount;
    mResult:= lMCount;
end;

function TGenealogyHelper.AutoSetNameInd(aInd: TGedIndividual): boolean;

var
    lInds: TGedIndividual;
    lName: TIndName;
begin
    Result := False;
    aInd.BeginUpdate;
    lName := aind.NameNode;
    if lName.GivenName = '' then
      begin
        if aInd.Sex='M' then
          lName.Givenname := 'NNm'
        else if aInd.Sex='F' then
          lName.Givenname := 'NNf'
        else
          lName.Givenname := 'NN';
        Result := True;
      end;
    for lInds in aInd.EnumerateSpouses do
        if (linds.Name <> '') and (lInds.NameNode.Surname <> '') and
            (lInds.NameNode.Surname[1] in ['A'..'Z', 'Ü'[1]]) then
          begin
            lName.Surname := '(' + lInds.NameNode.Surname + ')';
            Result := True;
            break;
          end;
    if not result then
    for lInds in aInd.EnumerateChildren do
        if (linds.Name <> '') and (lInds.NameNode.Surname <> '') and
            (lInds.NameNode.Surname[1] in ['A'..'Z', 'Ü'[1]]) then
          begin
            lName.Surname := '(' + lInds.NameNode.Surname + ')';
            Result := True;
            break;
          end;
    lInds := aInd.Father;
    if not result then
    if assigned(lInds) then
        if (linds.Name <> '') and (lInds.NameNode.Surname <> '') and
            (lInds.NameNode.Surname[1] in ['A'..'Z', 'Ü'[1]]) then
          begin
            lName.Surname := '(' + lInds.NameNode.Surname + ')';
            Result := True;

          end;
    lInds := aInd.Mother;
    if not result then
    if assigned(lInds) then
        if (linds.Name <> '') and (lInds.NameNode.Surname <> '') and
            (lInds.NameNode.Surname[1] in ['A'..'Z', 'Ü'[1]]) then
          begin
            lName.Surname := '(' + lInds.NameNode.Surname + ')';
            Result := True;

          end;
    aInd.EndUpdate;
end;

procedure TGenealogyHelper.AutoSetName;

var
    lTime: QWord;
    lGedObj: TGedComObj;
    lCount, lMCount: integer;
    lName: string;
begin
    lTime := GetTickCount64;
    lCount := 0;
    lMCount := 0;
    for lGedObj in FGedComFile do
        if lGedObj.InheritsFrom(TGedIndividual) then
          begin
            lName := TGedIndividual(lGedObj).Name;
            if (lName = '') or
                (lName = '.') or
                lName.EndsWith('...') or
                lName.EndsWith('…') or
                (lName = '?') or
                (lName = 'NN') or
                lName.EndsWith(' NN') or
                lName.EndsWith(' ?') or lName.EndsWith(' .') or
                (TGedIndividual(lGedObj).Surname='') then
              begin
                if AutoSetNameInd(TGedIndividual(lGedObj)) then
                    Inc(lcount)
                else
                    inc(lMCount);
                if assigned(FOnLongOp) and (GetTickCount64 - ltime > 100) then
                  begin
                    FOnLongOp(lGedObj);
                    lTime := GetTickCount64;
                  end;
              end;
          end;
    pResult := lCount;
    mResult := lMCount;
end;

procedure TGenealogyHelper.AutoRemoveInds;
var
  lNoName,lNoPar, lNoInfo, lDateMatch, lHusbMatch, lWifeMatch: Boolean;
  lGedObj, lChld, lch2, lLinkC: TGedComObj;
  lName, lRef: String;
  lInd, lSp, lsp2: TGedIndividual;
  lTime: QWord;
  lCount, lMCount, j: Integer;
  lFam: TGedFamily;
begin
    lTime := GetTickCount64;
    lCount := 0;
    lMCount := 0;
//    lDebInd :=TGedIndividual(FGedComFile[7842]);
// 1. Stufe: Lösche Einzel-Personen ohne Informationen
    for lGedObj in FGedComFile.RevEnum do
      try
        if lGedObj.InheritsFrom(TGedIndividual) then
          begin
            if assigned(FOnLongOp) and (GetTickCount64 - ltime > 100) then
              begin
                FOnLongOp(lGedObj);
                lTime := GetTickCount64;
              end;
//            if (lDebInd.SpouseCount>0) and  (lDebInd.Spouses[0].id<0) then
 //             Continue;

            lInd := TGedIndividual(lGedObj);
            lName := lInd.Name;
            lNoName:= (lName = '') or (lName = '.') or (lName = '?') or
                (lName = 'NN') or lName.EndsWith(' NN') or
                lName.EndsWith(' ?') or lName.EndsWith(' .');
            lNoPar :=
              not assigned(lInd.Mother) and  // No Mother
              not assigned(lInd.Father);  // No Father
            lNoInfo := (lInd.sex <> 'U') and (lGedObj.count <= 2);  // Nur Name und Geschlecht !
            if lNoName and lNoPar and lNoInfo and (lInd.FamCount = 0) then
              begin
                FGedComFile.RemoveChild(lInd);
                freeandnil(lInd);
                Inc(lcount);
                Continue;
              end;
            lRef := lind.PersonID;
            for lSp in lind.EnumerateSpouses do
              begin
                for lsp2 in lsp.EnumerateSpouses do
                  if lsp2.id <0 then
                    Continue;
                  if (lsp2 <> lInd) and (((lRef<>'') and (lref=lsp2.PersonID)) or lind.Equals(lsp2)) then
                    begin
                      FGedComFile.Merge(lsp2,TgedcomObj(lInd));
                      Inc(lcount);
                      break;
                    end;
                 if not assigned(lind) then break;
              end;
            if not assigned(lind) then Continue;
            lFam:=nil;
            for lLinkC in lind.GetRevEnumerator('FAMC') do
              begin
                if not Assigned(lfam) then
                  lfam:=TGedFamily(lLinkC.Link)
                else
                  if assigned(lLinkC.Link) and (lLinkC.Link<>lfam) then
                    begin
                      lDateMatch := (lFam.MarriageDate = '') or (TGedFamily(lLinkC.Link).MarriageDate='') or
                        (lFam.MarriageDate = TGedFamily(lLinkC.Link).MarriageDate);
                      lHusbMatch := not assigned(lFam.Husband) or not assigned(TGedFamily(lLinkC.Link).Husband) or
                        (lFam.Husband.Name = TGedFamily(lLinkC.Link).Husband.Name);
                      lWifeMatch := not assigned(lFam.Wife) or not assigned(TGedFamily(lLinkC.Link).Wife) or
                        (lFam.Wife.Name = TGedFamily(lLinkC.Link).Wife.Name);
                      if lDateMatch and lHusbMatch and lWifeMatch then
                        begin
                          FGedComFile.Merge(TGedFamily(lLinkC.Link),TGedComObj(lFam));
                           Inc(lcount);
                        end;
                      lFam := TGedFamily(lLinkC.Link);
                    end
              end;
            if lref <> '' then
              for j := lInd.ID-1 downto 0 do
                if FGedComFile.Child[J].inheritsfrom(TGedIndividual) 
                    and (TGedIndividual(FGedComFile.Child[J]).PersonID = lref)
                    and (TGedIndividual(FGedComFile.Child[J]).Name = lind.Name)
                    and (TGedIndividual(FGedComFile.Child[J]).sex = lind.sex)  then
                      begin
                        FGedComFile.Merge(FGedComFile.Child[J],TgedcomObj(lInd));
                        Inc(lcount);
                        break;
                      end
                 else
            else
            for j := lInd.ID-1 downto lInd.ID-30 do
              if j>=0 then
              if FGedComFile[J].Equals(lInd) then
                    begin
                      FGedComFile.Merge(FGedComFile.Child[J],TgedcomObj(lInd));
                      Inc(lcount);
                      break;
                    end;
          end
        else
          if lGedObj.inheritsFrom(TGedFamily) then
            begin
              if assigned(FOnLongOp) and (GetTickCount64 - ltime > 100) then
                begin
                  FOnLongOp(lGedObj);
                  lTime := GetTickCount64;
                end;
              lFam := TGedFamily(lGedObj);
              if not assigned(lfam.Husband) and Not Assigned(lFam.Wife) then
                begin
                  for lChld in lFam do
                    if assigned(lChld.Link) then
                    begin
                      for lch2 in lChld.Link do
                        if lch2.link = lfam then
                          begin
                            lch2.Parent := nil;
                            lch2.free;
                            break;
                          end;
                      lChld.Link := nil;
                    end;
                  FGedComFile.RemoveChild(lFam);
                  FreeAndNil(lFam);
                end
              else
              for j := lfam.id-1 downto lfam.id-30 do
                if FGedComFile[J].inheritsfrom(TGedFamily) then
                  begin
                    if lfam.Equals(FGedComFile[J]) then
                      begin
                        FGedComFile.Merge(FGedComFile[J],tgedcomobj(lFam));
                        Inc(lcount);
                        break
                      end;
                    if not assigned(lFam) then
                      break;
                  end
              else
                break;
       if not assigned(lFam) then
         Continue;
            end;

      Except

      end;
    pResult := lCount;
    mResult := lMCount;

end;


end.
