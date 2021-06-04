unit cls_h2gStep2;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Unt_GNameHandler, unt_IGenBase2;

type
    TParseEvent = procedure(Sender: TObject; aText: string; Ref: string;
        dsubtype: integer) of object;

    TProcessData = procedure(Sender: TObject;
        const aText, aRef, aKat, aData: string) of object;

    { TH2gStep2 }

    TH2gStep2 = class
        procedure ComputeOutput(CType: byte; Text: string);
    private
        FData: string;
        FDataHeader: string;
        FDataKat: string;
        FDataReference: string;
        FLastHeader: string;
        FFamRef: string;
        FMainRef: string;
        FonProcessData: TProcessData;
        FonStartFamily: TParseEvent;
        FonStartIndiv: TParseEvent;
        FonFamilyData: TParseEvent;
        FonFamilyDate: TParseEvent;
        FonFamilyIndiv: TParseEvent;
        FonFamilyPlace: TParseEvent;
        FonFamilyType: TParseEvent;
        FonIndiData: TParseEvent;
        FonIndiDate: TParseEvent;
        FonIndiName: TParseEvent;
        FonIndiOccu: TParseEvent;
        FonIndiPlace: TParseEvent;
        FonIndiRef: TParseEvent;
        FonIndiRel: TParseEvent;
        FPersonSex: char;
        FPFRef: string;
        procedure SetonStartIndiv(AValue: TParseEvent);
        procedure SetonFamilyData(AValue: TParseEvent);
        procedure SetonFamilyDate(AValue: TParseEvent);
        procedure SetonFamilyIndiv(AValue: TParseEvent);
        procedure SetonFamilyPlace(AValue: TParseEvent);
        procedure SetonFamilyType(AValue: TParseEvent);
        procedure SetonIndiData(AValue: TParseEvent);
        procedure SetonIndiDate(AValue: TParseEvent);
        procedure SetonIndiName(AValue: TParseEvent);
        procedure SetonIndiOccu(AValue: TParseEvent);
        procedure SetonIndiPlace(AValue: TParseEvent);
        procedure SetonIndiRef(AValue: TParseEvent);
        procedure SetonIndiRel(AValue: TParseEvent);
        procedure SetonProcessData(AValue: TProcessData);
        procedure SetonStartFamily(AValue: TParseEvent);
        procedure ProcessGenData(const s1, s2, s3, s4: string);
        procedure InitInd;
        procedure StartIndiv(const IRef1: string);
        procedure SetIndName(aName: string; aRef: string; subType: integer);
        procedure SetIndRef(aData: string; aRef: string);
        procedure SetIndData(aData: string; aRef: string; subType: TenumEventType);
        procedure SetIndDate(aDate: string; aRef: string; subType: TenumEventType);
        procedure SetIndPlace(aPlace: string; aRef: string; subType: TenumEventType);
        procedure StartFamily(const IRef1, IRef2: string; out FamRef: string);
        procedure SetFamilyMember(aIRef, aFRef: string; subType: integer);
        procedure SetFamilyDate(aDate, aFRef: string; subType: TenumEventType);
        procedure SetFamilyData(aData, aFRef: string; subType: TenumEventType);
        procedure SetFamilyPlace(aPlace, aFRef: string; subType: TenumEventType);

    public
        (* GNameHandler *)
        GNameHandler: TGNameHandler;

        constructor Create;
        destructor Destroy; override;

        property onStartIndiv: TParseEvent read FonStartIndiv write SetonStartIndiv;
        property onStartFamily: TParseEvent read FonStartFamily write SetonStartFamily;
        property onFamilyDate: TParseEvent read FonFamilyDate write SetonFamilyDate;
        property onFamilyType: TParseEvent read FonFamilyType write SetonFamilyType;
        property onFamilyData: TParseEvent read FonFamilyData write SetonFamilyData;
        property onFamilyPlace: TParseEvent read FonFamilyPlace write SetonFamilyPlace;
        property onFamilyIndiv: TParseEvent read FonFamilyIndiv write SetonFamilyIndiv;
        property onIndiName: TParseEvent read FonIndiName write SetonIndiName;
        property onIndiDate: TParseEvent read FonIndiDate write SetonIndiDate;
        property onIndiPlace: TParseEvent read FonIndiPlace write SetonIndiPlace;
        property onIndiOccu: TParseEvent read FonIndiOccu write SetonIndiOccu;
        property onIndiRel: TParseEvent read FonIndiRel write SetonIndiRel;
        property onIndiRef: TParseEvent read FonIndiRef write SetonIndiRef;
        property onIndiData: TParseEvent read FonIndiData write SetonIndiData;
        property onProcessData: TProcessData read FonProcessData write SetonProcessData;
        procedure ProcessGenData2(Sender: TObject; const s1, s2, s3, s4: string);
    end;

