unit unt_VIDSYNC;

interface

procedure HSync;

function VSync:word;

procedure RGB (color, red, green, blue : byte;s:boolean);

implementation

procedure RGB;

  asm
//    mov dx,$03c8
//    mov al,color
//    out Dx, al
//    mov dx,$03c9
//    mov al,red
//    out dx, al
//    mov al,green
//    out dx, al
//    mov al,blue
//    out dx, al
  end;



procedure HSync;assembler;

asm

end;

function vSync;assembler;

asm

end;

end.
