unit WPPDFEngineContract;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  SysUtils;

type
  TWPPDFPageArguments = array[0..4] of Integer;

  EWPPDFEngineUnavailable = class(Exception);
  EWPPDFLifecycleError = class(Exception);

  TWPPDFEngine = class
  public
    procedure BeginDocument; virtual; abstract;
    procedure BeginPage(const Arguments: TWPPDFPageArguments); virtual; abstract;
    procedure EndPage; virtual; abstract;
    procedure EndDocument; virtual; abstract;
  end;

implementation

end.
