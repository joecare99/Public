unit Cmp_gedObject;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils;

type TGedObject=class(TObject)
  /// <INfo>Basisclasse für Genealogiedaten</info>
   protected
     function GetValue:string;virtual;abstract;
     procedure SetValue(NewVal:string);virtual;abstract;
   public
     property Value:string read GetValue  write SetValue;
end;

  TGedDate=class(TGedObject)
  /// <
  private
    FType : (gdt_exact,
             gdt_unsave,
             gdt_before,
             gdt_between,
             gdt_after,
             gdt_calc,
             gdt_other) ;

    FDateString:string;
    FDateInf:(gdti_Day,gdti_Week,gdti_Month,gdti_Year,gdti_Decade,gdti_Century);
    FDateSer1:TTimeStamp;
    FDateSer2:TTimestamp;
  Protected
     function GetValue:string;override;
     procedure SetValue(NewVal:string);override;
end;

 TGedPlace=class(TGedObject)
  /// <
  private
    FPlaceString:string;
  protected
     function GetValue:string;override;
     procedure SetValue(NewVal:string);override;
end;

  TGedFactType=Class(TGedObject)
     FIsUnar:boolean;
  private
     FDescription:string;
  protected
     function GetValue:string;override;
     procedure SetValue(NewVal:string);override;
  end;

  TGedFact=Class(TGedObject)
  private
    FDescription:string;
    FDate:TGedDate;
    FPlace:TGedPlace;
    FFactType:TGedFactType;
  protected
     function GetValue:string;override;
     procedure SetValue(NewVal:string);override;
  public
    Property Date:TGedDate read FDate;
    Property Place:TGedFactType read FPlace;
    Property FactType:TGedFactType read FFactType;
  End;

  TGedIndividuum=Class(TGedObject)

  end;

  TGedIndivRole=Class(TGedObject)

  end;

  TGedFamily=Class(TGedObject)

  end;

implementation

function TGedDate.GetValue;

begin
  //
  result := Fdatestring;
end;

procedure TGedDate.SetValue;
begin
  FDateString := NewVal;
end;

function TGedPlace.GetValue;

begin
  //
  result := FPlaceString;
end;

procedure TGedPlace.SetValue;
begin
  FPlaceString := NewVal;
end;

function TGedFactType.GetValue;

begin
  //
  result := FDescription;
end;

procedure TGedFactType.SetValue;
begin
  FDescription := NewVal;
end;

function TGedFact.GetValue;

begin
  //
  result := FDescription;
end;

procedure TGedFact.SetValue;
begin
  FDescription := NewVal;
end;

end.