implementation

uses Unt_StringProcs, strutils;

const
    h2GedTag: array[0..6] of record
            s: string;
            e: TenumEventType;
            d: boolean
        end
    =
        ((s: 'BERUF'; e: evt_Occupation; d: True),
        (s: 'GEBURT'; e: evt_Birth{%H-}),
        (s: 'TAUFE'; e: evt_Baptism{%H-}),
        (s: 'TOD'; e: evt_Death{%H-}),
        (s: 'HEIRAT'; e: evt_Marriage{%H-}),
        (s: 'BEGRÄBNIS'; e: evt_Burial{%H-}),
        (s: 'VERWEIS'; e: evt_ID; d: True));

    csHT_Name = 'NAME:';
    csHT_Eltern = 'ELTERN:';
    csHT_Vater = 'Vater:';
    csHT_Mutter = 'Mutter:';
    csHT_Familie = 'FAMILIE:';
    csHT_Partner = 'PARTNER:';
    csHT_Kind = 'KIND:';
    csHT_info = 'info:';
    csHT_data = 'data:';
    csHT_Ref = 'Ref:';

    h2gNameKat: array[0..4] of string =
        (csHT_Name,
        csHT_Vater,
        csHT_Mutter,
        csHT_Partner,
        csHT_Kind);

{ TH2gStep2 }

procedure TH2gStep2.ComputeOutput(CType: byte; Text: string);
begin
    if (CType = 0) and (uppercase(Text) = csHT_Name) then
      begin
        InitInd();
        FDataHeader := csHT_Name;
        FDataKat := csHT_Name;
      end
    else if (CType = 0) and (uppercase(Text) = csHT_Eltern) then
      begin
        FDataHeader := csHT_Eltern;
        FLastHeader := csHT_Eltern;
        FDataKat := '';
      end
    else if (CType = 0) and (uppercase(Text) = csHT_Familie) then
      begin
        FDataHeader := csHT_Familie;
        FLastHeader := csHT_Familie;
        FDataKat := '';
      end
    else if (CType = 0) and (uppercase(Text) = csHT_Partner) then
      begin
        FDataKat := csHT_Partner;
      end
    else if (CType = 0) and (uppercase(Text) = csHT_Kind) then
      begin
        FDataKat := csHT_Kind;
      end
    else if (CType = 0) then
        FLastHeader := Text;
    if (CType = 2) and uppercase(Text).StartsWith('<A ') then
      begin
        FDataReference := Text.Substring(8);
        if FDataReference.StartsWith('"') then
            FDataReference := FDataReference.Remove(0, 1);
        if FDataReference.EndsWith('>') then
            FDataReference := FDataReference.Remove(FDataReference.Length - 1);
        if FDataReference.EndsWith('"') then
            FDataReference := FDataReference.Remove(FDataReference.Length - 1);
        if FDataReference.EndsWith('.html') then
            FDataReference := FDataReference.Remove(FDataReference.Length - 5);
      end;
    if (CType = 3) and ((FLastHeader = csHT_info) or (FLastHeader = csHT_Eltern)) then
      begin
        if Text.StartsWith(':') then
            Text := Text.Substring(1);
        FDataKat := trim(Text);
      end;
    if (CType = 3) and ((FLastHeader = csHT_Familie)) then
      begin
        if Text.StartsWith(':') then
            Text := Text.Substring(1);
        FDataKat := trim(Text);
        ProcessGenData(FDataHeader, '', FDataKat, '#Start');
        FDataHeader := trim(Text);
      end;
    if (CType = 3) and ((FLastHeader = csHT_data) or (FLastHeader = csHT_Ref)) then
      begin
        if Text.StartsWith(':') then
            Text := Text.Substring(1);
        FData := trim(Text);
        ProcessGenData(FDataHeader, FDataReference, FDataKat, FData);
      end;
