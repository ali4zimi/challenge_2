/*
 * Abstract class that represents a generic character (Player or Enemy) in the game.
 * This class contains common properties and methods shared between both the player and enemy classes.
 */
abstract class Character {
  int row, col;        // Grid coordinates (row, column) on the game map
  float x, y;          // Real-world coordinates (pixel positions) of the character
  float health;        // Health points of the character, typically starts at 100
  float speed;         // Speed at which the character moves (in pixels per frame)
  boolean alive;       // A flag indicating whether the character is alive or not

  /*
   * Constructor to initialize the character with its grid position and default properties.
   */
  Character(int row, int col) {
    this.row = row;
    this.col = col;

    // Initialize x, y based on the grid position and tile size
    this.x = row * tileSize + tileSize / 2;
    this.y = col * tileSize + tileSize / 2;

    this.health = 100;
    this.alive = true;
  }

  /*
   * Handles the movement of the character. Moves in the specified direction by the given speed.
   * If there's no collision with walls or other obstacles, the character's position is updated.
   */
  void move(char dir, float speed) {
    float newX = x;
    float newY = y;

    // Move in the specified direction (up, down, left, right)
    switch (dir) {
    case 'u':
      newY -= speed;
      break;
    case 'd':
      newY += speed;
      break;
    case 'l':
      newX -= speed;
      break;
    case 'r':
      newX += speed;
      break;
    }

    // Only move if there's no collision at the new position
    if (!collidesWithWall(newX, newY)) {
      x = newX;
      y = newY;

      row = (int) newX / tileSize;
      col = (int) newY / tileSize;
    }
  }

  /*
   * Checks if the character will collide with a wall or any obstacles at the given position.
   * The character is assumed to have a bounding box, and collision is detected using AABB (Axis-Aligned Bounding Box).
   */
boolean collidesWithWall(float newX, float newY) {
    float halfSize = tileSize * 0.4;  // Since the character is smaller than the tile size

    // Define the bounding box of the character (left, right, top, bottom)
    float left = newX - halfSize;
    float right = newX + halfSize;
    float top = newY - halfSize;
    float bottom = newY + halfSize;

    // Determine which grid tiles this box overlaps with
    int minRow = int(left / tileSize);
    int maxRow = int(right / tileSize);
    int minCol = int(top / tileSize);
    int maxCol = int(bottom / tileSize);

    // Loop through all potentially overlapping tiles
    for (int r = minRow; r <= maxRow; r++) {
      for (int c = minCol; c <= maxCol; c++) {

        // If out of bounds, treat it as a wall
        if (r < 0 || c < 0 || r >= gridSize || c >= gridSize) return true;

        // If the tile is a wall or breakable block, check for overlap
        if (isObstacle(r, c)) {

          // Tile bounds
          float tileLeft = r * tileSize;
          float tileRight = tileLeft + tileSize;
          float tileTop = c * tileSize;
          float tileBottom = tileTop + tileSize;

          // Axis-Aligned Bounding Box (AABB) collision check
          boolean overlap = !(right <= tileLeft || left >= tileRight ||
            bottom <= tileTop || top >= tileBottom);

          if (overlap) return true; // Collision found
        }
      }
    }

    // No collisions with any walls or blocks
    return false;
  }

  boolean isObstacle(int r, int c) {
    return map[r][c] instanceof Wall || map[r][c] instanceof BreakableBlock;
  }
}
