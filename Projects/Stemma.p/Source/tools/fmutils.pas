unit FMUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Grids, StrUtils;

procedure SaveFormPosition(Sender: TForm); deprecated 'use dmGenData.WriteCfgFormPosition';
procedure SaveGridPosition(Sender: TStringGrid;cols: integer);deprecated 'use dmGenData.WriteCfgGridPosition';
procedure GetGridPosition(Sender: TStringGrid;cols: integer);deprecated 'use dmGenData.ReadCfgGridPosition';
procedure GetFormPosition(Sender: TForm;a:integer;b:integer;c:integer;d:integer);deprecated 'use dmGenData.ReadCfgFormPosition';
procedure SaveModificationTime(no:integer);overload;deprecated 'use dmGenData.SaveModificationTime';
procedure SaveModificationTime(no:string);overload ;deprecated 'use dmGenData.SaveModificationTime';
procedure PopulateCitations(Tableau:TStringGrid;Code:string;no:integer);overload;deprecated'use dmGenData.PopulateCitations';
procedure PopulateCitations(Tableau:TStringGrid;Code:string;Nstr:String);overload;deprecated'use dmGenData.PopulateCitations';
function DecodeName(Name:string;format:byte):string;
procedure DecodePlace(Place: string; out article,detail,sCity,region,province,sCountry: string);
function DecodeChanged(Place:string):string;
function ConvertDate(Date:string;format:byte):string;
function RemoveUTF8(text:string):string;
function DecodePhrase(sIndividuum:string;role:string;phrase:string;TypeEvenement:string;evenement:string):string;overload;deprecated;
function DecodePhrase(idIndividuum:integer;role:string;phrase:string;TypeEvenement:string;evenement:integer):string;overload;
function DecodePhraseTMG(idSujet:integer;role:string;phrase:string;TypeEvenement:string;evenement:string):string;
function DecodePhraseStemma(idIndividual:integer;role:string;phrase:string;TypeEvenement:string;evenement,char:integer):string;overload;
function DecodePhraseStemma(sIndividual:string;role:string;phrase:string;TypeEvenement:string;evenement:string;char:integer):string;overload;deprecated;
function CalculateAge(Date1:string;Date2:string;format:byte):string;
function InterpreteDate(Date:string;format:byte):string;
function getI3(no:integer):string;overload;deprecated 'use dmGenData.getI3';
function getI4(no:integer):string;overload; deprecated 'use dmGenData.getI4';
function getName(no:integer):string;overload; deprecated 'use dmGenData.GetIndividuumName';
function getI3(nstr:string):string;overload;deprecated 'use dmGenData.getI3';
function getI4(nstr:string):string;overload;deprecated 'use dmGenData.getI4';
function getName(nstr:string):string;overload;deprecated 'use dmGenData.GetIndividuumName';
Function AutoQuote(orgStr:string):String;
function GetTableColWidthSum(const lTable: TStringGrid; const lIgnCol: Integer
  ): Integer;

implementation

uses
  cls_Translation, dm_GenData;

procedure SaveModificationTime(no: string);
var
  nn: integer;
begin
  if TryStrToInt(no,nn) then
     dmGenData.SaveModificationTime(nn);
end;

procedure PopulateCitations(Tableau:TStringGrid;Code:string;no:integer);

begin
   // Populate le tableau de citations
   dmGenData.PopulateCitations(Tableau, code,No);
end;

function InterpreteDate(Date:string;format:byte):string;
var
   annee1, mois1, jour1, annee2, mois2, jour2, style, Original, bc1, bc2, temp: string;
   i, len: integer;
   valid: boolean;
   tmpSep1, tmpSep2: integer;
   test:TDateTime;
begin
   // Doit accepter les années négatives
   Original:=Date;
   // Doit accepter année, mois et jour '...'
   while AnsiPos('...',Date)>0 do
      Date:=Copy(Date,1,AnsiPos('...',Date)-1)+'00'+Copy(Date,AnsiPos('...',Date)+3,length(Date));
   if length(Date)=0 then
      if format=1 then
         InterpreteDate:='100000000030000000000'
      else
         InterpreteDate:=''
   else
      begin
      style:='3';
      if (Copy(Date,1,3)='av.') then
         begin
         Date:=Copy(Date,4,length(Date));
         style:='0';
      end;
      if (Copy(Date,1,3)='ap.') then
         begin
         Date:=Copy(Date,4,length(Date));
         style:='4';
      end;
      if (Copy(Date,1,1)='<') then
         begin
         Date:=Copy(Date,2,length(Date));
         style:='0';
      end;
      if (Copy(Date,1,1)='c') or (Copy(Date,1,1)='v') then
         begin
         Date:=Copy(Date,2,length(Date));
         style:='1';
      end;
      if (Copy(Date,1,1)='>') then
         begin
         Date:=Copy(Date,2,length(Date));
         style:='4';
      end;
      while (Date[1]='.') or (Date[1]=' ') do Date:=Copy(Date,2,length(Date));
      // extract year, month, day
      bc1:='';
      if (Date[1]='-') then
         begin
         bc1:='-';
         Date:=Copy(Date,2,length(Date));
      end;
      Annee1:='0000';
      Mois1:='00';
      Jour1:='00';
      Valid:=true;
      len:=AnsiPos(' ou',Date)-1;
      if len<=0 then
        len:=AnsiPos('ou',Date)-1;
      if len<=0 then
        len:=AnsiPos(' -',Date)-1;
      if len<=0 then
        len:=AnsiPos('-',Date)-1;
      if len<=0 then
        len:=AnsiPos(' a',Date)-1;
      if len<=0 then
        len:=AnsiPos(' à',Date)-1;
      if len<=0 then
        len:=AnsiPos('a',Date)-1;
      if len<=0 then
        len:=AnsiPos('à',Date)-1;
      if len<=0 then
         len:=length(Date);
      tmpSep1 := 0;
      tmpSep2 := 0;
      //validate the position of the date separators, if any, and
      //make sure only date separators and numerics are entered ...
      if len>10 then len:=10;
      for i := 1 to len do
         if (i<=len) and (not (Date[i] in ['0'..'9'])) then
            begin
            if i < 3 then valid:=false
            else if tmpSep1 = 0 then tmpSep1 := i
            else if (i = tmpSep1+1) or (tmpSep2 > 0) then
                    if (i = tmpSep2+1) then valid:=false
                    else len := i-1
            else tmpSep2 := i;
         end;

      //check for other error conditions ...
      if ((tmpSep1 = 0) and not (len in [4,6,8])) or
         ((tmpSep1 > 0) and (tmpSep2 - tmpSep1 > 3)) or (tmpSep2 = len) then
            valid:=false;

      if valid then
         if (tmpSep1 > 0) then
             begin
                if (tmpSep1 < 3) then valid:=false; //must be yy, yyy or yyyy
                if valid then
                   begin
                   annee1 := Copy(Date,1,tmpSep1-1);
                   if tmpSep2=0 then
                      mois1 := Copy(Date,tmpSep1+1,len-tmpSep1)
                   else
                      begin
                      mois1 := Copy(Date,tmpSep1+1,tmpSep2-tmpSep1-1);
                      jour1 := Copy(Date,tmpSep2+1,len-tmpSep2);
                   end;
                end;
             end
         else
            begin
            annee1 := Copy(Date,1,4);
            if len>5 then
               mois1 := Copy(Date,5,2);
            if len>7 then
               jour1 := Copy(Date,7,2);
         end;
      while length(annee1)<4 do annee1:='0'+annee1;
      while length(mois1)<2 do mois1:='0'+mois1;
      while length(jour1)<2 do jour1:='0'+jour1;
      if (bc1='-') then
         begin
         annee1:=IntToStr(StrToInt(annee1)*(-1));
         while length(annee1)<4 do annee1:=Copy(annee1,1,1)+'0'+Copy(annee1,2,length(annee1));
      end;
      Date:=Copy(Date,len+1,Length(Date));
      Annee2:='0000';
      Mois2:='00';
      Jour2:='00';
      if length(Date)>0 then
         begin
         while (Date[1]=' ') do Date:=Copy(Date,2,length(Date));
         // Verify Style of 2nd date
         if (Date[1]='-') then
            begin
            Date:=Copy(Date,2,length(Date));
            style:='5';
         end;
         temp:=RemoveUTF8(Date);
         if (temp[1]='a') or (temp[1]='à') then
         begin
            Date:=Copy(temp,2,length(Date));
            style:='7';
         end;
         if (Copy(Date,1,2)='au') then
            begin
            Date:=Copy(Date,3,length(Date));
            style:='7';
         end;
         if (Copy(Date,1,2)='ou') then
            begin
            Date:=Copy(Date,3,length(Date));
            style:='6';
         end;
         while (Date[1]=' ') do Date:=Copy(Date,2,length(Date));
         bc2:='';
         if (Date[1]='-') then
            begin
            bc2:='-';
            Date:=Copy(Date,2,length(Date));
         end;
         if valid and (StrToInt(style)>4) then
            begin
            // extract year, month, day
            len:=Length(Date);
            tmpSep1 := 0;
            tmpSep2 := 0;
            //validate the position of the date separators, if any, and
            //make sure only date separators and numerics are entered ...
            if len>10 then
               valid:=false
            else
               for i := 1 to len do
                  if not (Date[i] in ['0'..'9']) then
                     begin
                     if i < 3 then valid:=false
                     else if tmpSep1 = 0 then tmpSep1 := i
                     else tmpSep2 := i;
                  end;

            //check for other error conditions ...
            if ((tmpSep1 = 0) and not (len in [4,6,8])) or
               ((tmpSep1 > 0) and (tmpSep2 - tmpSep1 > 3)) or (tmpSep2 = len) then
               valid:=false;

            if valid then
               if (tmpSep1 > 0) then
                  begin
                  if (tmpSep1 < 3) then valid:=false; //must be yy, yyy or yyyy
                     if valid then
                        begin
                        annee2 := Copy(Date,1,tmpSep1-1);
                        if tmpSep2=0 then
                           mois2 := Copy(Date,tmpSep1+1,len-tmpSep1)
                        else
                           begin
                           mois2 := Copy(Date,tmpSep1+1,tmpSep2-tmpSep1-1);
                           jour2 := Copy(Date,tmpSep2+1,len-tmpSep2);
                        end;
                     end;
              end
              else
                 begin
                 annee2 := Copy(Date,1,4);
                 mois2 := Copy(Date,5,2);
                 jour2 := Copy(Date,7,2);
              end;
            while length(annee2)<4 do annee2:='0'+annee2;
            while length(mois2)<2 do mois2:='0'+mois2;
            while length(jour2)<2 do jour2:='0'+jour2;
            if (bc2='-') then
               begin
               annee2:=IntToStr(StrToInt(annee2)*(-1));
               while length(annee2)<4 do annee2:=Copy(annee2,1,1)+'0'+Copy(annee2,2,length(annee2));
            end;
         end;
      end;
{ TODO 11 : Si <-999 l'annee a 5 chiffres, ce qui n'est pas pris en compte dans le format de date dans la base de données }
      if (length(annee1)>4) then
         Valid:=false;
      if (length(annee2)>4) then
         Valid:=false;
      if (StrToInt(mois1)>12) or (StrToInt(mois2)>12) or (StrToInt(jour1)>31) or (StrToInt(jour2)>31) then
         Valid:=false;
      { TODO : Bug: n'accepte pas si l'annee, le mois ou le jour est 0... }
      // Valide que le date est valide
      if (StrtoInt(mois1)>0) and (StrtoInt(jour1)>0) and (not (Copy(annee1,1,1)='-')) then
         if not (TryEncodeDate(Strtoint(annee1),Strtoint(mois1),Strtoint(jour1),test)) then valid:=false;
      if (StrtoInt(mois2)>0) and (StrtoInt(jour2)>0) and (not (Copy(annee2,1,1)='-')) then
         if not (TryEncodeDate(Strtoint(annee2),Strtoint(mois2),Strtoint(jour2),test)) then valid:=false;
      if Valid then
         if format=1 then
            InterpreteDate:='1'+Annee1+Mois1+Jour1+'0'+style+Annee2+Mois2+Jour2+'00'
         else
            InterpreteDate:=Original
      else
         if format=1 then
            InterpreteDate:='0'+Original
         else
            InterpreteDate:=Original;
   end;
