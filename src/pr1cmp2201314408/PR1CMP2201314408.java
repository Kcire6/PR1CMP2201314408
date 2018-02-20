/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pr1cmp2201314408;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.StringReader;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import jflex.*;
//import AnalizadorCHTML.Parser;
//import AnalizadorCHTML.Yylex;
import AnalizadorCJS.Parser;
import AnalizadorCJS.Yylex;
import java.io.FileWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
/**
 *
 * @author happy_000
 */
public class PR1CMP2201314408 {

    /**
     * @param args the command line arguments
     */
    
 
    public static void main(String[] args) {
        // TODO code application logic here
        
        String archivo = "C:/Users/happy_000/Documents/GitHub/entradaCJS.txt";
        String content = "";
        
        try{
            
        content = new String (Files.readAllBytes(Paths.get(archivo))).replace('\u201C', '\"')
                                                                     .replace('\u201D', '\"')
                                                                     .replace('\u2019', '\'')
                                                                     .replace('\u2018', '\'');
        
        File file = new File(archivo);
        FileWriter fileWriter = new FileWriter(file);
	fileWriter.write(content);
	fileWriter.flush();
	fileWriter.close();
        FileReader f = new FileReader(archivo);
        BufferedReader b = new BufferedReader(f);
        
        Yylex lex = new Yylex(b);
        Parser parse = new Parser(lex);
        parse.parse();
           
        lex.graficar();
        }catch(Exception ex){
            
        }
        
    }
    
}
