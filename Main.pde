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

import websockets.*;

int gridSize = 11;            // Grid size for the game map
int tileSize = 80;            // Size of each tile
Tile[][] map;                 // The game map
Player player;                // Player object
boolean gamePaused = true;    // Flag to check if the game is paused
boolean shouldExit = false;   // Flag to check if the game should exit
Menu menu;                    // Main menu object

ArrayList<Enemy> enemies = new ArrayList<Enemy>();  // List of enemies
ArrayList<Bomb> bombs = new ArrayList<Bomb>();      // List of bombs placed by the player
ArrayList<Explosion> explosions = new ArrayList<Explosion>();  // List of explosions
ArrayList<Item> items = new ArrayList<Item>();      // List of items in the game

WebsocketServer socket;       // WebSocket server for communication

void setup() {
  size(880, 880);  // Set canvas size to 880x880 pixels
  menu = new Menu();  // Initialize the menu object

  socket = new WebsocketServer(this, 1337, "/p5websocket");  // Start WebSocket server on port 1337
}

void draw() {
  background(#13A002);  // Set background color to green

  if (gamePaused) {
    menu.draw();  // Draw the menu if the game is paused
    menu.handleInput();  // Handle input for menu navigation (up, down, enter)
  } else {
    background(200);  // Set background to light gray when the game is active

    // Clear randomly generated obstacles around player positions
    clearSurroundingBlocks(1, 1);
    clearSurroundingBlocks(9, 9);

    ArrayList<String> dirs = new ArrayList<>();
    dirs.add("a");

    // Draw the game map
    drawMap();

    // Draw all placed bombs
    drawBombs();

    // Draw and update all explosions
    drawExplosions();

    // Draw and update items (like power-ups, speed items)
    drawItems();

    if (player.alive) {
      player.update();  // Update the player's state
      player.handleInput();  // Handle input (movement, actions)
    }

    // Update enemies if they are alive
    for (Enemy enemy : enemies) {
      if (enemy.alive) {
        enemy.update();
      }
    }
  }

  if (shouldExit) exit();  // Exit the game if the exit flag is true
}

void keyPressed() {
  // Set flags when UP or DOWN key is pressed to prevent flickering in menu navigation
  if (keyCode == UP) {
    menu.upPressed = true;  // Mark that UP key was pressed
  } else if (keyCode == DOWN) {
    menu.downPressed = true;  // Mark that DOWN key was pressed
  } else if (keyCode == ENTER) {
    menu.performAction();  // Perform the action when ENTER is pressed (e.g., start game)
  }
}

void webSocketServerEvent(String msg) {
  if (msg.contains("start game")) {
    newGame();
  } else if (msg.contains("exit game")) {
    shouldExit = true; 
  } else if (msg.contains("destroy all walls")) {
    destroyAllWalls();
  }
  
  print(msg);
}

// Start a new game by initializing the map, player, and enemies
void newGame() {
  map = generateMap();  // Generate a new game map
  player = new Player(1, 1);  // Place player at position (1,1)

  enemies.add(new Enemy(9, 9));  // Add an enemy at position (9,9)
  
  gamePaused = false;  
}

// Generates the game map with walls, breakable blocks, and grass
Tile[][] generateMap() {
  Tile[][] m = new Tile[gridSize][gridSize];  // Create a 2D array for the map
  for (int i = 0; i < gridSize; i++) {
    for (int j = 0; j < gridSize; j++) {
      if (i == 0 || j == 0 || i == gridSize - 1 || j == gridSize - 1) {
        m[i][j] = new Wall(i, j);  // Set borders of the map as walls
      } else if (i % 2 == 0 && j % 2 == 0) {
        m[i][j] = new Wall(i, j);  // Place additional walls in the inner grid at even indices
      } else if (random(1) < 0.2) {
        m[i][j] = new BreakableBlock(i, j);  // Place breakable blocks with a 20% chance
      } else {
        m[i][j] = new Grass(i, j);  // Empty space (grass)
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
void clearSurroundingBlocks(int posI, int posJ) {
  for (int i = posI - 1; i <= posI + 1; i++) {
    for (int j = posJ - 1; j <= posJ + 1; j++) {
      if (map[i][j] instanceof BreakableBlock) {
        map[i][j] = new Grass(i, j);  // Replace breakable block with grass
      }
    }
  }
}

// Draw and update all bombs in the game
void drawBombs() {
  for (int k = bombs.size() - 1; k >= 0; k--) {
    Bomb b = bombs.get(k);
    b.draw();  // Draw each bomb

    // Countdown once per second (60 FPS)
    if (frameCount % 60 == 0) {
      b.timer--;  // Decrease bomb timer
      if (b.timer <= 0) {
        b.explode();  // Explode the bomb when the timer reaches zero
        bombs.remove(k);  // Remove bomb from the list after explosion
      }
    }
  }
}

// Draw all explosions and handle their updates
void drawExplosions() {
  for (int k = explosions.size() - 1; k >= 0; k--) {
    Explosion e = explosions.get(k);
    e.drawFlame();  // Draw the explosion flames
    e.update();  // Update explosion state (e.g., timer)
    if (e.isFinished()) {
      explosions.remove(k);  // Remove finished explosions
    }
  }
}

// Draw all items (e.g., power-ups, speed items)
void drawItems() {
  for (Item item : items) {
    item.draw();  // Draw each item
  }
}

void destroyAllWalls() {
  for (int i = 0; i < gridSize; i ++) {
     for (int j = 0; j < gridSize; j++) {
       if (map[i][j] instanceof BreakableBlock) {
          map[i][j].breakBlock(); 
          map[i][j] = new Grass(i, j);
       }
     }
  }
}
