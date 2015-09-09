// Lost Worlds Client Code, written/put together by Amanda Howanice and Milo Trujillo
//To do: adjust buttons/fonts, figure out how to build stuff...
/*
Goals for building stuff:
Create class that makes building objects, have server make array of built things, 
cycle through the built things and display them (function inside the Building class, add UI to have the user be able to select
vertices rather than manually entering which they want to build. 
*/
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
PImage gameScreen;
// username and password variables
String usernameT = "";
String usernameS = "";
String passwordT = "";
String passwordS = "";
String savedName;

//Button variables:

//Login Button
int w1 = 200;
int h1 = 100;
int x1 = 50;
int y1 = 500;
boolean boardChange = false;

// Register button
int w2 = 200;
int h2 = 100;
int y2 = 650;
int x2 = 50;
boolean build1 = false;

//Description button
int x3 = 55;
int y3 = 130;
//Build Button
int x4 = 55;
int y4 = 600;

Button login = new Button("login1.png","login2.png",x1,y1,false);
Button register = new Button("reg1.png","reg2.png",x2,y2,false);
Button description = new Button("d1.png","d2.png",x3,y3,false);
Button build = new Button("build1.png","build2.png",x4,y4,false);



// positions of text
int ypos;

//password login stuff
boolean pass= false;
String tmp = "";
int RowList[] = new int[0];
String rc;
String message1;
boolean loginButton = false;
boolean regButton = false;
StringList CommandList;

