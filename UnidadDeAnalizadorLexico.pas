
unit UnidadDeAnalizadorLexico;

interface

uses
   UnitArchivo, UnitListaPosicional;

procedure ComenzarPrograma(var Fuente: Text; var TablaSimb: DatoTablaSimb);
procedure LeerCar(var Fuente: Text; var car: char);
procedure ObtenerSiguienteCompLex(var Fuente: Text; var CompLex: TipoSimboloGramatical; var Lexema: String; var TS: DatoTablaSimb;Var Car:Char);
function EsIdentificador(var Fuente: Text; var Lexema: String; var Car: char): Boolean;
procedure AnadirPalabrasReservadas(var TablaSimb: DatoTablaSimb);

implementation

Procedure AnadirPalabrasReservadas(Var TablaSimb: DatoTablaSimb);
Begin
  TablaSimb.elem[1].Lexema := 'program'; TablaSimb.elem[1].CompLex := Tprogram;
  TablaSimb.elem[2].Lexema := 'begin';   TablaSimb.elem[2].CompLex := Tbegin;
  TablaSimb.elem[3].Lexema := 'end';     TablaSimb.elem[3].CompLex := Tend;
  TablaSimb.elem[4].Lexema := 'if';      TablaSimb.elem[4].CompLex := Tif;
  TablaSimb.elem[5].Lexema := 'then';    TablaSimb.elem[5].CompLex := Tthen;
  TablaSimb.elem[6].Lexema := 'else';    TablaSimb.elem[6].CompLex := Telse;
  TablaSimb.elem[7].Lexema := 'while';   TablaSimb.elem[7].CompLex := Twhile;
  TablaSimb.elem[8].Lexema := 'do';      TablaSimb.elem[8].CompLex := Tdo;
  TablaSimb.elem[9].Lexema := 'write';   TablaSimb.elem[9].CompLex := Twrite;
  TablaSimb.elem[10].Lexema := 'read';   TablaSimb.elem[10].CompLex := Tread;

  TablaSimb.cant := 10;
end;

Procedure InicializarListayArchivo(Var TablaSimb: DatoTablaSimb; Var Fuente: text);
Begin
  CrearLista(TablaSimb);
  AnadirPalabrasReservadas(TablaSimb);
  AsignarArchivo(Fuente);
  AbrirOCrearArchivo(Fuente);
end;

procedure ComenzarPrograma(Var Fuente: Text; Var TablaSimb: DatoTablaSimb);
Var
  CompLex: TipoSimboloGramatical;
  Lexema: String;
  Car: Char;
Begin
  InicializarListayArchivo(TablaSimb, Fuente);
  CompLex := None;
  Car := ' ';
  Lexema := '';

  LeerCar(Fuente, Car);

  While (CompLex <> Pesos) and (CompLex <> ErrorLexico) do
  Begin
    ObtenerSiguienteCompLex(Fuente, CompLex, Lexema, TablaSimb, Car);

    If (CompLex <> Pesos) and (CompLex <> ErrorLexico) then
      Write('(', CompLex, ',', Lexema, ')  ')
    Else If Complex = ErrorLexico then
      Writeln('SE ENCONTRO UN ERROR LEXICO')
    Else If CompLex = Pesos then
      Writeln('$');
  end;
  CerrarArchivo(Fuente);
  Readln;
end;

procedure LeerCar(var Fuente: Text; var car: char);
begin
  if not FinArchivo(Fuente) then
  begin
    LeerCaracter(Fuente, car);
  end
  else
  begin
    car := FinArch;
  end;
end;

Function EsIdentificador(Var Fuente: Text; Var Lexema: String; Var Car: char): Boolean;
Const
  F = [1];
  M = 2;
Type
  Q = 0..M;
  Sigma = (Letra, Digito, Guion, Otro);
  TipoDelta = Array[Q, Sigma] of Q;
Var
  EstadoActual, EstadoAnterior: Q;
  Delta: TipoDelta;

  Function CarASimbId(Car: Char): Sigma;
  Begin
    Case Car of
      'a'..'z', 'A'..'Z': CarASimbId := Letra;
      '0'..'9'          : CarASimbId := Digito;
      '_'               : CarASimbId := Guion;
    else
      CarASimbId := Otro;
    End;
  end;

Begin
  Delta[0,Letra]:=1; Delta[0,Digito]:=M; Delta[0,Otro]:=M; Delta[0,Guion]:=M;
  Delta[1,Letra]:=1; Delta[1,Digito]:=1; Delta[1,Guion]:=1; Delta[1,Otro]:=M;

  EstadoAnterior := 0;
  EstadoActual := 0;

  While (EstadoActual <> M) do
  Begin
    EstadoAnterior := EstadoActual;
    EstadoActual := Delta[EstadoActual, CarASimbId(Car)];

    if EstadoActual <> M then
    Begin
      lexema := lexema + car;
      LeerCar(Fuente, Car);
    end;
  end;

  If EstadoAnterior in F then
    EsIdentificador := True
  Else
    EsIdentificador := False;
End;

