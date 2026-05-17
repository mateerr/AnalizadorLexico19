program project1;

Uses UnitArchivo,Unit1;

Begin
   ComenzarPrograma(Fuente,TablaSimb);
end.  
{Function CarASimbReal(Car:Char):Sigma;
Begin
//Aqui cargamos todos los simbolos que debe reconocer segun su categoria
  Case Car of
    '0'..'9'          :CarASimbReal:=Digito;
    'e'               :CarASimbReal:=Exp;
    '.'               :CarASimbReal:=Punto;
    '-'               :CarASimbReal:=Neg;
  else
    CarASimbReal:=Otro
  End;
End;

Function CarASimbRelacional(Car:Char):Sigma;
Begin
//Aqui cargamos todos los simbolos que debe reconocer segun su categoria
  Case Car of
    '<'          :CarASimbRelacional:=Menor;
    '>'          :CarASimbRelacional:=Mayor;
    '='          :CarASimbRelacional:=Igual;
  else
    CarASimbRelacional:=Otro
  End;
End;

Function CarASimbCadena(Car:Char):Sigma;
Begin
//Aqui cargamos todos los simbolos que debe reconocer segun su categoria
  Case Car of
    '"'          :CarASimbCadena:=Comilla;
  else
    CarASimbCadena:=Otro
  End;
End;}

{Function EsConstanteReal(Cadena:String):Boolean;
Const
  F=[1, 9, 6];
Type
  Q=0..11; //Numero de estados
  Sigma=(Digito, Exp, Punto, Neg, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer;
  EstadoActual:Q;
  Delta:TipoDelta;
Begin
  Delta[0,Digito]:=1;Delta[1,Digito]:=1;Delta[2,Digito]:=1;Delta[3,Digito]:=4;
  Delta[5,Digito]:=6;Delta[6,Digito]:=6;Delta[7,Digito]:=6;Delta[8,Digito]:=9;
  Delta[9,Digito]:=9;Delta[10,Digito]:=9;
  
  Delta[0,Exp]:=11; Delta[1,Exp]:=8;Delta[2,Exp]:=11;Delta[3,Exp]:=11;Delta[4,Exp]:=5;
  Delta[5,Exp]:=11;Delta[6,Exp]:=11;Delta[7,Exp]:=11;Delta[8,Exp]:=11;Delta[9,Exp]:=11;
  Delta[10,Exp]:=11;
  
  Delta[0,Punto]:=11;Delta[1,Punto]:=3;Delta[2,Punto]:=11;Delta[3,Punto]:=11;
  Delta[4,Punto]:=11;Delta[5,Punto]:=11;Delta[6,Punto]:=11;Delta[7,Punto]:=11;
  Delta[8,Punto]:=11;Delta[9,Punto]:=11;Delta[10,Punto]:=11;
  
  Delta[0,Neg]:=2;Delta[1,Neg]:=11;Delta[2,Neg]:=11;Delta[3,Neg]:=11;Delta[4,Neg]:=11;Delta[5,Neg]:=7;
  Delta[6,Neg]:=11;Delta[7,Neg]:=11;Delta[8,Neg]:=10;Delta[9,Neg]:=11;Delta[10,Neg]:=11;

  Delta[0,Otro]:=11;Delta[1,Otro]:=11;Delta[2,Otro]:=11;Delta[3,Otro]:=11;Delta[4,Otro]:=11;Delta[5,Otro]:=11;
  Delta[6,Otro]:=11;Delta[7,Otro]:=11;Delta[8,Otro]:=11;Delta[9,Otro]:=11;Delta[10,Otro]:=11;

  EstadoActual:=0;
  control:=1;
  
  While (Control <= Length(Cadena)) and (EstadoActual <> 11) do
  
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbReal(Cadena[Control])];
    Control:=Control+1;
  end;

  EsConstanteReal:=EstadoActual in F;
End;

Function EsOperadorRelacional(Cadena:String):Boolean;
Const
  F=[1,2,3,4,5]; //Conjunto de estados finales
Type
  Q=0..6; //Numero de estados
  Sigma=(Menor, Mayor, Igual, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer; //Control para recorrer la cadena de entrada
  EstadoActual:Q;
  Delta:TipoDelta;
Begin

  Delta[0,Menor]:=1;Delta[1,Menor]:=6;Delta[2,Menor]:=6;Delta[3,Menor]:=6;
  Delta[4,Menor]:=6;Delta[5,Menor]:=6;
  
  Delta[0,Mayor]:=2;Delta[1,Mayor]:=4;Delta[2,Mayor]:=6;Delta[3,Mayor]:=6;
  Delta[4,Mayor]:=6;Delta[5,Mayor]:=6;
  
  Delta[0,Igual]:=3;Delta[1,Igual]:=5;Delta[2,Igual]:=5;Delta[3,Igual]:=6;
  Delta[4,Igual]:=6;Delta[5,Igual]:=6;

  Delta[0,Otro]:=6;Delta[1,Otro]:=6;Delta[2,Otro]:=6;Delta[3,Otro]:=6;
  Delta[4,Otro]:=6;Delta[5,Otro]:=6;

  EstadoActual:=0; //colocamos el estado inicial
  control:=1; //inicializamos el recorrido de la cadena desde el primer caracter
  

  While (Control <= Length(Cadena)) and (EstadoActual <> 6) do //lo recorremos hasta que termine la cadena o bien llegue al estado muerto
  
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbReal(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsOperadorRelacional:=EstadoActual in F;
End;

Function EsConstanteCadena(Cadena:String):Boolean;
Const
  F=[2]; //Conjunto de estados finales
Type
  Q=0..3; //Numero de estados
  Sigma=(Comilla, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer; //Control para recorrer la cadena de entrada
  EstadoActual:Q;
  Delta:TipoDelta;
Begin

  Delta[0,Comilla]:=1; Delta[0,Otro]:=3; 
  
  Delta[1,Comilla]:=2; Delta[1,Otro]:=1;
  
  Delta[2,Comilla]:=3; Delta[2, Otro]:=3;


  EstadoActual:=0; //colocamos el estado inicial
  control:=1; //inicializamos el recorrido de la cadena desde el primer caracter
  
  While (Control <= Length(Cadena)) and (EstadoActual <> 3) do //lo recorremos hasta que termine la cadena o bien llegue al estado muerto
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbCadena(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsConstanteCadena:=EstadoActual in F;
  End;
end;}