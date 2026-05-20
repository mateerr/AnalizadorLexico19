
Unit UnidadDeAnalizadorLexico;


Interface

Uses 
crt,UnitArchivo;

Procedure ComenzarPrograma(Var Fuente:tFileChar;Var TablaSimb:tFileTS);
Procedure LeerCar(Var Fuente:tFileChar;Var control:Longint; Var car:char);
Procedure ObtenerSiguienteCompLex(Var Fuente:tFileChar;Var Control:Longint; Var CompLex:TipoSimboloGramatical;Var Lexema:String;Var TS:tFileTS);
Function CarASimbId(Car:Char): byte;
Function EsIdentificador(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String): Boolean;
Procedure AnadirPalabrasReservadas(Var TS:tFileTS);

Implementation

Procedure AnadirPalabrasReservadas(Var TS:tFileTS);

Type 
  VectorPalabraReservadas = Array[1..10] Of TElemTS;

Var 
  i: 0..10;
  x: DatoTablaSimb;
  PalabraReservadas: VectorPalabraReservadas;
Begin
  PalabraReservadas[1].Lexema := 'program';
  PalabraReservadas[1].CompLex := TipoSimboloGramatical(14);
  PalabraReservadas[2].Lexema := 'begin';
  PalabraReservadas[2].CompLex := TipoSimboloGramatical(15);
  PalabraReservadas[3].Lexema := 'end';
  PalabraReservadas[3].CompLex := TipoSimboloGramatical(16);
  PalabraReservadas[4].Lexema := 'if';
  PalabraReservadas[4].CompLex := TipoSimboloGramatical(17);
  PalabraReservadas[5].Lexema := 'then';
  PalabraReservadas[5].CompLex := TipoSimboloGramatical(18);
  PalabraReservadas[6].Lexema := 'else';
  PalabraReservadas[6].CompLex := TipoSimboloGramatical(19);
  PalabraReservadas[7].Lexema := 'while';
  PalabraReservadas[7].CompLex := TipoSimboloGramatical(20);
  PalabraReservadas[8].Lexema := 'do';
  PalabraReservadas[8].CompLex := TipoSimboloGramatical(21);
  PalabraReservadas[9].Lexema := 'write';
  PalabraReservadas[9].CompLex := TipoSimboloGramatical(22);
  PalabraReservadas[10].Lexema := 'read';
  PalabraReservadas[10].CompLex := TipoSimboloGramatical(23);
  i := 0;
  While i < 10 Do
    Begin
      Seek(TS,i);
      x.elem[i+1].Lexema := PalabraReservadas[i+1].Lexema;
      x.elem[i+1].CompLex := PalabraReservadas[i+1].CompLex;
      Write(TS,x);
      inc(i);
    End;
  i := 0;
  {While i < 10 do
  Begin
    Seek(TS,i);
    Read(TS,x);
    Writeln('(',x.elem[i+1].CompLex,',',x.elem[i+1].Lexema,')');
    inc(i);
  end;
  Readkey;}
End;

Procedure ComenzarPrograma(Var Fuente:tFileChar;Var TablaSimb:tFileTS);

Var Control: Longint;
  CompLex: TipoSimboloGramatical;
  Lexema: String;
Begin
  AsignarArchivoChar(Fuente);
  AsignarArchivoTS(TablaSimb);
  AbrirOCrearArchivoTS(TablaSimb);
  AbrirOCrearArchivoChar(Fuente);
  CompLex := TipoSimboloGramatical(Inicial);
  Control := 0;
  Lexema := '';
  While (Not FinArchivo(Fuente)) And (CompLex <> TipoSimboloGramatical(ErrorLexico)) Do
    Begin
      CompLex := TipoSimboloGramatical(Inicial);
      ObtenerSiguienteCompLex(Fuente,Control,CompLex,Lexema,TablaSimb);
    End;
  CerrarArchivoTS(TablaSimb);
  CerrarArchivoChar(Fuente);
