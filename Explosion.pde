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
    fill(255, 200, 0, 150);  // Yellow-orange, semi-transparent
    noStroke();

    // Draw center
    rect(i * tileSize, j * tileSize, tileSize, tileSize);

    // --- Up ---
    for (int d = 1; d <= range; d++) {
      if (isWall(i, j - d)) break;
      rect(i * tileSize, (j - d) * tileSize, tileSize, tileSize);
      checkAndChange(i, j - d);
      if (map[i][j - d] instanceof BreakableBlock) break;  // Stop after breaking
    }

    // --- Down ---
    for (int d = 1; d <= range; d++) {
      if (isWall(i, j + d)) break;
      rect(i * tileSize, (j + d) * tileSize, tileSize, tileSize);
      checkAndChange(i, j + d);
      if (map[i][j + d] instanceof BreakableBlock) break;
    }

    // --- Left ---
    for (int d = 1; d <= range; d++) {
      if (isWall(i - d, j)) break;
      rect((i - d) * tileSize, j * tileSize, tileSize, tileSize);
      checkAndChange(i - d, j);
      if (map[i - d][j] instanceof BreakableBlock) break;
    }

    // --- Right ---
    for (int d = 1; d <= range; d++) {
      if (isWall(i + d, j)) break;
      rect((i + d) * tileSize, j * tileSize, tileSize, tileSize);
      checkAndChange(i + d, j);
      if (map[i + d][j] instanceof BreakableBlock) break;
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
