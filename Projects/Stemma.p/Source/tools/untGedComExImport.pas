unit untGedComExImport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Type
  TenumGedComIDTypes =
    (eGCIT_Individual=0,
     eGCIT_Family=1,
     eGCIT_Place=2,
     eGCIT_Citation=3,
     eGCIT_Source=4,
     eGCIT_Last=15 );

{ TClsGedCom }

 TClsGedCom=Class(TComponent)
       private
         // TStrings Storage for the GedCom-Datafile
         FStrings:Tstringlist;

        public
          Constructor Create(AOwner: TComponent); override;
          destructor Destroy; override;

          // LoadFromFile Load the Gedcom - File Auto-Charset
          Function LoadFromFile(Filename:String):boolean;
          Function LoadFromStream(aStream:TStream):boolean;

          // SaveToFile Saves the Data to a Gedcom File
          Function SaveToFile(Filename:String):boolean;
          Function WriteToStream(aStream:TStream):boolean;

          // Parse GedCom-Data from Stringlist to Database
          Function ParseData:boolean;

          // Generate GedCom Data from DB
          function GenerateData: boolean;
     end;

implementation

uses LConvEncoding;
{ TClsGedCom }

constructor TClsGedCom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStrings := TStringList.Create;
end;

destructor TClsGedCom.Destroy;
begin
  FreeAndNil(FStrings);
  inherited Destroy;
end;

function TClsGedCom.LoadFromFile(Filename: String): boolean;
var lFS:TFileStream;
begin
  result := false;
  if not Fileexists(Filename) then exit;
  {ELSE}
  lFS:= TFileStream.create(Filename,fmOpenRead);
  try
    // Transfer then Data to LoadFromStream
    result := LoadFromStream(lFS);
  finally
    // Cleanup the Filestream
    freeandnil(lFS);
  end;
end;

function TClsGedCom.LoadFromStream(aStream: TStream): boolean;
//var lStr:String;
begin
  result := false;
  // Adjust/Guess-Encoding

  // Transfer Data to Stringlist

  // Do basic Hashing in the Stringlist
  // Go through the Stringlist and Mark the Entries by Their ID
  // Number Circle: LSB-LoNibble Gives the Type see TenumGedComIDTypes
end;

function TClsGedCom.SaveToFile(Filename: String): boolean;
var lFS:TFileStream;
  Const NewExt='.new';
        BakExt='.bak';
begin
  result := false;
  if Fileexists(ChangeFileExt(Filename,NewExt)) then
    DeleteFile(ChangeFileExt(Filename,NewExt));
  lFS:=TFilestream.create(ChangeFileExt(Filename,NewExt),fmCreate);
  try
  result := WriteToStream(lFS);
  finally
    FreeAndNil(lFS);
  end;
  if Fileexists(Filename) then
     begin
       if Fileexists(ChangeFileExt(Filename,BakExt)) then
         deletefile(ChangeFileExt(Filename,BakExt));
       RenameFile(Filename,ChangeFileExt(Filename,BakExt))
     end;
  RenameFile(ChangeFileExt(Filename,NewExt),Filename)
end;

function TClsGedCom.WriteToStream(aStream: TStream): boolean;
begin
  result := false;

end;

function TClsGedCom.ParseData: boolean;
begin
  result := false;
  // Import-Settings (Append/Replace/New)
  // Parse Individuals
  // Offer Filter to User (By Name, Personal Data, Relationship)
  // if replace then Clear DB, if New then Generate New
  // Import Individuals with single Events.
  //
  //
  // Import Families (Filter)
  // Import Places (Filter)
  // Import Citation
  // Import Sources
end;

function TClsGedCom.GenerateData: boolean;
begin
  result := false;
  //1. Filter Data /
  //2. Export Header
  //2.1 Prepare List of Source/Citaton
  //3. Export all Individuals in filter
  //3.1   For each Ind get single events
  //3.1.1 For Each event get the LInks
  //4. Export Families
  //5. Places
  //6. Citation
  //7. Sources
end;

end.

