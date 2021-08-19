class Block{
  public float x,y,w,h;
  public boolean[] faces = {true,true,true,true};
  public boolean visited = false;
  public boolean wood,selected;
  public int ore,light;
  public float vx = (x*zoom)+xoff;
  public float vy = (y*zoom)+yoff;
  public float vw = w*zoom;
  public float vh = h*zoom;
  public float timer,breakTime,brs = 0;
  public boolean border,breaking,full = false;
  public String type = "";
  public boolean invis = false;
  Block(float xs,float ys,float ws,float hs){
    x = xs;
    y = ys;
    w = ws;
    h = hs;
    ore = 5;
    light = 0;
    selected = false;
    breaking = false;
    breakTime = 40/breakMult;
    
    if(noise((x/w)*0.1,(y/h)*noiseScale)>0.2&&noise((x/w)*noiseScale,(y/h)*0.1)<0.5&&int(random(0,5))==1){
      int rand = int(random(0,101));
      if(rand<51){
        ore = 0;
      }
      if(rand>50&&rand<71){
        ore = 1;
      }
      if(rand>70&&rand<91){
        ore = 2;
      }
      if(rand>90){
        ore = 3;
      }
    }
    if(noise((x/w)*0.1,(y/h)*0.1)>0.1+dist(x,y,px,py)/1400&&noise((x/w)*0.1,(y/h)*0.1)<0.5&&random(0,10)>2){
      wood=true;
    }
    checkType();
    brs = breakTime;
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
      spawnDrops(this);
      if(wood){
        hasSeenRoots = true;
      }
      if(ore==3){
        hasSeenRubys = true;
      }
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
  void update(){
    breakTime = brs/breakMult;
    if(faces[0]&&faces[1]&&faces[2]&&faces[3]){
      full = true;
    }else{
      full = false;
    }
    
    vx = (x*zoom)+xoff;
    vy = (y*zoom)+yoff;
    vw = w*zoom;
    vh = h*zoom;
    if(checkSpawn){
      if(dist(vx,vy,px,py)<100){
        x = 1000;
      }
    }
    if(visited){
      stroke(0,255,255);
    }else{
      stroke(0,0,255);
    }
    
    if(faces[0]&&faces[1]&&faces[2]&&faces[3]){
      if(ore==0){
        stroke(255);
      }
      if(ore==1){
        stroke(255,255,0);
      }
      if(ore==2){
        stroke(0,255,0);
      }
      if(ore==3){
        stroke(255,0,0);
      }
    }
    
    //vx = x;
    //vy = y;
    //vw = w;
    //vh = h;
    if(wood&&faces[0]&&faces[1]&&faces[2]&&faces[3]){
      stroke(127,127,0);
    }
    if(border){
      stroke(127);
    }
    if(faces[0]){
      line(vx,vy,vx+vw,vy);
    }
    if(faces[1]){
      line(vx+vw,vy,vx+vw,vy+vh);
    }
    if(faces[2]){
      line(vx+vw,vy+vh,vx,vy+vh);
    }
    if(faces[3]){
      line(vx,vy+vh,vx,vy);
    }
    if(faces[0]&&faces[1]&&faces[2]&&faces[3]){
      if(type=="stone"&&!border){
        fill(0);
        noStroke();
        rect(vx-1,vy-1,vw+2,vh+2);
        image(stoneBlock,vx,vy,vw,vh);
      }
      if(type=="emrald_ore"&&!border){
        fill(0);
        noStroke();
        rect(vx-1,vy-1,vw+2,vh+2);
        image(emraldOre,vx,vy,vw,vh);
      }
      if(type=="ruby_ore"&&!border){
        fill(0);
        noStroke();
        rect(vx-1,vy-1,vw+2,vh+2);
        image(rubyOre,vx,vy,vw,vh);
      }
      if(type=="iron_ore"&&!border){
        fill(0);
        noStroke();
        rect(vx-1,vy-1,vw+2,vh+2);
        image(ironOre,vx,vy,vw,vh);
      }
      if(type=="gold_ore"&&!border){
        fill(0);
        noStroke();
        rect(vx-1,vy-1,vw+2,vh+2);
        image(goldOre,vx,vy,vw,vh);
      }
      if(type=="wood"&&!border){
        fill(0);
        noStroke();
        rect(vx-1,vy-1,vw+2,vh+2);
        image(woodBlock,vx,vy,vw,vh);
      }
    }
    if(selected&&!border){
      fill(255,255,255,127);
      noStroke();
      rect(vx,vy,vw,vh);
    }
    if(!faces[0]||!faces[1]||!faces[2]||!faces[3]){
      x = 2000;
      
    }
    if(!border){
      updateLighting();
    }
    breakUpdate();
  }
  
  void checkType(){
    if(!faces[0]||!faces[1]||!faces[2]||!faces[3]){
      type = "none";
      breakTime = 10;
    }else if(visited){
      type = "wall";
      breakTime = 20;
    }else if(ore==0){
      type = "iron_ore";
      breakTime = 40;
    }else if(ore==1){
      type = "gold_ore";
      breakTime = 45;
    }else if(ore==2){
      type = "emrald_ore";
      breakTime = 50;
    }else if(ore==3){
      type = "ruby_ore";
      breakTime = 60;
    }else if(wood){
      type = "wood";
      breakTime = 10;
    }else{
      type = "stone";
      breakTime = 30;
    }
  }
}  
