unit unt_XMLRessource;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Procedure Execute;

implementation

uses XMLConf;

var xmlRes:TXMLConfig;
    FDataPath:string;

procedure Execute;
var
  i: Integer;
begin
  FDataPath:='Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:='..'+DirectorySeparator+ FDataPath;

  FDataPath:=FDataPath+DirectorySeparator+'XML-Test';
  assert(DirectoryExists(FDataPath),'Make sure, the data-directory exists');

  xmlRes:=TXMLConfig.Create(nil);
  try
    xmlRes.RootName:='ressource';
    xmlRes.Filename := FDataPath+DirectorySeparator+'English2.xml' ;        // reads the file if it already exists, but...;
    xmlres.Clear;
    xmlres.OpenKey  ('/String') ;
    xmlres.SetValue('Tools/text','Tool-Value');
    xmlres.SetValue('Settings/text','Settings-Value');
    xmlres.SetValue('About/text','About-Value');
    xmlres.SetValue('Practice/text','Practice-Value');
    xmlres.SetValue('Random_Select/text','Random Select-Value');
    xmlres.Flush;
  finally
    FreeAndNil(xmlRes);
  end;

  xmlRes:=TXMLConfig.Create(nil);
  try
    xmlRes.RootName:='ressource';
    xmlRes.Filename := FDataPath+DirectorySeparator+'English2.xml' ;        // reads the file if it already exists, but...;
    xmlres.OpenKey  ('/String') ;
    writeln(xmlres.getValue('Tools/text','Tools'));
    writeln(xmlres.getValue('Settings/text','Settings'));
    writeln(xmlres.getValue('About/text','About'));
    writeln(xmlres.getValue('Practice/text','Practice'));
    writeln(xmlres.getValue('Random_Select/text','Random Select'));
  finally
    FreeAndNil(xmlRes);
  end;
  readln;
end;


end.

