package AnalizadorCJS;

import java_cup.runtime.Symbol;
import Tools.DatosExtra;
import AnalizadorCJS.sym;
import java.io.File;
import java.io.FileWriter;
%%
//opciones de jflex
%unicode
%public
%line
%column
%cup
%ignorecase
%char
%full
%init{
    // inicialización de variables
%init}

%{
    //declaración de variables
    //métodos a ocupar
    public String TextoInicial = "digraph html { abc [shape=none, margin=0, label=< <TABLE BORDER=\"0\" CELLBORDER=\"1\" CELLSPACING=\"0\" CELLPADDING=\"4\"><TR> <TD>TIPO</TD><TD>TOKEN</TD> <TD>LINEA</TD> <TD>COLUMNA</TD> </TR>";
    public String TextoMedio = "";
    public String TextoFinal = " </TABLE>>];}";
    
public void graficar(){

String archivo = "C:/Users/happy_000/Desktop/graph.dot";

try {
 File file = new File(archivo);
        FileWriter fileWriter = new FileWriter(file);
	fileWriter.write(TextoInicial+TextoMedio+TextoFinal);
	fileWriter.flush();
	fileWriter.close();
          String str ="dot -Tpng C:/Users/happy_000/Desktop/graph.dot > C:/Users/happy_000/Desktop/output.png";
          Process process = Runtime.getRuntime().exec(new String[]{"cmd.exe", "/c",str});         
    } catch (Exception ex) {}
}


public void CrearTupla(String tip,String tex){
          String tupla = "<TR>" +"<TD>"+tip+"</TD>"+"<TD>"+tex+"</TD>"+"<TD>"+yyline+"</TD>"+"<TD>"+yycolumn+"</TD>"+ "</TR>";
          TextoMedio = TextoMedio + tupla;
    }
    public void consola(String s){
        System.out.println(s);
    }
      public java_cup.runtime.Symbol simbolo(int id){
        consola("detectado " + yytext() + "," + yyline + "," +yycolumn );
        
        // el constructor de Symbol acepta un segundo argumento que puede ser
        // cualquier objeto, se ocupa DatosExtra para pasar el lexema y su posición
        return new java_cup.runtime.Symbol(id, new DatosExtra(yytext(), yyline, yycolumn));
    } 
%}
//%eofval{
//System.out.println("Fin del archivo");
//return null;
//%eofval}

// declaración de macros

nuevaLinea      = "\n" | "\r"

PARA = [\u0028]
PARC = [\u0029]

//OPERADORES ARITMETICOS
SUMA=[\u002B]
RESTA=[\u002D] 
MULTI=[\u002A]
DIV=[\u002F]
POTE=[\u005E]
MODU=[\u0025]
ADDIC=[\u002B][\u002B]
SUSTRA=[\u002D][\u002D]

//OPERADORES RELACIONALES
IGUAL= [\U003D]
DIF=[\U0021][\U003D]
MEN=[\U003C]
MAY=[\U003E]
MENI=[\U003C][\U003D]
MAYI=[\U003E][\U003D]

//OPERADORES LOGICOS
AND = [\u0026][\u0026]
OR = [\u007C][\u007C]
NOT = [\u0021]


//VECTOR
LLAVEA = [\u007B]
LLAVEC = [\u007D]
COMA = [\u002C]
CONT = "CONTEO"
PUNTO = [\u002E]
A_TXT = "ATEXTO"[\u0028][\u0029]

//SI 
SI = "SI"
SINO = "SINO"

//SELECCIONA 
SELECT = "SELECCIONA"
CASO = "CASO"
DEFEC = "DEFECTO"

//PARA
PARAR = "PARA"

//MIENTRAS
MIENTRAS = "MIENTRAS"
DETENER = "DETENER"

//IMPRIMIR
IMPRI = "IMPRIMIR"

//FUNCION
FUNC = "FUNCION"

//RETORNAR
RETOR = "RETORNAR"

//MENSAJE
MENS = "MENSAJE"

//EVENTOS
LISTO = "LISTO"
MODIF = "MODIFICADO"
CLICK = "CLIQUEADO"

//OBTENEER
OBTENER = "OBTENER"

//SET ELEMENTO 
SETEL = "SETELEMENTO"

//OBSERVADOR
OBSER = "OBSERVADOR"



