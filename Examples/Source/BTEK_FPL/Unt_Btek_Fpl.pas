unit Unt_Btek_Fpl;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils;

procedure ShowForm;stdcall;external 'Btek_fpl.dll';
procedure ShowForm2(const App:TApplication);stdcall;external 'Btek_fpl.dll';
procedure SimpleMessage;stdcall;external 'Btek_fpl.dll';


implementation

end.

