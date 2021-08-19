import gifAnimation.*;

int size = 10;
int x = size*20;
int y = size*20;
int iterations = 2200;
int open = 2;
int erosion = 1;
int walls = 1;
int wallChance = 3;
float noiseScale = 0.02;
float zoom = 5;
int xoff = -500;
int yoff = -500;
int speed = 3;
char[] keysDown = {};
int playerCW = 30;
int playerCH = 15;
int px = 200;
int py = 200;
int mapW = 50;
int mapH = 50;
boolean checkSpawn = true;
boolean superBreak = false;
color lightCol = color(0);
float breakMult = 1;
boolean debug = true;
float pickBreakSpeed = 1.7;
float ironBreakSpeed = 2.0;
boolean hasPick = false;
boolean hasSeenRoots = false;
boolean hasSeenRubys = false;
int selectedSlot = 0;
boolean moving = false;
boolean craftingOpen = false;
int pickLevel = 0;
InvSlot[] inventory = {};

Block[] map = {};
Block[] blocks = {};
Item[] items = {};
Place[] playerBlocks = {};

void setup(){
  size(500,500);
  loadImages();
  loadItems();
  makeGrid();
  for(int i=0;i<erosion;i++){
    makeMaze();
  }
  newBlock(0,0,mapW*size,mapH*size);
  blocks[blocks.length-1].border = true;
  map = blocks;
  for(Block eachBlock : blocks){
    eachBlock.update();
  }
  for(Place eachBlock : playerBlocks){
    eachBlock.update();
  }
  frameRate(40);
  collectItem(new Item(0,0,newType(workbenchItem, "workbench", true, 25, itemConst[13])));
  for(int i=0;i<9;i++){
    collectItem(new Item(0,0,itemConst[i]));
  }
}

//draw

void draw(){
  titleDisplay = false;
  background(0);
  for(Block eachBlock : blocks){
    eachBlock.update();
  }
  
  for(Item eachItem : items){
    eachItem.update();
  }
  fill(255);
  noStroke();
  //rect(px,py,playerCW,playerCH);
  if(moving){
    image(player,px,py-15,playerCW,30);
  }else{
    image(playerIdle,px,py-15,playerCW,30);
  }
  for(Place eachBlock : playerBlocks){
    eachBlock.update();
  }
  playerMove();
  breakBlock();
  updateLight();
  //println(zoom);
  checkSpawn = false;
  if(craftingOpen){
    craftingMenu(null);
  }
  inv();
  if(frameCount<2){
    background(127);
    textAlign(CENTER);
    fill(255);
    textSize(30);
    text("THIS IS A DEMO!",250,250);
    textSize(20);
    text("ALL ART AND GAMEPLAY ARE SUBJECT TO CHANGE!",250,280);
    textSize(20);
    text("MOST FEATURES ARE NOT YET IMPLEMENTED",250,310);
    textSize(20);
    text("BUGS WILL OCCUR",250,340);
  }
  fill(255);
  textSize(20);
  text(frameRate,50,50);
}

//functions 

void inv(){
  
  for(int i=0;i<10;i++){
    if(selectedSlot==i){
      image(inv,(i*48)+10-2,450-2,52,52);
    }else{
      image(inv,(i*48)+10,450,48,48);
    }
    if(inventory.length>i){
      if(inventory[i].selected){
        inventory[i].x = mouseX-20;
        inventory[i].y = mouseY-20;
        inventory[i].moving = true;
      }
      if(!inventory[i].moving){
        if(inventory[i].crafting){
          inventory[i].x = 250-25;
          inventory[i].y = 50-25;
        }else{
          inventory[i].x = (inventory[i].slot*48)+10;
          inventory[i].y = 450;
        }
      }
      if(collision(inventory[i].x,inventory[i].y,48,48,mouseX,mouseY,2,2)&&mousePressed){
        inventory[i].selected = true;
      }
      if(crafting){
        if(collision(inventory[i].x,inventory[i].y,48,48,100,100,300,300)){
          inventory[i].glowing = true;
        }
      }
      if(!mousePressed){
        if(crafting){
          inventory[i].selected = false;
        }else{
          if(inventory[i].item.item.isBlock && inventory[i].selected){
            boolean touch = false;
            println("bred");
            for(Block eachBlock : blocks){
              if((collision(mouseX,mouseY,2,2,eachBlock.vx,eachBlock.vy,eachBlock.vw,eachBlock.vh)&&!eachBlock.border)){
                touch = true;
                inventory[i].selected = false;
                inventory[i].moving = false;
                inventory[i].glowing = false;
                break;
              }
            }
            if(!touch){
              Place p = getPlace(inventory[i].item.item,floor(((mouseX-xoff)/zoom)/10)*10,floor(((mouseY-yoff)/zoom)/10)*10);
              if(!collision(p.vx,p.vy,p.vw,p.vh,px,py,playerCW,playerCH)){
                newPlace(inventory[i].item.item,floor(((mouseX-xoff)/zoom)/10)*10,floor(((mouseY-yoff)/zoom)/10)*10);
                inventory[i].selected = false;
                inventory[i].moving = false;
                inventory[i].glowing = false;
                inventory[i].count--;
                reloadInv();
                touch = true;
              }
              break;
            }
          }else{
            inventory[i].selected = false;
            inventory[i].moving = false;
            inventory[i].glowing = false;
          }
        }
      }
      image(inventory[i].item.item.img,inventory[i].x,inventory[i].y,48,48);
      if(inventory[i].item.item.img==pickItem){
        setBreakSpeed(pickBreakSpeed,1);
      }
      if(inventory[i].item.item.img==ironPickItem){
        setBreakSpeed(ironBreakSpeed,2);
      }
      fill(255);
      textSize(20);
      if(!inventory[i].crafting){
        text(str(inventory[i].count),inventory[i].x,inventory[i].y,48,48);
      }
    }
  }
}

