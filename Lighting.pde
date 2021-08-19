int lightInt = 17;
int lightEnd = 2;

void updateLight(){
  for(Block eachBlock:blocks){
    eachBlock.light = checkLight(eachBlock.vx,eachBlock.vy);
  }
  for(Place eachBlock:playerBlocks){
    eachBlock.light = checkLight(eachBlock.vx,eachBlock.vy);
  }
}

int checkLight(float x,float y){
    for(int i=0;i<15;i++){
      if(dist(x,y,px,py)<size*i*lightEnd){
        return i;
      }
    }
    return 0;
}
