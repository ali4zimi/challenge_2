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

    spreadExplosion(i, j, 0, -1);  // Up Side
    spreadExplosion(i, j, 0, 1);   // Down Side
    spreadExplosion(i, j, -1, 0);  // Left Side
    spreadExplosion(i, j, 1, 0);   // Right Side
  }

  void spreadExplosion(int ci, int cj, int di, int dj) {
    for (int d = 1; d <= range; d++) {
      int ti = ci + di * d;
      int tj = cj + dj * d;

      if (isWall(ti, tj)) break; // Stop at wall
      rect(ti * tileSize, tj * tileSize, tileSize, tileSize);
      checkAndChange(ti, tj);

      for (Bomb bomb : bombs) {
        if (hitBomb(ti, tj, bomb)) {
          bomb.explode();
        }
      }

      if (hitPlayer(ti, tj)) {
        player.die();
        gameState = GameState.LOSE;
      }



      for (Enemy enemy : enemies) {
        if (hitEnemy(ti, tj, enemy)) {
          enemy.die();
          gameState = GameState.WIN;
        }
      }



      if (map[ti][tj] instanceof BreakableBlock) break; // Stop if breakable block
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

  // Check if explosion hit the player
  boolean hitPlayer(int row, int col) {
    return player.row == row && player.col == col;
  }

  boolean hitEnemy(int row, int col, Enemy enemy) {
    return enemy.row == row && enemy.col == col;
  }
  
  boolean hitBomb(int row, int col, Bomb bomb) {
    return bomb.row == row && bomb.col == col;
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
