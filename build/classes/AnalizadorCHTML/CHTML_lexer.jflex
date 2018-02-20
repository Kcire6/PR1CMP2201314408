package AnalizadorCHTML;

import java_cup.runtime.Symbol;
import Tools.DatosExtra;
import AnalizadorCHTML.sym;
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

DIGITO          = [0-9]
nuevaLinea      = "\n" | "\r"

TEXTO_CHTML = ([\u0021-\u003B] | [\u003D] | [\u003F-\u007E]) ([\u0020-\u003B] | [\u003D] | [\u003F-\u007E])* 
TEXTO_TEXTO = ([\u0021-\u003B] | [\u003D] | [\u003F-\u007E]) ([\u0020-\u003B] | [\u003D] |[\u000A] | [\u003F-\u007E])*
//TEXTO TAGS 
//VALOR ATRIBUTO 
A_TVALOR = \"([^\\\"]|\\.)*\" |[\u201C]([^\\\"]|\\.)*[\u201D]  

//SIGNS
    //Open tag
OTAG = "<"

    //Close Tag
CTAG = ">"

    //EQUALS
EQUALS = "="

    //PUNTO COMA 
PYCOMA = ";"

//ETIQUETAS
    //CHTML
T_CHTML = "CHTML"
T_FCHTML = "FIN-CHTML"

    //ENCABEZADO
T_CHEADER = "ENCABEZADO"
T_FCHEADER = "FIN-ENCABEZADO"

    //BODY
T_CCUERPO = "CUERPO"
T_FCCUERPO = "FIN-CUERPO"

    //CJS
T_CJS = "CJS"
T_FCJS = "FIN-CJS"

    //CCSS
T_CCSS = "CCSS"
T_FCCSS = "FIN-CCSS"

    //TITULO
T_TITLE = "TITULO"
T_FTITLE = "FIN-TITULO"

    //PANEL 
T_PANEL = "PANEL"
T_FPANEL = "FIN-PANEL"

    //TEXTO 
T_TEXTO = "TEXTO"
T_FTEXTO = "FIN-TEXTO"

    //IMAGEN 
T_IMAGEN = "IMAGEN"
T_FIMAGEN = "FIN-IMAGEN" 

    //BOTON 
T_BOTON = "BOTON"
T_FBOTON = "FIN-BOTON"

    //ENLACE 
T_ENLACE = "ENLACE"
T_FENLACE = "FIN-ENLACE"

    //TABLA 
T_TABLA = "TABLA"
T_FTABLA = "FIN-TABLA"

    //FILA
T_FILA = "FIL_T"
T_FFILA = "FIN-FIL_T"

    //CELDA_HEAD
T_CHEAD = "CB"
T_FCHEAD = "FIN-CB"

    //CELDA 
T_CELDA = "CT"
T_FCELDA = "FIN-CT"

    //TEXT AREA 
T_TEXTA = "TEXTO_A"
T_FTEXTA = "FIN-TEXTO_A"

    //TEXT BOX 
T_TEXTB = "CAJA_TEXTO"
T_FTEXTB = "FIN-CAJA_TEXTO"
    
    //COMBO BOX 
T_CAJA = "CAJA"
T_FCAJA = "FIN-CAJA"
 
   //OPCION 
T_OPCION = "OPCION"
T_FOPCION = "FIN-OPCION" 

    //SPINNER (CONTADOR)
T_SPINNER = "SPINNER"
T_FSPINNER = "FIN-SPINNER" 
  
    //SALTO 
T_SALTO = "SALTO-FIN"
    

//ATRIBUTOS
    //FONDO
A_FONDO = "fondo"

    //RUTA 
A_RUTA = "ruta"

    //CLICK 
A_CLICK = "click"

    //VALOR 
A_VALOR = "valor"

    //ID 
A_ID = "id" 

    //GRUPO 
A_GRUPO = "grupo"

    //ALTO 
A_ALTO = "alto"

    //ANCHO 
A_ANCHO = "ancho"

    //ALINEADO 
A_ALINEADO = "alineado"


%state COMMENT
%state TAG_NAME
%state TEXTOCHTML
%%

// declaración de acciones léxicas
<YYINITIAL>"<//-" {yybegin(COMMENT);System.out.println("inicia comentario");}
<COMMENT>([^\*]|\*[^/]) {}
<COMMENT>"-//>" {System.out.println("termina comentario");yybegin(YYINITIAL);}

