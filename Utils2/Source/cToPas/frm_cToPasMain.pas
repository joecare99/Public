// This file is part of CtoPAStom.  Buildbot is free software: you can
// redistribute it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, version 2.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//
// Copyright Tommaso Fantozzi

unit frm_cToPasMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls,strutils,md5;

type prePostRecord=record
     pre:array of string;
     condition:string;
     post:array of string;
     isComplex:boolean;
     isNormal:boolean;
end;

type varSet=record
     varName:array of string;
     varValue:array of string;
     varType:array of string;
     isArray:array of boolean;
     arrayLen:array of string;
     isFunction:array of boolean;
     order:array of integer;
     aProperty:array of string;
     asRef:array of boolean;
     isPointer:array of boolean;
     hasDirective:array of string;
end;

type forStat=record
     condList:string;
     varList:string;
     oplist:string;
     param:varSet;
     auxVariab:string;
end;

type istSet=record
     ist:array of string;
     kind:array of integer;
     dataFOR:array of forStat;

// Kind
//     0=ND
//     1=IF
//     2=ELSE
//     3=END
//     4=FOR
//     5=WHILE
//     6=inFOR instruction
end;

type paramList=record
     varName:string;
     functionName:string;
     paramList:array of string;
end;


type

  { TfrmcToPasMain }

  TfrmcToPasMain = class(TForm)
    btnConvert: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    pnlClient: TPanel;
    pnlTop: TPanel;
    procedure btnConvertClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure pnlClientClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmcToPasMain: TfrmcToPasMain;


implementation

{$R *.lfm}

{ TfrmcToPasMain }

function nextSymbol(var input:string;aa:integer):string;
var
   a,b,c,d,e:integer;