end;

procedure TH2gStep2.SetonStartIndiv(AValue: TParseEvent);
begin
    if FonStartIndiv = AValue then
        Exit;
    FonStartIndiv := AValue;
end;

procedure TH2gStep2.SetonFamilyData(AValue: TParseEvent);
begin
    if FonFamilyData = AValue then
        Exit;
    FonFamilyData := AValue;
end;

procedure TH2gStep2.SetonFamilyDate(AValue: TParseEvent);
begin
    if FonFamilyDate = AValue then
        Exit;
    FonFamilyDate := AValue;
end;

procedure TH2gStep2.SetonFamilyIndiv(AValue: TParseEvent);
begin
    if FonFamilyIndiv = AValue then
        Exit;
    FonFamilyIndiv := AValue;
end;

procedure TH2gStep2.SetonFamilyPlace(AValue: TParseEvent);
begin
    if FonFamilyPlace = AValue then
        Exit;
    FonFamilyPlace := AValue;
end;

procedure TH2gStep2.SetonFamilyType(AValue: TParseEvent);
begin
    if FonFamilyType = AValue then
        Exit;
    FonFamilyType := AValue;
end;

procedure TH2gStep2.SetonIndiData(AValue: TParseEvent);
begin
    if FonIndiData = AValue then
        Exit;
    FonIndiData := AValue;
end;

procedure TH2gStep2.SetonIndiDate(AValue: TParseEvent);
begin
    if FonIndiDate = AValue then
        Exit;
    FonIndiDate := AValue;
end;

procedure TH2gStep2.SetonIndiName(AValue: TParseEvent);
begin
    if FonIndiName = AValue then
        Exit;
    FonIndiName := AValue;
end;

procedure TH2gStep2.SetonIndiOccu(AValue: TParseEvent);
begin
    if FonIndiOccu = AValue then
        Exit;
    FonIndiOccu := AValue;
end;

procedure TH2gStep2.SetonIndiPlace(AValue: TParseEvent);
begin
    if FonIndiPlace = AValue then
        Exit;
    FonIndiPlace := AValue;
end;

procedure TH2gStep2.SetonIndiRef(AValue: TParseEvent);
begin
    if FonIndiRef = AValue then
        Exit;
    FonIndiRef := AValue;
end;

procedure TH2gStep2.SetonIndiRel(AValue: TParseEvent);
begin
    if FonIndiRel = AValue then
        Exit;
    FonIndiRel := AValue;
end;

procedure TH2gStep2.SetonProcessData(AValue: TProcessData);
begin
    if FonProcessData = AValue then
        Exit;
    FonProcessData := AValue;
end;

procedure TH2gStep2.SetonStartFamily(AValue: TParseEvent);
begin
    if FonStartFamily = AValue then
        Exit;
    FonStartFamily := AValue;
end;

procedure TH2gStep2.ProcessGenData(const s1, s2, s3, s4: string);
begin
    if assigned(FonProcessData) then
        FonProcessData(Self, s1, s2, s3, s4)
    else
      ProcessGenData2(self,s1,s2,s3,s4);
end;

