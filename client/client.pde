import processing.net.*;
Client myClient;
String dataIntake;
String userInput = "";
int i;
void setup()
{
  size(600,400);
  i = 1;
  myClient= new Client(this,"129.161.198.131",1234);
}


void draw()
{
  if (myClient.available() > 0) 
  {
   dataIntake = myClient.readStringUntil('\n'); 
  }
  background(255);
  fill(0);
  text(userInput,200,200);
  if (dataIntake != null){
    text(dataIntake,300,300);
  }
}

void keyPressed()
{
  if ((key == BACKSPACE) && userInput.length() > 0 && (i < userInput.length()))
  {
    userInput = "";
  }
  if (key =='\n'){
    myClient.write(userInput);
    userInput = "";
  }
  else 
  {
    userInput = userInput + key;
  } 
}

