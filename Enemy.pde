// This code is not complete yet. I am still working to improve the AI, and will apply a pathfinding algorithm (like BFS or A*) in future updates.

class Enemy extends Character {
  char direction;                                                  // Current direction the enemy is facing
  Orientation previousDirectionType;                               // Stores the previous direction type (horizontal/vertical)
  Orientation currentDirectionType = Orientation.HORIZONTAL;       // Initial direction type is horizontal
  boolean collision;                                               // Whether the enemy has collided with an obstacle


  Enemy(int i, int j) {
    super(i, j);
    direction = 'l'; // Set initial direction to 'left'
    speed = 5; // Set the movement speed of the enemy
  }

  // this is AI part of enemy class but still not complete
  void update() {
    // See: Detect if the enemy is colliding with walls
    see();

    // Think: Decide on the next movement direction based on current state
    think();

    // Act: Move the enemy based on the chosen direction and handle collisions
    act();

    // Check if the enemy collides with the player
    checkPlayerCollision();

    // Draw the enemy on the screen
    drawEnemy();
  }

  // Draws the enemy as a circle with a red color
  void drawEnemy() {
    fill(#FF6A6A); // Set fill color to red
    ellipse(x, y, tileSize * 0.8, tileSize * 0.8); // Draw a circle representing the enemy
  }

  // Determines if the enemy is colliding with a wall in the current direction
  void see() {
    float newX = x;
    float newY = y;

    // Based on the current direction, check for collisions in that direction
    switch (direction) {
    case 'u': // Up
      collision = collidesWithWall(newX, newY - 10); // Check if moving up causes a collision
      break;
    case 'l': // Left
      collision = collidesWithWall(newX - 10, newY); // Check if moving left causes a collision
      break;
    case 'd': // Down
      collision = collidesWithWall(newX, newY + 10); // Check if moving down causes a collision
      break;
    case 'r': // Right
      collision = collidesWithWall(newX + 10, newY); // Check if moving right causes a collision
      break;
    }
  }

  void think() {
    // If the enemy is still moving in the same direction type (horizontal/vertical),
    // decide whether to change direction or continue in the same pattern.
    if (currentDirectionType == previousDirectionType) {
      // If currently moving horizontally, try moving vertically if possible
      if (currentDirectionType == Orientation.HORIZONTAL && (map[i][j - 1] instanceof Tile || map[i][j + 1] instanceof Tile)) {
        char[] options = {'u', 'd'}; // Up or Down
        direction = randomDirection(options); // Choose a random vertical direction
        previousDirectionType = currentDirectionType; // Store current direction type for later comparison
        currentDirectionType = Orientation.VERTICAL; // Switch to vertical movement
      }
      // If currently moving vertically, try moving horizontally if possible
      else if (currentDirectionType == Orientation.VERTICAL && (map[i - 1][j] instanceof Tile || map[i + 1][j] instanceof Tile)) {
        char[] options = {'l', 'r'}; // Left or Right
        direction = randomDirection(options); // Choose a random horizontal direction
        previousDirectionType = currentDirectionType; // Store current direction type
        currentDirectionType = Orientation.HORIZONTAL; // Switch to horizontal movement
      }
    }
  }


  void act() {
    // If no collision detected, move the enemy in the chosen direction
    if (!collision) {
      move(direction, speed);
    } else {
      // If collision is detected, choose a new direction to avoid it
      char[] options = {'u', 'l', 'd', 'r'}; // Possible directions to move
      direction = randomDirection(options);
      previousDirectionType = currentDirectionType;
      currentDirectionType = Orientation.HORIZONTAL;
      move(direction, speed);
    }
  }

  // Randomly selects a direction from a list of possible directions
  char randomDirection(char[] options) {
    int index = int(random(options.length));
    return options[index];
  }

  // Checks for a collision with the player
  void checkPlayerCollision() {
    // If the player is alive and the distance between the enemy and player is small enough
    if (player.alive && dist(player.x, player.y, this.x, this.y) < tileSize * 0.5) {
      player.die();
      gamePaused = true;
    }
  }
}


public enum Orientation {
  HORIZONTAL, VERTICAL;
}