procedure TH2gStep2.InitInd;
begin
    // Starts a New Individuum
    // Clear all Data

end;

procedure TH2gStep2.StartIndiv(const IRef1: string);
begin
    if assigned(FonStartIndiv) then
         FonStartIndiv(self, IRef1, '', 0);
end;

procedure TH2gStep2.SetIndName(aName: string; aRef: string; subType: integer);
begin
    if assigned(FonIndiName) then
        FonIndiName(self, aName, aRef, subType);
end;

procedure TH2gStep2.SetIndRef(aData: string; aRef: string);
begin
    if (aData <> '') and assigned(FonIndiRef) then
        FonIndiRef(self, aData, aRef, 0);
end;

procedure TH2gStep2.SetIndData(aData: string; aRef: string; subType: TenumEventType);
begin
    if (aData <> '') and assigned(FonIndiData) then
        FonIndiData(self, aData, aRef, Ord(subType));
end;

procedure TH2gStep2.SetIndDate(aDate: string; aRef: string; subType: TenumEventType);
begin
    if (aDate <> '') and assigned(FonIndiDate) then
        FonIndiDate(self, aDate, aRef, Ord(subType));
end;

procedure TH2gStep2.SetIndPlace(aPlace: string; aRef: string; subType: TenumEventType);
begin
    if (aPlace <> '') and assigned(FonIndiPlace) then
        FonIndiPlace(self, aPlace, aRef, Ord(subType));
end;

procedure TH2gStep2.StartFamily(const IRef1, IRef2: string; out FamRef: string);
begin
    if IRef1 < IRef2 then
        FamRef := 'F' + IRef1 + IRef2
    else
        FamRef := 'F' + IRef2 + IRef1;
    if assigned(FonStartFamily) then
        FonStartFamily(self, FamRef, '', 0);
    SetFamilyMember(iRef1, FamRef, 1);
    SetFamilyMember(iRef2, FamRef, 2);
end;

procedure TH2gStep2.SetFamilyMember(aIRef, aFRef: string; subType: integer);
begin
    if (aIRef <> '') and assigned(FonFamilyIndiv) then
        FonFamilyIndiv(self, aIRef, aFRef, subType);
end;

procedure TH2gStep2.SetFamilyDate(aDate, aFRef: string; subType: TenumEventType);
begin
    if (aDate <> '') and assigned(FonFamilyDate) then
        FonFamilyDate(self, aDate, aFRef, Ord(subType));
end;

procedure TH2gStep2.SetFamilyData(aData, aFRef: string; subType: TenumEventType
  );
begin
    if (aData <> '') and assigned(FonFamilyData) then
        FonFamilyData(self, aData, aFRef, Ord(subType));
end;

procedure TH2gStep2.SetFamilyPlace(aPlace, aFRef: string; subType: TenumEventType);
begin
    if (aPlace <> '') and assigned(FonFamilyPlace) then
        FonFamilyPlace(self, aPlace, aFRef, Ord(subType));
end;

constructor TH2gStep2.Create;
begin
    GNameHandler.Init;
end;

destructor TH2gStep2.Destroy;
begin
    GNameHandler.Done;
end;

procedure TH2gStep2.ProcessGenData2(Sender: TObject; const s1, s2, s3, s4: string);
var
    sRef, lGivenName, lSurnameName, lRest, lDate, lParFamRef: string;
    lPos, lFound, i: integer;
    lPersonSex: char;
    {%H-}lFlag: Boolean; // Todo:
