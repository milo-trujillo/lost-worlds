import processing.net.*;
import java.io.*;
import java.net.*;

Socket myClient;
String dataIntake;
String userInput = "";
int i;
Tile[] TileArray = new Tile[19];
boolean screenSwitch = false;
PImage menu;
String usernameT = "";
String usernameS = "";
String passwordT = "";
String passwordS = "";
String tmp = "";
boolean pass= false;
int RowList[] = new int[0];
String rc;

void setup()
{
  menu = loadImage("menu.png");
  size(1024,768);
  i = 1;
  //print(round(float(5)/float(2)));
  userInput = "description:0\n";
  ArrayBuilder();
  //print(RowList);
  userInput = "";
  //print("HAI");
  background(menu);
  for (int i = 0; i < RowList.length; i++){
    print(RowList[i]);
  }

}


void draw()
{
  if (screenSwitch == false){
    background(menu);
    textSize(40);
    text("Enter your username ==> ", 50,300);
    text(usernameT,575,300);
    text("Enter your password ==> ",50, 350);
    text(tmp,575,350); 
    text(usernameS, 575,600);
    text(passwordS,575,700);
  }
  if (screenSwitch == true)
  {
    textSize(20);
    background(255);
    fill(0);
    text(userInput,200,200);
    for (int i = 0; i < TileArray.length; i++)
    {
      if (TileArray[i] == null)
      {
        continue;
      }
      TileArray[i].converter();
      TileArray[i].display();
    }
  }
  
}
void mouseClicked(){
  screenSwitch = true;
}
void keyPressed()
{
  if (screenSwitch == false){
     if (key == '\n'){
      //saves the string the user typed
      usernameS = usernameT;
      usernameT = "";
      passwordS = passwordT;
      passwordT = "";
      tmp = "";
      //print(RowList);
    } if ((key!='\n') && (keyCode!= SHIFT) && (pass == false))
    {
     usernameT = usernameT + key; 
    }
    if (key == '\t'){
      pass = true;
      tmp = "";
    }
    if ((keyCode == BACKSPACE) && (pass == false))
    {
      usernameT = "";
    }
    if ((keyCode == BACKSPACE) && (pass == true))
    {
      passwordT = "";
      tmp = "";
    }
    if ((key!='\n') && (keyCode!= SHIFT) && (pass == true) && (key!='\t') && (keyCode!= BACKSPACE) )
    {
     passwordT = passwordT + key; 
     tmp = tmp+"*";
    } 
  }
  if (screenSwitch == true)
  {
    if ((keyCode == BACKSPACE) ) //&& userInput.length() > 0 && (i < userInput.length())
    {
      userInput = "";
    }
    if ((key =='\n') && (keyCode!= BACKSPACE)){
      //myClient.write(userInput);
      userInput= userInput+"\n";
      String temp = "";
      int op = 0;
      int np = 0;
      int j = 0;
      for (i = 0; i < userInput.length(); i++)
      {
       if ((userInput.charAt(i) >= 33) && (userInput.charAt(i)<=126))
       {
         temp+= userInput.charAt(i);
         j++;
       }
      }
      userInput = temp+"\n";
      ArrayBuilder();
      //print(RowList);
      userInput = "";
    }
    if ((key!='\n') && (keyCode!= SHIFT) && (keyCode != BACKSPACE))
    {
      userInput = userInput + key;
    } 
  }
}

void ArrayBuilder()
{
  PrintWriter out;
  BufferedReader in;
  try
  {
   myClient= new Socket("128.113.196.236",2345);
   myClient.setSoTimeout(3000);
   out = new PrintWriter(myClient.getOutputStream(), true);
   in = new BufferedReader(new InputStreamReader(myClient.getInputStream()));
   out.write(userInput);
   out.flush();
  }
  catch(Exception e)
  {
    //print("Something went wrong. HALP.");
    return;
  }
 int i = 0;
 //String RowList[] = new String[0];
 
 while (true)
 {
   try
   {
     String line = "";
     //print ("Something went wrong here.");
     /*
     if ((line = in.readLine()) == null)
     {
       print("hey. Hello. hi.");
       return;
     }
     */
    int ret;
    char c; 
     while( true )
     {
       ret =(c = (char)myClient.getInputStream().read());
       //print("...");
       //print(hex(c));
       //print("\n");
       if ((ret == -1)|| (c==0xFFFF))
       {
         //print("ret is equal to -1.");
         return;
       }
       if (c == '\n')
       {
        //print("c == \n");
        break; 
       }
       line+=c;
     }
 
     //print(line);
     String[] d = split(line,':');
     if (d.length != 5)
     {
       //print ("d.length != 5");
       continue;
     }
     //print("Description String:",d);
     TileArray[i] = new Tile( d[1],d[2],d[3],d[4]);
     //print("Hey. it crashed here");
     //print(d[1],d[2],d[3]);
     rc = d[2];
     //print("\n");
     //print(rc);
     RowList = append(RowList,int(rc));
     //print(RowList);
     //print("This line is a nope line. Cause nope, it doesn't work.");
     i++;
   }
   catch(Exception e)
   {
    //print("Whyyyyyyyyy....",e.getMessage());
    //print(e.getMessage());
    break; 
   }
 }
 
 
  
}

class Tile
{
  String name;
  String row;
  String column;
  int xpos;
  int ypos;
  int totalRows;
  int xoffsetDeep = 400;
  int xoffsetShallow = 325;
  String prob;
  Tile(String nameTemp, String rowTemp, String columnTemp,String probTemp )
 {
  name = nameTemp+".png";
  row = rowTemp;
  column = columnTemp;
  prob = probTemp;
 }
 void converter()
 {
   ypos = (115*int(row))+100;
   if ( int(row)%2 == 0)
   {
   xpos = xoffsetDeep+ 150*int(column);
   }
  if ( int(row)%2 != 0)
 { 
    xpos = xoffsetShallow + 150*int(column);
 }
 if ((round(float(max(RowList))/float(2)) == int(row))){
   xpos = xoffsetShallow-75 + 150*int(column);
 }

 }
 void display()
 {
   image(loadImage(name),xpos,ypos);
   //rectMode(CENTER);
   fill(255);
   ellipse(xpos+75,ypos+75,50,50);
   fill(0);
   text(prob,xpos+70,ypos+80);
 }
}