void breakBlock(){
  for(Block eachBlock : blocks){
    if(collision(mouseX,mouseY,10,10,eachBlock.vx,eachBlock.vy,eachBlock.vw,eachBlock.vh)&&mousePressed){
      if(!eachBlock.border){
        if(pickLevel>=3){
          if(eachBlock.ore==3&&!hasSeenRubys){
            eachBlock.brs = 100;
            subTitle("Rubys! These must be worth millions!");     
          }
          eachBlock.breaking = true;
        }else{
          if(!hasSeenRoots&&eachBlock.type == "wood"){
            subTitle("Roots? This far underground? How?");
            eachBlock.brs = 70;
            eachBlock.breaking = true;
          }
          if(!hasPick){
            if(eachBlock.ore!=5){
              subTitle("I can't break this yet...");
              eachBlock.breaking = false;
            }else{
              eachBlock.breaking = true;
            }
          }
          if(pickLevel==1){
            if(eachBlock.ore>0&&eachBlock.ore!=5){
              subTitle("I can't break this yet...");
              eachBlock.breaking = false;
            }
          }
          if(pickLevel==2){
            eachBlock.breaking = true;
            if(eachBlock.ore>2&&eachBlock.ore!=5){
              subTitle("I can't break this yet...");
              eachBlock.breaking = false;
            }
          }
          if(pickLevel==3){
            eachBlock.breaking = true;
          }
        }
      }
    }
  }
  for(Place eachBlock : playerBlocks){
    if(collision(mouseX,mouseY,10,10,eachBlock.vx,eachBlock.vy,eachBlock.vw,eachBlock.vh)&&mousePressed){
      if(!eachBlock.border){
        eachBlock.breaking = true;
      }
    }
  }
}

boolean checkMove(int x,int y){
    for(Block eachBlock : blocks){
        float vx = (eachBlock.x*zoom)+xoff;
        float vy = (eachBlock.y*zoom)+yoff;
        float vw = eachBlock.w*zoom;
        float vh = eachBlock.h*zoom;
        if(eachBlock.faces[0]){
          if(lineRect(eachBlock.vx,eachBlock.vy,eachBlock.vx+eachBlock.vw,eachBlock.vy,x,y,playerCW,playerCH)){
            return true;
          }
        }
        if(eachBlock.faces[1]){
          if(lineRect(eachBlock.vx+eachBlock.vw,eachBlock.vy,eachBlock.vx+eachBlock.vw,eachBlock.vy+eachBlock.vh,x,y,playerCW,playerCH)){
            return true;
          }
        }
        if(eachBlock.faces[2]){
          if(lineRect(vx+vw,vy+vh,vx,vy+vh,x,y,playerCW,playerCH)){
            return true;
          }
        }
        if(eachBlock.faces[3]){
          if(lineRect(vx,vy+vh,vx,vy,x,y,playerCW,playerCH)){
            return true;
          }
        }
      }
      for(Place eachBlock : playerBlocks){
        float vx = (eachBlock.x*zoom)+xoff;
        float vy = (eachBlock.y*zoom)+yoff;
        float vw = eachBlock.w*zoom;
        float vh = eachBlock.h*zoom;
        if(eachBlock.faces[0]){
          if(lineRect(eachBlock.vx,eachBlock.vy,eachBlock.vx+eachBlock.vw,eachBlock.vy,x,y,playerCW,playerCH)){
            return true;
          }
        }
        if(eachBlock.faces[1]){
          if(lineRect(eachBlock.vx+eachBlock.vw,eachBlock.vy,eachBlock.vx+eachBlock.vw,eachBlock.vy+eachBlock.vh,x,y,playerCW,playerCH)){
            return true;
          }
        }
        if(eachBlock.faces[2]){
          if(lineRect(vx+vw,vy+vh,vx,vy+vh,x,y,playerCW,playerCH)){
            return true;
          }
        }
        if(eachBlock.faces[3]){
          if(lineRect(vx,vy+vh,vx,vy,x,y,playerCW,playerCH)){
            return true;
          }
        }
      }
      return false;   
}