Function EsConstanteReal(Var Fuente: Text; Var car: Char; Var Lexema: String; Var CompLex: TipoSimboloGramatical): Boolean;
Const
  F = [1, 9, 6];
  NF = [3, 5, 8, 7, 10];
  M = 11;
Type
  Q = 0..M;
  Sigma = (Digito, Exp, Punto, Neg, Otro);
  TipoDelta = Array[Q, Sigma] of Q;
Var
  EstadoActual, EstadoAnterior: Q;
  Delta: TipoDelta;

  Function CarASimbReal(C: Char): Sigma;
  Begin
    Case C of
      '0'..'9': CarASimbReal := Digito;
      'e', 'E': CarASimbReal := Exp;
      '.'     : CarASimbReal := Punto;
      '-'     : CarASimbReal := Neg;
    else
      CarASimbReal := Otro;
    End;
  End;

Begin
  Delta[0,Digito]:=1; Delta[1,Digito]:=1; Delta[2,Digito]:=1; Delta[3,Digito]:=4;
  Delta[5,Digito]:=6; Delta[6,Digito]:=6; Delta[7,Digito]:=6; Delta[8,Digito]:=9;
  Delta[9,Digito]:=9; Delta[10,Digito]:=9;

  Delta[0,Exp]:=M; Delta[1,Exp]:=8; Delta[2,Exp]:=M; Delta[3,Exp]:=M; Delta[4,Exp]:=5;
  Delta[5,Exp]:=M; Delta[6,Exp]:=M; Delta[7,Exp]:=M; Delta[8,Exp]:=M; Delta[9,Exp]:=M;
  Delta[10,Exp]:=M;

  Delta[0,Punto]:=M; Delta[1,Punto]:=3; Delta[2,Punto]:=M; Delta[3,Punto]:=M;
  Delta[4,Punto]:=M; Delta[5,Punto]:=M; Delta[6,Punto]:=M; Delta[7,Punto]:=M;
  Delta[8,Punto]:=M; Delta[9,Punto]:=M; Delta[10,Punto]:=M;

  Delta[0,Neg]:=M; Delta[1,Neg]:=M; Delta[2,Neg]:=M; Delta[3,Neg]:=M; Delta[4,Neg]:=M;
  Delta[5,Neg]:=7; Delta[6,Neg]:=M; Delta[7,Neg]:=M; Delta[8,Neg]:=10; Delta[9,Neg]:=M;
  Delta[10,Neg]:=M;

  Delta[0,Otro]:=M; Delta[1,Otro]:=M; Delta[2,Otro]:=M; Delta[3,Otro]:=M; Delta[4,Otro]:=M;
  Delta[5,Otro]:=M; Delta[6,Otro]:=M; Delta[7,Otro]:=M; Delta[8,Otro]:=M; Delta[9,Otro]:=M;
  Delta[10,Otro]:=M;

  EstadoActual := 0;
  EstadoAnterior := 0;

  While (EstadoActual <> M) do
  Begin
    EstadoAnterior := EstadoActual;
    EstadoActual := Delta[EstadoActual, CarASimbReal(car)];

    If EstadoActual <> M then
    Begin
      Lexema := Lexema + car;
      LeerCar(Fuente, car);
    end;
  end;

  If EstadoAnterior in F then
    EsConstanteReal := TRUE
  Else If EstadoAnterior in NF then
  Begin
    CompLex := ErrorLexico;
    EsConstanteReal := TRUE;
  end
  Else
    EsConstanteReal := FALSE;
End;

Function EsOperadorRelacional(Var Fuente: Text; Var Lexema: String; Var Car: Char): Boolean;
Const
  F = [1, 2, 3, 4, 5];
  M = 6;
Type
  Q = 0..M;
  Sigma = (Menor, Mayor, Igual, Otro);
  TipoDelta = Array[Q, Sigma] of Q;
Var
  EstadoActual, EstadoAnterior: Q;
  Delta: TipoDelta;

  Function CarASimbRelacional(Car: Char): Sigma;
  Begin
    Case Car of
      '<' : CarASimbRelacional := Menor;
      '>' : CarASimbRelacional := Mayor;
      '=' : CarASimbRelacional := Igual;
    else
      CarASimbRelacional := Otro;
    End;
  End;

Begin
  Delta[0,Menor]:=1; Delta[1,Menor]:=M; Delta[2,Menor]:=M; Delta[3,Menor]:=M; Delta[4,Menor]:=M; Delta[5,Menor]:=M;
  Delta[0,Mayor]:=2; Delta[1,Mayor]:=4; Delta[2,Mayor]:=M; Delta[3,Mayor]:=M; Delta[4,Mayor]:=M; Delta[5,Mayor]:=M;
  Delta[0,Igual]:=3; Delta[1,Igual]:=5; Delta[2,Igual]:=5; Delta[3,Igual]:=M; Delta[4,Igual]:=M; Delta[5,Igual]:=M;
  Delta[0,Otro]:=M;  Delta[1,Otro]:=M;  Delta[2,Otro]:=M;  Delta[3,Otro]:=M;  Delta[4,Otro]:=M;  Delta[5,Otro]:=M;

  EstadoAnterior := 0;
  EstadoActual := 0;

  While (EstadoActual <> M) do
  Begin
    EstadoAnterior := EstadoActual;
    EstadoActual := Delta[EstadoActual, CarASimbRelacional(Car)];
    If EstadoActual <> M then
    Begin
      Lexema := Lexema + car;
      LeerCar(Fuente, Car);
    end;
  end;

  EsOperadorRelacional := EstadoAnterior in F;
