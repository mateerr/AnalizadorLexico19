unit UnidadDeAnalizadorLexico;


interface

uses
     crt,UnitArchivo;

   procedure ComenzarPrograma(Var Fuente:tFileChar;Var TablaSimb:tFileTS);
   procedure LeerCar(var Fuente:tFileChar;var control:Longint; var car:char);
   Procedure ObtenerSiguienteCompLex(Var Fuente:tFileChar;Var Control:Longint; Var CompLex:TipoSimboloGramatical;Var Lexema:String;Var TS:tFileTS);
   Function CarASimbId(Car:Char):byte;
   Function EsIdentificador(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String):Boolean;
   Procedure AnadirPalabrasReservadas(Var TS:tFileTS);

implementation

Procedure AnadirPalabrasReservadas(Var TS:tFileTS);
Type
  VectorPalabraReservadas = Array[1..10] of TElemTS;
Var
  i:0..10;x:DatoTablaSimb;PalabraReservadas:VectorPalabraReservadas;
Begin
     PalabraReservadas[1].Lexema := 'program';PalabraReservadas[1].CompLex := TipoSimboloGramatical(14);
     PalabraReservadas[2].Lexema := 'begin';PalabraReservadas[2].CompLex := TipoSimboloGramatical(15);
     PalabraReservadas[3].Lexema := 'end';PalabraReservadas[3].CompLex := TipoSimboloGramatical(16);
     PalabraReservadas[4].Lexema := 'if'; PalabraReservadas[4].CompLex := TipoSimboloGramatical(17);
     PalabraReservadas[5].Lexema := 'then';   PalabraReservadas[5].CompLex := TipoSimboloGramatical(18);
     PalabraReservadas[6].Lexema := 'else';  PalabraReservadas[6].CompLex := TipoSimboloGramatical(19);
     PalabraReservadas[7].Lexema := 'while'; PalabraReservadas[7].CompLex := TipoSimboloGramatical(20);
     PalabraReservadas[8].Lexema := 'do'; PalabraReservadas[8].CompLex := TipoSimboloGramatical(21);
     PalabraReservadas[9].Lexema := 'write'; PalabraReservadas[9].CompLex := TipoSimboloGramatical(22);
     PalabraReservadas[10].Lexema:= 'read'; PalabraReservadas[10].CompLex := TipoSimboloGramatical(23);
  AbrirOCrearArchivoTS(TS);
  i := 0;
  While i < 10 do
  Begin
    Seek(TS,i);
    x.elem[i+1].Lexema:=PalabraReservadas[i+1].Lexema;
    x.elem[i+1].CompLex:=PalabraReservadas[i+1].CompLex;
    Write(TS,x);
    inc(i);
  end;
   i := 0;
  {While i < 10 do
  Begin
    Seek(TS,i);
    Read(TS,x);
    Writeln('(',x.elem[i+1].CompLex,',',x.elem[i+1].Lexema,')');
    inc(i);
  end;
  Readkey;}
end;

procedure ComenzarPrograma(Var Fuente:tFileChar;Var TablaSimb:tFileTS);
Var Control:Longint;CompLex:TipoSimboloGramatical;Lexema:String;
   Begin
     AsignarArchivoChar(Fuente);
     AsignarArchivoTS(TablaSimb);
     AbrirOCrearArchivoChar(Fuente);
     CompLex := TipoSimboloGramatical(Inicial);
     Control := 0;
     Lexema := '';
     While (Not FinArchivo(Fuente)) and (CompLex <> TipoSimboloGramatical(ErrorLexico)) do
     Begin
       CompLex := TipoSimboloGramatical(Inicial);
         ObtenerSiguienteCompLex(Fuente,Control,CompLex,Lexema,TablaSimb);
         end;
     CerrarArchivoChar(Fuente);
     end;
procedure LeerCar(var Fuente:tFileChar;var control:Longint; var car:char);
begin

  if control< filesize(Fuente) then
    begin
      LeerArchivoChar(Fuente,car,control);
    end
  else
      begin
        car:=FinArch;
      end;
end;

Function CarASimbId(Car:Char):byte;
Begin
  Case Car of
    'a'..'z', 'A'..'Z':CarASimbId:=0;
    '0'..'9'          :CarASimbId:=1;
    '_'               :CarASimbId:=2;
  else
    CarASimbId:=3
  End;
