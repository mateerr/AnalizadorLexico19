unit UnitArchivo;

interface

uses
  crt;
Const rutaChar = '.\Fuente.dat'; rutaTS ='.\TablaSimbolos.dat';MaxSim=200;FinArch=#0;

   type
     TipoSimboloGramatical=(Tid,TcReal,Tcad,TParenA,TParenC,Tmas,Tmenos,Tproducto,Tdivision,TpuntoYComa,
     Tcoma,Tpunto,TopRel,TopAsign,Tprogram,Tbegin,Tend,Tif,Tthen,Telse,Twhile,Tdo,Tread,Twrite,ErrorLexico,Pesos);

     TElemTS = record
      compLex:TipoSimboloGramatical;
      Lexema:string[100];
     end;

     DatoTablaSimb = record
       elem:array[1..MaxSim]of TElemTS;
       cant:0..maxsim;
     end;

  tFileChar = file of char;
  tFileTS = file of DatoTablaSimb;

  Var Fuente:tFileChar;TablaSimb:tFileTS;

procedure AsignarArchivoChar(Var Fuente:tFileChar);
Procedure AbrirOCrearArchivoChar(var Fuente:tFileChar);
Procedure CerrarArchivoChar(var Fuente:tFileChar);
Procedure LeerArchivoChar(Var Fuente:tFileChar; Var x:char; PosicionArch:longint);

procedure AsignarArchivoTS(Var TablaSimb:tFileTS);
Procedure AbrirOCrearArchivoTS(var TablaSimb:tFileTS);
Procedure CerrarArchivoTS(var TablaSimb:tFileTS);
Procedure LeerArchivoTS(Var TablaSimb:tFileTS; Var x:DatoTablaSimb; PosicionArch:longint);

implementation

procedure AsignarArchivoChar(Var Fuente:tFileChar);
Begin
  Assign(Fuente,RutaChar);
end;

Procedure AbrirOCrearArchivoChar(var Fuente:tFileChar);
begin
  {$I-}
  reset(Fuente);
  if IOResult <>0 then rewrite(Fuente);
  {$I+}
end;

Procedure CerrarArchivoChar(var Fuente:tFileChar);
begin
   Close(Fuente);
end;

Procedure LeerArchivoChar(Var Fuente:tFileChar; Var x:char; PosicionArch:longint);
Begin
  Seek(Fuente,PosicionArch);
  Read(Fuente,x);
end;

procedure AsignarArchivoTS(Var TablaSimb:tFileTS);
Begin
     Assign(TablaSimb,RutaTS);
end;

Procedure AbrirOCrearArchivoTS(var TablaSimb:tFileTS);
Begin
     {$I-}
  reset(TablaSimb);
  if IOResult <>0 then rewrite(TablaSimb);
  {$I+}
end;


Procedure CerrarArchivoTS(var TablaSimb:tFileTS);
Begin
    Close(TablaSimb);
end;

Procedure LeerArchivoTS(Var TablaSimb:tFileTS; Var x:DatoTablaSimb; PosicionArch:longint);
Begin
   Seek(TablaSimb,PosicionArch);
  Read(TablaSimb,x);
end;

end.