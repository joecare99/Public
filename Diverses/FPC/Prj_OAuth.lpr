program Prj_OAuth;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,
  sysutils,
  DateUtils,
  fphttpclient,
  opensslsockets,
  fpjson,
  base64,
  sha1;


function TokenHeader: string;
var
  j: TJSONObject;
begin
  j:=TJSONObject.Create();
  try
    j.Add('alg', 'RS256');
    j.Add('typ', 'JWT');
    j.Add('kid', '45d4f54ad5fa5df45asdfadsfqregthtg454878798');
    result := j.ToString();
  finally
    freeandnil(j)
  end;
end;

function TokenSign(const APrivateKey, APayload: string): string;
var
  VHeader: string;
  VPayload: string;
  VSignature: string;
begin
  VHeader := EncodeStringBase64( TokenHeader);
  VPayload := EncodeStringBase64(APayload);
  VSignature := EncodeStringBase64(VHeader + '.' + VPayload).HMACSHA256(APrivateKey).EncodeBase64URL;
  Result := VHeader + '.' + VPayload + '.' + VSignature;
end;

function TokenPayload(const VJSON: IJSONValue): string;
var
  VDate: TDateTime;
begin
  VDate := Now;
  Result := TJSONObject.New()
    .Put('iss', VJSON.Path('client_email', ''))
    .Put('aud', 'https://accounts.google.com/o/oauth2/token')
    .Put('iat', IntToStr(DateTimeToUnix(VDate, False)))
    .Put('exp', IntToStr(DateTimeToUnix(VDate.IncreaseMinutes(30), False)))
    .Stringify()
end;

var
  VJSON: IJSONValue;
  VPayload: string;
  VToken: string;
  VHttp: TFPHTTPClient;
  VBody: TStrings;
  VUrl: string;
  VResponse: TStringStream;
begin
  VJSON := TJSONParser.New('agente-sc-nv9d-46509c843848.json', fmOpenReadWrite).Parse;
  VPayload := TokenPayload(VJSON);
  VToken:= TokenSign(VJSON.Path('private_key', ''), VPayload);



  VHttp := TFPHTTPClient.Create(nil);
  VBody := TStringList.Create;
  VResponse := TStringStream.Create('');
  try
    try
      VBody.AddPair('grant_type', 'urn:ietf:params:oauth:grant-type:jwt-bearer');
      VBody.AddPair('assertion', VToken);

      VUrl := 'https://accounts.google.com/o/oauth2/token';

      VHttp.FormPost(VUrl, VBody, VResponse);

      WriteLn(VResponse.DataString);
      WriteLn('');

    except
      raise
    end;
  finally
    FreeAndNil(VResponse);
    FreeAndNil(VBody);
    FreeAndNil(VHttp);
  end;


end.

