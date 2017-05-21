unit unt_BaseClass;

{$mode delphi}

interface

uses
  Classes, SysUtils;

type
  {$ifndef SUPPORTS_GENERICS}
  {$if declared(TStringArray)}
  TStringArray =Sysutils.TStringArray;
  {$else}
  TStringArray = array of string;
  {$endif}
  {$endif}
  // see §1

  TBaseClass = class
    class function Something:{$ifdef SUPPORTS_GENERICS}Tarray<String>{$else}TStringArray{$endif}; virtual; abstract;
  end;

implementation

end.

