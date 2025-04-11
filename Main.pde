/*
 * Bomberman Game
 *
 * This game is a simplified version of the classic Bomberman game, where the player controls a character
 * in a grid-based environment filled with walls, breakable blocks, bombs, explosions, enemies, and items.
 * The goal of the game is to destroy breakable blocks and enemies using bombs while avoiding explosions and
 * managing power-ups. The player can place bombs, which will explode after a short delay, clearing obstacles
 * and damaging enemies within the blast radius.
 *
 * Author: Ali Baba Azimi
 * Date: 25.03.2025
 */

import java.util.ArrayList;
import java.util.Iterator;
import websockets.*;

// Global Variables
final int gridSize = 11;
final int tileSize = 80;

Tile[][] map;
Player player;
Menu menu;

boolean gameStarted = false;
boolean gamePaused = true;
boolean shouldExit = false;

enum GameState {
  MENU, PLAYING, WIN, LOSE, PAUSED
}
GameState gameState = GameState.MENU;

ArrayList<Enemy> enemies = new ArrayList<>();
ArrayList<Bomb> bombs = new ArrayList<>();
ArrayList<Explosion> explosions = new ArrayList<>();
ArrayList<Item> items = new ArrayList<>();


WebsocketServer socket;       // WebSocket server for communication, I used to for voice commands

// Setup & Main Loop
void setup() {
  size(880, 880);
  menu = new Menu();
  socket = new WebsocketServer(this, 3000, "/bomberman_websocket");
}

void draw() {
  //background(gamePaused ? #13A002 : 200);

  if (gameState != GameState.PLAYING) {
    menu.show();
  } else {
    clearSurroundingBlocks(1, 1);
    clearSurroundingBlocks(9, 9);

    drawMap();
    drawBombs();
    drawExplosions();
    drawItems();

    if (player.alive) {
      player.update();
      player.handleInput();
    }

    // Update enemies
    Iterator<Enemy> iter = enemies.iterator();
    while (iter.hasNext()) {
      Enemy enemy = iter.next();
      if (enemy.alive) {
        enemy.update();
      } else {
        iter.remove();
      }
    }

    if (enemies.isEmpty()) {
      gameState = GameState.WIN;
      menu.show();
      print("You win");
    }
  }

  if (shouldExit) exit();
}

void keyPressed() {
  // Set flags when UP or DOWN key is pressed to prevent flickering in menu navigation
  if (keyCode == UP) {
    menu.upPressed = true;  // Mark that UP key was pressed
  } else if (keyCode == DOWN) {
    menu.downPressed = true;  // Mark that DOWN key was pressed
  } else if (keyCode == ENTER) {
    menu.performAction();  // Perform the action when ENTER is pressed (e.g., start game)
  } else if (key == 'p' || key == 'P') {
    gameState = GameState.PAUSED;
  }
}


// Voice command through websockets
// credits: https://florianschulz.info/stt/
void webSocketServerEvent(String msg) {
  if (msg.contains("start game")) {
    initNewGame();
  } else if (msg.contains("exit game")) {
    shouldExit = true;
  } else if (msg.contains("destroy all blocks")) {
    player.destroyAllBlocks();
  } else if (msg.contains("magic power")) {
    player.destroyAllEnemies();
  }

  print(msg);
}

// Game Initialization
void initNewGame() {
  enemies.clear();
  bombs.clear();
  explosions.clear();
  items.clear();

  map = generateMap();
  player = new Player(1, 1);
  enemies.add(new Enemy(9, 9));
}


// Generates the game map with walls, breakable blocks, and grass
Tile[][] generateMap() {
  Tile[][] m = new Tile[gridSize][gridSize];

  for (int row = 0; row < gridSize; row++) {
    for (int col = 0; col < gridSize; col++) {
      if (row == 0 || col == 0 || row == gridSize - 1 || col == gridSize - 1 || (row % 2 == 0 && col % 2 == 0)) {
        m[row][col] = new Wall(row, col);
      } else if (random(1) < 0.2) {
        m[row][col] = new BreakableBlock(row, col);
      } else {
        m[row][col] = new Grass(row, col);
      }
    }
  }

  return m;
}

// Draw the entire map by iterating through all tiles
void drawMap() {
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      map[i][j].draw();
    }
  }
}

// Clears the surrounding blocks (up, down, left, right, and diagonals) around a given position to not lock player and enemies
void clearSurroundingBlocks(int posRow, int posCol) {
  for (int row = posRow - 1; row <= posRow + 1; row++) {
    for (int col = posCol - 1; col <= posCol + 1; col++) {
      if (map[row][col] instanceof BreakableBlock) {
        map[row][col] = new Grass(row, col);
      }
    }
  }
}
// Draw and update all bombs in the game
void drawBombs() {
  for (int k = bombs.size() - 1; k >= 0; k--) {
    Bomb b = bombs.get(k);
    b.draw();

    if (frameCount % 60 == 0) {
      b.timer--;
      if (b.timer <= 0) {
        b.explode();
        bombs.remove(k);
      }
    }
  }
}

// Draw all explosions and handle their updates
void drawExplosions() {
  for (int k = explosions.size() - 1; k >= 0; k--) {
    Explosion e = explosions.get(k);
    e.drawFlame();
    e.update();

    if (e.isFinished()) {
      explosions.remove(k);
    }
  }
}

// Draw all items (e.g., power-ups, speed items)
void drawItems() {
  for (Item item : items) {
    item.draw();
  }
}
