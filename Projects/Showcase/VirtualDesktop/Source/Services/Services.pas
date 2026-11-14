unit Services;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TStringArray = array of string;

  IClockService = interface
    ['{3F4F5F6A-0A1C-4B17-9D9A-4BD7DF55A101}']
    function Now: TDateTime;
  end;

  INoteStorage = interface
    ['{96ED8E5E-3DB6-4AA7-8E20-0F8E2E9B7102}']
    function LoadText: string;
    procedure SaveText(const AText: string);
  end;

  IUserWorkspaceService = interface
    ['{A42EED94-465D-40D4-9502-237AA687FD51}']
    function RootPath: string;
    function ResolveFile(const ARelativePath: string): string;
  end;

  IConfigurationService = interface
    ['{263868FB-649A-4B73-890B-BAF838244857}']
    function ReadString(const ASection, AKey, ADefault: string): string;
    procedure WriteString(const ASection, AKey, AValue: string);
    procedure DeleteKey(const ASection, AKey: string);
    function ReadSections: TStringArray;
    procedure Save;
  end;

implementation

end.