End;
Procedure LeerCar(Var Fuente:tFileChar;Var control:Longint; Var car:char);
Begin

  If control< filesize(Fuente) Then
    Begin
      LeerArchivoChar(Fuente,car,control);
    End
  Else
    Begin
      car := FinArch;
    End;
End;

Function CarASimbId(Car:Char): byte;
Begin
  Case Car Of 
    'a'..'z', 'A'..'Z': CarASimbId := 0;
    '0'..'9'          : CarASimbId := 1;
    '_'               : CarASimbId := 2;
    Else
      CarASimbId := 3
  End;
End;

Function EsIdentificador(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String): Boolean;

Const 
  F = [1];
  M = 2;

Type 
  Q = 0..2;
  Sigma = (Letra, Digito, Guion, Otro);
  TipoDelta = Array[Q,Sigma] Of Q;

Var 
  EstadoActual,EstadoAnterior: Q;
  Delta: TipoDelta;
  car: char;
Begin
  Delta[0,Letra] := 1;
  Delta[0,Digito] := M;
  Delta[0,Otro] := M;
  Delta[0,Guion] := M;
  Delta[1,Letra] := 1;
  Delta[1,Digito] := 1;
  Delta[1,Guion] := 1;
  Delta[1,Otro] := M;

  EstadoAnterior := 0;
  EstadoActual := 0;
  lexema := '';
  Car := ' ';

  While (EstadoActual <> M) And (Not FinArchivo(Fuente)) Do
    Begin

      LeerCar(Fuente,Control,Car);
      EstadoAnterior := EstadoActual;
      EstadoActual := Delta[EstadoActual,Sigma(CarASimbId(Car))];

      If EstadoActual <> M Then
        Begin
          lexema := lexema+car;
          inc(control);
        End;

    End;



  If EstadoAnterior In F Then
    EsIdentificador := True
  Else
    EsIdentificador := False;

End;

Function CarASimbReal(Car:Char): byte;
Begin
  Case Car Of 
    '0'..'9'          : CarASimbReal := 0;
    'e'               : CarASimbReal := 1;
    '.'               : CarASimbReal := 2;
    '-'               : CarASimbReal := 3;
    Else
      CarASimbReal := 4;
  End;
End;

Function EsConstanteReal(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String): Boolean;

Const 
  F = [1, 9, 6];
  NF1 = [3,5,8];
  NF2 = [7,10];
  M = 11;

Type 
  Q = 0..M;
  Sigma = (Digito, Exp, Punto, Neg, Otro);
  TipoDelta = Array[Q,Sigma] Of Q;

Var 
  EstadoActual,EstadoAnterior: Q;
  Delta: TipoDelta;
  car: char;
