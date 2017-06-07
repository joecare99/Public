unit Unt_DetectVMWare;

interface

function IsInsideVMWare: Boolean;

procedure Execute;

implementation


uses SysUtils;

{
  This function can be used to determine whether your program is
  running from within VMWare.

  For more information please refer to the article at:
  http://www.codeproject.com/system/VmDetect.asp
}

function IsInsideVMWare: Boolean;
var
  rc: Boolean;
begin
  rc := False;

  try
    asm
      push   edx
      push   ecx
      push   ebx

      mov    eax, 'VMXh'
      mov    ebx, 0 // any value but not the MAGIC VALUE
      mov    ecx, 10 // get VMWare version
      mov    edx, 'VX' // port number

      in     eax, dx // read port
                     // on return EAX returns the VERSION
      cmp    ebx, 'VMXh' // is it a reply from VMWare?
      setz   [rc] // set return value

      pop    ebx
      pop    ecx
      pop    edx
    end;
  except
    on EPrivilege do rc := False;
  end;

  Result := rc;
end;

procedure Execute;

begin

  Write('IsInsideVMWare:');
  if IsInsideVMWare then
    WriteLn('Yes')
  else
    WriteLn('No');
end;


end.
