unit UnitListaPosicional;

interface

const
  MaxSim = 200;
  FinArch = #0;

type
  TipoSimboloGramatical = (Tid, TcReal, Tcad, TParenA, TParenC, Tmas, Tmenos, Tproducto, Tdivision, TpuntoYComa,
                           Tcoma, Tpunto, TopRel, TopAsign, Tprogram, Tbegin, Tend, Tif, Tthen, Telse, Twhile, Tdo, Tread, Twrite, ErrorLexico, Pesos, None);

  TElemTS = record
    compLex: TipoSimboloGramatical;
    Lexema: string[100];
  end;

  DatoTablaSimb = record
    elem: array[1..MaxSim] of TElemTS;
    cant: 0..MaxSim;

  end;

  Var Lista:DatoTablaSimb;



procedure CrearLista(var L: DatoTablaSimb);
function EsVacia(L: DatoTablaSimb): boolean;
function EsLlena(L: DatoTablaSimb): boolean;
function Longitud(L: DatoTablaSimb): integer;
procedure Insertar(var L: DatoTablaSimb; X: TElemTS; P: integer);
procedure Eliminar(var L: DatoTablaSimb; P: integer);
function Recuperar(L: DatoTablaSimb; P: integer): TElemTS;
function Localizar(L: DatoTablaSimb; Var CompLex: TipoSimboloGramatical; X: TElemTS): Boolean;

implementation

procedure DesplazarDerecha(var L: DatoTablaSimb; P: integer);
var
  i: integer;
begin
  for i := L.cant downto P do
    L.elem[i + 1] := L.elem[i];
end;

procedure DesplazarIzquierda(var L: DatoTablaSimb; P: integer);
var
  i: integer;
begin
  for i := P to L.cant - 1 do
    L.elem[i] := L.elem[i + 1];
end;

procedure CrearLista(var L: DatoTablaSimb);
begin
  L.cant := 0;
end;

function EsVacia(L: DatoTablaSimb): boolean;
begin
  EsVacia := L.cant = 0;
end;

function EsLlena(L: DatoTablaSimb): boolean;
begin
  EsLlena := L.cant = MaxSim;
end;

function Longitud(L: DatoTablaSimb): integer;
begin
  Longitud := L.cant;
end;

procedure Insertar(var L: DatoTablaSimb; X: TElemTS; P: integer);
begin
  if EsLlena(L) then
    writeln('Error: La lista está llena.')
  else
  begin
    DesplazarDerecha(L, P);
    L.elem[P] := X;
    L.cant := L.cant + 1;
  end;
end;

procedure Eliminar(var L: DatoTablaSimb; P: integer);
begin
  if EsVacia(L) then
    writeln('Error: La lista está vacía.')
  else
  begin
    DesplazarIzquierda(L, P);
    L.cant := L.cant - 1;
  end;
end;

function Recuperar(L: DatoTablaSimb; P: integer): TElemTS;
begin
    Recuperar := L.elem[P]
end;

function Localizar(L: DatoTablaSimb; Var CompLex: TipoSimboloGramatical; X: TElemTS): boolean;
var
  encontrado: boolean;
  i:integer;
begin
  encontrado := false;
  i := 1;

  while (i <= L.cant) and (not encontrado) do
  begin
    if L.elem[i].Lexema = X.Lexema then
      Begin
      encontrado := true;
      CompLex := L.elem[i].CompLex;
      end
    else
      i := i + 1;
  end;

   Localizar := encontrado;
end;

end.