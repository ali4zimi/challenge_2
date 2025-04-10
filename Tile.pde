abstract class Tile {
  float x, y;                       // Position of the tile in the game world
  float width = tileSize * 0.8;     // Width of the tile (80% of tile size)
  float height = tileSize * 0.8;    // Height of the tile (80% of tile size)

  Tile(float i, float j) {
    this.x = i * tileSize; // Convert grid position to pixel position (x)
    this.y = j * tileSize; // Convert grid position to pixel position (y)
  }
  
  // Abstract method to be implemented by subclasses to define how the tile is drawn
  abstract void draw();
}

class Wall extends Tile {
  Wall(float x, float y) {
    super(x, y); 
  }

  void draw() {
    fill(80); 
    stroke(0); 
    rect(x, y, tileSize, tileSize); 
  }  
}

class Grass extends Tile {
  Grass(float x, float y) {
    super(x, y);
  }

  void draw() {
    fill(#13A002);
    noStroke(); 
    rect(x, y, tileSize, tileSize); 
  }
}

class BreakableBlock extends Tile {
  int i, j; 
  Item hiddenItem; // Item hidden inside the breakable block

  BreakableBlock(int i, int j) {
    super(i * tileSize, j * tileSize); 
    this.i = i;
    this.j = j;

    // 80% chance to contain an item
    if (random(1) < 0.8) {
      if (random(1) < 0.8) { // 80% chance to contain BombPower
        hiddenItem = new BombPowerItem(i, j); // Create a BombPower item
      } else {
        hiddenItem = new SpeedItem(i, j); // Otherwise, create a Speed item
      }
    }
  }

  void draw() {
    fill(#FABA65); 
    stroke(0); 
    rect(i * tileSize, j * tileSize, tileSize, tileSize); 
  }

  void breakBlock() {
    if (hiddenItem != null) {
      items.add(hiddenItem);  
    }
  }
}