end;

Function EsIdentificador(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String):Boolean;
Const
  F=[1];
  M=2;
Type
  Q=0..2;
  Sigma=(Letra, Digito, Guion, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual,EstadoAnterior:Q;
  Delta:TipoDelta;
  car:char;
Begin
  Delta[0,Letra]:=1;Delta[0,Digito]:=M;Delta[0,Otro]:=M;Delta[0,Guion]:=M;
  Delta[1,Letra]:=1;Delta[1,Digito]:=1;Delta[1,Guion]:=1;Delta[1,Otro]:=M;

  EstadoAnterior:=0;
  EstadoActual:=0;
  lexema := '';
  Car := ' ';

  While (EstadoActual <> M) and (not FinArchivo(Fuente)) do
  Begin

    LeerCar(Fuente,Control,Car);
    EstadoAnterior := EstadoActual;
    EstadoActual:=Delta[EstadoActual,Sigma(CarASimbId(Car))];

    if EstadoActual <> M then
      Begin
      lexema:=lexema+car;
      inc(control);
      end;

  end;



  If EstadoAnterior in F then
    EsIdentificador:=True
    Else
      EsIdentificador:=False;

End;

Function CarASimbReal(Car:Char):byte;
Begin
  Case Car of
    '0'..'9'          :CarASimbReal:=0;
    'e'               :CarASimbReal:=1;
    '.'               :CarASimbReal:=2;
    '-'               :CarASimbReal:=3;
  else
    CarASimbReal:=4;
  End;
End;

Function EsConstanteReal(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String):Boolean;
Const
  F=[1, 9, 6];
  NF1 = [3,5,8];
  NF2 = [7,10];
  M = 11;
Type
  Q=0..M;
  Sigma=(Digito, Exp, Punto, Neg, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual,EstadoAnterior:Q;
  Delta:TipoDelta;
  car:char;
Begin
  Delta[0,Digito]:=1;Delta[1,Digito]:=1;Delta[2,Digito]:=1;Delta[3,Digito]:=4;
  Delta[5,Digito]:=6;Delta[6,Digito]:=6;Delta[7,Digito]:=6;Delta[8,Digito]:=9;
  Delta[9,Digito]:=9;Delta[10,Digito]:=9;

  Delta[0,Exp]:=M; Delta[1,Exp]:=8;Delta[2,Exp]:=M;Delta[3,Exp]:=M;Delta[4,Exp]:=5;
  Delta[5,Exp]:=M;Delta[6,Exp]:=M;Delta[7,Exp]:=M;Delta[8,Exp]:=M;Delta[9,Exp]:=M;
  Delta[10,Exp]:=M;

  Delta[0,Punto]:=M;Delta[1,Punto]:=3;Delta[2,Punto]:=M;Delta[3,Punto]:=M;
  Delta[4,Punto]:=M;Delta[5,Punto]:=M;Delta[6,Punto]:=M;Delta[7,Punto]:=M;
  Delta[8,Punto]:=M;Delta[9,Punto]:=M;Delta[10,Punto]:=M;

  Delta[0,Neg]:=2;Delta[1,Neg]:=M;Delta[2,Neg]:=M;Delta[3,Neg]:=M;Delta[4,Neg]:=M;Delta[5,Neg]:=7;
  Delta[6,Neg]:=M;Delta[7,Neg]:=M;Delta[8,Neg]:=10;Delta[9,Neg]:=M;Delta[10,Neg]:=M;

  Delta[0,Otro]:=M;Delta[1,Otro]:=M;Delta[2,Otro]:=M;Delta[3,Otro]:=M;Delta[4,Otro]:=M;Delta[5,Otro]:=M;
  Delta[6,Otro]:=M;Delta[7,Otro]:=M;Delta[8,Otro]:=M;Delta[9,Otro]:=M;Delta[10,Otro]:=M;

  Lexema := '';
  EstadoActual:=0;
  car := ' ';

  While (EstadoActual <> M) and (not FinArchivo(Fuente)) do
  Begin

    LeerCar(Fuente,Control,Car);
    EstadoAnterior := EstadoActual;
    EstadoActual:=Delta[EstadoActual,Sigma(CarASimbReal(car))];
    If EstadoActual <> M then
      Begin
      Lexema := Lexema + car;
      Inc(Control);
      end;
  end;

  If EstadoAnterior in F then
  EsConstanteReal:= TRUE
  Else If EstadoAnterior in NF1 then
  Begin
      Delete(Lexema,Length(Lexema),1);
      Dec(control);
      EsConstanteReal:= TRUE
  end
  Else If EstadoAnterior in NF2 then
  Begin
       Delete(Lexema,Length(Lexema) - 1,2);
       control := control - 2;
       EsConstanteReal:= TRUE
  end
  Else EsConstanteReal:= False;
End;

Function CarASimbRelacional(Car:Char):byte;
Begin

  Case Car of
    '<'          :CarASimbRelacional:=0;
    '>'          :CarASimbRelacional:=1;
    '='          :CarASimbRelacional:=2;
  else
    CarASimbRelacional:=3
  End;
End;


Function EsOperadorRelacional(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String):Boolean;
Const
  F=[1,2,3,4,5];
  M=6;
Type
  Q=0..M;
  Sigma=(Menor, Mayor, Igual, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual,EstadoAnterior:Q;
  Delta:TipoDelta;
  Car:Char;
Begin

  Delta[0,Menor]:=1;Delta[1,Menor]:=M;Delta[2,Menor]:=M;Delta[3,Menor]:=M;
  Delta[4,Menor]:=M;Delta[5,Menor]:=M;

  Delta[0,Mayor]:=2;Delta[1,Mayor]:=4;Delta[2,Mayor]:=M;Delta[3,Mayor]:=M;
  Delta[4,Mayor]:=M;Delta[5,Mayor]:=M;

  Delta[0,Igual]:=3;Delta[1,Igual]:=5;Delta[2,Igual]:=5;Delta[3,Igual]:=M;
  Delta[4,Igual]:=M;Delta[5,Igual]:=M;

  Delta[0,Otro]:=M;Delta[1,Otro]:=M;Delta[2,Otro]:=M;Delta[3,Otro]:=M;
  Delta[4,Otro]:=M;Delta[5,Otro]:=M;

  Lexema := '';
  EstadoActual:=0;
  car :=' ';


  While (EstadoActual <> M) and (not FinArchivo(Fuente)) do

  Begin
    LeerCar(Fuente,Control,Car);
    EstadoAnterior:=EstadoActual;
    EstadoActual:=Delta[EstadoActual,Sigma(CarASimbRelacional(Car))];
    If EstadoActual <> M then
      Begin
      Lexema := Lexema + car;
      Inc(Control);
      end;
  end;

  EsOperadorRelacional:=EstadoAnterior in F;
End;

Function CarASimbCadena(Car:Char):Byte;
Begin

  Case Car of
    '"'          :CarASimbCadena:=0;
  else
    CarASimbCadena:=1
  End;
End;


Function EsConstanteCadena(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String):Boolean;
Const
  F=[2];
  NF=[1];
  M = 3;
Type
  Q=0..M;
  Sigma=(Comilla, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual,EstadoAnterior:Q;
  Delta:TipoDelta;
  car:Char;
Begin

  Delta[0,Comilla]:=1; Delta[0,Otro]:=M;

  Delta[1,Comilla]:=2; Delta[1,Otro]:=1;

  Delta[2,Comilla]:=M; Delta[2, Otro]:=M;

  Lexema := '';
  EstadoActual:=0;
  car :=' ';

  While (EstadoActual <> M) and (not FinArchivo(Fuente)) do
  Begin

    LeerCar(Fuente,Control,Car);
    EstadoAnterior:= EstadoActual;
    EstadoActual:=Delta[EstadoActual,Sigma(CarASimbCadena(car))];
    If EstadoActual <> M then
    Begin
    Lexema := Lexema + car;
    Inc(control);
    End;
  end;

  if EstadoAnterior in F then
     EsConstanteCadena:= true
  else If EstadoAnterior in NF then
       Begin
          EsConstanteCadena := False;
       end;


End;

Function CarASimbOpAsignacion(Car:Char):Byte;
Begin
  Case Car of
    ':'          :CarASimbOpAsignacion:=0;
    '='          :CarASimbOpAsignacion:=1;
  else
    CarASimbOpAsignacion:=2
  End;
End;

Function EsOpAsignacion (Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String):Boolean;
Const
  F=[2];
  FN=[1];
  M=3;
Type
  Q=0..M;
  Sigma=(DosPuntos,igual, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual,EstadoAnterior:Q;
  Delta:TipoDelta;
  car:Char;
Begin

  Delta[0,DosPuntos]:=1;Delta[1,DosPuntos]:=M;Delta[2,DosPuntos]:=M;
  Delta[0,igual]:=M;Delta[1,igual]:=2;Delta[2,igual]:=M;
  Delta[0,Otro]:=M;Delta[1,Otro]:=M;Delta[2, Otro]:=M;

  Lexema := '';
  EstadoActual:=0;
  car :=' ';

  While (EstadoActual <> M) and (not FinArchivo(Fuente)) do
  Begin

    LeerCar(Fuente,Control,Car);
    EstadoAnterior:= EstadoActual;
    EstadoActual:=Delta[EstadoActual,Sigma(CarASimbOpAsignacion(car))];
    If EstadoActual <> M then
    Begin
    Lexema := Lexema + car;
    Inc(control);
    end;

  if EstadoAnterior in FN then
  Begin
     Dec(control);
     EsOpAsignacion := False;
  End
     Else If EstadoAnterior in F then
     EsOpAsignacion:=TRUE;
end;

end;

Function EsSimboloEspecial (Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String;Var CompLex:TipoSimboloGramatical):Boolean;
Var
  car:Char;
Begin
  car := ' ';
  If not FinArchivo(Fuente) then
   LeerCar(Fuente,Control,Car);

   Lexema := '';
   Case Car of
     '+'                 :CompLex := TipoSimboloGramatical(Tmas);
     '-'                 :CompLex := TipoSimboloGramatical(Tmenos);
     '/'                 :CompLex := TipoSimboloGramatical(Tdivision);
     '*'                 :CompLex := TipoSimboloGramatical(Tproducto);
     '('                 :CompLex := TipoSimboloGramatical(TParenA);
     ')'                 :CompLex := TipoSimboloGramatical(TParenC);
     ','                 :CompLex := TipoSimboloGramatical(Tcoma);
     ';'                 :CompLex := TipoSimboloGramatical(TpuntoYComa);
     '.'                 :CompLex := TipoSimboloGramatical(Tpunto);
   end;

   If not(CompLex = TipoSimboloGramatical(Inicial)) then
      Begin
      Lexema := Lexema + car;
      EsSimboloEspecial := TRUE;
      end
   Else EsSimboloEspecial := FALSE;

end;

Function ExisteEnTs (Var Lexema:String;Var TS:tFileTS;Var CompLex:TipoSimboloGramatical):Boolean;
Begin

end;

Procedure InstalarEnTS(Lexema:String;Var TS:tFileTS;CompLex:TipoSimboloGramatical);
Begin

end;

Procedure ObtenerSiguienteCompLex(Var Fuente:tFileChar;Var Control:Longint; Var CompLex:TipoSimboloGramatical;Var Lexema:String;Var TS:tFileTS);
Begin

  If EsIdentificador(Fuente,Control,Lexema) then
     Complex:=TipoSimboloGramatical(Tid)
  else If EsConstanteReal(Fuente,Control,Lexema) then
        CompLex:=TipoSimboloGramatical(TcReal)
  else If EsOperadorRelacional(Fuente,control, Lexema) then
        CompLex:=TipoSimboloGramatical(TopRel)
  else if EsConstanteCadena(Fuente,control, Lexema) then
        Complex:=TipoSimboloGramatical(Tcad)
  else if EsOpAsignacion(Fuente,control,Lexema) then
        CompLex := TipoSimboloGramatical(TopAsign)
  else if Not EsSimboloEspecial(Fuente,Control,Lexema,CompLex) then
        CompLex:=TipoSimboloGramatical(ErrorLexico);

if (CompLex <> TipoSimboloGramatical(ErrorLexico)) and (not ExisteEnTs(Lexema,TS,CompLex)) then
  InstalarEnTS(Lexema,TS,CompLex);
end;

end.