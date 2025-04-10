class Bomb {
  int i, j;             // Tile coordinates
  float x, y;           // Pixel coordinates
  float width = tileSize * 0.7;
  float height = tileSize * 0.7;
  int power = 1;
  float timer = 5;        // Countdown in seconds

  Bomb(int i, int j, int power) {
    this.i = i;
    this.j = j;
    this.power = power;
    
    this.x = i * tileSize + tileSize / 2;
    this.y = j * tileSize + tileSize / 2;
  }

  void draw() {
    noStroke();

    // Main bomb body
    fill(0);  // Dark brown/gray
    ellipse(x, y, width, height);

    // Fuse base position (top-left corner)
    float fuseBaseX = x - width * 0.25;
    float fuseBaseY = y - height * 0.25;

    // Fuse base circle
    fill(67, 67, 67);  // Lighter brown
    ellipse(fuseBaseX, fuseBaseY, width * 0.3, height * 0.3);

    // Fuse line at 135 degrees (up-left)
    float fuseLength = map(timer, 0, 5, 0, tileSize * 0.2);
    float angle = radians(210);  // 135 degrees in radians
    float fuseTipX = fuseBaseX + cos(angle) * fuseLength;
    float fuseTipY = fuseBaseY + sin(angle) * fuseLength;

    stroke(255, 100, 0);  // Orange-red fuse
    strokeWeight(3);
    line(fuseBaseX, fuseBaseY, fuseTipX, fuseTipY);
    strokeWeight(1);

    // Flame at the tip of the fuse
    noStroke();
    fill(255, 200, 0, 180);
    ellipse(fuseTipX, fuseTipY, 6, 6);

    // Sparkles around flame tip
    for (int s = 0; s < 5; s++) {
      float sparkleAngle = random(TWO_PI);
      float dist = random(2, 6);
      float sx = fuseTipX + cos(sparkleAngle) * dist;
      float sy = fuseTipY + sin(sparkleAngle) * dist;

      fill(255, random(180, 220), 0, random(100, 200));
      ellipse(sx, sy, random(1, 3), random(1, 3));
    }
  }

  void explode() {
    println("BOOM at tile [" + i + ", " + j + "]");
    explosions.add(new Explosion(i, j, power));
  }
}