Begin
  Delta[0,Digito] := 1;
  Delta[1,Digito] := 1;
  Delta[2,Digito] := 1;
  Delta[3,Digito] := 4;
  Delta[5,Digito] := 6;
  Delta[6,Digito] := 6;
  Delta[7,Digito] := 6;
  Delta[8,Digito] := 9;
  Delta[9,Digito] := 9;
  Delta[10,Digito] := 9;

  Delta[0,Exp] := M;
  Delta[1,Exp] := 8;
  Delta[2,Exp] := M;
  Delta[3,Exp] := M;
  Delta[4,Exp] := 5;
  Delta[5,Exp] := M;
  Delta[6,Exp] := M;
  Delta[7,Exp] := M;
  Delta[8,Exp] := M;
  Delta[9,Exp] := M;
  Delta[10,Exp] := M;

  Delta[0,Punto] := M;
  Delta[1,Punto] := 3;
  Delta[2,Punto] := M;
  Delta[3,Punto] := M;
  Delta[4,Punto] := M;
  Delta[5,Punto] := M;
  Delta[6,Punto] := M;
  Delta[7,Punto] := M;
  Delta[8,Punto] := M;
  Delta[9,Punto] := M;
  Delta[10,Punto] := M;

  Delta[0,Neg] := 2;
  Delta[1,Neg] := M;
  Delta[2,Neg] := M;
  Delta[3,Neg] := M;
  Delta[4,Neg] := M;
  Delta[5,Neg] := 7;
  Delta[6,Neg] := M;
  Delta[7,Neg] := M;
  Delta[8,Neg] := 10;
  Delta[9,Neg] := M;
  Delta[10,Neg] := M;

  Delta[0,Otro] := M;
  Delta[1,Otro] := M;
  Delta[2,Otro] := M;
  Delta[3,Otro] := M;
  Delta[4,Otro] := M;
  Delta[5,Otro] := M;
  Delta[6,Otro] := M;
  Delta[7,Otro] := M;
  Delta[8,Otro] := M;
  Delta[9,Otro] := M;
  Delta[10,Otro] := M;

  Lexema := '';
  EstadoActual := 0;
  car := ' ';

  While (EstadoActual <> M) And (Not FinArchivo(Fuente)) Do
    Begin

      LeerCar(Fuente,Control,Car);
      EstadoAnterior := EstadoActual;
      EstadoActual := Delta[EstadoActual,Sigma(CarASimbReal(car))];
      If EstadoActual <> M Then
        Begin
          Lexema := Lexema + car;
          Inc(Control);
        End;
    End;

  If EstadoAnterior In F Then
    EsConstanteReal := TRUE
  Else If EstadoAnterior In NF1 Then
         Begin
           Delete(Lexema,Length(Lexema),1);
           Dec(control);
           EsConstanteReal := TRUE
         End
  Else If EstadoAnterior In NF2 Then
         Begin
           Delete(Lexema,Length(Lexema) - 1,2);
           control := control - 2;
           EsConstanteReal := TRUE
         End
  Else EsConstanteReal := False;
End;

Function CarASimbRelacional(Car:Char): byte;
Begin

  Case Car Of 
    '<'          : CarASimbRelacional := 0;
    '>'          : CarASimbRelacional := 1;
    '='          : CarASimbRelacional := 2;
    Else
      CarASimbRelacional := 3
  End;
End;


Function EsOperadorRelacional(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String): Boolean;

Const 
  F = [1,2,3,4,5];
  M = 6;

Type 
  Q = 0..M;
  Sigma = (Menor, Mayor, Igual, Otro);
  TipoDelta = Array[Q,Sigma] Of Q;

Var 
  EstadoActual,EstadoAnterior: Q;
  Delta: TipoDelta;
  Car: Char;
Begin

  Delta[0,Menor] := 1;
  Delta[1,Menor] := M;
  Delta[2,Menor] := M;
  Delta[3,Menor] := M;
  Delta[4,Menor] := M;
  Delta[5,Menor] := M;

  Delta[0,Mayor] := 2;
  Delta[1,Mayor] := 4;
  Delta[2,Mayor] := M;
  Delta[3,Mayor] := M;
  Delta[4,Mayor] := M;
  Delta[5,Mayor] := M;

  Delta[0,Igual] := 3;
  Delta[1,Igual] := 5;
  Delta[2,Igual] := 5;
  Delta[3,Igual] := M;
  Delta[4,Igual] := M;
  Delta[5,Igual] := M;

  Delta[0,Otro] := M;
  Delta[1,Otro] := M;
  Delta[2,Otro] := M;
  Delta[3,Otro] := M;
  Delta[4,Otro] := M;
  Delta[5,Otro] := M;

  Lexema := '';
  EstadoActual := 0;
  car := ' ';


  While (EstadoActual <> M) And (Not FinArchivo(Fuente)) Do

    Begin
      LeerCar(Fuente,Control,Car);
      EstadoAnterior := EstadoActual;
      EstadoActual := Delta[EstadoActual,Sigma(CarASimbRelacional(Car))];
      If EstadoActual <> M Then
        Begin
          Lexema := Lexema + car;
          Inc(Control);
        End;
    End;

  EsOperadorRelacional := EstadoAnterior In F;
