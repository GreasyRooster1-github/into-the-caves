String title = "";
boolean titleDisplay = false;
int titleFrame = 0;

void subTitle(String str){
  titleDisplay = true;
  textSize(27);
  fill(255);
  textAlign(CENTER);
  text(str,250,430);
  titleFrame = frameCount;
}