//VARIABLES
VAR = "DimV" 
ID = [a-zA-Z] ([a-zA-Z0-9]|[\u002D]|[\u005F])*

//SIGNS
    //punto y coma
PYCOMA = ";"
    //DOS PUNTOS 
DPUNTO = ":"

//TIPOS DE DATO 
    
    //TEXTO  
TD_TEXTO = \"([^\\\"]|\\.)*\" 
    
    //BOOLEAN 
TD_BOOL = [\u0027]"true"[\u0027] | [\u0027]"false"[\u0027]

    //NUMERO 
TD_NUMBER = [0-9]+ ([\u002E][0-9]+)?

    //DATE 
TD_DATE = [\u0027](3[01]|[12][0-9]|0[1-9])"/"(1[012]|0[1-9])"/"([012][0-9][0-9][0-9])[\u0027]

    //DATE TIME 
TD_DATET = [\u0027](3[01]|[12][0-9]|0[1-9])"/"(1[012]|0[1-9])"/"([012][0-9][0-9][0-9]) [\u0020] ([01][0-9]|2[0123])":"([0-5][0-9])":"([0-5][0-9])  [\u0027]

//ETIQUETAS


%state COMMENTL
%state COMMENTML
%%


//ESTADO DE COMENTARIO MULTI LINEA
<YYINITIAL>"\u0027/" {yybegin(COMMENTML);System.out.println("inicia comentario MULTI");}
<COMMENTML>([^\*]|\*[^/]) {}
<COMMENTML>"/\u0027" {System.out.println("termina comentario MULTI");yybegin(YYINITIAL);}

//ESTADO DE COMENTARIO LINEA 
<YYINITIAL>"\u0027" {yybegin(COMMENTL);System.out.println("inicia comentario L");}
<COMMENTL>([^\n]|\*[^/]) {}
<COMMENTL>"\u000A" {System.out.println("termina comentario L");yybegin(YYINITIAL);}

<YYINITIAL>{VAR} {System.out.println("VAR:" + yytext());return simbolo(sym.VAR);}
<YYINITIAL>{ID} {System.out.println("ID:" + yytext() );return simbolo(sym.ID);}

<YYINITIAL>{PYCOMA} {System.out.println("PUNTO Y COMA");return simbolo(sym.PYCOMA);}
<YYINITIAL>{DPUNTO} {System.out.println("DPUNTO");return simbolo(sym.DPUNTO);}

<YYINITIAL>{TD_TEXTO} {System.out.println("TD_TEXTO: "+yytext());return simbolo(sym.TD_TEXTO);}
<YYINITIAL>{TD_BOOL} {System.out.println("TD_BOOL: "+yytext());return simbolo(sym.TD_BOOL);}
<YYINITIAL>{TD_NUMBER} {System.out.println("TD_NUMBER: "+yytext());return simbolo(sym.TD_NUMBER);}
<YYINITIAL>{TD_DATE} {System.out.println("TD_DATE: "+yytext());return simbolo(sym.TD_DATE);}
<YYINITIAL>{TD_DATET} {System.out.println("TD_DATET: "+yytext());return simbolo(sym.TD_DATET);}

<YYINITIAL>{PARA} {System.out.println("PARA");return simbolo(sym.PARA);}
<YYINITIAL>{PARC} {System.out.println("PARC");return simbolo(sym.PARC);}

//OPERADORES ARITMETICOS
<YYINITIAL>{SUMA} {System.out.println("SUMA");return simbolo(sym.SUMA);}
<YYINITIAL>{RESTA} {System.out.println("RESTA");return simbolo(sym.RESTA);}
<YYINITIAL>{MULTI} {System.out.println("MULTI");return simbolo(sym.DPUNTO);}
<YYINITIAL>{DIV} {System.out.println("DIV");return simbolo(sym.DPUNTO);}
<YYINITIAL>{POTE} {System.out.println("POTE");return simbolo(sym.DPUNTO);}
<YYINITIAL>{MODU} {System.out.println("MODU");return simbolo(sym.DPUNTO);}
<YYINITIAL>{ADDIC} {System.out.println("ADDIC");return simbolo(sym.DPUNTO);}
<YYINITIAL>{SUSTRA} {System.out.println("SUSTRA");return simbolo(sym.DPUNTO);}