begin
     result:='';
     for a := aa+1 to length(input) do
     begin
         if (input[a]<>#32) and (input[a]<>#9) and (input[a]<>#13) and (input[a]<>#10) then
         begin
            result:=input[a];
            exit;
         end;
     end;
end;

function nextSymbolP(var input:string;aa:integer):integer;
var
   a,b,c,d,e:integer;
begin
     result:=aa;
     for a := aa+1 to length(input) do
     begin
         if (input[a]<>#32) and (input[a]<>#9) and (input[a]<>#13) and (input[a]<>#10) then
         begin
            result:=a;
            exit;
         end;
     end;
end;

function prevSymbol(var input:string;aa:integer):string;
var
   a,b,c,d,e:integer;
begin
     result:='';
     if (aa-1)>length(input) then exit;
     for a := aa-1 downto 1 do
     begin
         if (input[a]<>#32) and (input[a]<>#9) and (input[a]<>#13) and (input[a]<>#10) then
         begin
            result:=input[a];
            exit;
         end;
     end;
end;

function isAllowedFirstChar(input:string):boolean;
begin
   result:=false;
   if length(input)<>1 then
   begin
     result:=false;
     exit;
   end;
   if ((Ord(input[1])>=65)and(Ord(input[1])<=90 ) or
       (Ord(input[1])>=97)and(Ord(input[1])<=122) or
       (input[1]='_')                            ) then
       result:=true;
end;

function isAllowedChar(var input:string;aa:integer):boolean;
begin
   result:=false;
   if length(input)<aa then
   begin
     result:=false;
     exit;
   end;
   if ((Ord(input[aa])>=65)and(Ord(input[aa])<=90 ) or
       (Ord(input[aa])>=97)and(Ord(input[aa])<=122) or
       (Ord(input[aa])>=48)and(Ord(input[aa])<=57 ) or
       (input[aa]='_') or (input[aa]='.')         ) then
       begin
            result:=true;
            exit;
       end;
   if length(input)<aa+2 then
   begin
     result:=false;
     exit;
   end;
   if (input[aa]='-') and (input[aa+1]='>') then
   begin
     if ((Ord(input[aa+2])>=65)and(Ord(input[aa+2])<=90 ) or
         (Ord(input[aa+2])>=97)and(Ord(input[aa+2])<=122) or
         (Ord(input[aa+2])>=48)and(Ord(input[aa+2])<=57 ) or
         (input[aa]='_') or (input[aa]='.')         ) then
         begin
              result:=true;
              exit;
         end;
   end;
   if (input[aa-1]='-') and (input[aa]='>') then
   begin
     if ((Ord(input[aa+1])>=65)and(Ord(input[aa+1])<=90 ) or
         (Ord(input[aa+1])>=97)and(Ord(input[aa+1])<=122) or
         (Ord(input[aa+1])>=48)and(Ord(input[aa+1])<=57 ) or
         (input[aa]='_') or (input[aa]='.')         ) then
         begin
              result:=true;
              exit;
         end;
   end;
end;

function array2Pas(input:string):string;
var
   a,b,c,d,e:integer;
   tmp1:string;
   inVirg:boolean=false;
   inBracket:integer=0;
begin
     tmp1:=AnsiReplaceText(input,#13,' ');
     tmp1:=AnsiReplaceText(tmp1,#10,' ');
     a:=0;
     if (tmp1='') then
     begin
        result:=tmp1;
        exit;
     end;
     while (a <= length(input)) do
     begin
         inc (a);
         if (tmp1[a]='(') and (not inVirg) then inc(inBracket);
         if (tmp1[a]=')') and (not inVirg) then dec(inBracket);
         if (tmp1[a]='"')then
         begin
           if inVirg=true then
              inVirg:=false
           else
             inVirg:=true;
         end;
         if (not inVirg) then
         begin
              if (tmp1[a]='[') then
              begin
                   tmp1[a]:='[';
              end;
              if (tmp1[a]=']') then
              begin
                   if (a=length(tmp1)) then tmp1[a]:=']';
                   for b := a+1 to length(tmp1) do
                   begin
                        if (tmp1[b]<>' ') and (tmp1[b]<>'[') then
                        begin
                           tmp1[a]:=']';
                           a:=b;
                           break;
                        end;
                        if (tmp1[b]='[') then
                        begin
                             tmp1[a]:=',';
                             tmp1[b]:=' ';
                             a:=b;
                             break;
                        end;
                   end;
              end;
         end;
     end;
     result:=tmp1;
end;

function pointer2Pas(input:string):string;
begin
     result:=input;
     if length(input)>1 then
          if (pos('*',input)=1) then
          begin
               result:=midStr(input,2,length(input)-1)+'^';
          end;
end;

function kind(input:string):integer;
var
   a,b,c,d,e:integer;
   tmp1:string;
begin
     result:=0;
     input:=Trim(input);
     b:=length(input);
     if (b=0) then exit;
     a:=0;
     c:=0;
     while (a<b) do
     begin
          inc(a);
          if (c>0) and isAllowedChar(input,a)      then inc(c);
          if (c=0) and isAllowedFirstChar(input[a]) then inc(c);
          if (c<>a) then break;
     end;
     tmp1:=midStr(input,1,c);
     // Kind
     //     0=ND
     //     1=IF
     //     2=ELSE
     //     3=END
     //     4=FOR
     //     5=WHILE
     //     7=SWITCH
     //     8=DO
     //     9=whileOfDO
     //    10=Label
     //    11=Directive
     //    12=return
     if (tmp1='if')           then result:=1;
     if tmp1='else'           then result:=2;
     if tmp1='END-IForFOR'    then result:=3;
     if (tmp1='for')          then result:=4;
     if (tmp1='while')        then result:=5;
     if (tmp1='switch')       then result:=7;
     if (tmp1='do')           then result:=8;
     if (tmp1='whileOfDO')    then result:=9;
     if (tmp1='return')       then result:=12;
end;


function Variab(input:istSet):varSet;
var a,b,c,d,e:integer;
tmp1:string;
tmp2:string;
lungArr:integer;
aaa,bbb,ccc:boolean;
varType:string='';
varName:string='';
varValue:string='';
isArray:boolean=false;
isFunction:boolean=false;
arrayLen:string='';
inBracket:integer=0;
inVirg:boolean=false;
returnlen:integer=0;
found:boolean=false;
aProperty:string='';
asRef:boolean=false;
isPointer:boolean=false;
inBigBracket:boolean=false;
hasDirective:string='';
nn:integer=0;
begin
     setLength(result.varName,0);
     for a := 0 to length(input.ist) - 1 do
     begin
          tmp1:=AnsiReplaceText(input.ist[a],#13,' ');
          tmp1:=AnsiReplaceText(tmp1,#10,' ');
          aaa:=false;
          bbb:=false;
          ccc:=false;
          isArray:=false;
          arrayLen:='';
          varType:='';
          varValue:='';
          varName:='';
          arrayLen:='';
          hasDirective:='';
          inBracket:=0;
          inVirg:=false;
          found:=false;
          asRef:=false;
          nn:=1;
          for b := 1 to length(tmp1) do
          begin
               if isAllowedFirstChar(tmp1[b]) then aaa:=true;
               if (aaa=true) and (bbb=false) then
                  if not (isAllowedChar(tmp1,b)) and
                     (Ord(tmp1[b])<>32) then
                     begin
                          if (tmp1[b]='&') then asRef:=true else break;
                     end;
               if (aaa=true) and (bbb=false) and (Ord(tmp1[b])=32) then
               begin
                  tmp2:=Trim(midStr(tmp1,b,length(tmp1)-b+1));
                  if (pos('*=',tmp2)=1) then break;
                  if length(tmp2)>0  then
                     if isAllowedFirstChar(tmp2[1]) or
                        (tmp2[1]='&') or (tmp2[1]='*') then
                        begin
                          varType:=midStr(tmp1,nn,b-nn);
                          c:=b;
                          bbb:=true;
                        end;
               end;
               if (varType='return') or (varType='goto') then
               begin
                 varType:='';
                 found:=true;
                 break;
               end;
               if (varType='unsigned') or (varType='signed') or (varType='short') then
               begin
                 varType:='';
                 bbb:=false;
               end;
               if (varType='static') or (varType='auto') or (varType='inline') or (varType='const') then
               begin
                 hasDirective:=varType;
                 varType:='';
                 nn:=c;
                 bbb:=false;
               end;
               if (bbb=true) then
               begin
                    inBigBracket:=false;
                    inVirg:=false;
                    inBracket:=0;
                    tmp2:='';
                    for d := c + 1 to length(tmp1) do
                    begin
                         if (tmp1[d]='(') and (not inVirg) then inc(inBracket);
                         if (tmp1[d]=')') and (not inVirg) then dec(inBracket);
                         if (tmp1[d]='"')then
                         begin
                           if inVirg=true then
                              inVirg:=false
                           else
                             inVirg:=true;
                         end;
                         if (tmp1[d]='{') then inBigBracket:=true;
                         if (tmp1[d]='}') then inBigBracket:=false;
                         if (tmp1[d]<>',')or(inBigBracket=true)or((inVirg)or(inBracket>0)) then tmp2:=tmp2+tmp1[d];
                         if ((tmp1[d]=',')and (not inVirg) and (inBracket=0) and (inBigBracket=false) )or(d=length(tmp1)) then
                         begin
                             e:=pos('=',tmp2);
                             if (e=0)or((e>0)and(pos('(',tmp2)<e)and(pos('(',tmp2)>0)) then
                                varName:=Trim(tmp2)
                             else
                             begin
                                 varName:=Trim(midStr(tmp2,1,e-1));
                                if (e<length(tmp2))then varValue:=Trim(midStr(tmp2,e+1,length(tmp2)-e));
                             end;
                            if (pos('[',varName)>0) and (pos(']',varName)>0) then
                               isArray:=true
                            else
                               isArray:=false;
                            if (pos('(',varName)>0) and (pos(')',varName)>0) then
                               isFunction:=true
                            else
                               isFunction:=false;
                            if (pos('*',varName)=1) then isPointer:=true else isPointer:=false;
                            if (isFunction=true)then aProperty:=varName;
                            if (varName<>'') then
                            begin
                                returnlen:=length(result.varName)+1;
                                setLength(result.varName,returnlen);
                                setLength(result.varType,returnlen);
                                setLength(result.varValue,returnlen);
                                setLength(result.arrayLen,returnlen);
                                setLength(result.isArray,returnlen);
                                setLength(result.isFunction,returnlen);
                                setLength(result.order,returnlen);
                                setLength(result.aProperty,returnlen);
                                setLength(result.asRef,returnlen);
                                setLength(result.isPointer,returnlen);
                                setLength(result.hasDirective,returnlen);
                                result.varName[returnlen-1]:=varName;
                                result.varType[returnlen-1]:=Trim(varType);
                                result.varValue[returnlen-1]:=varValue;
                                result.arrayLen[returnlen-1]:='';
                                result.isArray[returnlen-1]:=isArray;
                                result.isFunction[returnlen-1]:=isFunction;
                                result.order[returnlen-1]:=a;
                                result.aProperty[returnlen-1]:=aProperty;
                                result.asRef[returnlen-1]:=asRef;
                                result.isPointer[returnlen-1]:=isPointer;
                                result.hasDirective[returnlen-1]:=hasDirective;
                                varName:='';
                                varValue:='';
                                arrayLen:='';
                                hasDirective:='';
                                isArray:=false;
                                tmp2:='';
                                found:=true;
                            end;
                            if (d=length(tmp1)) then aaa:=false;
                         end;
                    end;
               end;
               if (not aaa) then break;
          end;

          if (not found) then
          begin
              aaa:=false;
              bbb:=false;
              ccc:=false;
              isArray:=false;
              arrayLen:='';
              varType:='';
              varValue:='';
              varName:='';
              arrayLen:='';
              inBracket:=0;
              inVirg:=false;
              found:=false;
              for b := 1 to length(tmp1) do
              begin
                   if isAllowedFirstChar(tmp1[b]) then aaa:=true;
                   if (aaa=true) and (bbb=false) then
                      if (not isAllowedChar(tmp1,b)) and
                         (Ord(tmp1[b])<>32) and (tmp1[b]<>'=') and
                         (tmp1[b]<>'[') and (tmp1[b]<>']') then break;

                   if (aaa=true) and (bbb=false) and ((Ord(tmp1[b])=32) or (tmp1[b]='='))then
                   begin
                      tmp2:=Trim(midStr(tmp1,b,length(tmp1)-b+1));
                      if length(tmp2)>0  then
                         if (tmp2[1]='=') and (length(tmp2)>1) then
                            begin
                              varName:=Trim(midStr(tmp1,1,b-1));
                              varValue:=Trim(midStr(tmp2,2,length(tmp2)-1));
                              bbb:=true;
                            end;
                   end;
                   if (pos('[',varName)>0) and (pos(']',varName)>0) then
                      isArray:=true
                   else
                      isArray:=false;
                   if (pos('(',varName)>0) and (pos(')',varName)>0) then
                      isFunction:=true
                   else
                      isFunction:=false;
                   if (isFunction=true)then aProperty:=varName;
                   if (varValue<>'') and (varName<>'') then
                   begin
                     returnlen:=length(result.varName)+1;
                     setLength(result.varName,returnlen);
                     setLength(result.varType,returnlen);
                     setLength(result.varValue,returnlen);
                     setLength(result.arrayLen,returnlen);
                     setLength(result.isArray,returnlen);
                     setLength(result.isFunction,returnlen);
                     setLength(result.order,returnlen);
                     setLength(result.aProperty,returnlen);
                     setLength(result.asRef,returnlen);
                     setLength(result.isPointer,returnlen);
                     setLength(result.hasDirective,returnlen);
                     result.varName[returnlen-1]:=varName;
                     result.varType[returnlen-1]:=Trim(varType);
                     result.varValue[returnlen-1]:=varValue;
                     result.arrayLen[returnlen-1]:='';
                     result.isArray[returnlen-1]:=isArray;
                     result.isFunction[returnlen-1]:=isFunction;
                     result.order[returnlen-1]:=a;
                     result.aProperty[returnlen-1]:=aProperty;
                     result.asRef[returnlen-1]:=asRef;
                     result.isPointer[returnlen-1]:=isPointer;
                     result.hasDirective[returnlen-1]:=hasDirective;
                     varName:='';
                     varValue:='';
                     arrayLen:='';
                     hasDirective:='';
                     isArray:=false;
                     tmp2:='';
                     found:=true;
                   end;
              end;
            end;

     end;
end;

function IstFor(input:string):forStat;
var
   a,b,c,d,e,f:integer;
   varList:string='';
   condList:string='';
   opList:string='';
   inVirg:boolean=false;
   inBracket:integer=0;
   varIn:istSet;
   tmp1:string='';
   returnlen:integer=0;
begin
   a:=pos('for',input);
   f:=pos('{',input);
   if (a>0) then
   begin
     for b := a to length(input) do
     begin
          if (input[b]='(') then
          begin
              for c := b+1 to length(input) do
              begin
                  if input[c]=')' then
                  begin
                      for d := b+1 to c do
                      begin
                          if (input[d]=';') and (varList='') and (condList='') then
                          begin
                             varList:=Trim(MidStr(input,b+1,d-b-1));
                             varList:=AnsiReplaceText(varList,chr(13),'');
                             varList:=AnsiReplaceText(varList,chr(10),'');
                             e:=d;
                          end;
                          if (input[d]=';') and (varList<>'') and (condList='') then
                          begin
                             condList:=Trim(MidStr(input,e+1,d-e-1));
                             condList:=AnsiReplaceText(condList,chr(13),'');
                             condList:=AnsiReplaceText(condList,chr(10),'');
                             e:=d;
                          end;
                          if (input[d]=')') and (condList<>'') then
                          begin
                             opList:=Trim(MidStr(input,e+1,d-e-1));
                             opList:=AnsiReplaceText(opList,chr(13),'');
                             opList:=AnsiReplaceText(opList,chr(10),'');
                          end;
                      end;
                  end;
              end;
          end;
     end;
   end;
   result.varList :=varList;
   result.condList:=condList;
   setLength(varIn.ist,0);
   setLength(varIn.kind,0);
   for a := 1 to length(varList) do
   begin
       if (varList[a]='(') and (not inVirg) then inc(inBracket);
       if (varList[a]=')') and (not inVirg) then dec(inBracket);
       if (varList[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (varList[a]<>',')or (inBracket>0) or (inVirg=true) then tmp1:=tmp1+varList[a];
       if (inBracket=0) and (not inVirg) then
       begin
         if (varList[a]=',')or(a=length(varList)) then
            if (tmp1<>'') then
            begin
              returnlen:=length(varIn.ist)+1;
              setLength(varIn.ist,returnlen);
              setLength(varIn.kind,returnlen);
              varIn.ist[returnlen-1]:=tmp1;
              varIn.kind[returnlen-1]:=0;
              tmp1:='';
            end;
       end;
   end;
   varList:=varList+';';
   result.param:=variab(varIn);
   result.auxVariab:='A'+midStr(MD5Print(MD5String(input)),1,9);
   inVirg:=false;
   inBracket:=0;
   for a := 1 to length(opList) do
   begin
       if (opList[a]='(') and (not inVirg) then inc(inBracket);
       if (opList[a]=')') and (not inVirg) then dec(inBracket);
       if (opList[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (inBracket=0) and (not inVirg) and (opList[a]=',') then opList[a]:=';';
   end;
   result.oplist:=opList+';';
end;

function extractParamFunct(input:string):varSet;
var
   a,b,c,d,e:integer;
   tmp1:string='';
   inVirg:boolean=false;
   inBracket:integer=0;
   aSet:istSet;
   returnlen:integer;
begin
     setlength(result.varName,0);
     b:=pos('(',input);
     for a := b to length(input) do
     begin
          if (input[a]='"')then
          begin
            if inVirg=true then
               inVirg:=false
            else
              inVirg:=true;
          end;
          if (input[a]='(') and (not inVirg) then inc(inBracket);
          if (b=a) then c:=a;
          if (not inVirg) and ((input[a]=',') or (input[a]=')')) and (inBracket=1) then
          begin
               tmp1:=Trim(midStr(input,c+1,a-c-1));
               if (tmp1<>'') then
               begin
                 returnlen:=length(aSet.ist)+1;
                 setLength(aSet.ist,returnlen);
                 aSet.ist[returnlen-1]:=tmp1;
                 c:=a;
               end;
          end;
          if (input[a]=')') and (not inVirg) then dec(inBracket);
     end;
     result:=variab(aSet);
end;

function ists(input:string):istSet;
var
   a,b,c,d,e:integer;
   inBracket:integer=0;
   inVirg:boolean=false;
   tmp1:string='';
   tmp2:string='';
   tmpFOR:istSet;
   found:boolean=false;
begin
     setLength(result.ist,0);
     setLength(result.kind,0);
     a:=0;
     input:=Trim(AnsiReplaceText(input,chr(9),''))+' ';
     b:=length(input);
     while (a<b) do
     begin
       inc(a);
       if (input[a]='(') and (not inVirg) then inc(inBracket);
       if (input[a]=')') and (not inVirg) then dec(inBracket);
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (inBracket=0) and (Trim(tmp1)='else') then
       begin
         SetLength(result.ist,length(result.ist)+1);
         result.ist[length(result.ist)-1]:=Trim(tmp1);
         SetLength(result.kind,length(result.kind)+1);
         result.kind[length(result.kind)-1]:=kind(Trim(tmp1));
         tmp1:='';
       end;
       tmp2:=Trim(tmp1);
       if (inBracket=0)and (not inVirg) and (tmp2<>'') and (input[a]=#13) then
       begin
           if (Tmp2[1]='#') then
           begin
             SetLength(result.ist,length(result.ist)+1);
             result.ist[length(result.ist)-1]:=tmp2;
             SetLength(result.kind,length(result.kind)+1);
             result.kind[length(result.kind)-1]:=11;
             tmp1:='';
           end;
       end;
       if (inBracket=0)and (not inVirg) and (input[a]=':')and (tmp1<>'') then
       begin
            found:=false;
            for e := 1 to length(Trim(tmp1)) do
            begin
              if (not isAllowedFirstChar(tmp1[e])) and
                 (Ord(tmp1[e])<>32)and(tmp1[e]<>':') then
                 found:=true;
            end;
            if (not found) then
            begin
              SetLength(result.ist,length(result.ist)+1);
              result.ist[length(result.ist)-1]:=Trim(tmp1);
              SetLength(result.kind,length(result.kind)+1);
              result.kind[length(result.kind)-1]:=10;
              inc(a);
              tmp1:='';
            end;
       end;
       if (inBracket=0)and (not inVirg) and ((input[a]=';')or((input[a]='{') and (prevSymbol(input,a)<>'=')) or(input[a]='}'))and(a<b) then
       begin
         if (Trim(tmp1)<>'') then
         begin
           if (input[a]='}') and (nextSymbol(input,a)=';') then
           begin
              a:=nextSymbolP(input,a);
              tmp1:=tmp1+'}';
           end;
           SetLength(result.ist,length(result.ist)+1);
           result.ist[length(result.ist)-1]:=Trim(tmp1);
           SetLength(result.kind,length(result.kind)+1);
           result.kind[length(result.kind)-1]:=kind(Trim(tmp1));
           if (result.kind[length(result.kind)-1]=4) then
           begin
                tmpFOR:=ists(IstFor(Trim(tmp1)).oplist);
           end;
           for e := 0 to length(tmpFOR.ist)-1 do
           begin
                SetLength(result.ist,length(result.ist)+1);
                SetLength(result.kind,length(result.kind)+1);
                result.ist[length(result.ist)-1]:=tmpFor.ist[e];
                result.kind[length(result.ist)-1]:=6;
           end;
           tmp1:='';
         end;
         if (input[a]='}') and (nextSymbol(input,a)<>';') then
         begin
            SetLength(result.ist,length(result.ist)+1);
            result.ist[length(result.ist)-1]:='END-IForFOR';
            SetLength(result.kind,length(result.kind)+1);
            result.kind[length(result.kind)-1]:=3;
         end;
         inc(a);
         if (a>b) then exit;
       end;
       if ((input[a]='{')or(input[a]='}')) then
       begin
          if (invirg or (inBracket<>0)) or (prevSymbol(input,a)='=') then tmp1:=tmp1+input[a]
       end
       else
           tmp1:=tmp1+input[a];
       tmp1:=AnsiReplaceText(tmp1,#13,' ');
       tmp1:=AnsiReplaceText(tmp1,#10,' ');
     end;
end;

function noComment(input:string):string;
var
   a:integer;
   inComm1:boolean=false;
   inComm2:boolean=false;
   inVirg:boolean=false;
begin
   result:='';
   for a:= 1 to length(input) do
   begin
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (a<length(input))then
       begin
          if (input[a]='/') and (input[a+1]='/') and not inVirg then inComm1:=true;
          if (input[a]='/') and (input[a+1]='*') and not inVirg then inComm2:=true;
       end;
       if (inComm1=true) and (input[a]=#13) then inComm1:=false;
       if (not inComm1) and (not inComm2) then result:=result+input[a];
       if (a>1) then
          if (input[a]='/') and (input[a-1]='*') and not inVirg then inComm2:=false;
   end;
end;

function logicOperator(input:string):string;
var
   a,b,c,d,e,f:integer;
   inVirg:boolean;
   tmp1:string='';
   brackOpen:integer=0;
   inBracket:integer;
   opC:array [1..4] of array [1..2] of string;
   noMod:boolean;
   opFound:boolean;
begin
     opC[1,1]:='&&';
     opC[1,2]:='and';
     opC[2,1]:='||';
     opC[2,2]:='or';
     opC[3,1]:='==';
     opC[3,2]:='=';
     opC[4,1]:='!=';
     opC[4,2]:='<>';
     a:=0;
     while (a<length(input)) do
     begin
       inc(a);
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (not inVirg) then
       begin
         if (brackOpen>0) and (
            (input[a]=',') or (input[a]=')') or
            (input[a]='&') or (input[a]='|')  ) then
            begin
              for e := 1 to brackOpen do tmp1:=tmp1+')';
              brackOpen:=0;
            end;
            noMod:=true;
            for d := 1 to length(opC) do
            begin
              opFound:=false;
              if length(opC[d])=2 then
                 if (input[a]=midStr(opC[d,1],1,1)) and (input[a+1]=midStr(opC[d,1],2,1)) then opFound:=true;
              if (opFound=true) then
              begin
                inBracket:=0;
                for b := 0 to length(tmp1)-1 do
                begin
                  c := length(tmp1) - b;
                  if (tmp1[c]=')') then dec(inBracket);
                  if (inBracket=0)and((tmp1[c]=',') or (tmp1[c]='(')or(tmp1[c]='&')or(tmp1[c]='!')or(tmp1[c]='|')) then
                  begin
                     insert('(',tmp1,c+1);
                     break;
                  end;
                  if (inBracket=0)and(c=1) then
                  begin
                    insert('(',tmp1,c);
                    break;
                  end;
                  if (tmp1[c]='(') then inc(inBracket);
                end;
                tmp1:=tmp1+')'+opC[d,2]+'(';
                noMod:=false;
                brackOpen:=brackOpen+1;
                inc(a);
              end
            end;
           if input[a]='%' then
           begin
                if (a>1) and (a<length(input)) then
                begin
                  if (input[a-1]<>' ')then tmp1:=tmp1+' ';
                  tmp1:=tmp1+'mod';
                  if (input[a+1]<>' ')then tmp1:=tmp1+' ';
                  noMod:=false;
                end;
           end;
            if input[a]='!' then
            begin
                 tmp1:=tmp1+' not(';
                 brackOpen:=brackOpen+1;
                 noMod:=false;
            end;

            if (noMod=true) then
                tmp1:=tmp1+input[a];
       end
       else tmp1:=tmp1+input[a];
     end;

     if (brackOpen>0) and (a=length(input)) then tmp1:=tmp1+')';
     result:=tmp1;
end;


function mathOp(input:string):string;
var
   a,b,c,d,e,f:integer;
   varName:string;
   opType:integer=0;
begin
   b:=length(input);
   if (b>2) then
   begin
        if (input[b]='+')and(input[b-1]='+') then opType:=1;
        if (input[b]='-')and(input[b-1]='-') then opType:=2;
        if (opType<>0) then
        begin
          a:=0;
          c:=0;
          while (a<b-2) do
          begin
            inc(a);
            if (c>0) and
               (isAllowedChar(input,a) or
               (input[a]='[') or (input[a]=']') ) then inc(c);
            if (c=0) and
               (isAllowedFirstChar(input[a])) then inc(c);
            if (c<>a) then
            begin
              result:=input;
              exit;
            end;
          end;
          varName:=midStr(input,1,b-2);
          if (opType=1) then result:='inc('+varName+')';
          if (opType=2) then result:='dec('+varName+')';
          exit;
        end;
        if (input[1]='+')and(input[2]='+') then opType:=1;
        if (input[1]='-')and(input[2]='-') then opType:=2;
        if (opType<>0) then
        begin
          a:=2;
          c:=0;
          while (a<b) do
          begin
            inc(a);
            if (c>0) and
               (isAllowedChar(input,a) or
               (input[a]='[') or (input[a]=']') ) then inc(c);
            if (c=0) and
               (isAllowedFirstChar(input[a])) then inc(c);
            if (c+2<>a) then
            begin
              result:=input;
              exit;
            end;
          end;
          varName:=midStr(input,3,b-2);
          if (opType=1) then result:='inc('+varName+')';
          if (opType=2) then result:='dec('+varName+')';
          exit;
        end;
   end;
   if (opType=0) then result:=input;
end;

function refCheck(input:string):string;
var
   a,b,c,d,e:integer;
begin
   if length(input)>2 then
   begin
        if input[1]='&' then
        begin
           result:='var '+midStr(input,2,length(input)-1);
           result:=AnsiReplaceText(result,'  ',' ');
        end
        else
           result:=input;
   end
   else result:=input;
end;

function typeConvert(input:string):string;
begin
   result:=input;
   if input='int' then result:='integer';
   if input='unsigned' then result:='cardinal';
end;

function pointerConvert(input:string):string;
begin
   result:=input;
   if length(input)=1 then
      result:='p'+AnsiUpperCase(input);
   if length(input)>1 then
      result:='p'+AnsiUpperCase(input[1])+midStr(input,2,length(input)-1);
   if input='int' then result:='pInteger';
   if input='string' then result:='pString';
   if input='double' then result:='pDouble';
end;

function arrayDeclaration(input:string):string;
var
   a,b,c,d,e:integer;
   inSquare:boolean=false;
   value:array of string;
begin
     setLength(value,0);
     e:=length(value);
     result:='';
     b:=0;
     for a := 1 to length(input) do
     begin
          if (input[a]=']') then inSquare:=false;
          if (inSquare=true) then
          begin
            value[b-1]:=value[b-1]+input[a];
            value[b-1]:=Trim(value[b-1]);
          end;
          if (input[a]='[') then
          begin
             inSquare:=true;
             inc(b);
             setLength(value,b);
             value[b-1]:='';
          end;
     end;
     try
       for b:= 0 to length(value)-1 do
       begin
           if (value[b]<>'') then
           begin
             c:=strToInt(value[b])-1;
             result:=result+'array [0..'+inttostr(c)+'] of ';
           end
           else result:=result+'array of ';
       end;
     except
       on E:Exception do
          result:='';
     end;
end;

function removeSquares(input:string):string;
var
   a,b,c,d,e:integer;
begin
   a:=pos('[',input);
   if (a>0) then
      result:=midStr(input,1,a-1)
   else
      result:=input;
end;

function nextWord(var input:string;aa:integer):string;
var
   a,b,c,d,e:integer;
begin
   result:='';
   for a := aa+1 to length(input) do
   begin
        if not(isAllowedChar(input,a))and(input[a]<>#32)and(input[a]<>#13)and (input[a]<>#10)and (input[a]<>#9)  then
           exit;
        if (result<>'') and (input[a]=#32) then exit;
        if (input[a]<>#32)and(input[a]<>#13)and (input[a]<>#10)and (input[a]<>#9) then
            result:=result+input[a];
   end;
end;

function preProcess(input:string):string;
var
   a,b,c,d,e:integer;
   inVirg:boolean=false;
   inBracket:integer=0;
   inFOR1:boolean=false;
   inFOR2:boolean=false;
   tmp1:string='';
   tmp2:string='';
   tmp3:string='';
   inDO1,inDO2,inDO3:boolean;
   inELSE:boolean=false;
   inVirg2:boolean=false;
   inBracket2:integer=0;
   count:array of integer;
   toBrace:boolean=false;
begin

   inVirg:=false;
   for a := 1 to length(input) do
   begin
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (a < length(input)) then
       begin
         if (isAllowedChar(input,a))   and (input[a+1]='(') then
         begin
           insert(' ',input,a+1);
         end;
         if (isAllowedChar(input,a+1)) and (input[a]=')')   then
         begin
           insert(' ',input,a+1);
         end;
       end;
   end;

   for a := 1 to length(input) do
   begin
       result:=result+input[a];
       if (inFOR1) and ((input[a]<>' ') and (input[a]<>'(') and (input[a]<>#9) and (input[a]<>#10) and (input[a]<>#13)) then inFOR1:=false;
       if (input[a]='(') and (not inVirg) then inc(inBracket);
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (not inVirg) and (inBracket=0) then
       begin
         if input[a]=';' then
            result:=result+' ';
         if (a>6) then
         begin
           if (input[a]='r') and (input[a-1]='o') and (input[a-2]='f') then
             if not (isAllowedChar(input,a-3)) then inFOR1:=true;
           if (input[a]='f') and (input[a-1]='i')then
             if not (isAllowedChar(input,a-2)) then inFOR1:=true;
           if (input[a]='e') and (input[a-1]='l') and (input[a-2]='i') and (input[a-3]='h') and (input[a-4]='w') then
             if not (isAllowedChar(input,a-5)) then inFOR1:=true;
           if (input[a]='e') and (input[a-1]='s') and (input[a-2]='l') and (input[a-3]='e') then
             if not (isAllowedChar(input,a-4)) then inElse:=true;
           if (input[a]='o') and (input[a-1]='d') then
             if not (isAllowedChar(input,a-2)) then inElse:=true;
           if (a<length(input)) and ((inELSE=true)or(inFOR1=true))then
           begin
             if (isAllowedChar(input,a+1)) then
             begin
               inELSE:=false;
               inFOR1:=false;
             end;
           end;
         end;
         if (inELSE)or(inFOR1) then
         begin
           inVirg2:=false;
           for b := a downto 1 do
           begin
               if (input[b]='"')then
               begin
                 if inVirg=true then
                    inVirg:=false
                 else
                   inVirg:=true;
               end;
              if (input[b]=#13) or (input[b]=#10) then
              begin
                   break;
              end;
              if (inVirg2=false) and (input[b]='#') then
              begin
                   inELSE:=false;
                   inFOR1:=false;
                   break;
              end;
           end;
         end;
       end;
      if (length(count)=0) and (inBracket=0) and (input[a]=';') and (not inVirg) then
      begin
        inFOR1:=false;
        inFOR2:=false;
        inELSE:=false;
      end;
      if (inFOR1) and (inBracket=1) then inFOR2:=true;
       if (inFOR2) and (inBracket=0) then toBrace:=True;
       if toBrace then
       begin
         if (nextSymbol(input,a)<>'{') and (input[a]<>'{') then
         begin
             insert(' { '+#13+#10,result,length(result));
             toBrace:=false;
             setLength(count,length(count)+1);
             count[length(count)-1]:=0;
             inFOR1:=false;
             inFOR2:=false;
             inELSE:=false;
          end;
          if (input[a]='{') then
          begin
            if (length(count)>0) then
               inc(count[length(count)-1]);
            inFOR1:=false;
            inFOR2:=false;
            inELSE:=false;
            toBrace:=false;
          end;
       end;
       tmp3:=midStr(input,a-25,25);
       if (input[a]='}') and (not inVirg) then
       begin
         if (length(count)>0) then
         begin
              dec(count[length(count)-1]);
         end;
       end;
       if (not inVirg) and (inBracket=0) and (  ((input[a]=';') or  (input[a]='}')) and (nextWord(input,a)<>'else') ) then
       begin
         for b := length(count)-1 downto 0 do
         begin
           if (count[b]=0) then
           begin
               result:=result+#13+#10+' } ';
               setLength(count,length(count)-1);
           end
           else
           begin
             break;
           end;
         end;
       end
       else
       begin
           if (not inVirg) and (inBracket=0) and ((input[a]=';') or ( (input[a]='}') and (nextWord(input,a)<>'else') )) then
           begin
             if (length(count)>0) then
             begin
               if (count[length(count)-1]=0) then
               begin
                   result:=result+#13+#10+' } ';
                   setLength(count,length(count)-1);
               end;
             end;
           end;
       end;
       if (inELSE=true) then inFOR2:=true;
       if (input[a]=')') and (not inVirg) then dec(inBracket);
   end;
   input:=result;
   result:='';
   for a := 1 to length(input) do
   begin
       result:=result+input[a];
       if (input[a]='(') and (not inVirg) then inc(inBracket);
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (not inVirg) and (inBracket=0) then
       begin
           b:=length(result);
           if (b>6) then
           begin
             tmp1:=midStr(result,b-4,5);
             if (tmp1 ='while') then
             begin
               inDO1:=false;
               for c := b-5 downto 1 do
               begin
                   if result[c]='}' then
                   begin
                     inDO1:=true;
                     break;
                   end;
                   if (isAllowedChar(result,c)) then
                   begin
                     inDO1:=false;
                     break;
                   end;
               end;
               if (inDO1=true) then
               begin
                 inVirg2:=false;
                 tmp2:=midStr(result,length(result)-100,150);
                 inBracket2:=0;
                 inDO2:=false;
                 inDO3:=false;
                 for c := a to length(input) do
                 begin
                     if (input[c]='(') and (not inVirg2) then inc(inBracket2);
                     if (input[c]='"')then
                     begin
                       if inVirg2=true then
                          inVirg2:=false
                       else
                         inVirg2:=true;
                     end;
                     tmp2:=midStr(input,c-100,150);

                     if (inBracket2>0) then inDO2:=true;
                     if (input[c]=')') and (not inVirg2) then dec(inBracket2);
                     if (inDO2=true)and(inBracket2=0) then inDO3:=true;
                     if (inDO3=true)and(input[c]='{') then
                     begin
                       inDO1:=false;
                       inDO2:=false;
                       inDO3:=false;
                       break;
                     end;
                     if (inDO3=true)and(input[c]=';') then
                     begin
                          result:=result+'OfDO';
                          break;
                     end;
                 end;
               end;
             end;
           end;
       end;
       if (input[a]=')') and (not inVirg) then dec(inBracket);
   end;
end;

function postProcess(input:string):string;
var
   a,b,c,d,e:integer;
   tmp1:string='';
   inVirg:boolean=false;
   noMod:boolean=true;
begin
   result:='';
   if (input='') then
   begin
        result:=input;
        exit;
   end;
   a:=1;
   tmp1:='';
   noMod:=true;
   while (a<=length(input)) do
   begin
        if (input[a]<>#13) then
        begin
          if (input[a]='"')then
          begin
            if inVirg=true then
               inVirg:=false
            else
              inVirg:=true;
          end;
          if (input[a]='"') then
          begin
               tmp1:=tmp1+#39;
               noMod:=false;
          end;
          if (inVirg=true) and (input[a]=#39) then
          begin
            tmp1:=tmp1+#39+'+#39+'+#39;
            noMod:=false;
          end;
          if (inVirg=true) and (input[a]='\') and (a<length(input)) then
          begin
               if (input[a+1]='n') then
               begin
                 tmp1:=tmp1+#39+'+#13+'+#39;
                 noMod:=false;
                 inc(a);
               end;
          end;
          if (inVirg=false) and (input[a]='-') and (a<length(input)) then
          begin
               if (input[a+1]='>') then
               begin
                 tmp1:=tmp1+'^.';
                 noMod:=false;
                 inc(a);
               end;
          end;
          if (noMod=true) then tmp1:=tmp1+input[a];
          noMod:=true;
        end
        else
        begin
           result:=result+tmp1+#13;
           tmp1:='';
        end;
        inc(a);
   end;
end;

function extractFromFunct(functName:string;input:string):string;
var
   a,b,c,d,e:integer;
   tmp1:string='';
   tmp2:string='';
   inBracket:integer=0;
   inVirg:boolean=false;
begin
   result:='';
   input:=trim(input);
   a:=pos(functName,input);
   d:=length(functName);
   tmp1:=midStr(input,a,length(input)-a+1);
   b:=pos('(',tmp1);
   if (a>1) then
   begin
       if isAllowedChar(input,a-1) then exit;
   end;
   if (b>0) then
   begin
     for c:= d+1 to b do
     begin
          if isAllowedChar(tmp1,c) then
          begin
            result:='';
            exit;
          end;
     end;
   end;
   inBracket:=0;
   inVirg:=false;
   tmp2:='';
   for c:= d+1 to length(tmp1) do
   begin
        if (tmp1[c]='"')then
        begin
          if inVirg=true then
             inVirg:=false
          else
            inVirg:=true;
        end;
        if (tmp1[c]='(') and (not inVirg) then inc(inBracket);
        if (inBracket=1) and (tmp1[c]=')') and (not inVirg) then break;
        if (tmp1[c]=')') and (not inVirg) then dec(inBracket);
        if (inBracket>0) then tmp2:=tmp2+tmp1[c];
   end;
   tmp2:=midStr(tmp2,2,length(tmp2)-1);
   result:=tmp2;
end;

function addMallocComment(varName,varValue:string;xx:varSet):string;
var
   a,b,c,d,e:integer;
   varType:string='';
   tmp1:string='';
   tmp2:string='';
   newVar:string;
begin
   result:='';
   if (varName='') then exit;
   tmp1:=extractFromFunct('malloc',varValue);
   tmp2:=extractFromFunct('sizeof',varValue);
   for a := 0 to length(xx.varName)-1 do
   begin
        if (varName=xx.varName[a]) then
        begin
           varType:=xx.varType[a];
           break;
        end;
   end;
   newVar:=varName;
   if varName<>'' then
      if varName[1]='*' then newVar:=midStr(varName,2,length(varName)-1);
   if (tmp1<>'') and (newVar<>varName) then
      result:=#9+'// GetMem( '+newVar+' , ( '+AnsiReplaceText(tmp1,tmp2,varType)+' ) );';
   if (tmp1<>'') and (newVar=varName) then
      result:=#9+'// GetMem( '+newVar+' , ( '+tmp1+' ) );';
end;

procedure addSymb(var xx:varSet;varName,varType:string);
var
   a,b,c,d,e:integer;
   found:boolean;
   returnlen:integer;
begin
   found:=false;
   for a := 0 to length(xx.varName)-1 do
   begin
        if (xx.varName[a]=varName) then found:=true;
   end;
   if (found=true) then
   begin
      exit;
   end
   else
   begin
     returnlen:=length(xx.varName)+1;
     setLength(xx.varName,returnlen);
     setLength(xx.varType,returnlen);
     xx.varName[returnlen-1]:=varName;
     xx.varType[returnlen-1]:=vartype;
   end;
end;

function adjComplex(input:string):string;
var
   a,b,c,d,e:integer;
   inVirg:boolean=false;
   opC:array[1..2] of array[1..2] of string;
   brackOpen:integer=0;
   inBracket:integer=0;
   tmp1:string='';
   opFound:boolean=false;
   noMod:boolean=true;
   a1:string='';
   a2:string='';
   a3:string='';
begin
opC[1,1]:='--';
opC[1,2]:='ss';
opC[2,1]:='++';
opC[2,2]:='pp';
a:=0;
while (a<length(input)) do
begin
  inc(a);
  if (input[a]='"')then
  begin
    if inVirg=true then
       inVirg:=false
    else
      inVirg:=true;
  end;
  if (not inVirg) then
  begin
    if (brackOpen>0) and (not isAllowedChar(input,a)) then
       begin
         for e := 1 to brackOpen do tmp1:=tmp1+a3;
         brackOpen:=0;
       end;
       noMod:=true;
       for d := 1 to length(opC) do
       begin
         opFound:=false;
         if length(opC[d])=2 then
            if (input[a]=midStr(opC[d,1],1,1)) and (input[a+1]=midStr(opC[d,1],2,1)) then opFound:=true;
            if (opFound)then
            begin
                if (isAllowedChar(input,a-1)) then
                begin
                    a1:=opC[d,2]+'_(';
                    a2:=')';
                    a3:='';
                end
                else
                if (a<length(input)-length(opC[d])+1) then
                  if (isAllowedFirstChar(input[a+length(opC[d,1])])) then
                  begin
                      a1:='';
                      a2:='_'+opC[d,2]+'(';
                      a3:=')';
                  end;
            end;

         if (opFound=true) then
         begin
           inBracket:=0;
           for b := 0 to length(tmp1)-1 do
           begin
             c := length(tmp1) - b;
             if (tmp1[c]=')') then dec(inBracket);
             if (not isAllowedChar(tmp1,c)) then
             begin
                insert(a1,tmp1,c+1);
                break;
             end;
             if (inBracket=0)and(c=1) then
             begin
               insert(a1,tmp1,c);
               break;
             end;
             if (tmp1[c]='(') then inc(inBracket);
           end;
           tmp1:=tmp1+a2;
           noMod:=false;
           brackOpen:=brackOpen+1;
           inc(a);
         end
       end;
       if (noMod=true) then
           tmp1:=tmp1+input[a];
  end
  else tmp1:=tmp1+input[a];
end;

if (brackOpen>0) and (a=length(input)) then tmp1:=tmp1+a3;
result:=tmp1;
end;

function aAddAuxFunct():string;
begin
    result:='// These function are required to emulate pre and postfix operators //'+#13;
    result:=result+'function pp_(var x: integer): integer; inline;'+#13;
    result:=result+'begin'+#13;
    result:=result+#9+'Result := x;'+#13;
    result:=result+#9+'Inc(x);'+#13;
    result:=result+#9+'end;'+#13;
    result:=result+'function _pp(var x: integer): integer; inline;'+#13;
    result:=result+'begin'+#13;
    result:=result+#9+'Inc(x);'+#13;
    result:=result+#9+'Result := x;'+#13;
    result:=result+'function ss_(var x: integer): integer; inline;'+#13;
    result:=result+'begin'+#13;
    result:=result+#9+'Result := x;'+#13;
    result:=result+#9+'Dec(x);'+#13;
    result:=result+'end;'+#13;
    result:=result+'function _ss(var x: integer): integer; inline;'+#13;
    result:=result+'begin'+#13;
    result:=result+#9+'Dec(x);'+#13;
    result:=result+#9+'Result := x;'+#13;
    result:=result+'end;'+#13;
    result:=result+'//----------END of auxiliary functions--------//';
end;

function conditionParser(input:string):prePostRecord;
var
   a,b,c,d,e:integer;
   tmp1:string='';
   tmp2:array of string;
   tmp3:string='';
   aa:array of integer;
   pre:array of byte;
   post:array of byte;
   isComplex:boolean=false;
   inVirg:boolean=false;
begin
   input:='('+AnsiReplaceText(input,' ','')+')';
   input:=AnsiReplaceText(input,#10,'');
   input:=AnsiReplaceText(input,#13,'');
   setLength(result.pre,0);
   setLength(result.post,0);
   result.condition:=input;
   result.isComplex:=isComplex;
   result.isNormal:=true;
   if (pos('++',input)=0) and (pos('--',input)=0) then exit;
   result.isNormal:=false;
   b:=length(input);
   tmp1:='';
   setLength(tmp2,0);
   setLength(aa  ,0);
   setLength(pre ,0);
   setLength(post,0);
   for a := 1 to b do
   begin
        if (input[a]='"')then
        begin
          if inVirg=true then
             inVirg:=false
          else
            inVirg:=true;
        end;
        if (not inVirg) then
        begin
            if (isAllowedChar(input,a)      ) and (tmp1<>'') then tmp1:=tmp1+input[a];
            if (isAllowedFirstChar(input[a])) and (tmp1='' ) then tmp1:=tmp1+input[a];
            if (not (isAllowedChar(input,a))) and (tmp1<>'') then
            begin
               d:=length(tmp2);
               setLength(tmp2,d+1);
               setLength(aa  ,d+1);
               setLength(pre ,d+1);
               setLength(post,d+1);
               tmp2[d]:=tmp1;
               aa  [d]:=0;
               pre [d]:=0;
               post[d]:=0;
               e:=length(tmp1);
               if (a>e+2) then
               begin
                  c:=a-e-1;
                  if (input[c]='-') and (input[c-1]='-') then pre[d]:=1;
                  if (input[c]='+') and (input[c-1]='+') then pre[d]:=2;
               end;
               if (a<=b-1) then
               begin
                  c:=a;
                  if (input[c]='-') and (input[c+1]='-') then post[d]:=1;
                  if (input[c]='+') and (input[c+1]='+') then post[d]:=2;
               end;
               tmp1:='';
            end;
        end;
   end;
   if (tmp1<>'') then
   begin
     d:=length(tmp2);
     setLength(tmp2,d+1);
     setLength(aa  ,d+1);
     setLength(pre ,d+1);
     setLength(post,d+1);
     tmp2[d]:=tmp1;
     aa  [d]:=0;
     pre [d]:=0;
     post[d]:=0;
     e:=length(tmp1);
     if (a>e+2) then
     begin
        c:=a-e-1;
        if (input[c]='-') and (input[c-1]='-') then pre[d]:=1;
        if (input[c]='+') and (input[c-1]='+') then pre[d]:=2;
     end;
      tmp1:='';
   end;

   for a := 0 to length(tmp2)-1 do
   begin
     if (aa[a]<0) then continue;
     if (aa[a]=0) then aa[a]:=1;
     for b := a+1 to length(tmp2)-1 do
     begin
          if (tmp2[a]=tmp2[b]) and (aa[b]=0) then
          begin
            inc(aa[a]);
            if (pre[b]>0) or (post[b]>0) or (pre[a]>0) or (post[a]>0) then isComplex:=true;
            aa[b]:=-1;
          end;
     end;
   end;
   result.isComplex:=isComplex;
   if not isComplex then
   begin
     for a := 0 to length(tmp2)-1 do
     begin
       if (pre[a]<>0) then
       begin
         d:=length(result.pre);
         setLength(result.pre,d+1);
         if (pre[a]=1) then result.pre[d]:='dec('+tmp2[a]+');';
         if (pre[a]=2) then result.pre[d]:='inc('+tmp2[a]+');';
       end;
       if (post[a]<>0) then
       begin
         d:=length(result.post);
         setLength(result.post,d+1);
         if (post[a]=1) then result.post[d]:='dec('+tmp2[a]+');';
         if (post[a]=2) then result.post[d]:='inc('+tmp2[a]+');';
       end;
     end;
     b:=length(input);
     a:=1;
     result.condition:='';
     while (a<=b) do
     begin
       if (input[a]='"')then
       begin
         if inVirg=true then
            inVirg:=false
         else
           inVirg:=true;
       end;
       if (not inVirg) then
       begin
          if (a<b) then
             if ((input[a]='+') and (input[a+1]='+')) or ((input[a]='-') and (input[a+1]='-')) then
             begin
                inc(a)
             end
             else
             begin
                result.condition:=result.condition+input[a];
             end;
          if (a=b) then
             if not(((input[a-1]='+') and (input[a]='+')) or ((input[a-1]='-') and (input[a]='-'))) then
                result.condition:=result.condition+input[a];
       end
       else
           result.condition:=result.condition+input[a];
       inc(a);
     end;
   end;
   if (isComplex) then
   begin
       result.condition:=adjComplex(input);
   end;
end;

function convertCtoPAS(input:string):string;
var
aa,bb,cc:string;
a,b,c,d,e:integer;
zz,yy:varSet;
symbTable:varSet;
ww:istSet;
vv:forStat;
nn:boolean;
found:boolean=false;
found1:boolean=false;
functName:string;
aproperty:string;
inTab:integer=0;
nextFunctPos:integer;
tmp1:string='';
tmpCond:prePostRecord;
addAuxFunct:boolean=false;
begin
   result:='';
//   result:=preProcess(noComment(input));
//   exit;
   ww:=ists(preProcess(noComment(input)));
   zz:=Variab(ww);
   for a := 0 to length(zz.varName)-1 do
   begin
       inTab:=0;
       nn:=zz.isFunction[a];
       cc:=zz.varName[a];
       if (zz.isFunction[a]) then
       begin
          nextFunctPos:=0;
          if (a<length(zz.varName)) then
          begin
            for b := a+1 to length(zz.varName)-1 do
            begin
               if (zz.isFunction[b]=true) then
               begin
                 nextFunctPos:=zz.order[b];
                 break;
               end;
            end;
          end;
          if (nextFunctPos=0) then nextFunctPos:=length(ww.ist)-1;
          functName:=midStr(zz.varName[a],1,pos('(',zz.varName[a])-1);
          if (zz.varType[a]<>'void') then result:=result+#13+'function ' +functName+'(';
          if (zz.varType[a]= 'void') then result:=result+#13+'procedure '+functName+'(';
          yy:=extractParamFunct(zz.varName[a]);
          setLength(symbTable.varName,0);
          setLength(symbTable.varType,0);
          for b := 0 to length(yy.varName)-1 do
          begin
              if (not yy.isPointer[b]) then result:=result+#13+refCheck(removeSquares(yy.varName[b]))+':'+arrayDeclaration(yy.varName[b])+typeConvert(yy.varType[b]);
              if (    yy.isPointer[b]) then result:=result+#13+refCheck(removeSquares(midStr(yy.varName[b],2,length(yy.varName[b])-1)))+':'+pointerConvert(yy.varType[b]);
              if (b<length(yy.varName)-1) then result:=result+';';
              addSymb(symbTable,yy.varName[b],yy.varType[b]);
          end;
          if (zz.varType[a]<>'void') then result:=result+#13+'):'+typeConvert(zz.varType[a])+';';
          if (zz.varType[a]= 'void') then result:=result+#13+');'+#13;
          if (zz.hasDirective[a]<>'') then result := result +' '+ zz.hasDirective[a]+';';
          result := result +#13;
          d:=0;
          aproperty:=zz.aProperty[a];
          for b := 0 to length(zz.varName)-1 do
          begin
               if (zz.aProperty[b]=aproperty) and (not zz.isFunction[b])    and
                  (zz.varType[b]<>'')         and (zz.varType[b]<>'return') then
                  begin
                       if (d=0) then result:=result+'var'+#13;
                       if (not zz.isPointer[b]) then result:=result+#9+(removeSquares(zz.varName[b]))+':'+arrayDeclaration(zz.varName[b])+typeConvert(zz.varType[b])+';'+#13;
                       if (    zz.isPointer[b]) then result:=result+#9+(removeSquares(midStr(zz.varName[b],2,length(zz.varName[b])-1)))+':'+pointerConvert(zz.varType[b])+';'+#13;
                       addSymb(symbTable,zz.varName[b],zz.varType[b]);
                       d:=1;
                  end;
          end;
          setLength(ww.dataFOR,0);
          for b := zz.order[a] to nextFunctPos do
          begin
               if (ww.kind[b]=4) then
               begin
                   setLength(ww.dataFOR,b+1);
                   ww.dataFOR[b]:=(istFor(ww.ist[b]));
                   ww.dataFOR[b].auxVariab:=ww.dataFOR[b].auxVariab+inttostr(b);
               end;
               if (length(ww.dataFOR)>b) then
               begin
                 for c := 0 to length(ww.dataFOR[b].param.varName)-1 do
                 begin
                     if (ww.dataFOR[b].param.varType[c]<>'') then
                        result:=result+#9+array2Pas(ww.dataFOR[b].param.varName[c])+':'+arrayDeclaration(ww.dataFOR[b].param.varName[c])+typeConvert(ww.dataFOR[b].param.varType[c])+';'+#13;
                        addSymb(symbTable,ww.dataFOR[b].param.varName[c],ww.dataFOR[b].param.varType[c]);
                 end;
                 found1:=false;
                 for c :=0 to b-1 do
                 begin
                 if (ww.dataFOR[b].auxVariab=ww.dataFOR[c].auxVariab) then found1:=true;
                 end;
                 if not found1 then result:=result+#9+ww.dataFOR[b].auxVariab+':boolean;'+#13;
               end;
          end;
          result:=result+'begin'+#13;
          e:=length(ww.ist)-1;
          for b := zz.order[a] to nextFunctPos do
          begin
               found:=false;
               for c := 0 to length(zz.varName)-1 do
               begin
                   if (zz.order[c]=b) then
                   begin
                     found:=true;
                     if (not zz.isFunction[c])and(zz.varValue[c]<>'') then
                     begin
                       for d := 0 to inTab do
                           result:=result+chr(9);
                       result:=result+array2Pas(pointer2Pas((zz.varName[c])))+' := '+logicOperator(array2Pas(pointer2Pas(zz.varValue[c])))+';';
                       if (pos('malloc',zz.varValue[c])>0) then result:=result+addMallocComment(zz.varName[c],zz.varValue[c],symbTable);
                       result:=result+#13;
                     end;
                   end;
               end;
               if (not found) then
               begin
                 case (ww.kind[b]) of
                 1:
                   begin
                      tmpCond:=conditionParser(logicOperator(array2Pas(mathOp(Trim(midStr(ww.ist[b],3,length(ww.ist[b])-2))))));
                      for e := 0 to length(tmpCond.pre)-1 do
                      begin
                         for d := 0 to inTab do
                             result:=result+chr(9);
                         result:=result+tmpCond.pre[e]+#13;
                      end;
                      for d := 0 to inTab do
                          result:=result+chr(9);
                      result:=result+'if '+tmpCond.condition+' then '+#13;
                      for d := 0 to inTab do
                          result:=result+chr(9);
                      result:=result+'begin'+#13;
                      inc(inTab);
                      for e := 0 to length(tmpCond.post)-1 do
                      begin
                         for d := 0 to inTab do
                             result:=result+chr(9);
                         result:=result+tmpCond.post[e]+#13;
                      end;
                      if (tmpCond.isComplex) then addAuxFunct:=true;
                   end;
                 2:
                   begin
                      for d := 0 to inTab do
                          result:=result+chr(9);
                      result:=result+'else'+#13;
                      for d := 0 to inTab do
                          result:=result+chr(9);
                      result:=result+'begin'+#13;
                      inc(inTab);
                   end;
                 3:
                   begin
                      if (length(ww.kind)>b+1) then
                      begin
                           if (ww.kind[b+1]=9) then
                           begin
                             tmpCond:=conditionParser(logicOperator(array2Pas(Trim(midStr(ww.ist[b+1],10,length(ww.ist[b+1])-9)))));
                             if (tmpCond.isComplex) then addAuxFunct:=true;
                             if length(tmpCond.post)=0 then
                             begin
                                 for e := 0 to length(tmpCond.pre)-1 do
                                 begin
                                    for d := 0 to inTab do
                                        result:=result+chr(9);
                                    result:=result+tmpCond.pre[e]+#13;
                                 end;
                                 for d := 0 to inTab-1 do
                                     result:=result+chr(9);
                                 result:=result+'until not('+tmpCond.condition+');'+#13;
                             end
                             else
                             begin
                                for e := 0 to length(tmpCond.pre)-1 do
                                begin
                                   for d := 0 to inTab do
                                       result:=result+chr(9);
                                   result:=result+tmpCond.pre[e]+#13;
                                end;
                                for d := 0 to inTab do
                                    result:=result+chr(9);
                                result:=result+'if '+tmpCond.condition+' then break'+#13;
                                for e := 0 to length(tmpCond.post)-1 do
                                begin
                                   for d := 0 to inTab do
                                       result:=result+chr(9);
                                   result:=result+tmpCond.post[e]+#13;
                                end;
                                for d := 0 to inTab-1 do
                                    result:=result+chr(9);
                                result:=result+'until (false);'+#13;
                             end;
                           end
                           else
                           begin
                              if (ww.kind[b+1]=2) then
                              begin
                                for d := 0 to inTab-1 do
                                    result:=result+chr(9);
                                result:=result+'end'+#13;
                              end
                              else
                              begin
                                for d := 0 to inTab-1 do
                                    result:=result+chr(9);
                                result:=result+'end;'+#13;
                              end;
                           end;
                      end
                      else
                      begin
                        for d := 0 to inTab-1 do
                            result:=result+chr(9);
                        result:=result+'end;'+#13;
                      end;
                   end;
                 4:
                   begin
                        vv:=ww.dataFOR[b];
                        for e := 0 to length(vv.param.varName)-1 do
                        begin
                          for d := 0 to inTab do
                              result:=result+chr(9);
                          result:=result+vv.param.varName[e]+' := '+vv.param.varValue[e]+';'+#13;
                        end;
                        for d := 0 to inTab do
                            result:=result+chr(9);
                            result:=result+vv.auxVariab+' := false;'+#13;
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+'while ( true ) do'+#13;
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+'begin'+#13;
                        inc(inTab);
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+'if ('+vv.auxVariab+'=true ) then'+#13;
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+'begin'+#13;
                        inc(inTab);
                        e:=b+1;
                        if (length(ww.kind)>e) then
                           while (ww.kind[e]=6) do
                           begin
                                for d := 0 to inTab do
                                    result:=result+chr(9);
                                result:=result+array2Pas(mathOp(ww.ist[e]))+';'+#13;
                                inc(e);
                                if (length(ww.kind)=e) then break;
                           end;
                        dec(inTab);
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+'end;'+#13;
                        tmpCond:=conditionParser(logicOperator(array2Pas(vv.condList)));
                        for e := 0 to length(tmpCond.pre)-1 do
                        begin
                           for d := 0 to inTab do
                               result:=result+chr(9);
                           result:=result+tmpCond.pre[e]+#13;
                        end;
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+'if not '+tmpCond.condition+' then break;'+#13;
                        for e := 0 to length(tmpCond.post)-1 do
                        begin
                           for d := 0 to inTab do
                               result:=result+chr(9);
                           result:=result+tmpCond.post[e]+#13;
                        end;
                        for d := 0 to inTab do
                            result:=result+chr(9);
                        result:=result+vv.auxVariab+' := true;'+#13;
                        if (tmpCond.isComplex) then addAuxFunct:=true;
                   end;
                 5:begin
                    begin
                       tmpCond:=conditionParser(logicOperator(array2Pas(mathOp(Trim(midStr(ww.ist[b],6,length(ww.ist[b])-5))))));
                       if (tmpCond.isNormal) or (length(tmpCond.pre)=0) then
                       begin
                           for d := 0 to inTab do
                               result:=result+chr(9);
                           result:=result+'while '+tmpCond.condition+' do'+#13;
                           for d := 0 to inTab do
                               result:=result+chr(9);
                           result:=result+'begin'+#13;
                           for e := 0 to length(tmpCond.post)-1 do
                           begin
                              for d := 0 to inTab do
                                  result:=result+chr(9);
                              result:=result+tmpCond.post[e]+#13;
                           end;
                           inc(inTab);
                       end
                       else
                       begin
                          for d := 0 to inTab do
                              result:=result+chr(9);
                          result:=result+'while (true) do'+#13;
                          for d := 0 to inTab do
                              result:=result+chr(9);
                          result:=result+'begin'+#13;
                          inc(inTab);
                          for e := 0 to length(tmpCond.pre)-1 do
                          begin
                             for d := 0 to inTab do
                                 result:=result+chr(9);
                             result:=result+tmpCond.pre[e]+#13;
                          end;
                          for d := 0 to inTab do
                              result:=result+chr(9);
                          result:=result+'if not '+tmpCond.condition+' then break;'+#13;
                          for e := 0 to length(tmpCond.post)-1 do
                          begin
                             for d := 0 to inTab do
                                 result:=result+chr(9);
                             result:=result+tmpCond.post[e]+#13;
                          end;
                       end;
                    end;
                    if (tmpCond.isComplex) then addAuxFunct:=true;
                   end;
                 6:
                   begin
                       //Do nothing
                   end;
                 7:begin
                      for d := 0 to inTab do
                          result:=result+chr(9);
                      result:=result+array2Pas(mathOp(ww.ist[b]))+';'+#13;
                      inc(inTab);
                   end;
                 8:begin
                      for d := 0 to inTab do
                          result:=result+chr(9);
                      result:=result+'repeat'+#13;
                      inc(inTab);
                   end;
                 9:
                   begin
                       //Do nothing
                   end;
                 10:begin
                      result:=result+ww.ist[b]+':'+#13;
                   end;
                 11:begin
                      result:=result+'{'+ww.ist[b]+'}'+#13;
                   end;
                 12:begin
                    tmp1:=logicOperator(array2Pas(mathOp(Trim(midStr(ww.ist[b],7,length(ww.ist[b])-6)))));
                    tmpCond:=conditionParser(tmp1);
                    if (tmpCond.isComplex) then addAuxFunct:=true;

                    if (tmp1<>'') then
                    begin
                      for e := 0 to length(tmpCond.pre)-1 do
                      begin
                         for d := 0 to inTab do
                             result:=result+chr(9);
                         result:=result+tmpCond.pre[e]+#13;
                      end;
                      for d := 0 to inTab do
                        result:=result+chr(9);
                      result:=result+'result:='+tmpCond.condition+';'+#13;
                    end;
                    for d := 0 to inTab do
                       result:=result+chr(9);
                    result:=result+'exit;'+#13;
                    end;
                 else
                       for d := 0 to inTab do
                           result:=result+chr(9);
                       result:=result+logicOperator(array2Pas(mathOp(ww.ist[b])))+';'+#13;
                   end;
                 if ((ww.kind[b])=3) then
                    dec(inTab);
               end;
          end;
       end;
   end;
   result:=postProcess(result);
   if addAuxFunct=true then result:=aAddAuxFunct+result;
end;

procedure TfrmcToPasMain.Memo1Change(Sender: TObject);
begin
   //memo2.text:=convertCtoPAS(memo1.text);
end;

procedure TfrmcToPasMain.btnConvertClick(Sender: TObject);
begin
   memo2.text:=convertCtoPAS(memo1.text);
end;

procedure TfrmcToPasMain.pnlClientClick(Sender: TObject);
begin

end;

end.