End;

Function CarASimbCadena(Car:Char): Byte;
Begin

  Case Car Of 
    '"'          : CarASimbCadena := 0;
    Else
      CarASimbCadena := 1
  End;
End;


Function EsConstanteCadena(Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String): Boolean;

Const 
  F = [2];
  NF = [1];
  M = 3;

Type 
  Q = 0..M;
  Sigma = (Comilla, Otro);
  TipoDelta = Array[Q,Sigma] Of Q;

Var 
  EstadoActual,EstadoAnterior: Q;
  Delta: TipoDelta;
  car: Char;
Begin

  Delta[0,Comilla] := 1;
  Delta[0,Otro] := M;

  Delta[1,Comilla] := 2;
  Delta[1,Otro] := 1;

  Delta[2,Comilla] := M;
  Delta[2, Otro] := M;

  Lexema := '';
  EstadoActual := 0;
  car := ' ';

  While (EstadoActual <> M) And (Not FinArchivo(Fuente)) Do
    Begin

      LeerCar(Fuente,Control,Car);
      EstadoAnterior := EstadoActual;
      EstadoActual := Delta[EstadoActual,Sigma(CarASimbCadena(car))];
      If EstadoActual <> M Then
        Begin
          Lexema := Lexema + car;
          Inc(control);
        End;
    End;

  If EstadoAnterior In F Then
    EsConstanteCadena := true
  Else If EstadoAnterior In NF Then
         Begin
           EsConstanteCadena := False;
         End;


End;

Function CarASimbOpAsignacion(Car:Char): Byte;
Begin
  Case Car Of 
    ':'          : CarASimbOpAsignacion := 0;
    '='          : CarASimbOpAsignacion := 1;
    Else
      CarASimbOpAsignacion := 2
  End;
End;

Function EsOpAsignacion (Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String): Boolean;

Const 
  F = [2];
  FN = [1];
  M = 3;

Type 
  Q = 0..M;
  Sigma = (DosPuntos,igual, Otro);
  TipoDelta = Array[Q,Sigma] Of Q;

Var 
  EstadoActual,EstadoAnterior: Q;
  Delta: TipoDelta;
  car: Char;
Begin

  Delta[0,DosPuntos] := 1;
  Delta[1,DosPuntos] := M;
  Delta[2,DosPuntos] := M;
  Delta[0,igual] := M;
  Delta[1,igual] := 2;
  Delta[2,igual] := M;
  Delta[0,Otro] := M;
  Delta[1,Otro] := M;
  Delta[2, Otro] := M;

  Lexema := '';
  EstadoActual := 0;
  car := ' ';

  While (EstadoActual <> M) And (Not FinArchivo(Fuente)) Do
    Begin

      LeerCar(Fuente,Control,Car);
      EstadoAnterior := EstadoActual;
      EstadoActual := Delta[EstadoActual,Sigma(CarASimbOpAsignacion(car))];
      If EstadoActual <> M Then
        Begin
          Lexema := Lexema + car;
          Inc(control);
        End;

      If EstadoAnterior In FN Then
        Begin
          Dec(control);
          EsOpAsignacion := False;
        End
      Else If EstadoAnterior In F Then
             EsOpAsignacion := TRUE;
    End;

End;

Function EsSimboloEspecial (Var Fuente:tFileChar;Var Control:Longint;Var Lexema:String;Var CompLex:TipoSimboloGramatical): Boolean;

Var 
  car: Char;
