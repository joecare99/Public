program Stemma;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  DefaultTranslator,sysutils,
  Interfaces, // this includes the LCL widgetset
  Forms, dbflaz, anchordockpkg, frm_Main, FMUtils, frm_ConnectDB,
  frm_Names, frm_Explorer,
frm_parents, frm_History, frm_Children, frm_Siblings,
  frm_Events, 
frm_Documents, frm_Ancesters, frm_Descendants, frm_EditDocuments, frm_ShowImage,
  frm_Images, frm_EditParents, frm_EditCitations,
frm_EditName, frm_EditEvents, frm_EditWitness,
  frm_Places, frm_Usage, frm_Sources, 
frm_Repositories, frm_EditSource, frm_Types, frm_EditTypes,
  frm_About, frm_SelectPerson, dm_GenData, Traduction,uScaleDPI, 
frm_SelectDialog;

{$R *.res}

function GetApplicationName: string;
begin
  Result := 'Stemma';
end;

function GetVendorName: string;
begin
  Result := 'JC-Soft';
end;


begin
  Application.Initialize;
  OnGetApplicationName:=@GetApplicationName;
  OnGetVendorName:=@GetVendorName;
  Application.CreateForm(TfrmStemmaMainForm, frmStemmaMainForm);
  Application.CreateForm(TfrmConnectDb, frmConnectDb);
  Application.CreateForm(TfrmNames, frmNames);
  Application.CreateForm(TfrmExplorer, frmExplorer);
  Application.CreateForm(TfrmChildren, frmChildren);
  Application.CreateForm(TfrmHistory, frmHistory);
  Application.CreateForm(TfrmParents, frmParents);
  Application.CreateForm(TfrmSiblings, frmSiblings);
  Application.CreateForm(TfrmEvents, frmEvents);
  Application.CreateForm(TfrmDocuments, frmDocuments);
  Application.CreateForm(TFormAncetres, FormAncetres);
  Application.CreateForm(TFormDescendants, FormDescendants);
  Application.CreateForm(TfrmEditDocuments, frmEditDocuments);
  Application.CreateForm(TfrmShowImage, frmShowImage);
  Application.CreateForm(TFormImage, FormImage);
  Application.CreateForm(TfrmEditParents, frmEditParents);
  Application.CreateForm(TEditCitations, EditCitations);
  Application.CreateForm(TfrmEditName, frmEditName);
  Application.CreateForm(TfrmEditEvents, frmEditEvents);
  Application.CreateForm(TfrmEditWitness, frmEditWitness);
  Application.CreateForm(TFormLieux, FormLieux);
  Application.CreateForm(TfrmEventUsage, frmEventUsage);
  Application.CreateForm(TFormSources, FormSources);
  Application.CreateForm(TfrmRepository, frmRepository);
  Application.CreateForm(TEditSource, EditSource);
  Application.CreateForm(TfrmTypes, frmTypes);
  Application.CreateForm(TEditType, EditType);
  Application.CreateForm(Tapropos, apropos);
  Application.CreateForm(TFormSelectPersonne, FormSelectPersonne);
  Application.CreateForm(TdmGenData, dmGenData);
  HighDPI(-1);
  Application.CreateForm(TfrmSelectDialog, frmSelectDialog);
  Application.Run;
end.

