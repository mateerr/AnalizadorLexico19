unit UnitArchivo;

interface

uses
  crt;

const
  rutaFuente = '.\Fuente.txt';

var
  Fuente: Text;

procedure AsignarArchivo(var Fuente: Text);
procedure AbrirOCrearArchivo(var Fuente: Text);
procedure CerrarArchivo(var Fuente: Text);
procedure LeerCaracter(var Fuente: Text; var x: char);
function FinArchivo(var Fuente: Text): boolean;

implementation

procedure AsignarArchivo(var Fuente: Text);
begin
  Assign(Fuente, rutaFuente);
end;

procedure AbrirOCrearArchivo(var Fuente: Text);
begin
  {$I-}
  Reset(Fuente);
  if IOResult <> 0 then
    Begin
    Rewrite(Fuente);
    Close(Fuente);
    Reset(Fuente);
    end;
  {$I+}
end;

procedure CerrarArchivo(var Fuente: Text);
begin
  Close(Fuente);
end;

procedure LeerCaracter(var Fuente: Text; var x: char);
begin
  Read(Fuente, x);
end;

function FinArchivo(var Fuente: Text): boolean;
begin
  FinArchivo := EOF(Fuente);
end;

end.