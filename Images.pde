PImage unknown,stoneItem,stoneBlock,inv,ironItem,ironOre,goldItem,goldOre,rubyItem,rubyOre,emraldItem,emraldOre,woodItem,woodBlock,stickItem,fiberItem,craftingItem,pressedWoodItem,planksItem;
PImage pickheadItem,pickItem,playerIdle,workbenchItem,craftingStone,campfire,fireItem,ironHunkItem,ironPickItem;
Gif player;

void loadImages(){
  unknown = loadImage("Images/Unknown.png");
  stoneItem = loadImage("Images/stone.png");
  stoneBlock = loadImage("Images/stone_block.png");
  ironItem = loadImage("Images/iron.png");
  ironOre = loadImage("Images/iron_ore.png");
  goldItem = loadImage("Images/gold.png");
  goldOre = loadImage("Images/gold_ore.png");
  rubyItem = loadImage("Images/ruby.png");
  rubyOre = loadImage("Images/ruby_ore.png");
  emraldItem = loadImage("Images/emrald.png");
  emraldOre = loadImage("Images/emrald_ore.png");
  woodItem = loadImage("Images/wood.png");
  woodBlock = loadImage("Images/roots.png");
  inv = loadImage("Images/invSpot.png");
  stickItem = loadImage("Images/stick.png");
  craftingItem = loadImage("Images/crafting_tool.png");
  pressedWoodItem = loadImage("Images/pressed_wood.png");
  planksItem = loadImage("Images/planks.png");
  fiberItem = loadImage("Images/fibers.png");
  pickheadItem = loadImage("Images/pick_head.png");
  pickItem = loadImage("Images/pick.png");
  player = new Gif(this, "Images/Blue_Slime.gif");
  playerIdle = loadImage("Images/Blue_Slime_Idle.png");
  craftingStone = loadImage("Images/Crafting_Stone.png");
  workbenchItem = loadImage("Images/Work_Bench.png");
  campfire = loadImage("Images/campfire.png");
  fireItem = loadImage("Images/fire_Item.png");
  ironHunkItem = loadImage("Images/Iron_Hunk.png");
  ironPickItem = loadImage("Images/iron_pick.png");
  
  player.play();
  println(unknown);
}