Begin
  car := ' ';
  If Not FinArchivo(Fuente) Then
    LeerCar(Fuente,Control,Car);

  Lexema := '';
  Case Car Of 
    '+'                 : CompLex := TipoSimboloGramatical(Tmas);
    '-'                 : CompLex := TipoSimboloGramatical(Tmenos);
    '/'                 : CompLex := TipoSimboloGramatical(Tdivision);
    '*'                 : CompLex := TipoSimboloGramatical(Tproducto);
    '('                 : CompLex := TipoSimboloGramatical(TParenA);
    ')'                 : CompLex := TipoSimboloGramatical(TParenC);
    ','                 : CompLex := TipoSimboloGramatical(Tcoma);
    ';'                 : CompLex := TipoSimboloGramatical(TpuntoYComa);
    '.'                 : CompLex := TipoSimboloGramatical(Tpunto);
  End;

  If Not(CompLex = TipoSimboloGramatical(Inicial)) Then
    Begin
      Lexema := Lexema + car;
      EsSimboloEspecial := TRUE;
    End
  Else EsSimboloEspecial := FALSE;

End;

Function ExisteEnTs(Var Lexema: String; Var TS: tFileTS; Var CompLex: TipoSimboloGramatical): Boolean;

Var 
  i, Total : Longint;
  x : DatoTablaSimb;
Begin
  ExisteEnTs := False;
  Total := FileSize(TS);
  i := 0;
  While (i < Total) And (Not ExisteEnTs) Do
    Begin
      Seek(TS,i);
      Read(TS,x);
      If x.elem[i+1].Lexema=Lexema Then
        Begin
          //Devolver Complex. 
          CompLex := x.elem[i+1].CompLex;
          // Se cumple y termina ( ദ്ദി ˙ᗜ˙ ).
          ExisteEnTs := True;
        End;
      i := i+1;
    End;
End;

Procedure InstalarEnTS(Lexema: String; Var TS: tFileTS; CompLex: TipoSimboloGramatical);

Var 
  i, Total, Pos : Longint;
  x : DatoTablaSimb;
  YaExiste : Boolean;
Begin
  Total := FileSize(TS);
  YaExiste := False;
  i := 0;

  While (i < Total) And (Not YaExiste) Do
    Begin
      Seek(TS, i);
      Read(TS, x);
      If x.elem[i+1].Lexema = Lexema Then
        Begin
          YaExiste := True;
          i := i+1;
        End;
    End;

  If Not YaExiste Then
    Begin
      //Pos Libre 
      Pos := Total;
      Seek(TS, Pos);
      x.elem[Pos+1].Lexema  := Lexema;
      x.elem[Pos+1].CompLex := CompLex;
      Write(TS, x);
    End;
End;

//Valen Perdon por haber tardado, espero que sea suficiente (っᵔ◡ᵔ)っ.

Procedure ObtenerSiguienteCompLex(Var Fuente:tFileChar;Var Control:Longint; Var CompLex:TipoSimboloGramatical;Var Lexema:String;Var TS:tFileTS);
Begin

  If EsIdentificador(Fuente,Control,Lexema) Then
    Complex := TipoSimboloGramatical(Tid)
  Else If EsConstanteReal(Fuente,Control,Lexema) Then
         CompLex := TipoSimboloGramatical(TcReal)
  Else If EsOperadorRelacional(Fuente,control, Lexema) Then
         CompLex := TipoSimboloGramatical(TopRel)
  Else If EsConstanteCadena(Fuente,control, Lexema) Then
         Complex := TipoSimboloGramatical(Tcad)
  Else If EsOpAsignacion(Fuente,control,Lexema) Then
         CompLex := TipoSimboloGramatical(TopAsign)
  Else If Not EsSimboloEspecial(Fuente,Control,Lexema,CompLex) Then
         CompLex := TipoSimboloGramatical(ErrorLexico);

  If (CompLex <> TipoSimboloGramatical(ErrorLexico)) And (Not ExisteEnTs(Lexema,TS,CompLex)) Then
    InstalarEnTS(Lexema,TS,CompLex);
End;

End.
