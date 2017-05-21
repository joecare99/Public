unit Int_NeedsStatusbar;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils,ComCtrls;

type

  { iNeedsStatusbar }

  iNeedsStatusbar=interface(IUnknown)
    ['{247D9ACB-8252-4CBD-BDF2-219899BAD7CF}']
    function GetStatusBar: TStatusbar;
    procedure SetStatusBar(AValue: TStatusbar);
    property StatusBar:TStatusbar read GetStatusBar write SetStatusBar;
  end;

implementation

end.

