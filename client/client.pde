import processing.net.*;
import java.io.*;
import java.net.*;

Socket myClient;
String dataIntake;
String userInput = "";
int i;
Tile[] TileArray = new Tile[7];

void setup()
{
  size(1000,600);
  i = 1;
  ArrayBuilder();
  print("HAI");
  for (int i = 0; i < TileArray.length; i++){
    //print (TileArray[i]);
  }
}


void draw()
{
  background(255);
  fill(0);
  text(userInput,200,200);
  //if (dataIntake != null){
   //text(dataIntake,300,300);
  //}
  
  for (int i = 0; i < TileArray.length; i++)
  {
    if (TileArray[i] == null)
    {
      //print(TileArray[i-1]);
      continue;
    }
    TileArray[i].converter();
    TileArray[i].display();
  }
  
}

void keyPressed()
{
  if ((key == BACKSPACE) && userInput.length() > 0 && (i < userInput.length()))
  {
    userInput = "";
  }
  if (key =='\n'){
    //myClient.write(userInput);
    ArrayBuilder();
    userInput = "";
  }
  else 
  {
    userInput = userInput + key;
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
   out.write("description:0\n");
   out.flush();
  }
  catch(Exception e)
  {
    print("Something went wrong. HALP.");
    return;
  }
 int i = 0;
 
 
 
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
       print(hex(c));
       print("\n");
       if ((ret == -1)|| (c==0xFFFF))
       {
         print("ret is equal to -1.");
         return;
       }
       if (c == '\n')
       {
        //print("c == \n");
        break; 
       }
       line+=c;
     }
 
     print(line);
     String[] d = split(line,':');
     if (d.length != 5)
     {
       print ("d.length != 5");
       continue;
     }
     //print("Description String:",d);
     TileArray[i] = new Tile( d[1],d[2],d[3]);
     print("Hey. it crashed here");
     print(d[1],d[2],d[3]);
     print("\n");
     //print("This line is a nope line. Cause nope, it doesn't work.");
     i++;
   }
   catch(Exception e)
   {
    print("Whyyyyyyyyy....",e.getMessage());
    print(e.getMessage());
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
  int xoffsetDeep = 350;
  int xoffsetShallow = 300;
  Tile(String nameTemp, String rowTemp, String columnTemp)
 {
  name = nameTemp+".png";
  row = rowTemp;
  column = columnTemp;
 } 
 void converter()
 {
   ypos = 200+75*int(row);
   if ( int(row)%2 == 0)
   {
   xpos = xoffsetDeep+ 100*int(column);
   }
  if ( int(row)%2 != 0)
 { 
    xpos = xoffsetShallow + 100*int(column);
 }

 }
 void display()
 {
   image(loadImage(name),xpos,ypos);
 }
}