begin
    // Step3
    if S2.StartsWith('.') then
        sRef := ExtractFileName(S2)
    else
        sRef := S2;

    if TryParseStr(s3, h2gNameKat, psm_Full, lFound) then
      begin
        if lFound=0 then
          StartIndiv(sRef);
        lPos := s4.IndexOf('  ');
        if lPos >=0 then
          begin
        lGivenName := s4.Substring(0, lPos);
        lSurnameName := s4.Substring(lPos + 2);
          end
        else
          begin
            lGivenName := s4;
            lSurnameName := '';
          end;
        SetIndName(lSurnameName, sRef, 1);
        SetIndName(lGivenName, sRef, 2);
        case lFound of
            0:
              begin
                FPFRef := ''; // Init
                SetIndRef(sRef,sRef);
                FPersonSex := GNameHandler.GuessSexOfGivnName(lGivenName, True);
                if FPersonSex in ['M', 'F'] then
                  begin
                    SetIndData(FPersonSex, sRef, evt_Sex);
                  end;
                FMainRef := sRef;
              end;
            1:
              begin
                SetIndData('M', sRef, evt_Sex);
                GNameHandler.LearnSexOfGivnName(lGivenName, 'M');
                FPFRef := sRef;
              end;
            2:
              begin
                SetIndData('F', sRef, evt_Sex);
                GNameHandler.LearnSexOfGivnName(lGivenName, 'F');
                StartFamily(FPFRef, sRef, lParFamRef);
                FPFRef := '';
                SetFamilyMember(FMainRef,lParFamRef,3);
              end;
            3: // Partner
              begin
                if FPersonSex in ['M', 'F'] then
                    lPersonSex := IfThen(FPersonSex = 'F', 'M', 'F')[1]
                else
                    lPersonSex := GNameHandler.GuessSexOfGivnName(lGivenName, True);
                if lPersonSex in ['M', 'F'] then
                  begin
                    SetIndData(lPersonSex, sRef, evt_Sex);
                  end;
                if lPersonSex <> 'M' then
                  StartFamily(FMainRef, sRef, FFamRef)
                else
                  StartFamily( sRef,FMainRef, FFamRef)

              end;
            4: // Kind
              begin
                lPersonSex := GNameHandler.GuessSexOfGivnName(lGivenName, True);
                if lPersonSex in ['M', 'F'] then
                  begin
                    SetIndData(lPersonSex, sRef, evt_Sex);
                  end;
                SetFamilyMember(sRef, FFamRef, 3);
              end;
          end;
      end;

    lFlag:=false;
    for i := 0 to high(h2GedTag) do
        if s3 = h2GedTag[i].s then
          begin
            lFlag := true;
            // Split Datum und Ort
            lPOs := s4.IndexOf(',');
            if lPos >= 0 then
              begin
                lDate := trim(s4.Substring(0, lPos));
                lRest := s4.Substring(lPos);
              end
            else
              begin
                lDate := trim(s4);
                lRest := '';
              end;
            if (lDate<>'') and not (lDate[length(lDate)] in (Ziffern+['.','_']))  then
              begin
                lRest := lDate + lRest;
                lDate := '';
              end
            else
            if lRest.StartsWith(',') then
                lRest := trim(lrest.Remove(0, 1));
            if h2GedTag[i].e <> evt_Marriage then
              begin
                SetIndDate(ldate, sRef, h2GedTag[i].e);
                if h2GedTag[i].d then
                    if h2GedTag[i].e = evt_ID then
                        SetIndRef(lRest, sRef)
                    else
                        SetIndData(lRest, sRef, h2GedTag[i].e)
                else
                    SetIndPLace(lRest, sRef, h2GedTag[i].e);
              end
            else
              begin
                if (ldate='') and (lRest='') then
                  SetFamilyData('!', FFamRef, h2GedTag[i].e);
                SetFamilyDate(ldate, FFamRef, h2GedTag[i].e);
                SetFamilyPlace(lRest, FFamRef, h2GedTag[i].e);
              end;
          end;

 //   if not lFlag then
 // Todo : ParseError

    if s4='#Start' then
      begin
        if FPFRef<>'' then
          begin
            StartFamily(FPFRef,'', lParFamRef);
            SetFamilyMember(FMainRef,lParFamRef,3);
          end;
          FPFRef := '';
        FFamRef := '';
      end;
end;

end.