<TAG_NAME>{EQUALS}        {CrearTupla("EQUALS","&#61;");
                return simbolo(sym.EQUALS);}
<TAG_NAME>{PYCOMA}        {CrearTupla("PYCOMA","&#59;");
                return simbolo(sym.PYCOMA);}
<YYINITIAL>{OTAG}          {yybegin(TAG_NAME);CrearTupla("OTAG","&#60;");
                return simbolo(sym.OTAG);}
<TAG_NAME>{CTAG}          {yybegin(YYINITIAL);CrearTupla("CTAG","&#62;");
                return simbolo(sym.CTAG);}
<TAG_NAME>{T_CHTML}       {CrearTupla("T_CHTML",yytext());
                return simbolo(sym.T_CHTML);}
<TAG_NAME>{T_FCHTML}      {CrearTupla("T_FCHTML",yytext());
                return simbolo(sym.T_FCHTML);}
<TAG_NAME>{T_CHEADER}     {CrearTupla("T_CHEADER",yytext());
                return simbolo(sym.T_CHEADER);}
<TAG_NAME>{T_FCHEADER}    {CrearTupla("T_FCHEADER",yytext());
                return simbolo(sym.T_FCHEADER);}
<TAG_NAME>{T_CCUERPO}     {CrearTupla("T_CCUERPO",yytext());
                return simbolo(sym.T_CCUERPO);}
<TAG_NAME>{T_FCCUERPO}    {CrearTupla("T_FCCUERPO",yytext());
                return simbolo(sym.T_FCCUERPO);}
<TAG_NAME>{T_CJS}         {CrearTupla("T_CJS",yytext());
                return simbolo(sym.T_CJS);}
<TAG_NAME>{T_FCJS}        {CrearTupla("T_FCJS",yytext());
                return simbolo(sym.T_FCJS);}
<TAG_NAME>{T_CCSS}        {CrearTupla("T_CCSS",yytext());
                return simbolo(sym.T_CCSS);}
<TAG_NAME>{T_FCCSS}       {CrearTupla("T_FCCSS",yytext());
                return simbolo(sym.T_FCCSS);}
<TAG_NAME>{T_TITLE}       {CrearTupla("T_TITLE",yytext());
                return simbolo(sym.T_TITLE);}
<TAG_NAME>{T_FTITLE}      {CrearTupla("T_FTITLE",yytext());
                return simbolo(sym.T_FTITLE);}
<TAG_NAME>{T_PANEL}       {CrearTupla("T_PANEL",yytext());
                return simbolo(sym.T_PANEL);}
<TAG_NAME>{T_FPANEL}      {CrearTupla("T_FPANEL",yytext());
                return simbolo(sym.T_FPANEL);}
<TAG_NAME>{T_TEXTO}       {CrearTupla("T_TEXTO",yytext());
                return simbolo(sym.T_TEXTO);}
<TAG_NAME>{T_FTEXTO}      {CrearTupla("T_FTEXTO",yytext());
                return simbolo(sym.T_FTEXTO);}
<TAG_NAME>{T_IMAGEN}      {CrearTupla("T_IMAGEN",yytext());
                return simbolo(sym.T_IMAGEN);}
<TAG_NAME>{T_FIMAGEN}     {CrearTupla("T_FIMAGEN",yytext());
                return simbolo(sym.T_FIMAGEN);}
<TAG_NAME>{T_BOTON}       {CrearTupla("T_BOTON",yytext());
                return simbolo(sym.T_BOTON);}
<TAG_NAME>{T_FBOTON}      {CrearTupla("T_FBOTON",yytext());
                return simbolo(sym.T_FBOTON);}
<TAG_NAME>{T_ENLACE}      {CrearTupla("T_ENLACE",yytext());
                return simbolo(sym.T_ENLACE);}
<TAG_NAME>{T_FENLACE}     {CrearTupla("T_FENLACE",yytext());
                return simbolo(sym.T_FENLACE);}
<TAG_NAME>{T_TABLA}       {CrearTupla("T_TABLA",yytext());
                return simbolo(sym.T_TABLA);}
