class Place{
  public ItemType type;
  public float x,y,w,h;
  public float vx = (x*zoom)+xoff;
  public float vy = (y*zoom)+yoff;
  public float vw = w*zoom;
  public float vh = h*zoom;
  public PImage img;
  public int light;
  public float timer,breakTime,brs = 0;
  public boolean border,breaking,full = false;
  public boolean[] faces = {true,true,true,true}; // for easy collision copying never used by player\
  public boolean craftingO = false;
  Place(ItemType it,float xa,float ya){
    x = xa;
    y = ya;
    w = 10;
    h = 10;
    brs = it.brs;
    img = it.img;
    type = it;
    light = 0;
    breakTime = brs;
  }
  void update(){
    vx = (x*zoom)+xoff;
    vy = (y*zoom)+yoff;
    vw = w*zoom;
    vh = h*zoom;
    image(img,vx,vy,vw,vh);
    updateLighting();
    breakUpdate();
    if(dist(250,250,vx+vw/2,vy+vh/2)<100&&type.util){
      subTitle("Press E to open");
    }
    if(craftingO){
      craftingMenu(type.crafting,type.c);
    }
  }
  void updateLighting(){
    fill(0,(light*(255/lightInt)));
    if(light==0){
      fill(0,255);
    }
    noStroke();
    rect(vx,vy,vw+1,vh+1);
  }
  void breakUpdate(){
    if(!collision(int(vx),int(vy),int(vw),int(vh),int(mouseX),int(mouseY),int(2),int(2))){
      timer=0;
      breaking = false;
    }
    if(breaking){
      timer+=1;
    }
    if(timer>breakTime){
      spawnItems(type.dropsFrom,x,y);
      x = 1000;
    }
    noStroke();
    if(timer>breakTime/4){
      fill(255,255,0);
      rect(vx,vy,vw,vh);
    }
    if(timer>breakTime/2){
      fill(255,127,0);
      rect(vx,vy,vw,vh);
    }
    if(timer>(breakTime/4)*3){
      fill(255,0,0);
      rect(vx,vy,vw,vh);
    }
  }
  boolean craft(){  // almost named this crap()
    if(dist(250,250,vx+vw/2,vy+vh/2)<100&&type.util){
      if(craftingO){
        inventory[inventory.length-1].count=0;
        reloadInv();
      }
      craftingO = !craftingO;
      crafting = !crafting;
      return true;
    }else{
      return false;
    }
  }
}
