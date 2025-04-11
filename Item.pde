// This is abstract class and not initiatable

abstract class Item {
  int i, j;                   // Grid coordinates of the item
  float x, y;                 // Pixel positions of the item
  boolean collected = false;  // Whether the item has been collected by the player

  Item(int i, int j) {
    this.i = i;
    this.j = j;
    this.x = i * tileSize; // Convert grid position to pixel position
    this.y = j * tileSize; // Convert grid position to pixel position
  }


  void draw() {
    if (!collected) {
      drawIcon();
    }
  }

  // Abstract method to be implemented by subclasses to define how the item is drawn
  abstract void drawIcon();

  // Abstract method to apply the effect of the item on the player when collected
  abstract void applyEffect(Player player);
}

class BombPowerItem extends Item {
  BombPowerItem(int i, int j) {
    super(i, j);
  }

  void drawIcon() {
    fill(255, 0, 0); // Set fill color to red
    ellipse(x + tileSize / 2, y + tileSize / 2, tileSize * 0.5, tileSize * 0.5); // Draw a circle in the center
  }

  void applyEffect(Player player) {
    player.bombPower++; // Increase the player's bomb power
  }
}

class SpeedItem extends Item {
  SpeedItem(int i, int j) {
    super(i, j);
  }

  void drawIcon() {
    fill(0, 200, 255);
    rect(x + tileSize * 0.25, y + tileSize * 0.25, tileSize * 0.5, tileSize * 0.5);
  }

  void applyEffect(Player player) {
    player.speed += 5;
  }
}


class MagicPowerItem extends Item {
  MagicPowerItem(int col, int row) {
    super(col, row);
  }

  void drawIcon() {
    fill(255, 255, 0); // Yellow triangle
    float centerX = x + tileSize / 2;
    float centerY = y + tileSize / 2;
    float halfSize = tileSize * 0.25;

    triangle(
      centerX, centerY - halfSize, // Top point
      centerX - halfSize, centerY + halfSize, // Bottom-left
      centerX + halfSize, centerY + halfSize          // Bottom-right
      );
  }

  void applyEffect(Player player) {
    player.magicPower += 1;
  }
}
