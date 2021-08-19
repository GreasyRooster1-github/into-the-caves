ItemType[] itemConst = {};
Recipe[] recipes = {};
boolean crafting = false;

class Item {
  public float x, y, w, h, vx, vy, vw, vh;
  public ItemType item;
  Item(float xa, float ya, ItemType itema) {
    item=itema;
    x = xa;
    y = ya;
    w = 5;
    h = 5;
  }
  void update() {
    vx = (x*zoom)+xoff;
    vy = (y*zoom)+yoff;
    vw = w*zoom;
    vh = h*zoom;
    image(item.img, vx, vy, vw, vh);
    if (inventory.length>9) {
      if (inventory[9].count==100) {
        return;
      }
    }
    if (dist(vx, vy, px, py)<100) {
      float dir = atan2((py-vy), (px-vx));
      x += cos(dir)*1.5;
      y += sin(dir)*1.5;
    }
    if (collision(vx, vy, vw, vh, px, py, playerCW, playerCH)) {
      collectItem(this);
      x = 1010;
    }
    //println(item.img);
  }
}

class ItemType {
  public PImage img;
  public String dropsFrom;
  public boolean isBlock, util;
  public int brs = 0;
  public ItemType crafting;
  public color c;
  ItemType(PImage imga, String dropsFroma, boolean isBlocka) {
    img = imga;
    dropsFrom = dropsFroma;
    isBlock = isBlocka;
  }
  ItemType(PImage imga, String dropsFroma, boolean isBlocka, int brsa, ItemType u, color ca) {
    img = imga;
    dropsFrom = dropsFroma;
    isBlock = isBlocka;
    brs = brsa;
    if (u!=null) {
      util = true;
    }
    crafting = u;
    c = ca;
  }
}

class InvSlot {
  public Item item;
  public int count, x, y, slot;
  public boolean selected, glowing, moving, crafting;
  InvSlot(Item itema, int slota) {
    item = itema;
    count = 1;
    slot = slota;
    selected = false;
    glowing = false;
    moving = false;
    crafting = false;
  }
}

class Recipe {
  public ItemType[] in;
  public ItemType[] result;
  Recipe(ItemType[] ina, ItemType[] r) {
    in = ina;
    result = r;
  }
}

void collectItem(Item item) {
  int c = 0;
  for (InvSlot eachSlot : inventory) {
    if (eachSlot.item.item == item.item&&eachSlot.count<100) {
      eachSlot.count++;
      return;
    }
    c++;
  }
  newInvslot(item, inventory.length);
}

void spawnDrops(Block block) {
  //newItem(0,0,itemConst[0]);
  for (ItemType eachType : itemConst) {
    if (eachType.dropsFrom==block.type) {
      newItem(block.x+2.5, block.y+2.5, eachType);
    }
  }
}

void spawnItems(String block, float x, float y) {
  //newItem(0,0,itemConst[0]);
  for (ItemType eachType : itemConst) {
    if (eachType.dropsFrom==block) {
      newItem(x+2.5, y+2.5, eachType);
    }
  }
}

void loadItems() {
  ItemType[] c = {
    newType(stoneItem, "stone", false),        //0
    newType(ironItem, "iron_ore", false),      //1
    newType(goldItem, "gold_ore", false),      //2
    newType(rubyItem, "ruby_ore", false),      //3
    newType(emraldItem, "emrald_ore", false),  //4
    newType(woodItem, "wood", false),          //5
    newType(stickItem, "", false),             //6
    newType(fiberItem, "", false),             //7
    newType(craftingItem, "", false),          //8
    newType(pressedWoodItem, "", false),       //9
    newType(pickheadItem, "", false),          //10
    newType(pickItem, "", false),              //11
    newType(unknown, "null", false),           //12
    newType(craftingStone, "", false),         //13
  };
  //block!
  //newType(img,dropsfrom,true,breaktime,utilItem)
  //non-block!
  //newType(img,dropsfrom,false)
  ItemType[] a = {
    newType(fireItem, "", false),                  //14
    newType(ironHunkItem, "", false),              //15
    newType(ironPickItem, "", false),              //16
  };
  ItemType wb = newType(workbenchItem, "workbench", true, 25, c[13]);
  ItemType pl = newType(planksItem, "planks", true, 20, null);
  ItemType cm = newType(campfire, "campfire", true, 25, a[0], color(255, 127, 0));
  ItemType[] b = {wb,pl,cm};
  c = (ItemType[]) concat(c, a);
  c = (ItemType[]) concat(c, b);
  ItemType[] debug = {c[0]};
  ItemType[] st = {c[5]};
  ItemType[] st1 = {c[7]};
  ItemType[] st2 = {c[6], c[7], c[0]};
  ItemType[] st3 = {c[8], c[5]};
  ItemType[] st4 = {c[9], c[7]}; 
  ItemType[] st5 = {c[0], c[8]};
  ItemType[] st6 = {c[10], c[6]};
  ItemType[] st7 = {c[0], pl}; //workbench
  ItemType[] st8 = {c[6], c[7], c[9], c[13]}; //campfire
  ItemType[] st9 = {c[1],c[14]}; // iron Hunk
  ItemType[] st10 = {c[15],c[6]}; // iron pick
  
  Recipe[] r = {
    newRecipe(debug, c[7]), 
    newRecipe(st, c[7]), 
    newRecipe(st1, c[6]), 
    newRecipe(st2, c[8]), 
    newRecipe(st3, c[9], c[8]), 
    newRecipe(st4, pl), 
    newRecipe(st5, c[10], c[8]), 
    newRecipe(st6, c[11]), 
    newRecipe(st7, wb), 
    newRecipe(st8, cm), 
    newRecipe(st9, c[15]),
    newRecipe(st10, c[16]),
  };
  recipes = r;
  itemConst = c;
}

