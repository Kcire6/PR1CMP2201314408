/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import java.util.ArrayList;

/**
 *
 * @author happy_000
 */


/*
id::
    1 = CHTML 
    2 = 
    3 =
    4 = 
    5 = 
    6 =
    7 = 
    8 =
*/
public class Nodo {
    public String name;
    public int id;
    public String value;
    
    public ArrayList<Nodo> hijos = new ArrayList<Nodo>();
    
    public Nodo(String name, int id, String value){
        this.name = name;
        this.id = id;
        this.value = value;
    }
}
