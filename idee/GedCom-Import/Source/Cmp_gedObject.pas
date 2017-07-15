unit Cmp_gedObject;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses SysUtils;

type tGedObject=class(tobject)
  /// <INfo>Basisclasse für Genealogiedaten</info>
     function GetValue:string;virtual;abstract;
     procedure SetValue(NewVal:string);virtual;abstract;
   public
     property Value:string read GetValue  write SetValue;
end;

type tGedDate=class(tGedObject)
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
    FDateSer1:TTimeStamp;
    FDateSer2:TTimestamp;
     function GetValue:string;override;
     procedure SetValue(NewVal:string);override;
end;

implementation

function tGedDate.GetValue;

begin
  //
  result := Fdatestring;
end;

procedure tGedDate.SetValue;
begin
  FDateString := NewVal;
end;

end.
