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
         ObtenerSiguienteCompLex(Fuente,Control,CompLex,Lexema,TablaSimb);
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

Procedure InstalarEnTS(Lexema:String;Var TS:tFileTS;CompLex:TipoSimboloGramatical);
Begin

end;

Procedure ObtenerSiguienteCompLex(Var Fuente:tFileChar;Var Control:Longint; Var CompLex:TipoSimboloGramatical;Var Lexema:String;Var TS:tFileTS);
Begin

  If EsIdentificador(Fuente,Control,Lexema) then
    Begin
     Complex:=TipoSimboloGramatical(Tid);
     InstalarEnTS(Lexema,TS,CompLex);
    end;
  {else If EsConstanteReal(Fuente,Control,Lexema) then
        CompLex:=TipoSimboloGramatical(TcReal);
  else If EsOperadorRelacional(Fuente, control, Lexema) then
        CompLex:=operadorRelacional
  else if EsConstanteCadena(Fuente, control, Lexema)
        Complex:=constCadena
  else if Not EsSimboloEspecial(Fuente,Control,Lexema,CompLex) then
    CompLex:=ErrorLexico}
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
Type
  Q=0..2;
  Sigma=(Letra, Digito, Guion, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual:Q;
  Delta:TipoDelta;
  car:char;
Begin
  Delta[0,Letra]:=1;Delta[0,Digito]:=2;Delta[0,Otro]:=2;Delta[0,Guion]:=2;
  Delta[1,Letra]:=1;Delta[1,Digito]:=1;Delta[1,Guion]:=1;Delta[1,Otro]:=2;

  EstadoActual:=0;
  lexema := '';
  While EstadoActual <> 2 do
  Begin
    LeerCar(Fuente,Control,Car);
    EstadoActual:=Delta[EstadoActual,Sigma(CarASimbId(Car))];
    if EstadoActual <> 2 then
      lexema:=lexema+car;
  end;

  If EstadoActual in F then
    EsIdentificador:=True
End;

end.