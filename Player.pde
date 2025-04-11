class Player extends Character {
  String name;           // Player's name (can be used for multiplayer or saving the game state)
  int bombPower;         // Bomb power: determines the explosion range of bombs the player can place
  int magicPower;

  /*
   * Constructor to initialize the player with a specific grid position (i, j).
   */
  Player(int row, int col) {
    super(row, col);
    bombPower = 1;        // Default bomb power
    magicPower = 0;       // Can be triggered by voice 'Kill all enemies'
    super.speed = 5;      // Default speed for the player
  }

  /*
   * Updates the player by checking for item pickups and drawing the player's representation on the screen.
   */
  void update() {
    checkItemPickup();    // Check if the player picks up any items

    fill(0, 0, 255);      // Draw the player as a blue circle
    ellipse(x, y, tileSize * 0.8, tileSize * 0.8);
  }

  /*
   * Handles player input (movement and bomb placement).
   * The player can move using arrow keys and place bombs using the spacebar.
   */
  void handleInput() {
    if (keyPressed) {
      if (key == CODED) {
        switch (keyCode) {
        case UP:
          move('u', player.speed);  // Move up
          break;
        case DOWN:
          move('d', player.speed);  // Move down
          break;
        case LEFT:
          move('l', player.speed);  // Move left
          break;
        case RIGHT:
          move('r', player.speed);  // Move right
          break;
        }
      } else {
        if (key == ' ') {
          player.installBomb();  // Place a bomb
        }
      }
    }
  }

  /*
   * Places a bomb at the player's current position, unless there's already a bomb on the same tile.
   */
  void installBomb() {
    // Prevent placing multiple bombs on the same tile
    for (Bomb b : bombs) {
      if (b.row == row && b.col == col) return;  // Exit if there's already a bomb here
    }

    bombs.add(new Bomb(row, col, bombPower));  // Add a new bomb to the list of bombs
  }

  /*
   * Handles the player's death by setting their 'alive' flag to false and printing a death message.
   */
  void die() {
    this.alive = false;
  }

  /*
   * Checks if the player picks up any items. If so, it applies the item's effect.
   */
  void checkItemPickup() {
    for (Item item : items) {
      if (!item.collected && playerTouches(item)) {
        item.applyEffect(player);  // Apply the item's effect on the player
        item.collected = true;     // Mark the item as collected
      }
    }
  }

  /*
   * Determines if the player has collided with an item by calculating the distance between the player and the item.
   */
  boolean playerTouches(Item item) {
    return dist(player.x, player.y, item.x + tileSize / 2, item.y + tileSize / 2) < tileSize * 0.5;
  }


  void destroyAllBlocks() {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (map[row][col] instanceof BreakableBlock) {
          map[row][col].breakBlock();
          map[row][col] = new Grass(row, col);
        }
      }
    }
  }

  void destroyAllEnemies() {
    if (magicPower > 0) {
      enemies.clear();
    }
  }
}
