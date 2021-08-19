Block[] getNexts(int x,int y){
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
  return nexts;
}

void setBreakSpeed(float speed,int level){
  if(breakMult<speed){
    breakMult = speed;
    pickLevel = level;
    hasPick = true;
  }
}

Block getBlock(int x,int y){
  for(Block eachBlock : blocks){
    if(eachBlock.x==x){
      if(eachBlock.y==y){
        return eachBlock;
      }
    }
  }
  return new Block(123456789,0,0,0);
}

void makeGrid(){
  for(int i=0;i<mapW;i++){
    for(int j=0;j<mapH;j++){
      newBlock(i*size,j*size,size,size);
    }
  }
}

void newBlock(float x,float y,float x1,float y1){
  Block h1 = new Block(x,y,x1,y1); 
  blocks = (Block[]) append (blocks, h1); // append it
}

Place newPlace(ItemType it,float x,float y){
  Place h1 = new Place(it,x,y); 
  playerBlocks = (Place[]) append (playerBlocks, h1); // append it
  return h1;
}

Place getPlace(ItemType it,float x,float y){
  Place h1 = new Place(it,x,y); 
  return h1;
}

void newItem(float x,float y,ItemType type){
  Item h1 = new Item(x,y,type); 
  items = (Item[]) append (items, h1); // append it
}

void newInvslot(Item item,int slot){
  InvSlot h1 = new InvSlot(item,slot); 
  inventory = (InvSlot[]) append (inventory, h1); // append it
}

Recipe newRecipe(ItemType[] ina,ItemType... result){
  return new Recipe(ina,result);
}

ItemType newType(PImage img,String dropsFrom,boolean block){
  return new ItemType(img,dropsFrom,block);
}

ItemType newType(PImage img,String dropsFrom,boolean block,int i,ItemType u){
  return new ItemType(img,dropsFrom,block,i,u,color(127));
}

ItemType newType(PImage img,String dropsFrom,boolean block,int i,ItemType u,color c){
  return new ItemType(img,dropsFrom,block,i,u,c);
}

boolean collision(float x,float y,float w,float h,float x1,float y1,float w1,float h1){
  if (x < x1 + w1 && x + w > x1 && y < y1 + h1 && y + h > y1) {
        return true;
    }else{
        return false;
    }
}

boolean lineRect(float x1, float y1, float x2, float y2, float rx, float ry, float rw, float rh) {

  // check if the line has hit any of the rectangle's sides
  // uses the Line/Line function below
  boolean left =   lineLine(x1,y1,x2,y2, rx,ry,rx, ry+rh);
  boolean right =  lineLine(x1,y1,x2,y2, rx+rw,ry, rx+rw,ry+rh);
  boolean top =    lineLine(x1,y1,x2,y2, rx,ry, rx+rw,ry);
  boolean bottom = lineLine(x1,y1,x2,y2, rx,ry+rh, rx+rw,ry+rh);

  // if ANY of the above are true, the line
  // has hit the rectangle
  if (left || right || top || bottom) {
    return true;
  }
  return false;
}


// LINE/LINE
boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1){
    return true;
  }
  return false;
}