void reloadInv() {
  InvSlot[] n = {};
  InvSlot[] temp = {};
  for (int b=0; b<inventory.length; b++) {
    temp = (InvSlot[]) append (temp, null);
  }
  arrayCopy(inventory, temp); //copy inventory so we can collect items and clear inventory
  printArray(inventory);
  printArray(temp);
  inventory = n;
  for (InvSlot eachItem : temp) {
    if (eachItem.count>0&&!eachItem.crafting) {
      for (int j=0; j<eachItem.count; j++) {
        collectItem(new Item(xoff-250, yoff-250, eachItem.item.item));
      }
    }
  }
}

void craftingMenu(ItemType item) {
  craftingFunc(item, color(127));
}

void craftingMenu(ItemType item, color c) {
  craftingFunc(item, c);
}

void craftingFunc(ItemType item, color c) {
  boolean doItem = true;
  if (item == null) {
    doItem = false;
  }
  fill(c);
  stroke(red(c)+63, green(c)+63, blue(c)+63);
  strokeWeight(10);
  rect(100, 100, 300, 300);

  strokeWeight(1);
  textSize(30);
  textAlign(CENTER);
  fill(red(c)-27, green(c)-27, blue(c)-27);
  text("Press 'X' to craft!", 250, 130);
  textSize(20);

  if (doItem) {
    fill(c);
    strokeWeight(8);
    rectMode(CENTER);
    rect(250, 50, 50, 50);
    rectMode(CORNER);
    strokeWeight(1);
    if (inventory.length < 1) { // so i dont get inv out of bounds
      newInvslot(new Item(0, 0, item), 1);
      inventory[inventory.length-1].crafting = true;
      printArray(inventory);
    } else if (!inventory[inventory.length-1].crafting) {
      newInvslot(new Item(0, 0, item), 1);
      inventory[inventory.length-1].crafting = true;
      printArray(inventory);
    }
  }

  ItemType[] i = {};
  for (InvSlot eachItem : inventory) {
    if (eachItem.glowing) {
      i = (ItemType[]) append (i, eachItem.item.item);
    }
  }
  for (Recipe eachRecipe : recipes) {
    //println(i);
    //println(eachRecipe.in);
    if (isMatch(eachRecipe.in, i)) {
      if (keyPressed && Character.toLowerCase(key)=='x') {
        for (InvSlot eachItem : inventory) {
          if (eachItem.glowing) {
            eachItem.count--;
          }
        }
        reloadInv();
        for (ItemType res : eachRecipe.result) {
          collectItem(new Item(px, py, res));
        }
      } else {
        //pulse crafting table
        fill(red(c)-(sin(frameCount/10.0)+1)*4, green(c)-(sin(frameCount/10.0)+1)*4, blue(c)-(sin(frameCount/10.0)+1)*4);
        stroke(red(c)+63, green(c)+63, blue(c)+63);
        strokeWeight((sin(frameCount/10.0)+1)*8);
        rect(100, 100, 300, 300);
        strokeWeight(1);
        textSize(30);
        textAlign(CENTER);
        fill(red(c)-27-(sin(frameCount/10.0)+1)*4, green(c)-27-(sin(frameCount/10.0)+1)*4, blue(c)-27-(sin(frameCount/10.0)+1)*4);
        text("Press 'X' to craft!", 250, 130);
        textSize(20);
      }
    }
  }
}

boolean isMatch(ItemType[] arrayA, ItemType[] arrayB) {
  int matchedValues = 0;
  for (int i=0; i < arrayA.length; i++) {
    for (int j=0; j < arrayB.length; j++) {
      // we can now compare each value in arrayA to each value in arrayB
      if (arrayA[i] == arrayB[j]) {
        matchedValues++;
        // no point continuing once we've confirmed there's a match...
        break;
      }
    }
  }
  // check if the arrays are 'equal'
  if (matchedValues == arrayA.length && arrayA.length == arrayB.length) {
    return true;
  }
  return false;
}
