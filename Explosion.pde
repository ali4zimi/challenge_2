class Explosion {
  int i, j;           // Center tile of explosion
  int range = 1;      // How far the explosion spreads
  int timer = 30;     // Duration in frames (e.g. 0.5 seconds at 60 FPS)

  Explosion(int i, int j, int range) {
    this.i = i;
    this.j = j;
    this.range = range;
  }

  void drawFlame() {
    fill(255, 200, 0, 150);
    noStroke();
    rect(i * tileSize, j * tileSize, tileSize, tileSize);  // Center explosion

    spreadExplosion(i, j, 0, -1);  // Up
    spreadExplosion(i, j, 0, 1);   // Down
    spreadExplosion(i, j, -1, 0);  // Left
    spreadExplosion(i, j, 1, 0);   // Right
  }

  void spreadExplosion(int i, int j, int di, int dj) {
    for (int d = 1; d <= range; d++) {
      int x = i + di * d;
      int y = j + dj * d;

      if (isWall(x, y)) break; // Stop at wall
      rect(x * tileSize, y * tileSize, tileSize, tileSize);
      checkAndChange(x, y);

      if (map[x][y] instanceof BreakableBlock) break; // Stop if breakable block
    }
  }

  // Check if the tile at (i, j) is a breakable block, and change it to grass
  void checkAndChange(int i, int j) {
    if (map[i][j] instanceof BreakableBlock) {
      BreakableBlock block = (BreakableBlock) map[i][j];
      block.breakBlock();  // Reveal item
      map[i][j] = new Grass(i, j);
    }
  }


  // Check if the tile at (i, j) is a wall
  boolean isWall(int i, int j) {
    if (i < 0 || j < 0 || i >= gridSize || j >= gridSize) return true;
    return map[i][j] instanceof Wall;
  }

  boolean isFinished() {
    return timer <= 0;
  }

  void update() {
    timer--;
  }
}
