program Server2; 
uses 
  Forms, 
  Frm_SERVER2 in '..\Source\DDE2\Frm_SERVER2.PAS' {ServerForm}; 
{$R *.RES} 
{$E EXE} 
begin 
Application.Initialize; 
  Application.Title := 'Demo: Server2'; 
  Application.CreateForm(TServerForm, ServerForm); 
  Application.Run; 
end. 