void playerMove(){
  moving = false;
  if(keyPressed){
    if(Character.toLowerCase(key)=='w'&&!checkMove(px,py-speed)){
      yoff+=speed;
      moving = true;
    }
    if(Character.toLowerCase(key)=='s'&&!checkMove(px,py+speed)){
      yoff-=speed;
      moving = true;
    }
    if(Character.toLowerCase(key)=='a'&&!checkMove(px-speed,py)){
      xoff+=speed;
      moving = true;
    }
    if(Character.toLowerCase(key)=='d'&&!checkMove(px+speed,py)){
      xoff-=speed;
      moving = true;
    }
  }
}

void makeMaze(){
  Block self = getBlock(x,y);
  Block[] nexts = {null,null,null,null};
  if(getBlock(x+size,y).x!=123456789){
    nexts[0] = getBlock(x+size,y);
  }
  if(getBlock(x,y+size).x!=123456789){
    nexts[1] = getBlock(x,y+size);
  }
  if(getBlock(x-size,y).x!=123456789){
    nexts[2] = getBlock(x-size,y);
  }
  if(getBlock(x,y-size).x!=123456789){
    nexts[3] = getBlock(x,y-size);
  }
  int ran = int(random(0,4));
  Block gt = nexts[ran];
  if(nexts[0]==null&&gt==nexts[0]){
    gt = nexts[int(random(1,4))];
  }
  if(nexts[1]==null&&gt==nexts[1]){
    if(int(random(0,2))==0){
      if(nexts[0]!=null){
        gt = nexts[0];
      }else{
        if(nexts[2]!=null){
          gt = nexts[2];
        }
      }
    }else{
      if(nexts[2]!=null){
        gt = nexts[2];
      }else{
        if(nexts[0]!=null){
          gt = nexts[0];
        }
      }
    }
  }
  if(nexts[2]==null&&gt==nexts[2]){
    if(int(random(0,2))==0){
      if(nexts[1]!=null){
        gt = nexts[1];
      }else{
        if(nexts[3]!=null){
          gt = nexts[3];
        }
      }
    }else{
      if(nexts[3]!=null){
        gt = nexts[3];
      }else{
        if(nexts[1]!=null){
          gt = nexts[1];
        }
      }
    }
  }
  if(nexts[3]==null&&gt==nexts[3]){
    gt = nexts[int(random(1,3))];
  }
  //println(nexts);
  x = int(gt.x);
  y = int(gt.y);
  self.visited = true;
    if(ran==0){
      self.faces[0] = false;
      gt.faces[2] = false;
    }
    if(ran==1){
      self.faces[1] = false;
      gt.faces[3] = false;
    }
    if(ran==2){
      self.faces[2] = false;
      gt.faces[0] = false;
    }
    if(ran==3){
      self.faces[3] = false;
      gt.faces[1] = false;
    }
  if(int(random(0,wallChance))==0){
    int ranFace = int(random(0,4));
    gt.faces[ranFace] = true;
  }
  iterations--;
  if(iterations>1){
    makeMaze();
  }else{
    for(Block eachBlock : blocks){
      Block[] nxt = getNexts(int(eachBlock.x),int(eachBlock.y));
      for(Block eachNb : nxt){
        if(eachNb!=null && int(random(0,open))==0){
          if(!eachNb.faces[0]){
            eachBlock.faces[2] = false;
          }
          if(!eachNb.faces[1]){
            eachBlock.faces[3] = false;
          }
          if(!eachNb.faces[2]){
            eachBlock.faces[0] = false;
          }
          if(!eachNb.faces[3]){
            eachBlock.faces[1] = false;
          }
        }
      }
    }
  }
}

void keyReleased(){
  if(debug){
    if(Character.toLowerCase(key)=='r'){
      zoom+=0.1;
      xoff=250;
      yoff=250;
    }
    if(Character.toLowerCase(key)=='t'){
      zoom-=0.1;
      xoff=250;
      yoff=250;
    }
    if(Character.toLowerCase(key)=='g'){
      superBreak = !superBreak;
    }
    if(Character.toLowerCase(key)=='q'){
      for(Block eachBlock : blocks){
        if(eachBlock.x == 2000){
          eachBlock.x = 0;
        }else{
          if(eachBlock.border){
            eachBlock.x = 2000;
          }
        }
      }
    }
  }
  if(Character.toLowerCase(key)=='e'){
    boolean c = false;
    for(Place eachPlace:playerBlocks){
      if(eachPlace.craft()){
        c = true;
      }
    }
    if(!c){
      crafting = !crafting;
      craftingOpen = !craftingOpen;
    }
  }
  
  if(key-48>0){
    selectedSlot = key-48;
    selectedSlot--;
    //println(selectedSlot);
  }
  if(Character.toLowerCase(key)=='0'){
    selectedSlot = 9;
  }
}

void mouseReleased(){
  breakBlock();
}
