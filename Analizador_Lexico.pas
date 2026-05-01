{Componentes léxicos: id, constReal, constCadena, parentesisAbre, parentesisCierra,
mas, menos, producto, división, puntoYComa, coma, punto, operadorRelacional, operadorAsignacion, y las
palabras reservadas: program, begin, end, if, then, else, while, do, read, write.}

MaxSim=200;
   FinArch=#0;
type
  TipoSimboloGramatical=(Tid,Tcreal,Tcad,Twhile,Tif,Tvar,Tpunto,Tpycom,Tcoma,Tdosp,Tmenos,Tmas,pesos,error);
  FileOfChar= file of char;
  TElemTS= record //Tabla de Elementos de Tabla de Simbolos
   compLex:TipoSimboloGramatical;
   Lexema:string;
  end;
  TablaDeSimbolos= record
    elem:array[1..MaxSim]of TElemTS;
    cant:0..maxsim;
  end;
  

procedure LeerCar(var Fuente:FileOfChar;var control:Longint; var car:char);
begin {este procedimiento es utilizado cada vez que se necesita leer un caracter 
       del archivo Fuente}
  if control< filesize(Fuente) then
    begin
      seek(FUENTE,control);
      read(fuente,car);
    end
  else
      begin
        car:=FinArch;
      end;
end; 


Procedure ObtenerSiguienteCompLex(Var Fuente:FileOfChar;Var Control:Longint; Var CompLex:TipoSimboloGramatical;Var Lexema:String;Var TS:TablaDeSimbolos);
. . . 
Begin {La TSA ya ingresa cargada con las Palabras Reservadas}
  {Avanzar el Control salteando todos los caracteres de control y espacios, hasta el primer carácter significativo}
  If EsIdentificador(Fuente,Control,Lexema) then
        InstalarEnTS(Lexema,TS,CompLex)
  else If EsConstanteReal(Fuente,Control,Lexema) then
        CompLex:=ConstanteReal
  else If EsConstanteEntera(Fuente,Control,Lexema) then
        CompLex:=ConstanteEntera
  else . . .
  else if Not EsSimboloEspecial(Fuente,Control,Lexema,CompLex) then
    CompLex:=ErrorLexico

    Function EsIdentificador(Cadena:String):Boolean;
Const
  F=[1]; //Conjunto de estados finales
Type
  Q=0..2; //Numero de estados
  Sigma=(Letra, Digito, Guion, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer; //Control para recorrer la cadena de entrada
  EstadoActual:Q;
  Delta:TipoDelta;
Begin
  {Aca definimos la función de transición, para cada estado y cada símbolo del alfabeto,
   indicando a qué estado se transita, en el caso del estado muerto, no colocamos transiciones
   para que al primer contacto, ya no acepte la cadena}
  Delta[0,Letra]:=1;Delta[0,Digito]:=2;Delta[0,Otro]:=2;Delta[0,Guion]:=2;
  Delta[1,Letra]:=1;Delta[1,Digito]:=1;Delta[1,Guion]:=1;Delta[1,Otro]:=2;
  
  EstadoActual:=0; //colocamos el estado inicial
  control:=1; //inicializamos el recorrido de la cadena desde el primer caracter
  While (Control <= Length(Cadena)) and (EstadoActual <> 2) do //lo recorremos hasta que termine la cadena o bien llegue al estado muerto
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbId(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsIdentificador:=EstadoActual in F;
End;

Function CarASimbId(Car:Char):Sigma;
Begin
//Aqui cargamos todos los simbolos que debe reconocer segun su categoria
  Case Car of
    'a'..'z', 'A'..'Z':CarASimbId:=Letra;
    '0'..'9'          :CarASimbId:=Digito;
    '_'               :CarASimbId:=Guion;
  else
    CarASimbId:=Otro
  End;
End;

Function CarASimbReal(Car:Char):Sigma;
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
    '<'          :CarASimbReal:=Menor;
    '>'          :CarASimbReal:=Mayor;
    '='          :CarASimbReal:=Igual;
  else
    CarASimbReal:=Otro
  End;
End;

Function EsConstanteReal(Cadena:String):Boolean;
Const
  F=[1, 9, 6]; //Conjunto de estados finales
Type
  Q=0..11; //Numero de estados
  Sigma=(Digito, Exp, Punto, Neg, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer; //Control para recorrer la cadena de entrada
  EstadoActual:Q;
  Delta:TipoDelta;
Begin
  {Aca definimos la función de transición, para cada estado y cada símbolo del alfabeto,
   indicando a qué estado se transita, en el caso del estado muerto, no colocamos transiciones
   para que al primer contacto, ya no acepte la cadena}
  {DIGITO, EXPONENTE, PUNTO, NEGATIVO, OTRO}
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

  EstadoActual:=0; //colocamos el estado inicial
  control:=1; //inicializamos el recorrido de la cadena desde el primer caracter
  
  While (Control <= Length(Cadena)) and (EstadoActual <> 11) do //lo recorremos hasta que termine la cadena o bien llegue al estado muerto
  
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbReal(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsConstanteReal:=EstadoActual in F;
End;

{
Function EsConstanteEntera(Cadena:String):Boolean;
Const
  F=[1, 9, 6]; //Conjunto de estados finales
Type
  Q=0..11; //Numero de estados
  Sigma=(Digito, Exp, Punto, Neg, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer; //Control para recorrer la cadena de entrada
  EstadoActual:Q;
  Delta:TipoDelta;
Begin
  //DIGITO, EXPONENTE, PUNTO, NEGATIVO, OTRO
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

  EstadoActual:=0; //colocamos el estado inicial
  control:=1; //inicializamos el recorrido de la cadena desde el primer caracter
  
  While (Control <= Length(Cadena)) and (EstadoActual <> 11) do //lo recorremos hasta que termine la cadena o bien llegue al estado muerto
  
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbEnt(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsConstanteEntera:=EstadoActual in F;
End;


Function EsConstanteCadena(Cadena:String):Boolean;
Const
  F=[1, 9, 6]; //Conjunto de estados finales
Type
  Q=0..11; //Numero de estados
  Sigma=(Digito, Exp, Punto, Neg, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  Control:Integer; //Control para recorrer la cadena de entrada
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

  EstadoActual:=0; //colocamos el estado inicial
  control:=1; //inicializamos el recorrido de la cadena desde el primer caracter
  
  While (Control <= Length(Cadena)) and (EstadoActual <> 11) do //lo recorremos hasta que termine la cadena o bien llegue al estado muerto
  
  Begin
    EstadoActual:=Delta[EstadoActual,CarASimbCad(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsConstanteReal:=EstadoActual in F;
End;
}

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