unit VisualHTTPClient;

{$mode objfpc}

interface

uses
  Classes, SysUtils, fphttpclient;

type
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

implementation

end.
