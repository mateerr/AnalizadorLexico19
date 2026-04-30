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