End;

Function EsConstanteCadena(Var Fuente: Text; Var car: Char; Var Lexema: String): Boolean;
Const
  F = [2];
  NF = [1];
  M = 3;
Type
  Q = 0..M;
  Sigma = (Comilla, Control, Otro);
  TipoDelta = Array[Q, Sigma] of Q;
Var
  EstadoActual, EstadoAnterior: Q;
  Delta: TipoDelta;

  Function CarASimbCadena(C: Char): Sigma;
  Begin
    Case C of
      '"': CarASimbCadena := Comilla;
      #0..#31, #127: CarASimbCadena := Control;
    else
      CarASimbCadena := Otro;
    End;
  End;

Begin
  Delta[0,Comilla]:=1; Delta[0,Control]:=M; Delta[0,Otro]:=M;
  Delta[1,Comilla]:=2; Delta[1,Control]:=M; Delta[1,Otro]:=1;
  Delta[2,Comilla]:=M; Delta[2,Control]:=M; Delta[2,Otro]:=M;

  EstadoAnterior := 0;
  EstadoActual := 0;

  While (EstadoActual <> M) do
  Begin
    EstadoAnterior := EstadoActual;
    EstadoActual := Delta[EstadoActual, CarASimbCadena(car)];
    If EstadoActual <> M then
    Begin
      Lexema := Lexema + car;
      LeerCar(Fuente, car);
    End;
  end;

  if EstadoAnterior in F then
    EsConstanteCadena := true
  else if EstadoAnterior in NF then
  Begin
    EsConstanteCadena := False;
  end;
End;

Function EsSimboloEspecial(Var Fuente: Text; Var Lexema: String; Var CompLex: TipoSimboloGramatical; Var Car: Char): Boolean;
Begin

  Case Car of
    ':': Begin
           Lexema := Lexema + Car;
           LeerCar(Fuente, Car);
           Case Car of
             '=': Begin
                    CompLex := TopAsign;
                  End;
             Else
               CompLex := ErrorLexico;
           End;
           end;
             '+': CompLex := Tmas;
             '-': CompLex := Tmenos;
             '/': CompLex := Tdivision;
             '*': CompLex := Tproducto;
             '(': CompLex := TParenA;
             ')': CompLex := TParenC;
             ',': CompLex := Tcoma;
             ';': CompLex := TpuntoYComa;
             '.': CompLex := Tpunto;
             Else
               CompLex := ErrorLexico;
    end;

  If CompLex <> ErrorLexico then
  Begin
    Lexema := Lexema + Car;
    LeerCar(Fuente,Car);
    EsSimboloEspecial := TRUE;
  end
  Else
    EsSimboloEspecial := FALSE;
end;

Function ExisteEnTs(Lexema: String; Var TS: DatoTablaSimb; Var CompLex: TipoSimboloGramatical): Boolean;
var
  X: TElemTS;
Begin
  X.Lexema := LowerCase(Lexema);
  X.compLex := CompLex;
  ExisteEnTs := Localizar(TS, CompLex, X);
end;

Procedure InstalarEnTS(Lexema: String; Var TS: DatoTablaSimb; CompLex: TipoSimboloGramatical);
var
  X: TElemTS;
Begin
  X.Lexema := LowerCase(Lexema);
  X.compLex := CompLex;
  Insertar(TS, X, TS.cant + 1);
end;

Procedure ObtenerSiguienteCompLex(Var Fuente: Text; Var CompLex: TipoSimboloGramatical; Var Lexema: String; Var TS: DatoTablaSimb; Var Car: Char);
Begin
  Lexema := '';

  While (Car in [#0..#32]) and (Car <> FinArch) do
  Begin
    LeerCar(Fuente, Car);
  End;

  If Car = FinArch then
  Begin
    CompLex := Pesos;
  End
  Else
  Begin
    If EsIdentificador(Fuente, Lexema, Car) then
    Begin
      CompLex := Tid;
      if not ExisteEnTs(Lexema, TS, CompLex) then
        InstalarEnTS(Lexema, TS, CompLex);
    end
    else If EsConstanteReal(Fuente, Car, Lexema, CompLex) then
    Begin
      If CompLex <> ErrorLexico then
        CompLex := TcReal;
    end
    else If EsOperadorRelacional(Fuente, Lexema, Car) then
      CompLex := TopRel
    else if EsConstanteCadena(Fuente, Car, Lexema) then
      CompLex := Tcad
    else if Not EsSimboloEspecial(Fuente, Lexema, CompLex, Car) then
      LeerCar(Fuente, Car);
  End;
end;

end.