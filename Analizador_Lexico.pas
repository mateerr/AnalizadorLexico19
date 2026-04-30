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
    EstadoActual:=Delta[EstadoActual,CarASimb(Cadena[Control])];
    Control:=Control+1;
  end;

//Si llego al estado final devuelve verdadero, caso contrario devuelve falso
  EsIdentificador:=EstadoActual in F;
End;

Function CarASimb(Car:Char):Sigma;
Begin
//Aqui cargamos todos los simbolos que debe reconocer segun su categoria
  Case Car of
    'a'..'z', 'A'..'Z':CarASimb:=Letra;
    '0'..'9'          :CarASimb:=Digito;
    '_'               :CarASimb:=Guion;
  else
    CarASimb:=Otro
  End;
End;