void setup()
{
  menu = loadImage("menu.png");
  gameScreen = loadImage("game.png");
  size(1024,768);
  i = 1;
  CommandList = new StringList();
  //print(round(float(5)/float(2)));
  //userInput = "description:0\n";
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
{ //Menu Screen Stuff
  if (screenSwitch == false){
    background(menu);
    textSize(40);
    text(usernameT,300,550);
    text(tmp,300,600); 
    text(usernameS, 575,600);
    text(passwordS,575,700);
    login.display();
    register.display();
    
  }
  if (screenSwitch == true)
  { //In game screen stuff
    background(gameScreen);
    textSize(20);
    fill(120,120,120);
    fill(0,200,200);
    description.display();
    build.display();
    fill(0);
    textSize(20);
    text(userInput,220,ypos);
    //Need another for loop like this one to display the array of built stuff
    //Controls display of tiles
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
//Responsible for command button switches, along with the screen switch
void mouseClicked(){ 
// The Change Board Button
  if (screenSwitch == true){
   if ((mouseX >= x3) && (mouseX < x3+w1) && (mouseY > y3) && (mouseY < y3+h1)){
    boardChange = true; 
    description.Switch();
    if (build1 == true){
      build1 = false;
      build.Switch();
    }
// The Build button
   }
   if ((mouseX >= x4) && (mouseX < x4+w2) && (mouseY > y4) && (mouseY < y4+h2)){
    build1 = true; 
    build.Switch();
    if (boardChange == true){
      boardChange = false;
      description.Switch();
    }
    
   } 
  }
  if ((screenSwitch == false)){ // The login button
    if ((mouseX >= x1) && (mouseX < x1+w1) && (mouseY > y1) && (mouseY < y1+h1)){
      regButton = false;
      login.Switch(); //triggers image switch for the button
      if (loginButton == false){
        loginButton = true;
        return;
      }
      if (loginButton == true){
        loginButton = false;
      }
    }
  }
    if ((mouseX >= x2) && (mouseX < x2+w2) && (mouseY > y2) && (mouseY < y2+h2)){ // The register button
      regButton = true;
      loginButton = false;
      register.Switch(); 
   }
}

//Responsible for constructing user input into a string, making backspace work, having username/passwords be a thing, setting positions of user input text on screen, recording the user's input
void keyPressed()
{ //This block is respomsible for recording user input only on the main menu screen, after the login button or the register button has been clicked.
  if ((screenSwitch == false) && ((loginButton == true) || (regButton == true))) {
      if (key == '\n'){
      //saves the string the user typed
      usernameS = usernameT+":"+passwordT;
      usernameT = "";
      passwordS = passwordT;
      passwordT = "";
      tmp = "";
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
      usernameS = "";
    }
    if ((keyCode == BACKSPACE) && (pass == true))
    {
      passwordT = "";
      passwordS = "";
      tmp = "";
      if ((passwordS == "") &&(keyCode == BACKSPACE)){
        usernameT = "";
        usernameS = "";
        tmp = "";
        pass = false;
      }
    }
    if ((key!='\n') && (keyCode!= SHIFT) && (pass == true) && (key!='\t') && (keyCode!= BACKSPACE) )
    {
     passwordT = passwordT + key; 
     tmp = tmp+"*";
    } 
  } 
    if ((screenSwitch == false) && (loginButton == true)){
    UserInput("login:"); //Calls User Input function when login button is clicked
  }
  if ((screenSwitch == false) && (regButton == true)){
    UserInput("register:"); //Calls User input function when register button is clicked
  }
 
  if ((screenSwitch == true) && (boardChange == true))
  {
    UserInput("description:");
    if (key ==ENTER){
      description.Switch(); // Changes the description button back to its "off" position
    }
    ypos = 220;
  }
  if ((screenSwitch == true) && (build1 == true))
  {
    UserInput("build:");
    if (key ==ENTER){
      build.Switch(); //Sets the build button to its off position.
    }
    ypos = 600;
  }
}
//Responsible for preparing user input to send to the server/calling array builder to construct the tile arrays.... 
void UserInput(String type)
{
    if ((keyCode == BACKSPACE) ) //&& userInput.length() > 0 && (i < userInput.length())
  {
    userInput = "";
  }
  if ((key =='\n') && (keyCode!= BACKSPACE)){
    //myClient.write(userInput);
    userInput= type+userInput+"\n";
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
    //Responsible for adding commands to the list sent to the server #####################
    userInput = temp+"\n";
    if (CommandList.size() >=2){
     CommandList.remove(1);
    }
    CommandList.append(userInput);
    //#######################################################
    ArrayBuilder();
    //print(RowList);
    userInput = "";
    boardChange = false;
    build1 = false;
  }
  if ((key!='\n') && (keyCode!= SHIFT) && (keyCode != BACKSPACE))
  {
    userInput = userInput + key;
  } 
  // new if statement
  if ((key =='\t') )
  {
   userInput = trim(userInput)+":";

  }
}

void ArrayBuilder() //Responsible for constructing tile arrays, along with opening the connection to the server, sending messages to the server, and receiving messages from the server.
{
  PrintWriter out;
  BufferedReader in;
  try
  { //Connecting to the server stuff
   myClient= new Socket("50.184.155.187",2345);
   myClient.setSoTimeout(3000);
   out = new PrintWriter(myClient.getOutputStream(), true);
   in = new BufferedReader(new InputStreamReader(myClient.getInputStream()));
   if (screenSwitch == true){ //Sends commands to the server in a list, with login being first and then other commands afterward
     for (int i = 0; i < CommandList.size(); i++){
      out.write(CommandList.get(i));
      out.flush(); 
     }
   }
   out.write(userInput);
   out.flush();
  }
  catch(Exception e)
  {
    return;
  }
 int i = 0;
 
 while (true)
 { //Listens for server input and adds each character to a string, saving it as "line", then splitting that string into the appropriate list to build the tile array
   try
   {
    String line = "";
    int ret;
    char c; 
     while( true )
     {
       ret =(c = (char)myClient.getInputStream().read());
       if ((ret == -1)|| (c==0xFFFF))
       {
         //print("It got to line 297");
         return;
       }
       if (c == '\n')
       {
        //print("It got to line 302");
        break; 
       }
       //print(line);
       //print(c);
       line+=c;
       //print(line);
     }
 
     print("<"+line+">");
     print(line.length());
    if (line.length() == 17){
     //print ("screenswitch is true");
        screenSwitch = true;
        savedName = userInput;
        //print(savedName);
        //CommandList.append(savedName);
        //print(CommandList);
        
    } 
    print(CommandList);
     String[] d = split(line,':');
     if (d.length != 5)
     {
       continue;
     }
     TileArray[i] = new Tile( d[1],d[2],d[3],d[4]);
     rc = d[2];
     RowList = append(RowList,int(rc));
     i++;
   }
   catch(Exception e)
   {
    //print(e.getMessage());
    break; 
   }
 }
}
/*
//The hypothetical class for the built stuff... I need to know how they're being 
identified to the server then somewhow figure out a formula to have each one be displayed. 
class Building
{
 String name;
 String LocationinfoTBD
 int xpos;
 int ypos; 
 Building(String nameTemp, String LocationinfoTBD,){
   name = nameTemp;
 }
 
}
*/
class Tile
{ //Class to construct each tile
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
   ellipse(xpos+75,ypos+100,25,25); //originally 50 50
   fill(0);
   if (prob.length() == 1){
   text(prob,xpos+70,ypos+108);
   }
   if (prob.length() == 2){
   text(prob,xpos+61,ypos+108);  
   }
 }
}

class Button{ //Class for buttons, which control their imagery, being turned on/off, and position. 
 boolean clicked;
 String namePlaceholder;
 String name;
 String name2;
 int ypos;
 int xpos; 
 Button ( String nameTemp,String nameTemp2,int xposTemp, int yposTemp, boolean clickedTemp){
   clicked = clickedTemp;
   name = nameTemp;
   name2 = nameTemp2;
   ypos = yposTemp;
   xpos = xposTemp;
 }
 void display(){
   if (clicked == false){
     image(loadImage(name),xpos,ypos); 
   }
  if (clicked== true){
     image(loadImage(name2),xpos,ypos);
   }
 }
 void Switch(){
   if (clicked == true){
    clicked = false;
    return;
   }
   if (clicked == false){
     clicked = true; 
   }
 }
}
