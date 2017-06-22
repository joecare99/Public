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
  rsAdd = '&Add';
  rsAddAChild = 'Add a child';
  rsAddACitation = 'Add a citation';
  rsAddADepository = 'Add a depository';
  rsAddADocument = 'Add a Document';
  rsAddAName = 'Add a name';
  rsAddAnEvent = 'Add an event';
  rsAddAnEventNameOrRela = 'Add an event, name or relation type';
  rsAddAnIndividual = 'Add an individual';
  rsAddAParent = 'Add a parent';
  rsAddASource = 'Add a source';
  rsAddAWitness = 'Add a witness';
  rsAddFirstName = 'Add &first name';
  rsAddingASisterTo = 'Adding a sister to ';
  rsAddTitle = 'Add &title';
  rsAreYouSureToDelX = 'Are you sure you want to delete %s "%s%" ?';
  rsAreYouSureToDelDoc = 'Are you sure you want to delete exhibit "';
  rsAreYouSureToDelete   = 'Are you sure you want to delete "%s" ?';
  rsAreYouSureToDelLnkToChld = 'Are you sure you want to delete the link to the'
    +' child "';
  rsAreYouSureToDelLnkToRep = 'Are you sure you want to delete the link to the '
    +'depository "';
  rsAreYouSureToDelRepository = 'Are you sure you want to delete repository "';
  rsAreYouSureToDelWitness = 'Are you sure you want to delete witness "';
  rsAreYouSureToQuit	= 'Are you sure you want to quit STEMMA?';
  rsChildren = 'Children';
  rsCitation = 'Citation';
  rsDatabaseAlreadyExist = 'Database already exist.';
  rsDatabaseNotFound = 'Database not found.';
  rsDateBeforeThe = 'before the ';
  rsDelete = '&Delete';
  rsDispNameAndLiveDate = '%s (%s - %s)';
  rsDispNameIdAndLiveDate = '%s [%d] (%s - %s)';
  rsDocumentModification = 'Exhibit modification';
  rsDocuments = 'Documents';
  rsDocument = 'Document';
  rsEnterDBNameToCreate		= 'Enter the database name to be created';
  rsEnterDBName = 'Enter the database name';
  rsEnterDBNameToDel = 'Enter the database name to delete';
  rsEnterNumberOfIndividual = 'Enter the number of the desired individual';
  rsEnterTheDepositoryNo = 'Enter the depository #';
  rsEvents = 'Events';
  rsGoTo = '&Go to';
  rsLocationOfTheTMG40dD = 'Location of the TMG 4.0d database';
  rsMarriedWith =' & %s (of %d)';
  rsMenuBirthEvents = 'B - Birth events';
  rsMenuDeathEvents = 'D - Death events';
  rsMenuHistoryCaption = '&%d- %s (%d)';
  rsModify = '&Modify';
  rsMonthApril = 'april';
  rsMonthFebruary = 'february';
  rsMonthJanuary = 'january';
  rsMonthJune = 'june';
  rsMonthMarch = 'march';
  rsMonthMay = 'may';
  rsNOTITLENODESCRIPTION = 'NO TITLE, NO DESCRIPTION';
  rsNameGivenName		= 'First name';
  rsNameSuffix		= 'Suffix';
  rsNameSurName		= 'Name';
  rsNameTitle		= 'Title';
  rsNumberOfTheIndividua = 'Number of the individual';
  rsOnlyTheExhibitsAssoc = 'Only the exhibits associated to an individual (type'
    +' "I") can be modified this way';
  rsParents = 'Parents';
  rsRemovalOfOrphanRecor = 'Removal of orphan records';
  rsRepositories = '&Repositories';
  rsSiblings = 'Siblings';
  rsUsage = '&Usage';
  SRepairNamesForSortin = 'Repair names (for sorting)';
  SRepairRelationSortDa = 'Repair relation sort date';
  SRepositoryModificati = 'Depository modification';
  SStep112EventTypeImpo = 'Step 1/12 - Event type importation';
  SStep212SourceReposit = 'Step 2/12 - Source-repository association '
    +'importation';
  SStep312RepositoryImp = 'Step 3/12 - Repository importation';
  rsText = 'Text';
  STheIndividualNotFound = 'The individual %s has not been found.';
  rsTOBEPROGRAMMED = 'TO BE PROGRAMMED';
  SUnableToConnectToDB 	= 'Couldn''t connect to MySQL database %s.';
  SConfirmation		= 'Confirmation';
  SDatabaseName 	= 'Database name';
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
FItems.Add(rsEnterDBNameToCreate);
FItems.Add(rsDatabaseAlreadyExist);
FItems.Add(rsLocationOfTheTMG40dD);
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
FItems.Add(rsNumberOfTheIndividua); {20}
FItems.Add(rsEnterNumberOfIndividual);
FItems.Add('');
FItems.Add('');
FItems.Add(rsEnterDBNameToDel);
FItems.Add(rsEnterDBName);
FItems.Add(rsDatabaseNotFound);
FItems.Add(rsAreYouSureToDelRepository);
FItems.Add('" ?');
FItems.Add(rsAddACitation);
FItems.Add(rsAddAnEvent); {30}
FItems.Add(rsAreYouSureToDelX);
FItems.Add(rsAreYouSureToDelWitness);
FItems.Add(rsAddADocument);
FItems.Add(rsText);
FItems.Add(rsAddAnIndividual);
FItems.Add(rsAddAName);
FItems.Add(rsNameSurName);
FItems.Add(rsNameGivenName);
FItems.Add(rsNameSuffix);
FItems.Add(rsNameTitle);   {40}
FItems.Add(rsAddAChild);
FItems.Add(rsAddAParent);
FItems.Add(rsAddASource);
FItems.Add(rsAreYouSureToDelLnkToRep);
FItems.Add(SRepositoryModificati);
FItems.Add(rsEnterTheDepositoryNo);
FItems.Add(rsAddADepository);
FItems.Add(rsAddAWitness);
FItems.Add(rsMenuBirthEvents);
FItems.Add(rsMenuDeathEvents); {50}
FItems.Add('M - Union events');
FItems.Add('X - Other events');
FItems.Add('N - Names');
FItems.Add('R - Filiations');
FItems.Add('Z - Other relations');
FItems.Add(rsAddAnEventNameOrRela);
FItems.Add(rsChildren);
FItems.Add(rsAreYouSureToDelLnkToChld);
FItems.Add(rsEvents);
FItems.Add(''); {60}
FItems.Add(rsOnlyTheExhibitsAssoc);
FItems.Add(rsAreYouSureToDelDoc);
FItems.Add(rsNOTITLENODESCRIPTION);
FItems.Add('image');
FItems.Add(rsDocuments);
FItems.Add('she');
FItems.Add('he');
FItems.Add('her');
FItems.Add('his');
FItems.Add('daughter of '); {70}
FItems.Add('son of ');
FItems.Add(' and ');
FItems.Add(rsTOBEPROGRAMMED);
FItems.Add('first');
FItems.Add(rsMonthJanuary);
FItems.Add(rsMonthFebruary);
FItems.Add(rsMonthMarch);
FItems.Add(rsMonthApril);
FItems.Add(rsMonthMay);
FItems.Add(rsMonthJune);           {80}
FItems.Add('july');
FItems.Add('august');
FItems.Add('september');
FItems.Add('october');
FItems.Add('november');
FItems.Add('december');
FItems.Add(rsDateBeforeThe);
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
FItems.Add(rsSiblings);
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
FItems.Add(rsParents); {130}
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
FItems.Add(rsDocumentModification);
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
FItems.Add(rsGoTo);
FItems.Add(rsUsage);
FItems.Add(rsAdd);
FItems.Add(rsModify);
FItems.Add(rsDelete);
FItems.Add('&Witnesses');
FItems.Add('&Citations');
FItems.Add(rsAddTitle);
FItems.Add(rsAddFirstName); {230}
FItems.Add('Add &surname');
FItems.Add('Add suffi&x');
FItems.Add(rsRepositories);
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
FItems.Add(rsAddingASisterTo);
FItems.Add(rsRemovalOfOrphanRecor);
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

