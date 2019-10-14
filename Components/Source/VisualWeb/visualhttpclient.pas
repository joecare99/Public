unit VisualHTTPClient;

{$mode objfpc}

interface

uses
  Classes, SysUtils, fphttpclient;

type

  { TVisualHTTPClient }

  TVisualHTTPClient = class(TFPCustomHTTPClient)
  private
    { private declarations }
  public
    { public declarations }
    Property RequestHeaders;
    Property RequestBody;
    Property ResponseHeaders;
    Property ServerHTTPVersion;
    Property ResponseStatusCode;
    Property ResponseStatusText;
    Property Cookies;
  published
    constructor Create(AOwner: TComponent); override;
    Property HTTPversion;
    {$if FPC_FULLVERSION>30000}
    Property AllowRedirect;
    Property MaxRedirects;
    Property OnRedirect;
    Property UserName;
    Property Password;
    Property OnPassword;
    Property OnDataReceived;
    Property OnHeaders;
    Property OnGetSocketHandler;
    {$endif}
  end;

type TRedirectEvent=fphttpclient.TRedirectEvent;

function DownloadFile(const lURL: string; const lFilename: string; Const lFileDate: TDateTime;const OnRedir:TRedirectEvent=nil ): boolean;

implementation

uses dateutils,ssockets, sslsockets;

function DownloadFile(const lURL: string; const lFilename: string;
  const lFileDate: TDateTime; const OnRedir: TRedirectEvent): boolean;
var
  mStrm: TMemoryStream;
  VisualHTTPClient1: TVisualHTTPClient;
  lFilepath: String;
begin
    Result := false;
    try
    mStrm := TMemoryStream.Create;
    lFilepath := ExtractFilePath(lFilename);
    if not DirectoryExists(lFilepath) then
       CreateDir(lFilepath);
    if not fileexists(lFilename) then
       begin
    VisualHTTPClient1:=TVisualHTTPClient.Create(nil);
    VisualHTTPClient1.AllowRedirect:=true;
    VisualHTTPClient1.OnRedirect:=OnRedir;
    VisualHTTPClient1.Get(lURL, mStrm);
    mStrm.Seek(0, soBeginning);
    mStrm.SaveToFile(lFilename);
    FilesetDate(lFilename, DateTimeToDosDateTime( lFileDate ));
    Result := True;
       end;
  finally
    FreeAndNil(VisualHTTPClient1);
    FreeAndNil(mStrm)
  end;
end;

{ TVisualHTTPClient }

constructor TVisualHTTPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;


end.