end;


function GetName(no:integer):string;

var UndecodedName:String;
begin
   UndecodedName:=dmGenData.GetIndividuumName(no);
   result := DecodeName(UndecodedName,1);
end;

function getI3(nstr: string): string;
var
  no: Longint;
begin
  if trystrtoint(Nstr,no) then
     result:=dmGenData.GetI3(no)
end;

function getI4(nstr: string): string;
var
  no: Longint;
begin
  if trystrtoint(Nstr,no) then
      result:=dmGenData.GetI4(no)
end;

function getName(nstr: string): string;
var
  no: Longint;
  UndecodedName: String;
begin
  if trystrtoint(Nstr,no) then
     UndecodedName:=dmGenData.GetIndividuumName(no);
  result := DecodeName(UndecodedName,1);
end;

function AutoQuote(orgStr: string): String;
begin
  result :=AnsiReplaceStr(
      AnsiReplaceStr(AnsiReplaceStr(orgStr, '\', '\\'),
      '"', '\"'), '''', '\''');
end;

function GetI3(no:integer):string;
begin
   result := dmGenData.GetI3(no);
end;

function GetI4(no:integer):string;
begin
   result := dmGenData.GetI4(no);
end;

function DecodePhraseStemma(sIndividual: string; role: string; phrase: string;
  TypeEvenement: string; evenement: string; char: integer): string;
var
  lidInd, lidEvent: Longint;
begin
  if TryStrToInt(sIndividual,lidInd) and TryStrToInt(evenement,lidEvent) then
    result :=DecodePhraseStemma(lidInd,role,phrase,TypeEvenement,lidEvent,char)
  else
    result := '';
end;

function CalculateAge(Date1:string;Date2:string;format:byte):string;
var
   annee1,mois1,jour1:word;
   annee2,mois2,jour2:word;
   annee3,mois3,jour3:word;
   temps1,temps2:TDateTime;
begin
   if (Copy(Date1,1,1)='1') AND (Copy(Date2,1,1)='1') then
      begin
      annee1:=StrtoInt(Copy(Date1,2,4));
      mois1:=StrtoInt(Copy(Date1,6,2));
      jour1:=StrtoInt(Copy(Date1,6,2));
      annee2:=StrtoInt(Copy(Date2,2,4));
      mois2:=StrtoInt(Copy(Date2,6,2));
      jour2:=StrtoInt(Copy(Date2,6,2));
      temps1:=EncodeDate(annee1,mois1,jour1);
      temps2:=EncodeDate(annee2,mois2,jour2);
      if temps1>temps2 then
         DecodeDate(temps1-temps2,annee3,mois3,jour3)
      else
         DecodeDate(temps2-temps1,annee3,mois3,jour3);
      if format=0 then
         CalculateAge:=inttostr(annee3);
   end
   else
      CalculateAge:='';
end;

function DecodePhrase(idIndividuum: integer; role: string; phrase: string;
  TypeEvenement: string; evenement: integer): string;
var
  i: Integer;
begin
   If copy(phrase,1,4)='!TMG' then
      result:=trim(DecodePhraseTMG(idIndividuum,role,copy(phrase,5,length(phrase)),TypeEvenement,inttostr(evenement)))
   else
      begin
      result:=trim(DecodePhraseStemma(idIndividuum,role,phrase,TypeEvenement,evenement,1));
   end;
   // Remplace les "  " par " "
   for i:=1 to length(Result)-1 do
      if Copy(Result,i,2)='  ' then
         Result:=Copy(Result,1,i)+Copy(Result,i+2,length(Result));
   if not (Copy(Result,length(Result),1)='.') then
      Result:=Result+'.';
   Result:=UpperCase(Copy(Result,1,1))+Copy(Result,2,Length(Result));
end;

function DecodePhraseTMG(idSujet:integer;role:string;phrase:string;TypeEvenement:string;evenement:string):string;
var
  RoleRecherche, Remplace, Code, temp, Sexe, lsI3:string;
  i, PosStart1, PosStart2, PosEnd1, PosEnd2, PosSeparateur:integer;
  Continue:boolean;
begin
   if AnsiPos('[L='+Translation.Items[320]+']',uppercase(phrase))>0 then
      begin
      phrase:=copy(phrase,AnsiPos('[L='+Translation.Items[320]+']',uppercase(phrase))+4+length(Translation.Items[320]),length(phrase));
      if AnsiPos('[L=',uppercase(phrase))>0 then
         phrase:=copy(phrase,1,AnsiPos('[L=',uppercase(phrase)));
   end;
   RoleRecherche:='[R='+role;
   if AnsiPos(RoleRecherche,uppercase(phrase))>0 then
      begin
      phrase:=copy(phrase,AnsiPos(RoleRecherche,uppercase(phrase))+length(RoleRecherche)+1,length(phrase));
      if AnsiPos('[R=',uppercase(phrase))>0 then
         phrase:=copy(phrase,1,AnsiPos('[R=',uppercase(phrase))-1);
   end;
   if AnsiPos('$!&',uppercase(phrase))>0 then
      begin
      if dmGenData.GetSexOfInd(idSujet)= 'F' then
         phrase:=copy(phrase,AnsiPos('$!&',phrase)+3,length(phrase))
      else
         phrase:=copy(phrase,1,AnsiPos('$!&',phrase)-1);
   end;
   PosStart1:=0;
   PosStart2:=0;
   PosEnd1:=0;
   PosEnd2:=0;
   PosSeparateur:=0;
   Continue:=true;
   while ((PosEnd2<=PosStart2) AND Continue) do
      begin
      i:=PosEnd2+1;
      while (i<=length(phrase)) do
         begin
         if Copy(phrase,i,1)='[' then
            begin
            PosStart2:=i;
            i:=length(phrase);
         end;
         i:=i+1;
      end;
      Continue:=(Copy(phrase,PosStart2,1)='[');
      if Continue then
         begin
         i:=PosStart2-1;
         while i>0 do
            begin
            if Copy(Phrase,i,1)='<' then
               begin
               PosStart1:=i;
               i:=0;
            end
            else
               if Copy(Phrase,i,1)='>' then
                  begin
                  PosStart1:=0;
                  i:=0;
               end;
            i:=i-1;
         end;
         i:=PosStart2+1;
         while i<=length(phrase) do
            begin
            if Copy(Phrase,i,1)=']' then
               begin
               PosEnd2:=i;
               i:=length(phrase);
            end;
            i:=i+1;
         end;
         i:=PosEnd2+1;
         while i<=length(phrase) do
            begin
               if Copy(Phrase,i,1)='>' then
                  begin
                  PosEnd1:=i;
                  i:=length(phrase);
               end
               else
                  if Copy(Phrase,i,1)='<' then
                     begin
                     PosEnd1:=0;
                     i:=length(phrase);
                  end;
               i:=i+1;
         end;
         if ((PosStart1>0) and (PosEnd1>0)) then
            begin
            i:=PosStart1+1;
            while i<=(PosEnd1-1) do
               begin
               if Copy(Phrase,i,1)='|' then
                  begin
                  PosSeparateur:=i;
                  i:=PosEnd1;
               end;
               i:=i+1;
            end;
         end;
      end;
   end;

// Trouve ce qui doit être remplacé

   Remplace:='';
   if TypeEvenement='R' then
      begin
      if PosEnd2>PosStart2 then
         begin
         Code:=Copy(Phrase,PosStart2+1,PosEnd2-PosStart2-1);
         if Code='A' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT SD FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=CalculateAge(dmGenData.GetI3(idSujet),dmGenData.Query4.Fields[0].AsString,0);
            if Remplace='0' then Remplace:='';
         end;
         if Code='A1' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT SD, A FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            lsI3 := dmGenData.GetI3(dmGenData.Query4.Fields[1].AsInteger);
            Remplace:=CalculateAge(lsI3,dmGenData.Query4.Fields[0].AsString,0);
            if Remplace='0' then Remplace:='';
         end;
         if Code='A2' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT SD, B FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            lsI3 := dmGenData.GetI3(dmGenData.Query4.Fields[1].AsInteger);
            Remplace:=CalculateAge(lsI3,dmGenData.Query4.Fields[0].AsString,0);
            if Remplace='0' then Remplace:='';
         end;
         if Code='AO' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT SD, B, A FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            if dmGenData.Query4.Fields[1].AsInteger=idSujet then
               lsi3:=dmGenData.geti3(dmGenData.Query4.Fields[1].AsInteger)
            else
               lsi3:=dmGenData.geti3(dmGenData.Query4.Fields[2].AsInteger);
            Remplace:=CalculateAge(lsI3,dmGenData.Query4.Fields[0].AsString,0);
            if Remplace='0' then Remplace:='';
         end;
         if Code='D' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT SD FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=ConvertDate(dmGenData.Query4.Fields[0].AsString,0);
         end;
//         if Code='L' then remplace:='/LIEU/'; JAMAIS DANS type 'R'
         if Code='M' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT M FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=dmGenData.Query4.Fields[0].AsString;
            if AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))>0 then
               begin
               Remplace:=copy(Remplace,AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))+4+length(Translation.Items[320]),length(Remplace));
               if AnsiPos('[L=',uppercase(Remplace))>0 then
                  Remplace:=copy(Remplace,1,AnsiPos('[L=',uppercase(Remplace)));
            end;
         end;
         if (Code='W') or (Code='N') then
            begin
            if role='ENFANT' then
               dmGenData.Query4.SQL.text:='SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent'
            else
               dmGenData.Query4.SQL.text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='P' then
            begin
            if role='ENFANT' then
               dmGenData.Query4.SQL.Text:='SELECT I.S FROM R JOIN I ON R.A=I.no WHERE R.no=:idEvent'
            else
               dmGenData.Query4.SQL.Text:='SELECT I.S FROM R JOIN I ON R.B=I.no WHERE R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if dmGenData.Query4.Fields[0].AsString='F' then
               Remplace:=Translation.Items[66]
            else
               Remplace:=Translation.Items[67];
         end;
         if Code='PP' then
            begin
            if role='ENFANT' then
               dmGenData.Query4.SQL.Text:='SELECT I.S FROM R JOIN I ON R.A=I.no WHERE R.no=:idEvent'
            else
               dmGenData.Query4.SQL.Text:='SELECT I.S FROM R JOIN I ON R.B=I.no WHERE R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if dmGenData.Query4.Fields[0].AsString='F' then
               Remplace:=Translation.Items[68]
            else
               Remplace:=Translation.Items[69];
         end;
         if Code='PO' then
            begin
            if role='ENFANT' then
               dmGenData.Query4.SQL.text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent'
            else
               dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='P1' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='P2' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='PAR' then
            begin
            Sexe:=dmGenData.GetSexOfInd(idSujet);
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=:idind ORDER BY R.SD';
            dmGenData.Query4.ParamByName('idInd').AsInteger:=idSujet;
            if not dmGenData.Query4.EOF then
               begin
               if Sexe='F' then
                  Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
               else
                  Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            end
            else
               Remplace:='';
         end;
         if Code='PARO' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT A,B FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if role='ENFANT' then
               Remplace:=dmGenData.Query4.Fields[1].AsString
            else
               Remplace:=dmGenData.Query4.Fields[0].AsString;
            dmGenData.Query4.SQL.Text:='SELECT I.S FROM I WHERE I.no=:iiPara1';
            dmGenData.Query4.ParamByName('idPara1').AsString:=Remplace;
            dmGenData.Query4.Open;
            Sexe:=dmGenData.Query4.Fields[0].AsString;
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A='+Remplace+' ORDER BY R.SD';
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               if sexe='F' then
                  Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
               else
                  Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            end
            else
               Remplace:='';
         end;
         if Code='PAR1' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT R.A, I.S FROM R JOIN I on R.A=I.no WHERE R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            Remplace:=dmGenData.Query4.Fields[0].AsString;
            Sexe:=dmGenData.Query4.Fields[1].AsString;
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A='+Remplace+' ORDER BY R.SD';
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               if Sexe='F' then
                  Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
               else
                  Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            end
            else
               Remplace:='';
         end;
         if Code='PAR2' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT R.B, I.S FROM R JOIN I on R.B=I.no WHERE R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            Remplace:=dmGenData.Query4.Fields[0].AsString;
            Sexe:=dmGenData.Query4.Fields[1].AsString;
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A='+Remplace+' ORDER BY R.SD';
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               if sexe='F' then
                  Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
               else
                  Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            end
            else
               Remplace:='';
         end;
//         if Code='WO' then remplace:='/Noms de tous les témoins/'; JAMAIS DANS type 'R'
         if Copy(Code,1,2)='R:' then // soit ENFANT, soit PARENT
            begin
            if Copy(Code,3,length(code))='ENFANT' then
               dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.A WHERE N.X=1 and R.no=:idEvent'
            else
               dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE N.X=1 and R.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
      end;
   end;
   if TypeEvenement='E' then
      begin
      if PosEnd2>PosStart2 then
         begin
         Code:=Copy(Phrase,PosStart2+1,PosEnd2-PosStart2-1);
         if Code='A' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT PD FROM E WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=CalculateAge(dmGenData.GetI3(idSujet),dmGenData.Query4.Fields[0].AsString,0);
            if Remplace='0' then Remplace:='';
         end;
         if Code='A1' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT E.PD, W.I FROM E JOIN W on E.no=W.E WHERE W.X=1 AND no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               lsI3 := dmGenData.GetI3(dmGenData.Query4.Fields[1].AsInteger);
               Remplace:=CalculateAge(lsI3,dmGenData.Query4.Fields[0].AsString,0);
               if Remplace='0' then Remplace:='';
            end;
         end;
         if Code='A2' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT E.PD, W.I FROM E JOIN W on E.no=W.E WHERE W.X=1 AND no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  begin
                  lsI3 := dmGenData.GetI3(dmGenData.Query4.Fields[1].AsInteger);
                  Remplace:=CalculateAge(lsI3,dmGenData.Query4.Fields[0].AsString,0);
                  if Remplace='0' then Remplace:='';
               end;
            end;
         end;
         if Code='AO' then
            begin
            dmGenData.Query4.SQL.text:='SELECT E.PD, W.I FROM E JOIN W on E.no=W.E WHERE W.X=1 AND (NOT (W.I=:idInd)) AND no=:idEvent';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               lsI3 := dmGenData.GetI3(dmGenData.Query4.Fields[1].AsInteger);
               Remplace:=CalculateAge(lsI3,dmGenData.Query4.Fields[0].AsString,0);
               if Remplace='0' then Remplace:='';
            end;
         end;
         if Code='D' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT PD FROM E WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=ConvertDate(dmGenData.Query4.Fields[0].AsString,0);
         end;
         if Code='L' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT L.L FROM L JOIN E ON L.no=E.L WHERE E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeChanged(dmGenData.Query4.Fields[0].AsString);
         end;
         if Code='M' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT M FROM E WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=dmGenData.Query4.Fields[0].AsString;
            if AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))>0 then
               begin
               Remplace:=copy(Remplace,AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))+4+length(Translation.Items[320]),length(Remplace));
               if AnsiPos('[L=',uppercase(Remplace))>0 then
                  Remplace:=copy(Remplace,1,AnsiPos('[L=',uppercase(Remplace))-1);
            end;
         end;
         if (Code='N') then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N FROM N WHERE N.X=1 and N.I=:idInd';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1);
         end;
         if (Code='W') or (Code='P') then
            begin
            dmGenData.Query4.SQL.Text:='SELECT I.S FROM I WHERE I.no=:idInd';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            if dmGenData.Query4.Fields[0].AsString='F' then
               Remplace:=Translation.Items[66]
            else
               Remplace:=Translation.Items[67];
         end;
         if Code='PP' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT I.S FROM I WHERE I.no=:idInd';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            if dmGenData.Query4.Fields[0].AsString='F' then
               Remplace:=Translation.Items[68]
            else
               Remplace:=Translation.Items[69];
         end;
         if Code='PO' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN W on N.I=W.I WHERE W.X=1 AND N.X=1 AND W.E='+Evenement+' AND NOT W.I=:idInd';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='P1' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN W on N.I=W.I WHERE W.X=1 AND N.X=1 AND W.E=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='P2' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN W on N.I=W.I WHERE W.X=1 AND N.X=1 AND W.E=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsString:=Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
            end;
         end;
         if Code='PAR' then
            begin
            Sexe:=dmGenData.GetSexOfInd(idSujet);
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A=:idInd ORDER BY R.SD';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               if sexe='F' then
                  Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
               else
                  Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            end
            else
               Remplace:='';
         end;
         if Code='PARO' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT W.I, I.S FROM W JOIN I on W.I=I.no WHERE W.X=1 AND W.E='+Evenement+' AND NOT W.I=:idInd';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               Remplace:=dmGenData.Query4.Fields[0].AsString;
               Sexe:=dmGenData.Query4.Fields[1].AsString;
               dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A='+Remplace+' ORDER BY R.SD';
               dmGenData.Query4.Open;
               if not dmGenData.Query4.EOF then
                  begin
                  if sexe='F' then
                     Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
                  else
                     Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
                  dmGenData.Query4.Next;
                  if not dmGenData.Query4.EOF then
                     Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               end
               else
                  Remplace:='';
            end;
         end;
         if Code='PAR1' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT W.I, I.S FROM W JOIN I on W.I=I.no WHERE W.X=1 AND W.E='+Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               Sexe:=dmGenData.Query4.Fields[1].AsString;
               Remplace:=dmGenData.Query4.Fields[0].AsString;
               dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A='+Remplace+' ORDER BY R.SD';
               dmGenData.Query4.Open;
               if not dmGenData.Query4.EOF then
                  begin
                  if sexe='F' then
                     Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
                  else
                     Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
                  dmGenData.Query4.Next;
                  if not dmGenData.Query4.EOF then
                     Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               end
               else
                  Remplace:='';
            end;
         end;
         if Code='PAR2' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT W.I, I.S FROM W JOIN I on W.I=I.no WHERE W.X=1 AND W.E='+Evenement;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  begin
                  Remplace:=dmGenData.Query4.Fields[0].AsString;
                  Sexe:=dmGenData.Query4.Fields[1].AsString;
                  dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I=R.B WHERE R.X=1 AND N.X=1 AND R.A='+Remplace+' ORDER BY R.SD';
                  dmGenData.Query4.Open;
                  if not dmGenData.Query4.EOF then
                     begin
                     if sexe='F' then
                        Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
                     else
                        Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
                     dmGenData.Query4.Next;
                     if not dmGenData.Query4.EOF then
                        Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
                  end
                  else
                     Remplace:='';
               end;
            end;
         end;
         if Code='WO' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN W on N.I=W.I JOIN E on W.E=E.no WHERE N.X=1 AND W.X=0 AND E.no='+Evenement;
            dmGenData.Query4.Open;
            While not dmGenData.Query4.EOF do
               begin
               temp:=DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if length(remplace)=0 then
                  Remplace:=temp
               else
                  if dmGenData.Query4.EOF then
                     Remplace:=Remplace+Translation.Items[72]+temp
                  else
                     Remplace:=Remplace+', '+temp;
            end;
         end;
         if Copy(Code,1,2)='R:' then
            begin
            RoleRecherche:=Copy(Code,3,length(Code));
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN W on N.I=W.I WHERE N.X=1 AND W.E='+
               Evenement+' AND W.R='''+RoleRecherche+'''';
            dmGenData.Query4.Open;
            While not dmGenData.Query4.EOF do
               begin
               temp:=DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if length(remplace)=0 then
                  Remplace:=temp
               else
                  if dmGenData.Query4.EOF then
                     Remplace:=Remplace+Translation.Items[72]+temp
                  else
                     Remplace:=Remplace+', '+temp;
            end;
         end;
      end;
   end;
   if TypeEvenement='N' then
      begin
      if PosEnd2>PosStart2 then
         begin
         Code:=Copy(Phrase,PosStart2+1,PosEnd2-PosStart2-1);
         if (Code='A') or (Code='A1') then
            begin
            dmGenData.Query4.SQL.Text:='SELECT PD FROM N WHERE no='+Evenement;
            dmGenData.Query4.Open;
            Remplace:=CalculateAge(dmGenData.GetI3(idSujet),dmGenData.Query4.Fields[0].AsString,0);
            if Remplace='0' then Remplace:='';
         end;
//         if Code='A2' then JAMAIS DANS TYPE 'N'
//         if Code='AO' then JAMAIS DANS TYPE 'N'
         if Code='D' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT PD FROM N WHERE no='+Evenement;
            dmGenData.Query4.Open;
            Remplace:=ConvertDate(dmGenData.Query4.Fields[0].AsString,0);
         end;
//         if Code='L' then remplace:='/LIEU/'; JAMAIS DANS type 'N'
         if Code='M' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT M FROM N WHERE no='+Evenement;
            dmGenData.Query4.Open;
            Remplace:=dmGenData.Query4.Fields[0].AsString;
            if AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))>0 then
               begin
               Remplace:=copy(Remplace,AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))+4+length(Translation.Items[320]),length(Remplace));
               if AnsiPos('[L=',uppercase(Remplace))>0 then
                  Remplace:=copy(Remplace,1,AnsiPos('[L=',uppercase(Remplace)));
            end;
         end;
         if (Code='W') or (Code='N') or (Code='P1') or (Copy(Code,1,2)='R:') then
            begin
            dmGenData.Query4.SQL.Text:='SELECT N FROM N WHERE no='+Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1)
         end;
         if Code='P' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT I.S FROM N JOIN I ON N.I=I.no WHERE N.no='+Evenement;
            dmGenData.Query4.Open;
            if dmGenData.Query4.Fields[0].AsString='F' then
               Remplace:=Translation.Items[66]
            else
               Remplace:=Translation.Items[67];
         end;
         if Code='PP' then
            begin
            dmGenData.Query4.SQL.Text:='SELECT I.S FROM N JOIN I ON N.I=I.no WHERE N.no='+Evenement;
            dmGenData.Query4.Open;
            if dmGenData.Query4.Fields[0].AsString='F' then
               Remplace:=Translation.Items[68]
            else
               Remplace:=Translation.Items[69];
         end;
//         if Code='PO' then JAMAIS DANS TYPE 'N'
//         if Code='P2' then JAMAIS DANS TYPE 'N'
         if (Code='PAR') or (Code='PAR1') then
            begin
            dmGenData.Query4.SQL.Text:='SELECT I.S FROM I WHERE I.no=:idIind';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            Sexe:=dmGenData.Query4.Fields[0].AsString;
            dmGenData.Query4.SQL.Text:='SELECT N.N FROM N JOIN R on N.I = R.B WHERE R.X=1 AND N.X=1 AND R.A=:idInd ORDER BY R.SD';
            dmGenData.Query4.ParamByName('idind').AsInteger:=idSujet;
            dmGenData.Query4.Open;
            if not dmGenData.Query4.EOF then
               begin
               if sexe='F' then
                  Remplace:=Translation.Items[70]+DecodeName(dmGenData.Query4.Fields[0].AsString,1)
               else
                  Remplace:=Translation.Items[71]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
               dmGenData.Query4.Next;
               if not dmGenData.Query4.EOF then
                  Remplace:=Remplace+Translation.Items[72]+DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            end
            else
               Remplace:='';
         end;
//         if Code='PARO' then JAMAIS DANS TYPE 'N'
//         if Code='PAR2' then JAMAIS DANS TYPE 'N'
//         if Code='WO' then remplace:='/Noms de tous les témoins/'; JAMAIS DANS type 'N'
      end;
   end;

   // Remplace

   if length(remplace)=0 then
      if (PosStart1>0) AND (PosEnd1>0) AND (PosEnd1>PosStart1) AND (PosStart1<PosStart2) AND (PosEnd1>PosEnd2) then
         if (PosSeparateur>0) AND (PosSeparateur<PosEnd2) then // on a "...<...|...[.]...>..."
            phrase:=Copy(phrase,1,PosStart1-1)+Copy(phrase,PosStart1+1,PosSeparateur-PosStart1-1)+
                    Copy(phrase,PosEnd1+1,Length(phrase))
         else
            if (PosSeparateur>0) AND (PosSeparateur>PosEnd2) then // on a "...<...[.]...|...>..."
               phrase:=Copy(phrase,1,PosStart1-1)+Copy(phrase,PosSeparateur+1,PosEnd1-PosSeparateur-1)+
                       Copy(phrase,PosEnd1+1,Length(phrase))
            else // on a "...<...[...]...>...
               phrase:=Copy(phrase,1,PosStart1-1)+Copy(phrase,PosEnd1+1,Length(phrase))
      else // on a " ...[...]..."
         phrase:=Copy(phrase,1,PosStart2-1)+Copy(phrase,PosEnd2+1,Length(phrase))
   else
      if (PosStart1>0) AND (PosEnd1>0) AND (PosEnd1>PosStart1) AND (PosStart1<PosStart2) AND (PosEnd1>PosEnd2) then
         if (PosSeparateur>0) AND (PosSeparateur<PosEnd2) then // on a "...<...|...[.]...>..."
            phrase:=Copy(phrase,1,PosStart1-1)+Copy(phrase,PosSeparateur+1,PosStart2-PosSeparateur-1)+
                    Remplace+Copy(phrase,PosEnd2+1,PosEnd1-PosEnd2-1)+Copy(Phrase,PosEnd1+1,Length(Phrase))
         else
            if (PosSeparateur>0) AND (PosSeparateur>PosEnd2) then // on a "...<...[.]...|...>..."
               phrase:=Copy(phrase,1,PosStart1-1)+Copy(phrase,PosStart1+1,PosStart2-PosStart1-1)+
                       Remplace+Copy(phrase,PosEnd2+1,PosSeparateur-PosEnd2-1)+Copy(Phrase,PosEnd1+1,Length(Phrase))
            else // on a "...<...[...]...>...
               phrase:=Copy(phrase,1,PosStart1-1)+Copy(phrase,PosStart1+1,PosStart2-PosStart1-1)+
                       Remplace+Copy(phrase,PosEnd2+1,PosEnd1-PosEnd2-1)+Copy(Phrase,PosEnd1+1,Length(Phrase))
      else // on a " ...[...]..."
         phrase:=Copy(phrase,1,PosStart2-1)+Remplace+Copy(phrase,PosEnd2+1,Length(phrase));

   if PosEnd2>PosStart2 then
      phrase:=DecodePhraseTMG(idSujet,role,phrase,TypeEvenement,evenement);

   DecodePhraseTMG:=phrase;
end;

function DecodePhraseStemma(idIndividual:integer;role:string;phrase:string;TypeEvenement:string;evenement,char:integer):string;
var
  RoleRecherche, Remplace, temp, Sexe, lSex:string;
  PosEnd1, PosSep1, PosSep2, PosSep3, compte:integer;
begin
   if AnsiPos('<L='+Translation.Items[319]+'>',uppercase(phrase))>0 then
      begin
      phrase:=copy(phrase,AnsiPos('<L='+Translation.Items[319]+'>',uppercase(phrase))+5,length(phrase));
      if AnsiPos('</L>',uppercase(phrase))>0 then
         phrase:=copy(phrase,1,AnsiPos('</L>',uppercase(phrase)));
   end;
   RoleRecherche:='<R='+role;
   if AnsiPos(RoleRecherche,uppercase(phrase))>0 then
      begin
      phrase:=copy(phrase,AnsiPos(RoleRecherche,uppercase(phrase))+length(RoleRecherche)+1,length(phrase));
      if AnsiPos('</R>',uppercase(phrase))>0 then
         phrase:=copy(phrase,1,AnsiPos('</R>',uppercase(phrase))-1);
   end;
   while (not ((copy(phrase,char,1)='$') or (copy(phrase,char,1)='<'))) and (char<length(phrase)) do
      char:=char+1;
   if idIndividual>0 then
      begin
      if copy(phrase,char,1)='$' then
         begin
         // fr: Vérifie si c'est une variable, si oui remplace par sa valeur
         // en: Checks to see if it is a variable, if yes replaces by its value
         if copy(phrase,char+1,1)='L' then
            begin
            // fr: Remplace par le Lieu
            // en: Replaces the place
            dmGenData.Query4.SQL.text:='SELECT L.L FROM L JOIN E ON L.no=E.L WHERE E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
            dmGenData.Query4.Open;
            remplace:=DecodeChanged(dmGenData.Query4.Fields[0].AsString);
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+2,length(phrase));
         end;
         if copy(phrase,char+1,1)='N' then
            begin
            // Remplace par le Nom
            dmGenData.Query4.SQL.text:='SELECT N FROM N WHERE no=:idName';
            dmGenData.Query4.ParamByName('idName').AsInteger:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=DecodeName(dmGenData.Query4.Fields[0].AsString,1);
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+2,length(phrase));
         end;
         if copy(phrase,char+1,1)='M' then
            begin
            // Remplace par le Mémo
            dmGenData.Query4.SQL.text:='SELECT M FROM '+TypeEvenement+' WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
            dmGenData.Query4.Open;
            Remplace:=dmGenData.Query4.Fields[0].AsString;
            if AnsiPos('<L='+Translation.Items[320]+']',uppercase(Remplace))>0 then
               begin
               Remplace:=copy(Remplace,AnsiPos('<L='+Translation.Items[320]+'>',uppercase(Remplace))+4+length(Translation.Items[320]),length(Remplace));
               if AnsiPos('</L>',uppercase(Remplace))>0 then
                  Remplace:=copy(Remplace,1,AnsiPos('</L>',uppercase(Remplace)));
            end;
            if AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))>0 then
               begin
               Remplace:=copy(Remplace,AnsiPos('[L='+Translation.Items[320]+']',uppercase(Remplace))+4+length(Translation.Items[320]),length(Remplace));
               if AnsiPos('[L=',uppercase(Remplace))>0 then
                  Remplace:=copy(Remplace,1,AnsiPos('[L=',uppercase(Remplace)));
            end;
            phrase:=Copy(phrase,1,char-1)+Remplace+
                    Copy(phrase,char+2,length(phrase));
         end;
         if copy(phrase,char+1,1)='P' then
            begin
            // Remplace par le Pronom

            if dmGenData.GetSexOfInd(idIndividual)='F' then
               Remplace:=Translation.Items[66] // Female pronoun
            else
               Remplace:=Translation.Items[67]; // Male pronoun
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+2,length(phrase));
         end;
         if copy(phrase,char+1,1)='D' then
            begin
            // Remplace par la Date
            if TypeEvenement='R' then
               dmGenData.Query4.SQL.Text:='SELECT SD FROM R WHERE no=:idEvent'
            else
               dmGenData.Query4.SQL.Text:='SELECT PD FROM '+TypeEvenement+' WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=evenement;
            dmGenData.Query4.Open;
            Remplace:=ConvertDate(dmGenData.Query4.Fields[0].AsString,0);
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+2,length(phrase));
         end;
         if copy(phrase,char+1,2)='R_' then
            begin
            // Vérifie quel role, remplace par la liste des noms }
            temp:=Copy(phrase,char+3,length(phrase));
            posend1:=AnsiPos('_',temp);
            if posend1>0 then
               begin
               RoleRecherche:=Copy(temp,1,posend1-1);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';

            dmGenData.Query4.ParamByName('idEvent').AsInteger:=evenement;
               dmGenData.Query4.Open;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  remplace:='';
                  if TypeEvenement='N' then
                     begin
                     remplace:=dmGenData.GetIndividuumName(idIndividual);
                  end;
                  if TypeEvenement='R' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT R.A, R.B FROM R WHERE no=:idEvent';
                                 dmGenData.Query4.ParamByName('idEvent').AsInteger:=evenement;
                                 dmGenData.Query4.Open;
                     if RoleRecherche='PARENT' then
                        remplace:=dmGenData.GetIndividuumName(dmGenData.Query4.Fields[1].AsInteger)
                     else
                        remplace:=dmGenData.GetIndividuumName(dmGenData.Query4.Fields[0].AsInteger)
                  end;
                  if TypeEvenement='E' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT W.I, N.N FROM W JOIN E ON E.no=W.E JOIN N ON N.I=W.I WHERE N.X=1 AND E.no=:idEvent'
            +' AND W.R='''+RoleRecherche+'''';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     dmGenData.Query4.First;
                     compte:=0;
                     while not dmGenData.Query4.EOF do
                        begin
                        temp:=DecodeName(dmGenData.Query4.Fields[1].AsString,1);
                        if compte=0 then
                           remplace:=temp;
                        if compte=1 then
                           remplace:=temp+Translation.Items[72]+remplace;
                        if compte>1 then
                           remplace:=temp+', '+remplace;
                        dmGenData.Query4.Next;
                        compte:=compte+1;
                     end;
                  end;
               end;
            end;
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+3+posend1,length(phrase));
         end;
         if copy(phrase,char+1,3)='RO_' then
            begin
            // Vérifie quel role, remplace par la liste des noms }
            temp:=Copy(phrase,char+4,length(phrase));
            posend1:=AnsiPos('_',temp);
            if posend1>0 then
               begin
               RoleRecherche:=Copy(temp,1,posend1-1);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  remplace:='';
                  if TypeEvenement='R' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT R.A, R.B FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     if RoleRecherche='PARENT' then
                        remplace:=dmGenData.GetIndividuumName(dmGenData.Query4.Fields[0].AsInteger)
                     else
                        remplace:=dmGenData.GetIndividuumName(dmGenData.Query4.Fields[1].AsInteger)
                  end;
                  if TypeEvenement='E' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT W.I, N.N FROM W JOIN E ON E.no=W.E JOIN N ON N.I=W.I WHERE N.X=1 AND E.no=:idEvent'
             +' AND W.R='''+RoleRecherche+'''';
           dmGenData.Query4.ParamByName('idEvent').AsInteger:=  Evenement;
                     dmGenData.Query4.Open;
                     compte:=0;
                     while not dmGenData.Query4.EOF do
                        begin
                        if not (dmGenData.Query4.Fields[0].AsInteger=idIndividual) then
                           begin
                           temp:=DecodeName(dmGenData.Query4.Fields[1].AsString,1);
                           if compte=0 then
                              remplace:=temp;
                           if compte=1 then
                              remplace:=temp+Translation.Items[72]+remplace;
                           if compte>1 then
                              remplace:=temp+', '+remplace;
                           compte:=compte+1;
                        end;
                        dmGenData.Query4.Next;
                     end;
                  end;
               end;
            end;
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+4+posend1,length(phrase));
         end;
         if copy(phrase,char+1,3)='RP_' then
            begin
            // Vérifie quel role, remplace par la liste des noms
            temp:=Copy(phrase,char+4,length(phrase));
            posend1:=AnsiPos('_',temp);
            if posend1>0 then
               begin
               RoleRecherche:=Copy(temp,1,posend1-1);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  remplace:='';
                  if TypeEvenement='R' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT R.A, R.B FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     dmGenData.Query3.SQL.Clear;
                     if RoleRecherche='PARENT' then
                        dmGenData.Query3.SQL.Add('SELECT R.A, R.B FROM R WHERE X=1 AND R.A='+
                                                  dmGenData.Query4.Fields[1].AsString)
                     else
                        dmGenData.Query3.SQL.Add('SELECT R.A, R.B FROM R WHERE X=1 AND R.A='+
                                                  dmGenData.Query4.Fields[0].AsString);
                     dmGenData.Query3.Open;
                     while not dmGenData.Query3.EOF do
                        begin
                        if length(remplace)=0 then
                           remplace:=dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger)
                        else
                           remplace:=remplace+Translation.Items[72]+dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger);
                        dmGenData.Query3.Next;
                     end;
                  end;
                  if TypeEvenement='E' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT W.I FROM W JOIN E ON E.no=W.E WHERE E.no=:idEvent'
            +' AND W.R='''+RoleRecherche+'''';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     compte:=0;
                     while not dmGenData.Query4.EOF do
                        begin
                        dmGenData.Query3.SQL.Text:='SELECT R.A, R.B FROM R WHERE X=1 AND R.A='+
                                                   dmGenData.Query4.Fields[0].AsString;
                        dmGenData.Query3.Open;
                        while not dmGenData.Query3.EOF do
                           begin
                           temp:=dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger);
                           if compte=0 then
                              remplace:=temp;
                           if compte=1 then
                              remplace:=temp+Translation.Items[72]+remplace;
                           if compte>1 then
                              remplace:=temp+', '+remplace;
                           compte:=compte+1;
                           dmGenData.Query3.Next;
                        end;
                        dmGenData.Query4.Next;
                     end;
                  end;
               end;
            end;
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+4+posend1,length(phrase));
         end;
         if copy(phrase,char+1,4)='ROP_' then
            begin
            // Vérifie quel role, remplace par la liste des noms
            temp:=Copy(phrase,char+5,length(phrase));
            posend1:=AnsiPos('_',temp);
            if posend1>0 then
               begin
               RoleRecherche:=Copy(temp,1,posend1-1);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  remplace:='';
                  if TypeEvenement='R' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT R.A, R.B FROM R WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     dmGenData.Query3.SQL.Clear;
                     if RoleRecherche='PARENT' then
                        dmGenData.Query3.SQL.Add('SELECT R.A, R.B FROM R WHERE X=1 AND R.A='+
                                                  dmGenData.Query4.Fields[0].AsString)
                     else
                        dmGenData.Query3.SQL.Add('SELECT R.A, R.B FROM R WHERE X=1 AND R.A='+
                                                  dmGenData.Query4.Fields[1].AsString);
                     dmGenData.Query3.Open;
                     while not dmGenData.Query3.EOF do
                        begin
                        if length(remplace)=0 then
                           remplace:=dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger)
                        else
                           remplace:=remplace+Translation.Items[72]+dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger);
                        dmGenData.Query3.Next;
                     end;
                  end;
                  if TypeEvenement='E' then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT W.I FROM W JOIN E ON E.no=W.E WHERE E.no=:idEvent' +
                     ' AND W.R='''+RoleRecherche+'''';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement ;
                     dmGenData.Query4.Open;
                     while not dmGenData.Query4.EOF do
                        begin
                        compte:=0;
                        if not (dmGenData.Query4.Fields[0].AsInteger=idIndividual) then
                           begin
                           dmGenData.Query3.SQL.Text:='SELECT R.A, R.B FROM R WHERE X=1 AND R.A='+
                                                      dmGenData.Query4.Fields[0].AsString;
                           dmGenData.Query3.Open;
                           while not dmGenData.Query3.EOF do
                              begin
                              temp:=dmGenData.GetIndividuumName(dmGenData.Query3.Fields[1].AsInteger);
                              if compte=0 then
                                 remplace:=temp;
                              if compte=1 then
                                    remplace:=temp+Translation.Items[72]+remplace;
                              if compte>1 then
                                    remplace:=temp+', '+remplace;
                              compte:=compte+1;
                              dmGenData.Query3.Next;
                           end;
                        end;
                        dmGenData.Query4.Next;
                     end;
                  end;
               end;
            end;
            phrase:=Copy(phrase,1,char-1)+remplace+
                    Copy(phrase,char+5+posend1,length(phrase));
         end;
         if (char+1) < length(phrase) then
            phrase:=DecodePhraseStemma(idIndividual,role,phrase,TypeEvenement,evenement,char+1);
      end;
      if copy(phrase,char,4)='<$S=' then
         begin
         // fr: Vérifie si c'est une fonction
         // en: Check if it is a function
         temp:=Copy(phrase,char+6,length(phrase));
         posend1:=AnsiPos('</S>',temp);
         temp:=copy(phrase,char+6,posend1-1);
         if ((copy(phrase,char+4,2)='M>') or (copy(phrase,char+4,2)='F>')) and
            (posend1>0) then
            begin
            // fr: Si c'est une fonction remplace par sa valeur
            // en: If it is a function replace it by its value
            Sexe:=Copy(phrase,char+4,1);
            lSex:=dmGenData.GetSexOfInd(idIndividual);
            if (sexe=lSex) or
               ((sexe='M') and (lSex='?'))then
               remplace:=temp
            else
               remplace:='';
            phrase:=Copy(phrase,1,char-1)+remplace+Copy(phrase,char+9+posend1,length(phrase));
         end;
         phrase:=DecodePhraseStemma(idIndividual,role,phrase,TypeEvenement,evenement,char);
      end;
      if copy(phrase,char,2)='<<' then
         begin
         temp:=Copy(phrase,char+3,length(phrase));
         possep1:=AnsiPos('|',temp);
         posend1:=AnsiPos('>>',temp);
         temp:=Copy(temp,possep1+1,length(temp));
         possep2:=AnsiPos('|',temp)+possep1;
         temp:=Copy(temp,possep2-possep1+1,length(temp));
         if AnsiPos('|',temp)>0 then
            begin
            possep3:=AnsiPos('|',temp)+possep2;
            if possep3>posend1 then possep3:=posend1;
            end
         else
            possep3:=posend1;
         // Vérifie si c'est une fonction, si oui remplace par sa valeur
         if (possep1>0) and (posend1>0) and (possep2>0) then
            begin
            remplace:=Copy(phrase,char+3+possep1,possep2-possep1-1);
            temp:=Copy(phrase,char+2,possep1);
            if Copy(temp,1,2)='$M' then
               begin
               dmGenData.Query4.SQL.Text:='SELECT M FROM '+TypeEvenement+' WHERE no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               If length(dmGenData.Query4.Fields[0].AsString)>0 then
                  remplace:=Copy(phrase,char+3+possep1+possep2,posend1-possep2-1);
            end;
            if Copy(temp,1,2)='$L' then
               begin
               dmGenData.Query4.SQL.Text:='SELECT L.L FROM L JOIN E ON L.no=E.L WHERE E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               If length(DecodeChanged(dmGenData.Query4.Fields[0].AsString))>0 then
                  remplace:=Copy(phrase,char+3+possep1+possep2,posend1-possep2-1);
            end;
            if Copy(temp,1,2)='$D' then
               begin
               if TypeEvenement='E' then
                  dmGenData.Query4.SQL.text:='SELECT PD FROM E WHERE E.no=:idEvent';
               if TypeEvenement='N' then
                  dmGenData.Query4.SQL.text:='SELECT PD FROM N WHERE E.no=:idEvent';
               if TypeEvenement='R' then
                  dmGenData.Query4.SQL.text:='SELECT SD FROM R WHERE E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               If Length(ConvertDate(dmGenData.Query4.Fields[0].AsString,1))>0 then
                  remplace:=Copy(phrase,char+3+possep1+possep2,posend1-possep2-1);
            end;
            if Copy(temp,1,3)='$R_' then
               begin
               RoleRecherche:=Copy(phrase,char+5,possep1-4);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               compte:=0;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  if (TypeEvenement='N') or (TypeEvenement='R') then
                     compte:=1;
                  if (TypeEvenement='E') then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT W.I FROM W JOIN E ON W.E=E.no WHERE '+
                                               'W.R='''+RoleRecherche+''' AND E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     compte:=dmGenData.Query4.RecordCount;
                  end;
               end;
            end;
            if Copy(temp,1,4)='$RO_' then
               begin
               RoleRecherche:=Copy(phrase,char+6,possep1-5);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               compte:=0;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  if (TypeEvenement='N') or (TypeEvenement='R') then
                     compte:=0;
                  if (TypeEvenement='E') then
                     begin
                     dmGenData.Query4.SQL.Text:='SELECT W.I FROM W JOIN E ON W.E=E.no WHERE '+
                                               'W.R='''+RoleRecherche+''' AND E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     compte:=dmGenData.Query4.RecordCount;
                     While not dmGenData.Query4.Eof do
                        begin
                        if dmGenData.Query4.Fields[0].AsInteger=idIndividual then
                           compte:=compte-1;
                        dmGenData.Query4.Next;
                     end;
                  end;
               end;
            end;
            if Copy(temp,1,4)='$RP_' then
               begin
               RoleRecherche:=Copy(phrase,char+6,possep1-5);
               // Vérifie que le role est dans la liste des roles possible }
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               compte:=0;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  if (TypeEvenement='N') then
                     begin
                     // Décompte les parents du idIndividual
                     dmGenData.Query4.SQL.text:='SELECT R.B FROM R WHERE X=1 AND R.A=:idInd';
                     dmGenData.Query4.ParamByName('idInd').AsInteger:=idIndividual;
                     dmGenData.Query4.Open;
                     compte:=dmGenData.Query4.RecordCount;
                  end;
                  if (TypeEvenement='R') then
                     begin
                     // Décompte les parents du role
                     if RoleRecherche='PARENT' then
                        dmGenData.Query4.SQL.text:='SELECT B FROM R WHERE no=:idEvent'
                     else
                        dmGenData.Query4.SQL.Text:='SELECT A FROM R WHERE no=:idEvent';
                     dmGenData.Query4.ParamByName('idEvent').AsInteger:=    Evenement;
                     dmGenData.Query4.Open;
                     dmGenData.Query3.SQL.Text:='SELECT B FROM R WHERE X=1 AND A='+
                                               dmGenData.Query4.Fields[0].AsString;
                     dmGenData.Query3.Open;
                     compte:=dmGenData.Query3.RecordCount;
                  end;
                  if (TypeEvenement='E') then
                     begin
                     // Decompte les parents des témoins
                     dmGenData.Query4.SQL.Text:='SELECT W.I FROM W JOIN E ON W.E=E.no WHERE '+
                                               'W.R='+RoleRecherche;
                     dmGenData.Query4.Open;
                     while not dmGenData.Query4.EOF do
                        begin
                        dmGenData.Query3.SQL.Text:='SELECT B FROM R WHERE X=1 AND A='+
                                                  dmGenData.Query4.Fields[0].AsString;
                        dmGenData.Query3.Open;
                        compte:=compte+dmGenData.Query3.RecordCount;
                        dmGenData.Query4.Next;
                     end;
                  end;
               end;
            end;
            if Copy(temp,1,5)='$ROP_' then
               begin
               // Decompte les parents des autres témoins
               RoleRecherche:=Copy(phrase,char+7,possep1-6);
               // Vérifie que le role est dans la liste des roles possible
               dmGenData.Query4.SQL.Text:='SELECT Y.R FROM Y JOIN '+TypeEvenement+
                                         ' ON Y.no='+TypeEvenement+'.Y WHERE '+
                                         TypeEvenement+'.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
               dmGenData.Query4.Open;
               compte:=0;
               if AnsiPos(RoleRecherche,dmGenData.Query4.Fields[0].AsString)>0 then
                  begin
                  if (TypeEvenement='E') then
                     begin
                     // Decompte les parents des autres témoins
                     dmGenData.Query4.SQL.Text:='SELECT W.I FROM W JOIN E ON W.E=E.no WHERE '+
                                               'W.R='''+RoleRecherche+''' AND E.no=:idEvent';
            dmGenData.Query4.ParamByName('idEvent').AsInteger:=Evenement;
                     dmGenData.Query4.Open;
                     while not dmGenData.Query4.EOF do
                        begin
                        if dmGenData.Query4.Fields[0].AsInteger<>idIndividual then
                           begin
                           dmGenData.Query3.SQL.Text:='SELECT B FROM R WHERE X=1 AND A='+
                                                     dmGenData.Query4.Fields[0].AsString;
                           dmGenData.Query3.Open;
                           compte:=compte+dmGenData.Query3.RecordCount;
                        end;
                        dmGenData.Query4.Next;
                     end;
                  end;
               end;
            end;
            if (compte=1) or ((compte>1) and (possep3=posend1)) then
               remplace:=Copy(phrase,char+3+possep2,possep3-possep2-1)
            else
               if compte>1 then
                  remplace:=Copy(phrase,char+3+possep3,posend1-possep3-1);
            phrase:=Copy(phrase,1,char-1)+remplace+Copy(phrase,char+4+posend1,length(phrase));
            phrase:=DecodePhraseStemma(idIndividual,role,phrase,TypeEvenement,evenement,char);
         end
         else
            begin
            if (char+1) < length(phrase) then
               phrase:=DecodePhraseStemma(idIndividual,role,phrase,TypeEvenement,evenement,char+1);
         end;
      end;
   end;
   DecodePhraseStemma:=phrase;
end;


function DecodePhrase(sIndividuum:string;role:string;phrase:string;TypeEvenement:string;evenement:string):string;
var
  i:integer;
  idInd, idEvent: Longint;
begin
   tryStrToInt(  sIndividuum ,idInd);
   tryStrToInt(  evenement ,idEvent);
   If copy(phrase,1,4)='!TMG' then
      DecodePhrase:=trim(DecodePhraseTMG(idInd,role,copy(phrase,5,length(phrase)),TypeEvenement,evenement))
   else
      begin
      DecodePhrase:=trim(DecodePhraseStemma(idInd,role,phrase,TypeEvenement,idEvent,1));
   end;
   // Remplace les "  " par " "
   for i:=1 to length(DecodePhrase)-1 do
      if Copy(DecodePhrase,i,2)='  ' then
         DecodePhrase:=Copy(DecodePhrase,1,i)+Copy(DecodePhrase,i+2,length(DecodePhrase));
   if not (Copy(DecodePhrase,length(DecodePhrase),1)='.') then
      DecodePhrase:=DecodePhrase+'.';
   DecodePhrase:=UpperCase(Copy(DecodePhrase,1,1))+Copy(DecodePhrase,2,Length(DecodePhrase));
end;

procedure SaveFormPosition(Sender: TForm);
begin
  dmGenData.WriteCfgFormPosition(sender);
end;

procedure SaveGridPosition(Sender: TStringGrid; cols: integer);
begin
  dmGenData.WriteCfgGridPosition(sender,cols);
end;

procedure GetGridPosition(Sender: TStringGrid; cols: integer);
begin
   dmGenData.ReadCfgGridPosition(sender,cols);
end;

procedure GetFormPosition(Sender: TForm; a: integer; b: integer; c: integer;
  d: integer);
begin
  dmGenData.ReadCfgFormPosition(sender,a,b,c,d);
end;

procedure SaveModificationTime(no:integer);
begin
  dmGenData.SaveModificationTime(no);
end;

procedure DecodePlace(Place: string; out article,detail,sCity,region,province,sCountry: string);
var
  pos2: integer;
  pos1: integer;
begin
  If copy(Place,1,4)='!TMG' then
     begin
     article:='';
     Place:=copy(Place,5,length(Place));
     detail:=copy(Place,1,AnsiPos('|',Place)-1);
     Place:=copy(Place,AnsiPos('|',Place)+1,length(Place));
     detail:=copy(Place,1,AnsiPos('|',Place)-1);
     Place:=copy(Place,AnsiPos('|',Place)+1,length(Place));
     sCity:=copy(Place,1,AnsiPos('|',Place)-1);
     Place:=copy(Place,AnsiPos('|',Place)+1,length(Place));
     region:=copy(Place,1,AnsiPos('|',Place)-1);
     Place:=copy(Place,AnsiPos('|',Place)+1,length(Place));
     province:=copy(Place,1,AnsiPos('|',Place)-1);
     Place:=copy(Place,AnsiPos('|',Place)+1,length(Place));
     sCountry:=copy(Place,1,AnsiPos('|',Place)-1);
  end
  else
     begin
     Pos1:=AnsiPos('<'+CTagNameArticle+'>',Place)+Length(CTagNameArticle)+2;
     Pos2:=AnsiPos('</'+CTagNameArticle+'>',Place);
     if (Pos1+Pos2)>9 then
        Article:=Copy(Place,Pos1,Pos2-Pos1)
     else
        Article:='';
     Pos1:=AnsiPos('<'+CTagNameDetail+'>',Place)+(Length(CTagNameDetail)+2);
     Pos2:=AnsiPos('</'+CTagNameDetail+'>',Place);
     if (Pos1+Pos2)>9 then
        Detail:=Copy(Place,Pos1,Pos2-Pos1)
     else
        Detail:='';
     Pos1:=AnsiPos('<Ville>',Place)+7;
     Pos2:=AnsiPos('</Ville>',Place);
     if (Pos1+Pos2)>7 then
        sCity:=Copy(Place,Pos1,Pos2-Pos1)
     else
        sCity:='';
     Pos1:=AnsiPos('<Région>',Place)+9;
     Pos2:=AnsiPos('</Région>',Place);
     if (Pos1+Pos2)>9 then
        Region:=Copy(Place,Pos1,Pos2-Pos1)
     else
        Region:='';
     Pos1:=AnsiPos('<Province>',Place)+10;
     Pos2:=AnsiPos('</Province>',Place);
     if (Pos1+Pos2)>10 then
        Province:=Copy(Place,Pos1,Pos2-Pos1)
     else
        Province:='';
     Pos1:=AnsiPos('<Pays>',Place)+6;
     Pos2:=AnsiPos('</Pays>',Place);
     if (Pos1+Pos2)>6 then
        sCountry:=Copy(Place,Pos1,Pos2-Pos1)
     else
        sCountry:='';
  end;
end;

function DecodeChanged(Place:string):string;
var
  article, detail, ville, region, province, pays: string;
begin
   DecodePlace(Place, article,detail,ville,region, province,pays   );
   if length(detail)=0 then
      Place:=trim(article+' '+ville+', '+region+', '+province+', '+pays)
   else
      Place:=trim(article+' '+detail+', '+ville+', '+region+', '+province+', '+pays);
   while (AnsiPos(', , ',Place)>0) do
      begin
      Place:=copy(Place,1,AnsiPos(', , ',Place)-1)+copy(Place,AnsiPos(', , ',Place)+2,length(Place));
   end;
   if copy(Place,length(Place),1)=',' then
      Place:=copy(Place,1,length(Place)-1);
   if copy(Place,1,2)=', ' then Place:=copy(Place,3,length(Place));
   DecodeChanged:=Place;
end;

function RemoveUTF8(text:string):string;
begin
   text:=AnsiReplaceStr(text,'å','a');
   text:=AnsiReplaceStr(text,'á','a');
   text:=AnsiReplaceStr(text,'à','a');
   text:=AnsiReplaceStr(text,'â','a');
   text:=AnsiReplaceStr(text,'ä','a');
   text:=AnsiReplaceStr(text,'ç','c');
   text:=AnsiReplaceStr(text,'é','e');
   text:=AnsiReplaceStr(text,'è','e');
   text:=AnsiReplaceStr(text,'ê','e');
   text:=AnsiReplaceStr(text,'ë','e');
   text:=AnsiReplaceStr(text,'ì','i');
   text:=AnsiReplaceStr(text,'ï','i');
   text:=AnsiReplaceStr(text,'î','i');
   text:=AnsiReplaceStr(text,'ò','o');
   text:=AnsiReplaceStr(text,'ö','o');
   text:=AnsiReplaceStr(text,'ô','o');
   text:=AnsiReplaceStr(text,'ø','o');
   text:=AnsiReplaceStr(text,'ù','u');
   text:=AnsiReplaceStr(text,'û','u');
   text:=AnsiReplaceStr(text,'ü','u');
   text:=AnsiReplaceStr(text,'ÿ','y');
   text:=AnsiReplaceStr(text,'ý','y');
   text:=AnsiReplaceStr(text,'ž','z');
   text:=AnsiReplaceStr(text,'Å','A');
   text:=AnsiReplaceStr(text,'Á','A');
   text:=AnsiReplaceStr(text,'À','A');
   text:=AnsiReplaceStr(text,'Â','A');
   text:=AnsiReplaceStr(text,'Ä','A');
   text:=AnsiReplaceStr(text,'Æ','AE');
   text:=AnsiReplaceStr(text,'Ç','C');
   text:=AnsiReplaceStr(text,'É','E');
   text:=AnsiReplaceStr(text,'È','E');
   text:=AnsiReplaceStr(text,'Ê','E');
   text:=AnsiReplaceStr(text,'Ë','E');
   text:=AnsiReplaceStr(text,'Ì','I');
   text:=AnsiReplaceStr(text,'Ï','I');
   text:=AnsiReplaceStr(text,'Î','I');
   text:=AnsiReplaceStr(text,'Ò','O');
   text:=AnsiReplaceStr(text,'Ö','O');
   text:=AnsiReplaceStr(text,'Ô','O');
   text:=AnsiReplaceStr(text,'Ù','U');
   text:=AnsiReplaceStr(text,'Û','U');
   text:=AnsiReplaceStr(text,'Ü','U');
   text:=AnsiReplaceStr(text,'Š','S');
   text:=AnsiReplaceStr(text,'Ž','Z');
   RemoveUTF8:=text;
end;

function ConvertDate(Date:string;format:byte):string;
var
   temp1, temp2, annee1, annee2, mois1, mois2, jour1, jour2: string;
   type1, type2, style : integer;
begin
   if copy(Date,1,1)<>'1' then
      ConvertDate := Copy(Date,2,length(Date))
   else
      begin
      annee1:=copy(Date,2,4);
      mois1 :=copy(Date,6,2);
      jour1 :=copy(Date,8,2);
      annee2:=copy(Date,12,4);
      mois2 :=copy(Date,16,2);
      jour2 :=copy(Date,18,2);
      tryStrToInt(copy(Date,11,1),style);
      type1:=0;
      type2:=0;
      if ((mois1='00') and (jour1='00')) then type1:=1 else    // annee seulement
      if ((annee1='0000') and (jour1='00')) then type1:=2 else // mois seulement
      if ((mois1='00') and (annee1='0000')) then type1:=3 else // jour seulement
      if (jour1='00') then type1:=4 else                       // manque jour seulement
      if (mois1='00') then type1:=5 else                       // manque mois seulement
      if (annee1='0000') then type1:=6;                        // manque annee seulement
      if ((mois2='00') and (jour2='00')) then type2:=1 else    // annee seulement
      if ((annee2='0000') and (jour2='00')) then type2:=2 else // mois seulement
      if ((mois2='00') and (annee2='0000')) then type2:=3 else // jour seulement
      if (jour2='00') then type2:=4 else                       // manque jour seulement
      if (mois2='00') then type2:=5 else                       // manque mois seulement
      if (annee2='0000') then type2:=6;                        // manque annee seulement
      if Copy(Date,1,21)='100000000030000000000' then
         ConvertDate :=''
      else
         begin
         If format=0 then
            begin
            Jour1:=IntToStr(StrtoInt(Jour1));
            Jour2:=IntToStr(StrtoInt(Jour2));
            Annee1:=IntToStr(StrtoInt(Annee1));
            Annee2:=IntToStr(StrtoInt(Annee2));
            if StrToInt(Jour1)=1 then Jour1:=Translation.Items[74];
            if StrToInt(Jour2)=1 then Jour2:=Translation.Items[74];
            case StrToInt(mois1) of
               1:mois1:=Translation.Items[75];
               2:mois1:=Translation.Items[76];
               3:mois1:=Translation.Items[77];
               4:mois1:=Translation.Items[78];
               5:mois1:=Translation.Items[79];
               6:mois1:=Translation.Items[80];
               7:mois1:=Translation.Items[81];
               8:mois1:=Translation.Items[82];
               9:mois1:=Translation.Items[83];
               10:mois1:=Translation.Items[84];
               11:mois1:=Translation.Items[85];
               12:mois1:=Translation.Items[86];
            end;
            case StrToInt(mois2) of
               1:mois2:=Translation.Items[75];
               2:mois2:=Translation.Items[76];
               3:mois2:=Translation.Items[77];
               4:mois2:=Translation.Items[78];
               5:mois2:=Translation.Items[79];
               6:mois2:=Translation.Items[80];
               7:mois2:=Translation.Items[81];
               8:mois2:=Translation.Items[82];
               9:mois2:=Translation.Items[83];
               10:mois2:=Translation.Items[84];
               11:mois2:=Translation.Items[85];
               12:mois2:=Translation.Items[86];
            end;
            case style of
               0:case type1 of
                    0:ConvertDate:=Translation.Items[87]+Jour1+' '+Mois1+' '+Annee1;
                    1:ConvertDate:=Translation.Items[88]+Annee1;
                    2:ConvertDate:=Translation.Items[88]+Mois1;
                    3:ConvertDate:=Translation.Items[89]+Jour1;
                    4:ConvertDate:=Translation.Items[88]+Mois1+' '+Annee1;
                    5:ConvertDate:=Translation.Items[89]+Jour1+
                                   Translation.Items[90]+Annee1;
                    6:ConvertDate:=Translation.Items[89]+Jour1+' '+Mois1;
                 end;
               1:case type1 of
                    0:ConvertDate:=Translation.Items[91]+Jour1+' '+Mois1+' '+Annee1;
                    1:ConvertDate:=Translation.Items[92]+Annee1;
                    2:ConvertDate:=Translation.Items[92]+Mois1;
                    3:ConvertDate:=Translation.Items[93]+Jour1;
                    4:ConvertDate:=Translation.Items[92]+Mois1+' '+Annee1;
                    5:ConvertDate:=Translation.Items[93]+Jour1+Translation.Items[90]+Annee1;
                    6:ConvertDate:=Translation.Items[93]+Jour1+' '+Mois1;
                 end;
               2:case type1 of
                    0:ConvertDate:=Translation.Items[91]+Jour1+' '+Mois1+' '+Annee1;
                    1:ConvertDate:=Translation.Items[92]+Annee1;
                    2:ConvertDate:=Translation.Items[92]+Mois1;
                    3:ConvertDate:=Translation.Items[93]+Jour1;
                    4:ConvertDate:=Translation.Items[92]+Mois1+' '+Annee1;
                    5:ConvertDate:=Translation.Items[93]+Jour1+Translation.Items[90]+Annee1;
                    6:ConvertDate:=Translation.Items[93]+Jour1+' '+Mois1;
                 end;
               3:case type1 of
                    0:ConvertDate:=Translation.Items[94]+Jour1+' '+Mois1+' '+Annee1;
                    1:ConvertDate:=Translation.Items[95]+Annee1;
                    2:ConvertDate:=Translation.Items[95]+Mois1;
                    3:ConvertDate:=Translation.Items[96]+Jour1;
                    4:ConvertDate:=Translation.Items[95]+Mois1+' '+Annee1;
                    5:ConvertDate:=Translation.Items[96]+Jour1+Translation.Items[90]+Annee1;
                    6:ConvertDate:=Translation.Items[96]+Jour1+' '+Mois1;
                 end;
               4:case type1 of
                    0:ConvertDate:=Translation.Items[97]+Jour1+' '+Mois1+' '+Annee1;
                    1:ConvertDate:=Translation.Items[98]+Annee1;
                    2:ConvertDate:=Translation.Items[98]+Mois1;
                    3:ConvertDate:=Translation.Items[99]+Jour1;
                    4:ConvertDate:=Translation.Items[98]+Mois1+' '+Annee1;
                    5:ConvertDate:=Translation.Items[99]+Jour1+Translation.Items[90]+Annee1;
                    6:ConvertDate:=Translation.Items[99]+Jour1+' '+Mois1;
                 end;
               5:begin
                 case type1 of
                    0:temp1:=Translation.Items[100]+Jour1+' '+Mois1+' '+Annee1;
                    1:temp1:=Translation.Items[101]+Annee1;
                    2:temp1:=Translation.Items[101]+Mois1;
                    3:temp1:=Translation.Items[102]+Jour1;
                    4:temp1:=Translation.Items[101]+Mois1+' '+Annee1;
                    5:temp1:=Translation.Items[102]+Jour1+Translation.Items[90]+Annee1;
                    6:temp1:=Translation.Items[102]+Jour1+' '+Mois1;
                 end;
                 case type2 of
                    0:ConvertDate:=temp1+Translation.Items[103]+Jour2+' '+Mois2+' '+Annee2;
                    1:ConvertDate:=temp1+Translation.Items[72]+Annee2;
                    2:ConvertDate:=temp1+Translation.Items[72]+Mois2;
                    3:ConvertDate:=temp1+Translation.Items[104]+Jour2;
                    4:ConvertDate:=temp1+Translation.Items[72]+Mois2+' '+Annee2;
                    5:ConvertDate:=temp1+Translation.Items[104]+Jour2+Translation.Items[90]+Annee2;
                    6:ConvertDate:=temp1+Translation.Items[104]+Jour2+' '+Mois2;
                 end;
                 end;
               6:begin
                 case type1 of
                    0:temp1:=Translation.Items[94]+Jour1+' '+Mois1+' '+Annee1;
                    1:temp1:=Translation.Items[95]+Annee1;
                    2:temp1:=Translation.Items[95]+Mois1;
                    3:temp1:=Translation.Items[96]+Jour1;
                    4:temp1:=Translation.Items[95]+Mois1+' '+Annee1;
                    5:temp1:=Translation.Items[96]+Jour1+Translation.Items[90]+Annee1;
                    6:temp1:=Translation.Items[96]+Jour1+' '+Mois1;
                 end;
                 case type2 of
                    0:ConvertDate:=temp1+Translation.Items[105]+Jour2+' '+Mois2+' '+Annee2;
                    1:ConvertDate:=temp1+Translation.Items[106]+Annee2;
                    2:ConvertDate:=temp1+Translation.Items[106]+Mois2;
                    3:ConvertDate:=temp1+Translation.Items[107]+Jour2;
                    4:ConvertDate:=temp1+Translation.Items[106]+Mois2+' '+Annee2;
                    5:ConvertDate:=temp1+Translation.Items[107]+Jour2+Translation.Items[90]+Annee2;
                    6:ConvertDate:=temp1+Translation.Items[107]+Jour2+' '+Mois2;
                 end;
                 end;
               7:begin
                 case type1 of
                    0:temp1:=Translation.Items[108]+Jour1+' '+Mois1+' '+Annee1;
                    1:temp1:=Translation.Items[109]+Annee1;
                    2:temp1:=Translation.Items[109]+Mois1;
                    3:temp1:=Translation.Items[110]+Jour1;
                    4:temp1:=Translation.Items[109]+Mois1+' '+Annee1;
                    5:temp1:=Translation.Items[110]+Jour1+Translation.Items[90]+Annee1;
                    6:temp1:=Translation.Items[110]+Jour1+' '+Mois1;
                 end;
                 case type2 of
                    0:ConvertDate:=temp1+Translation.Items[111]+Jour2+' '+Mois2+' '+Annee2;
                    1:ConvertDate:=temp1+Translation.Items[112]+Annee2;
                    2:ConvertDate:=temp1+Translation.Items[112]+Mois2;
                    3:ConvertDate:=temp1+Translation.Items[113]+Jour2;
                    4:ConvertDate:=temp1+Translation.Items[112]+Mois2+' '+Annee2;
                    5:ConvertDate:=temp1+Translation.Items[113]+Jour2+Translation.Items[90]+Annee2;
                    6:ConvertDate:=temp1+Translation.Items[113]+Jour2+' '+Mois2;
                 end;
                 end;
            end;
         end
         else
            begin
            case type1 of
               0:temp1:=Annee1+'/'+Mois1+'/'+Jour1;
               1:temp1:=Annee1;
               2:temp1:='.../'+Mois1+'/...';
               3:temp1:='.../.../'+Jour1;
               4:temp1:=Annee1+'/'+Mois1+'/...';
               5:temp1:=Annee1+'/.../'+Jour1;
               6:temp1:='.../'+Mois1+'/'+Jour1;
            end;
            case type2 of
               0:temp2:=Annee2+'/'+Mois2+'/'+Jour2;
               1:temp2:=Annee2;
               2:temp2:='.../'+Mois2+'/...';
               3:temp2:='.../.../'+Jour2;
               4:temp2:=Annee2+'/'+Mois2+'/...';
               5:temp2:=Annee2+'/.../'+Jour2;
               6:temp2:='.../'+Mois2+'/'+Jour2;
            end;
            case style of
               0:ConvertDate:='<'+temp1;
               1:ConvertDate:=Translation.Items[114]+temp1;
               2:ConvertDate:=Translation.Items[114]+temp1;
               3:ConvertDate:=temp1;
               4:ConvertDate:='>'+temp1;
               5:ConvertDate:=temp1+' - '+temp2;
               6:ConvertDate:=temp1+Translation.Items[115]+temp2;
               7:ConvertDate:=temp1+Translation.Items[112]+temp2;
            end;
         end;
      end;
   end;
end;

procedure PopulateCitations(Tableau: TStringGrid; Code: string; Nstr: String);
var
  no: Longint;
begin
  if trystrtoint(Nstr,no) then
     dmGenData.PopulateCitations(Tableau,code,no);
end;

function DecodeName(Name:string;format:byte):string;
var
   titre,prenom,nom,suffixe,temp,nomcomplet:string;
   Pos1, Pos2:integer;
begin
   nomcomplet := '';
   temp:=Name;
   titre:='';
   prenom:='';
   nom:='';
   suffixe:='';
   if copy(Name,1,5)='!TMG|' then
      begin
      temp := copy(temp,6,length(temp));
      nom := trim(copy(temp,1,AnsiPos('|',temp)-1));
      temp := copy(temp,AnsiPos('|',temp)+1,length(temp));
      titre := trim(copy(temp,1,AnsiPos('|',temp)-1));
      temp := copy(temp,AnsiPos('|',temp)+1,length(temp));
      prenom := trim(copy(temp,1,AnsiPos('|',temp)-1));
      temp := copy(temp,AnsiPos('|',temp)+1,length(temp));
      suffixe := trim(copy(temp,1,AnsiPos('|',temp)-1));
   end
   else
      begin
      // Traiter les noms avec <N=TITRE></N>...
      Pos1:=AnsiPos('<'+CTagNameTitle+'>',temp)+length(CTagNameTitle)+2;
      Pos2:=AnsiPos('</'+CTagNameTitle+'>',temp);
      if (Pos1+Pos2)>length(CTagNameTitle)+2 then
         titre:=Copy(temp,Pos1,Pos2-Pos1);
      Pos1:=AnsiPos('<'+CTagNameGivenName+'>',temp)+length(CTagNameGivenName)+2;     // 9 car le 'é' prends 2 position en ANSI
      Pos2:=AnsiPos('</'+CTagNameGivenName+'>',temp);
      if (Pos1+Pos2)>length(CTagNameGivenName)+2 then
         prenom:=Copy(temp,Pos1,Pos2-Pos1);
      Pos1:=AnsiPos('<'+CTagNameFamilyName+'>',temp)+length(CTagNameFamilyName)+2;
      Pos2:=AnsiPos('</'+CTagNameFamilyName+'>',temp);
      if (Pos1+Pos2)>length(CTagNameFamilyName)+2 then
         nom:=Copy(temp,Pos1,Pos2-Pos1);
      Pos1:=AnsiPos('<'+CTagNameSuffix+'>',temp)+length(CTagNameSuffix)+2;
      Pos2:=AnsiPos('</'+CTagNameSuffix+'>',temp);
      if (Pos1+Pos2)>length(CTagNameSuffix)+2 then
         Suffixe:=Copy(temp,Pos1,Pos2-Pos1);
   end;
   if format = 1 then
      begin
      If length(titre) > 0 then
         nomcomplet := titre;
      If length(prenom) > 0 then
         If length(nomcomplet) = 0 then
            nomcomplet := prenom
         else
            nomcomplet := nomcomplet + ' ' + prenom;
      If length(nom) > 0 then
         If length(nomcomplet) = 0 then
            nomcomplet := nom
         else
            nomcomplet := nomcomplet + ' ' + nom;
      If length(suffixe) > 0 then
         If length(nomcomplet) = 0 then
            nomcomplet := suffixe
         else
            nomcomplet := nomcomplet + ' ' + suffixe;
   end;
   if format = 2 then
      begin
      If length(nom) > 0 then
         nomcomplet := nom;
      If length(suffixe) > 0 then
         If length(nomcomplet) = 0 then
            nomcomplet := suffixe
         else
            nomcomplet := nomcomplet + ' ' + suffixe;
      If length(prenom) > 0 then
         If length(prenom) = 0 then
            nomcomplet := ', '+prenom
         else
            nomcomplet := nomcomplet + ', ' + prenom;
      If length(titre) > 0 then
         If length(nomcomplet) = 0 then
            nomcomplet := '('+titre+')'
         else
            nomcomplet := nomcomplet + ' (' + titre + ')';
   end;
   If length(nomcomplet) = 0 then nomcomplet := '???';
   Result := nomcomplet;
end;

function GetTableColWidthSum(const lTable: TStringGrid; const lIgnCol: Integer
  ): Integer;
var
  lMaxTblSize, i: Integer;
begin
  lMaxTblSize:=0;
  for i := 0 to lTable.ColCount-1 do
    if i <> lIgnCol then
       lMaxTblSize:=lMaxTblSize+lTable.Columns[i].Width;
  Result:=lMaxTblSize;
end;

end.