//OPERADORES RELACIONALES
<YYINITIAL>{IGUAL} {System.out.println("IGUAL");return simbolo(sym.IGUAL);}
<YYINITIAL>{DIF} {System.out.println("DIF");return simbolo(sym.DIF);}
<YYINITIAL>{MEN} {System.out.println("MEN");return simbolo(sym.MEN);}
<YYINITIAL>{MAY} {System.out.println("MAY");return simbolo(sym.MAY);}
<YYINITIAL>{MENI} {System.out.println("MENI");return simbolo(sym.MENI);}
<YYINITIAL>{MAYI} {System.out.println("MAYI");return simbolo(sym.MAYI);}

//OPERADORES LOGICOS
<YYINITIAL>{AND} {System.out.println("AND");return simbolo(sym.AND);}
<YYINITIAL>{OR}  {System.out.println("OR");return simbolo(sym.OR);}
<YYINITIAL>{NOT} {System.out.println("NOT");return simbolo(sym.NOT);}


//VECTOR
<YYINITIAL>{LLAVEA} {System.out.println("LLAVEA");return simbolo(sym.LLAVEA);}
<YYINITIAL>{LLAVEC} {System.out.println("LLAVEC");return simbolo(sym.LLAVEC);}
<YYINITIAL>{COMA} {System.out.println("COMA");return simbolo(sym.COMA);}
<YYINITIAL>{CONT} {System.out.println("CONT");return simbolo(sym.CONT);}
<YYINITIAL>{PUNTO} {System.out.println("PUNTO");return simbolo(sym.PUNTO);}
<YYINITIAL>{A_TXT} {System.out.println("A_TXT");return simbolo(sym.A_TXT);}

//SI 
<YYINITIAL>{SI} {System.out.println("SI");return simbolo(sym.SI);}
<YYINITIAL>{SINO} {System.out.println("SINO");return simbolo(sym.SINO);}

//SELECCIONA 
<YYINITIAL>{SELECT} {System.out.println("SELECT");return simbolo(sym.SELECT);}
<YYINITIAL>{CASO} {System.out.println("CASO");return simbolo(sym.CASO);}
<YYINITIAL>{DEFEC} {System.out.println("DEFEC");return simbolo(sym.DEFEC);}

//PARA
<YYINITIAL>{PARAR} {System.out.println("PARAR");return simbolo(sym.PARAR);}

//MIENTRAS
<YYINITIAL>{MIENTRAS} {System.out.println("MIENTRAS");return simbolo(sym.MIENTRAS);}
<YYINITIAL>{DETENER} {System.out.println("DETENER");return simbolo(sym.DETENER);}

//IMPRIMIR
<YYINITIAL>{IMPRI} {System.out.println("IMPRI");return simbolo(sym.IMPRI);}

//FUNCION
<YYINITIAL>{FUNC} {System.out.println("FUNC");return simbolo(sym.FUNC);}

//RETORNAR
<YYINITIAL>{RETOR} {System.out.println("RETOR");return simbolo(sym.RETOR);}

//MENSAJE
<YYINITIAL>{MENS} {System.out.println("MENS");return simbolo(sym.MENS);}

//EVENTOS
<YYINITIAL>{LISTO} {System.out.println("LISTO");return simbolo(sym.LISTO);}
<YYINITIAL>{MODIF} {System.out.println("MODIF");return simbolo(sym.DPUNTO);}
<YYINITIAL>{CLICK} {System.out.println("CLICK");return simbolo(sym.DPUNTO);}

//OBTENEER
<YYINITIAL>{OBTENER} {System.out.println("OBTENER");return simbolo(sym.OBTENER);}

//SET ELEMENTO 
<YYINITIAL>{SETEL} {System.out.println("SETEL");return simbolo(sym.SETEL);}

//OBSERVADOR
<YYINITIAL>{OBSER} {System.out.println("OBSER");return simbolo(sym.OBSER);}


//acciones vacías aceptan la entrada sin realizar acciones, si no se incluyen, el analizador reportará un error
{nuevaLinea} {
                //no haga nada
            }
" "         {
                //no haga nada
            }
[ \t\r\n\f] {
                //no haga nada
            }

.           { 
                consola("Error: lexema <" + yytext() + "> no reconocido por el analizador. " + "col " + yycolumn );
            }