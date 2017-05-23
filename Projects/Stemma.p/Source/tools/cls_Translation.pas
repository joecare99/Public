unit cls_Translation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

{ TTranslation }

 TTranslation=class
  Fitems:Tstrings;
private
  function GetItems(index: integer): String;
  function GetlnCode: string;
public
  constructor Create;
  destructor Destroy;override;
  procedure LoadFromFile(aLanguage:string;out Success:boolean);overload;
  procedure LoadFromFile(aLanguage:string);overload;
  property lnCode:string read GetlnCode;
  property Items[index:integer]:String read GetItems;
end;

resourcestring
  rsMenuHistoryCaption = '&%d- %s (%d)';
  SAddAChild = 'Add a child';
  SAddACitation = 'Add a citation';
  SAddADepository = 'Add a depository';
  SAddADocument = 'Add a Document';
  SAddAName = 'Add a name';
  SAddAnEvent = 'Add an event';
  SAddAnEventNameOrRela = 'Add an event, name or relation type';
  SAddAnIndividual = 'Add an individual';
  SAddAParent = 'Add a parent';
  SAddASource = 'Add a source';
  SAddAWitness = 'Add a witness';
  SAddFirstName = 'Add &first name';
  SAddingASisterTo = 'Adding a sister to ';
  SAddTitle = 'Add &title';
  SAreYouSureToDelX = 'Are you sure you want to delete %s "%s%" ?';
  SAreYouSureToDelDoc = 'Are you sure you want to delete exhibit "';
  SAreYouSureToDelete   = 'Are you sure you want to delete "%s" ?';
  SAreYouSureToDelLnkToChld = 'Are you sure you want to delete the link to the'
    +' child "';
  SAreYouSureToDelLnkToRep = 'Are you sure you want to delete the link to the '
    +'depository "';
  SAreYouSureToDelRepository = 'Are you sure you want to delete repository "';
  SAreYouSureToDelWitness = 'Are you sure you want to delete witness "';
  SAreYouSureToQuit	= 'Are you sure you want to quit STEMMA?';
  SChildren = 'Children';
  SCitation = 'Citation';
  SDatabaseAlreadyExist = 'Database already exist.';
  SDatabaseNotFound = 'Database not found.';
  SDispNameAndLiveDate = '%s (%s - %s)';
  SDispNameIdAndLiveDate = '%s [%d] (%s - %s)';
  SDocuments = 'Documents';
  SEnterTheDatabaseName = 'Enter the database name';
  SEnterTheDatabaseToDel = 'Enter the database name to delete';
  SEvents = 'Events';
  SGoTo = '&Go to';
  SLocationOfTheTMG40dD = 'Location of the TMG 4.0d database';
  SMarriedWith =' & %s (of %d)';
  SMonthFebruary = 'february';
  SMonthJanuary = 'january';
  SNOTITLENODESCRIPTION = 'NO TITLE, NO DESCRIPTION';
  SNumberOfTheIndividua = 'Number of the individual';
  SOnlyTheExhibitsAssoc = 'Only the exhibits associated to an individual (type'
    +' "I") can be modified this way';
  SParents = 'Parents';
  SRemovalOfOrphanRecor = 'Removal of orphan records';
  SRepairNamesForSortin = 'Repair names (for sorting)';
  SRepairRelationSortDa = 'Repair relation sort date';
  SRepositoryModificati = 'Depository modification';
  SStep112EventTypeImpo = 'Step 1/12 - Event type importation';
  SStep212SourceReposit = 'Step 2/12 - Source-repository association '
    +'importation';
  SStep312RepositoryImp = 'Step 3/12 - Repository importation';
  STheIndividualNotFound = 'The individual %s has not been found.';
  STOBEPROGRAMMED = 'TO BE PROGRAMMED';
  SUnableToConnectToDB 	= 'Couldn''t connect to MySQL database %s.';
  SConfirmation		= 'Confirmation';
  SDatabaseName 	= 'Database name';
  SEnterDBName		= 'Enter the database name to be created';
  STitle		= 'Title';
  SSuffix		= 'Suffix';
  SFamilyName		= 'Name';
  SGivenName		= 'First name';

var Translation:TTranslation;

implementation

uses LCLTranslator;




























constructor TTranslation.Create;
begin
 Fitems:=TStringList.Create;
  FItems.Add(''); {0}