<TAG_NAME>{T_FTABLA}      {CrearTupla("T_FTABLA",yytext());
                return simbolo(sym.T_FTABLA);}
<TAG_NAME>{T_FILA}        {CrearTupla("T_FILA",yytext());
                return simbolo(sym.T_FILA);}
<TAG_NAME>{T_FFILA}       {CrearTupla("T_FFILA",yytext());
                return simbolo(sym.T_FFILA);}
<TAG_NAME>{T_CHEAD}       {CrearTupla("T_CHEAD",yytext());
                return simbolo(sym.T_CHEAD);}
<TAG_NAME>{T_FCHEAD}      {CrearTupla("T_FCHEAD",yytext());
                return simbolo(sym.T_FCHEAD);}
<TAG_NAME>{T_CELDA}       {CrearTupla("T_CELDA",yytext());
                return simbolo(sym.T_CELDA);}
<TAG_NAME>{T_FCELDA}      {CrearTupla("T_FCELDA",yytext());
                return simbolo(sym.T_FCELDA);}
<TAG_NAME>{T_TEXTA}       {CrearTupla("T_TEXTA",yytext());
                return simbolo(sym.T_TEXTA);}
<TAG_NAME>{T_FTEXTA}      {CrearTupla("T_FTEXTA",yytext());
                return simbolo(sym.T_FTEXTA);}
<TAG_NAME>{T_TEXTB}       {CrearTupla("T_TEXTB",yytext());
                return simbolo(sym.T_TEXTB);}
<TAG_NAME>{T_FTEXTB}      {CrearTupla("T_FTEXTB",yytext());
                return simbolo(sym.T_FTEXTB);}
<TAG_NAME>{T_CAJA}        {CrearTupla("T_CAJA",yytext());
                return simbolo(sym.T_CAJA);}
<TAG_NAME>{T_FCAJA}       {CrearTupla("T_FCAJA",yytext());
                return simbolo(sym.T_FCAJA);}
<TAG_NAME>{T_OPCION}      {CrearTupla("T_OPCION",yytext());
                return simbolo(sym.T_OPCION);}
<TAG_NAME>{T_FOPCION}     {CrearTupla("T_FOPCION",yytext());
                return simbolo(sym.T_FOPCION);}
<TAG_NAME>{T_SPINNER}     {CrearTupla("T_SPINNER",yytext());
                return simbolo(sym.T_SPINNER);}
<TAG_NAME>{T_FSPINNER}    {CrearTupla("T_FSPINNER",yytext());
                return simbolo(sym.T_FSPINNER);}
<TAG_NAME>{T_SALTO}       {CrearTupla("T_SALTO",yytext());
                return simbolo(sym.T_SALTO);}
<TAG_NAME>{A_RUTA}        {CrearTupla("A_RUTA",yytext());
                return simbolo(sym.A_RUTA);}
<TAG_NAME>{A_CLICK}       {CrearTupla("A_CLICK",yytext());
                return simbolo(sym.A_CLICK);}
<TAG_NAME>{A_VALOR}       {CrearTupla("A_VALOR",yytext());
                return simbolo(sym.A_VALOR);}
<TAG_NAME>{A_ID}          {CrearTupla("A_ID",yytext());
                return simbolo(sym.A_ID);}
<TAG_NAME>{A_GRUPO}       {CrearTupla("A_GRUPO",yytext());
                return simbolo(sym.A_GRUPO);}
<TAG_NAME>{A_ALTO}        {CrearTupla("A_ALTO",yytext());
                return simbolo(sym.A_ALTO);}
<TAG_NAME>{A_ANCHO}       {CrearTupla("A_ANCHO",yytext());
                return simbolo(sym.A_ANCHO);}
<TAG_NAME>{A_ALINEADO}    {CrearTupla("A_ALINEADO",yytext());
                return simbolo(sym.A_ALINEADO);}
<TAG_NAME>{A_TVALOR}       {CrearTupla("A_TVALOR",yytext());
                return simbolo(sym.A_TVALOR);}
<TAG_NAME>{A_FONDO}       {CrearTupla("A_FONDO",yytext());
                return simbolo(sym.A_FONDO);}
<YYINITIAL>{TEXTO_CHTML}       {CrearTupla("TEXTO_CHTML",yytext());
                return simbolo(sym.TEXTO_CHTML);}

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