unit Unt_IData;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses variants;

type IData=interface
    ['{7E8B9348-4B2E-4A6F-B540-F0E9F3717EFC}']
    /// <INFO>GetData liefert einen (den aktellen) kompletten Datensatz.</INFO>
    function getdata:variant;
    /// <INFO>SetData verändert Daten / einzeln, mehrere oder alle</INFO>
    procedure SetData(NewVal:Variant);
    /// <INFO>Fügt einen neuen, leeren Datensatz an.</INFO>
    Procedure Append(Sender:Tobject=nil);
    Procedure Edit(Sender:Tobject=nil);
    Procedure Post(Sender:Tobject=nil);
    Procedure Cancel(Sender:Tobject=nil);
    procedure First(Sender:Tobject=nil);
    Procedure Last(Sender:Tobject=nil);
    Procedure Next(Sender:Tobject=nil);
    Procedure Previous(Sender:Tobject=nil);
    Procedure Delete(Sender:Tobject=nil);
    Function GetActID:integer;
    Function EOF:boolean;
    function BOF:boolean;
    property Data:variant read getdata write SetData;
end;

implementation

end.
