abstract class Tile {
  float x, y;                       // Position of the tile in the game world
  float width = tileSize * 0.8;     // Width of the tile (80% of tile size)
  float height = tileSize * 0.8;    // Height of the tile (80% of tile size)

  Tile(float col, float row) {
    this.x = col * tileSize; // Convert grid position to pixel position (x)
    this.y = row * tileSize; // Convert grid position to pixel position (y)
  }

  // Abstract method to be implemented by subclasses to define how the tile is drawn
  abstract void draw();
  abstract void breakBlock();
}

class Wall extends Tile {
  Wall(float col, float row) {
    super(col, row);
  }

  void draw() {
    fill(80);
    stroke(0);
    rect(x, y, tileSize, tileSize);
  }

  void breakBlock() {
  }
}

class Grass extends Tile {
  Grass(float col, float row) {
    super(col, row);
  }

  void draw() {
    fill(#13A002);
    noStroke();
    rect(x, y, tileSize, tileSize);
  }

  void breakBlock() {
  }
}

class BreakableBlock extends Tile {
  int col, row;
  Item hiddenItem; // Item hidden inside the breakable block

  BreakableBlock(int col, int row) {
    super(col * tileSize, row * tileSize);
    this.col = col;
    this.row = row;

    // 80% chance to contain an item
    if (random(1) < 0.8) {
      float r = random(1); // Only call random() once here

      if (r < 0.5) { // 50%
        hiddenItem = new BombPowerItem(col, row);
      } else if (r < 0.8) { // 30% (0.5 to 0.8)
        hiddenItem = new SpeedItem(col, row);
      } else { // 20% (0.8 to 1.0)
        hiddenItem = new MagicPowerItem(col, row);
      }
    }
  }

  void draw() {
    fill(#FABA65);
    stroke(0);
    rect(col * tileSize, row * tileSize, tileSize, tileSize);
  }

  void breakBlock() {
    if (hiddenItem != null) {
      items.add(hiddenItem);
    }
  }
}
