// Lost Worlds Client Code, written/put together by Amanda Howanice and Milo Trujillo
//To do: adjust buttons/fonts, figure out how to build stuff...
/*
 
*/
import processing.net.*;
import java.io.*;
import java.net.*;

Socket myClient;
String dataIntake;
String userInput = "";
int i;
Tile[] TileArray = new Tile[19];
Button[] CenterButtonArray = new Button[6];
boolean screenSwitch = false;
PImage menu;
PImage gameScreen;
// username and password variables
String usernameT = "";
String usernameS = "";
String passwordT = "";
String passwordS = "";
String savedName;

PFont font1;
//Button variables:

//Login Button
int w1 = 200;
int h1 = 100;
int x1 = 50;
int y1 = 500;
boolean boardChange = false;

//Login Button Font Variables:
int xv = 100;
int yv = 600;

//Register Button Text Variables:
int xv2 = 100;
int yv2 = 100;

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
//Button h0 = new Button("water.png","test.png",


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
  font1 = createFont("Rosewood.ttf",20);
  textFont(font1);
  for (int i = 0; i < RowList.length; i++){
    print(RowList[i]);
  }

}


void draw()
{ //Menu Screen Stuff
  if (screenSwitch == false){
    background(menu);
    textSize(20);
    login.display();
    register.display();
    text(usernameT,xv,yv); //originally 150 525
    text(tmp,xv2,yv2); //originally 150, 590
    text(usernameS, 575,600);
    text(passwordS,575,700);
    
    
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
    //Controls display of tiles
   
    try{
   CenterButtonArray[0] = new Button("test.png","test.png",TileArray[4].getX(),TileArray[4].getY(),false);
   CenterButtonArray[1] = new Button("test.png","test.png",TileArray[5].getX(),TileArray[5].getY(),false);
   CenterButtonArray[2] = new Button("test.png","test.png",TileArray[8].getX(),TileArray[8].getY(),false);
   CenterButtonArray[3] = new Button("test.png","test.png",TileArray[10].getX(),TileArray[10].getY(),false);
   CenterButtonArray[4] = new Button("test.png","test.png",TileArray[13].getX(),TileArray[13].getY(),false);
   CenterButtonArray[5] = new Button("test.png","test.png",TileArray[14].getX(),TileArray[14].getY(),false);
   }
   catch(Exception e){
     //print(e);
    return; 
    }
  
    for (int i = 0; i < TileArray.length; i++)
    {
      if (TileArray[i] == null)
      {
        continue;
      }
      TileArray[i].converter();
      TileArray[i].display();
    }
  for (int i = 0; i < CenterButtonArray.length; i++)
  {
    if (CenterButtonArray[i] == null)
    {
      print("Something wrong");
      continue;
    }
    CenterButtonArray[i].display();
    }
  }
}
//Responsible for command button switches, along with the screen switch
void mouseClicked(){ 
// The Change Board Button
  if (screenSwitch == true){
   if ((mouseX >= x3) && (mouseX < x3+w1) && (mouseY > y3) && (mouseY < y3+h1)){
    boardChange = true; 
    CommandList.append("description\n");
    ArrayBuilder();
    description.Switch();
    //UserInput("description:");
    //if (key ==ENTER){
      //description.Switch(); // Changes the description button back to its "off" position
    //}
    ypos = 220;
  }
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
    //All the movement buttons
    for (int i = 0; i < CenterButtonArray.length; i++)
    {
      if (CenterButtonArray[i] == null)
      {
        continue;
      } //Get2X(); Get2Y();
      //if mouseX and mouseY are a certain distance from CenterButtonArray[i].Get2X(); and CenterButtonArray[i].Get2Y();
      if ( dist(CenterButtonArray[i].get2X()+75,CenterButtonArray[i].get2Y()+75,mouseX,mouseY) <= 75)
      {
        print("*&*They clicked in the circle!!");
        CenterButtonArray[i].Switch();
        print("I switched!");
        CommandList.append(("move:"+i+"\n"));
        ArrayBuilder();
        CenterButtonArray[i].Switch();
        print("I'm a button again!"); 
      }
    }
    
  if ((screenSwitch == false)){ // The login button
    if ((mouseX >= x1) && (mouseX < x1+w1) && (mouseY > y1) && (mouseY < y1+h1)){
      if (regButton == true){
        register.Switch();
      }
      regButton = false;
      login.Switch(); //triggers image switch for the button
      if ((usernameT.length()>0)|| passwordT.length()>0){
        usernameT = "";
        passwordT = "";
        tmp = "";
      }
      //register.Switch();
      fill(0);
      xv = 150;
      yv = 525;
      xv2 = 150;
      yv2 = 590;
      //if (regButton == false){
        //if ((regButton == false) && loginButton == false){
        //return;
      //}
        //register.Switch();
      //}
      if (loginButton == false){
        loginButton = true;
        return;
      }
      if (loginButton == true){
        loginButton = false;
      }
    }
    if ((mouseX >= x2) && (mouseX < x2+w2) && (mouseY > y2) && (mouseY < y2+h2)){ // The register button
      if ((loginButton == true)){
        login.Switch();
      }
      loginButton = false;
      register.Switch();
      fill(0);
       if ((usernameT.length()>0)|| passwordT.length()>0){
          usernameT = "";
          passwordT = "";
          tmp = "";
        }
      xv = 150;
      yv = 675;
      xv2 = 150;
      yv2 = 740;
      //if (loginButton == true){
        //login.Switch();
      //}
      if (regButton == false){
        regButton = true;
        return;
      }
      if (regButton == true){
        regButton = false;
      }
     }
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
    if ((screenSwitch == false) && (loginButton == true) && (regButton ==false)){
    UserInput("login:"); //Calls User Input function when login button is clicked
  }
  if ((screenSwitch == false) && (regButton == true) && (loginButton ==false)){
    UserInput("register:"); //Calls User input function when register button is clicked
  }
 
  //if ((screenSwitch == true) && (boardChange == true))
  //{
    //CommandList.append("description:0\n");
    //ArrayBuilder();
    //UserInput("description:");
    //if (key ==ENTER){
      //description.Switch(); // Changes the description button back to its "off" position
    //}
    //ypos = 220;
  //}
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
   myClient= new Socket("128.113.138.14",2345);
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
    if (line.equals("Login successful.")){
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
 //Fill in 6 buttons here with Tile array info
 try{
   CenterButtonArray[0] = new Button("test.png","water.png",TileArray[4].getX(),TileArray[4].getY(),false);
   CenterButtonArray[1] = new Button("test.png","water.png",TileArray[5].getX(),TileArray[5].getY(),false);
   CenterButtonArray[2] = new Button("test.png","water.png",TileArray[8].getX(),TileArray[8].getY(),false);
   CenterButtonArray[3] = new Button("test.png","water.png",TileArray[13].getX(),TileArray[13].getY(),false);
   CenterButtonArray[4] = new Button("test.png","water.png",TileArray[14].getX(),TileArray[14].getY(),false);
   
 }
 catch(Exception e){
  //print(e);
  return; 
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
   //Button h0 = new Button("test.png","test.png",xpos,ypos,false); //Creates clickable pseudo tile buttons
   //h0.display();
   //rectMode(CENTER);
   fill(255);
   if (prob.equals("0")){
     //print("hai, it's not equal");
   } else{
     ellipse(xpos+75,ypos+100,25,25);  
   //originally 50 50
     fill(0);
     if (prob.length() == 1){
     text(prob,xpos+70,ypos+108);
     }
     if (prob.length() == 2){
     text(prob,xpos+61,ypos+108);  
     }
   }
 }
 public final int getX(){
  return xpos; 
 }
 public final int getY(){
  return ypos; 
 }
}

class Button{ //Class for buttons, which control their imagery, being turned on/off, and position. 
 boolean clicked;
 String namePlaceholder;
 String name;
 String name2;
 int y2pos;
 int x2pos; 
 Button ( String nameTemp,String nameTemp2,int xposTemp, int yposTemp, boolean clickedTemp){
   clicked = clickedTemp;
   name = nameTemp;
   name2 = nameTemp2;
   y2pos = yposTemp;
   x2pos = xposTemp;
 }
 void display(){
   if (clicked == false){
     image(loadImage(name),x2pos,y2pos); 
   }
  if (clicked== true){
     image(loadImage(name2),x2pos,y2pos);
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
 public final int get2X(){
  return x2pos; 
 }
 public final int get2Y(){
  return y2pos; 
 }
}