FItems.Add(SConfirmation);
FItems.Add(SUnableToConnectToDB);
FItems.Add(SDatabaseName);
FItems.Add(SEnterDBName);
FItems.Add(SDatabaseAlreadyExist);
FItems.Add(SLocationOfTheTMG40dD);
FItems.Add(SStep112EventTypeImpo);
FItems.Add(SStep212SourceReposit);
FItems.Add(SStep312RepositoryImp);
FItems.Add('Step 4/12 - Event Importation - Time to completion '); {10}
FItems.Add('Step 5/12 - Citation importation - Time to completion ');
FItems.Add('Step 6/12 - Individual importation - Time to completion ');
FItems.Add('Step 7/12 - Place importation - Time to completion ');
FItems.Add('Step 8/12 - Witness importation - Time to completion ');
FItems.Add('Step 9/12 - Name importation - Time to completion ');
FItems.Add('Step 10/12 - Relation importation - Time to completion ');
FItems.Add('Step 11/12 - Source importation - Time to completion ');
FItems.Add('Step 12/12 - Exhibits importation - Time to completion ');
FItems.Add('Error: STEMMA Database already existing or impossible to open imported database.');
FItems.Add(SNumberOfTheIndividua); {20}
FItems.Add('Enter the number of the desired individual');
FItems.Add('');
FItems.Add('');
FItems.Add(SEnterTheDatabaseToDel);
FItems.Add(SEnterTheDatabaseName);
FItems.Add(SDatabaseNotFound);
FItems.Add(SAreYouSureToDelRepository);
FItems.Add('" ?');
FItems.Add(SAddACitation);
FItems.Add(SAddAnEvent); {30}
FItems.Add(SAreYouSureToDelX);
FItems.Add(SAreYouSureToDelWitness);
FItems.Add(SAddADocument);
FItems.Add('Text');
FItems.Add(SAddAnIndividual);
FItems.Add(SAddAName);
FItems.Add(SFamilyName);
FItems.Add(SGivenName);
FItems.Add(SSuffix);
FItems.Add(STitle);   {40}
FItems.Add(SAddAChild);
FItems.Add(SAddAParent);
FItems.Add(SAddASource);
FItems.Add(SAreYouSureToDelLnkToRep);
FItems.Add(SRepositoryModificati);
FItems.Add('Enter the depository #');
FItems.Add(SAddADepository);
FItems.Add(SAddAWitness);
FItems.Add('B - Birth events');
FItems.Add('D - Death events');{50}
FItems.Add('M - Union events');
FItems.Add('X - Other events');
FItems.Add('N - Names');
FItems.Add('R - Filiations');
FItems.Add('Z - Other relations');
FItems.Add(SAddAnEventNameOrRela);
FItems.Add(SChildren);
FItems.Add(SAreYouSureToDelLnkToChld);
FItems.Add(SEvents);
FItems.Add(''); {60}
FItems.Add(SOnlyTheExhibitsAssoc);
FItems.Add(SAreYouSureToDelDoc);
FItems.Add(SNOTITLENODESCRIPTION);
FItems.Add('image');
FItems.Add(SDocuments);
FItems.Add('she');
FItems.Add('he');
FItems.Add('her');
FItems.Add('his');
FItems.Add('daughter of '); {70}
FItems.Add('son of ');
FItems.Add(' and ');
FItems.Add(STOBEPROGRAMMED);
FItems.Add('first');
FItems.Add(SMonthJanuary);
FItems.Add(SMonthFebruary);
FItems.Add('march');
FItems.Add('april');
FItems.Add('may');
FItems.Add('june');           {80}
FItems.Add('july');
FItems.Add('august');
FItems.Add('september');
FItems.Add('october');
FItems.Add('november');
FItems.Add('december');
FItems.Add('before the ');
FItems.Add('before ');
FItems.Add('before a ');
FItems.Add(' of the year ');    {90}
FItems.Add('circa the ');
FItems.Add('circa ');
FItems.Add('circa a ');
FItems.Add('the ');
FItems.Add('in ');
FItems.Add('a ');
FItems.Add('after the ');
FItems.Add('after ');
FItems.Add('after a ');
FItems.Add('between the ');       {100}
FItems.Add('between ');
FItems.Add('between a ');
FItems.Add(' and the ');
FItems.Add(' and a ');
FItems.Add(' or the ');
FItems.Add(' or in ');
FItems.Add(' or a ');
FItems.Add('from ');
FItems.Add('from ');
FItems.Add('from a ');          {110}
FItems.Add(' to ');
FItems.Add(' to ');
FItems.Add(' to a ');
FItems.Add('c.');
FItems.Add(' or ');
FItems.Add('Siblings');
FItems.Add('Main document');
FItems.Add('Selected document');
FItems.Add('Merge with...');
FItems.Add('Enter the place # with "'); {120}
FItems.Add('" should merge');
FItems.Add('Not the same place (');
FItems.Add(') vs (');
FItems.Add('Error');
FItems.Add('Are you sure you want to delete place "');
FItems.Add('Names');
FItems.Add(') and attributes');
FItems.Add('To remove a primary name, select the new primary name.');
FItems.Add('Are you sure you want to delete the name "');
FItems.Add(SParents); {130}
FItems.Add('Are you sure you want to delete the link to the parent "');
FItems.Add('Are you sure you want to delete source "');
FItems.Add('Are you sure you want to delete "');
FItems.Add('Event');
FItems.Add('Witness');
FItems.Add('Date');
FItems.Add('# Source');
FItems.Add('Source');
FItems.Add('# Author');
FItems.Add('Author');    {140}
FItems.Add('Select the desired language file');
FItems.Add('About');
FItems.Add('Version:');
FItems.Add('Date:');
FItems.Add('by François Marchi & Joe Care');
FItems.Add('Ancestors');
FItems.Add('Connexion to database');
FItems.Add('Close');
FItems.Add('User:');
FItems.Add('Server:');    {150}
FItems.Add('Password:');
FItems.Add('Ok');
FItems.Add('Repositories');
FItems.Add('Title');
FItems.Add('Description');
FItems.Add('Memo');
FItems.Add('Individual');
FItems.Add('Usage');
FItems.Add('Descendants');
FItems.Add('Citation modification'); {160}
FItems.Add('Source:');
FItems.Add('Description:');
FItems.Add('Quality:');
FItems.Add('Cancel');
FItems.Add('Event modification');
FItems.Add('Type:');
FItems.Add('Witnesses:');
FItems.Add('(presentation):');
FItems.Add('(sort):');
FItems.Add('Place:');               {170}
FItems.Add('Memo:');
FItems.Add('Sentence:');
FItems.Add('(default)');
FItems.Add('Citations:');
FItems.Add('Role');
FItems.Add('Name');
FItems.Add('Q');
FItems.Add('Exhibit modification');
FItems.Add('Title:');
FItems.Add('File:');              {180}
FItems.Add('Visualise');
FItems.Add('Name modification');
FItems.Add('Individual:');
FItems.Add('Name:');
FItems.Add('Type');
FItems.Add('Relation modification');
FItems.Add('Parent:');
FItems.Add('Child:');
FItems.Add('Sort date:');
FItems.Add('Source modification'); {190}
FItems.Add('Author:');
FItems.Add('Default Quality:');
FItems.Add('Repositories:');
FItems.Add('Repository');
FItems.Add('Witness modification');
FItems.Add('Witness:');
FItems.Add('Role:');
FItems.Add('Result:');
FItems.Add('Event type modification');
FItems.Add('Child');               {200}
FItems.Add('Format');
FItems.Add('Explorer');
FItems.Add('Birth');
FItems.Add('Death');
FItems.Add('Sibling');
FItems.Add('Navigation history');
FItems.Add('Places');
FItems.Add('Preposition');
FItems.Add('Detail');
FItems.Add('City');                 {210}
FItems.Add('Region');
FItems.Add('State');
FItems.Add('Country');
FItems.Add('Names and Attributes');
FItems.Add('Last modification:');
FItems.Add('Parent');
FItems.Add('Exhibit display');
FItems.Add('Sources');
FItems.Add('Author');
FItems.Add('Event types');{220}
FItems.Add('Phrase');
FItems.Add(SGoTo);
FItems.Add('&Usage');
FItems.Add('&Add');
FItems.Add('&Modify');
FItems.Add('&Delete');
FItems.Add('&Witnesses');
FItems.Add('&Citations');
FItems.Add(SAddTitle);
FItems.Add(SAddFirstName);
FItems.Add('Add &surname');
FItems.Add('Add suffi&x');
FItems.Add('&Repositories');
FItems.Add('&Primary');
FItems.Add('Sort by &first name');
FItems.Add('Sort by &surname');
FItems.Add('Sort by &birth');
FItems.Add('Sort by &death');
FItems.Add('&Sort');
FItems.Add('by &detail'); {240}
FItems.Add('by &city');
FItems.Add('by &region');
FItems.Add('by &state');
FItems.Add('by countr&y');
FItems.Add('&Merge');
FItems.Add('by &number');
FItems.Add('by &title');
FItems.Add('&File');
FItems.Add('Conne&xion');
FItems.Add('&Create project');{250}
FItems.Add('&Open project');
FItems.Add('&Import project');
FItems.Add('&TMG v. 4.0d');
FItems.Add('Delete project');
FItems.Add('&Language');
FItems.Add('&Quit');
FItems.Add('&Edit');
FItems.Add('Copy');
FItems.Add('Cut');
FItems.Add('Paste');
FItems.Add('Copy &name');
FItems.Add('Copy indi&vidual');
FItems.Add('Delete individual');
FItems.Add('&Father');
FItems.Add('&Mother');
FItems.Add('&Broter');
FItems.Add('&Sister');
FItems.Add('S&on');
FItems.Add('&Daughter');
FItems.Add('S&pouse');
FItems.Add('&Unrelated');
FItems.Add('B&irth');
FItems.Add('Bap&tism');
FItems.Add('D&eath');
FItems.Add('Buria&l');
FItems.Add('&Navigation');
FItems.Add('By &number');
FItems.Add('&Previous explorer element');
FItems.Add('Ne&xt explorer element');
FItems.Add('Complete &history');
FItems.Add('&Tools');
FItems.Add('&Sources');
FItems.Add('&Places');
FItems.Add('&Event Types');
FItems.Add('&Window');
FItems.Add('&Explorer');
FItems.Add('&Names and attributes');
FItems.Add('E&vents');
FItems.Add('&Parents');
FItems.Add('E&xhibits');
FItems.Add('&Children');
FItems.Add('&Siblings');
FItems.Add('&Image');
FItems.Add('&Ancestors');
FItems.Add('&Descendants');
FItems.Add('&Help');
FItems.Add('&About');
FItems.Add('Exhibits:');
FItems.Add('" and "');
FItems.Add('Do you want to unite "');
FItems.Add('There must be at least one witness.');
FItems.Add('&Parameters');
FItems.Add('&PDF');
FItems.Add('Select the location of the PDF viewer');
FItems.Add('Executables');
FItems.Add('Language translation table');
FItems.Add('The deleted person must not be a depot, author of a source, have principal child, parents nor events where another person is a principal witness.');
FItems.Add('Copie &event');
FItems.Add('Copie Pa&rent');
FItems.Add('Copie &Child');
FItems.Add('Adding a father to ');
FItems.Add('Adding a mother to ');
FItems.Add('Adding a brother to ');
FItems.Add('Adding a son to ');
FItems.Add('Adding a daughter to ');
FItems.Add('Selection of the other principal parent');
FItems.Add('None for now...');
FItems.Add('Adding a spouse to ');
FItems.Add('E');
FItems.Add('ENGLISH');
FItems.Add('&Export project');
FItems.Add('&Website');
FItems.Add('SITEMAP files creation (1/3)');
FItems.Add('Index creation (2/3)');
FItems.Add('Database transfer file creation (3/3)');
FItems.Add('Directory where to create HTML/PHP files');
FItems.Add('Enter the web site server name or address');
FItems.Add('Server name');
FItems.Add('Enter the website database name');
FItems.Add('Database name');
FItems.Add('Enter the website MySQL username');
FItems.Add('Username');
FItems.Add('Enter the username password');
FItems.Add('Password');
FItems.Add('Database compression');
FItems.Add('Repair Birth-Death');
FItems.Add(SAddingASisterTo);
FItems.Add(SRemovalOfOrphanRecor);
FItems.Add(SRepairNamesForSortin);
FItems.Add(SRepairRelationSortDa);
end;

destructor TTranslation.Destroy;
begin
  freeandnil(Fitems);
end;

function TTranslation.GetItems(index: integer): String;
begin
  if (index>=0) and (index<Fitems.count) then
  result := Fitems[index];
end;

function TTranslation.GetlnCode: string;
begin
  result := GetDefaultLang;
end;

procedure TTranslation.LoadFromFile(aLanguage: string; out Success: boolean); overload;
begin
  Success:=false;
  if FileExists(aLanguage) then
    begin
      Fitems.LoadFromFile(aLanguage);
      LCLTranslator.SetDefaultLang(copy(aLanguage,1,2),'');
      Success:=true;
    end;
end;

procedure TTranslation.LoadFromFile(aLanguage: string);
var success:boolean;
begin
  LoadFromFile(aLanguage,Success);
end;


initialization
  Translation:=TTranslation.create;

finalization
  freeandnil(Translation);
end.

