// I created this menu recently to manage the states of the game
// I plan to add more options such as resume game, settings, map designer

class Menu {
  String[] options = {"Start Game", "Exit Game"};
  int selectedOption = 0;

  float buttonWidth = 200;
  float buttonHeight = 50;
  float margin = 20;
  float startX, startY;

  boolean upPressed = false;  // Flag to track if UP key was pressed
  boolean downPressed = false; // Flag to track if DOWN key was pressed

  Menu() {
    startX = (width - buttonWidth) / 2;
    startY = (height - buttonHeight * options.length) / 2;
  }

  void draw() {
    background(50);  // Dark background for menu
    textSize(32);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Main Menu", width / 2, height / 4);

    for (int i = 0; i < options.length; i++) {
      if (i == selectedOption) {
        fill(255, 0, 0);  // Highlight selected option in red
      } else {
        fill(0, 255, 0);  // Regular button color
      }
      rect(startX, startY + (i * (buttonHeight + margin)), buttonWidth, buttonHeight);
      fill(255);
      text(options[i], width / 2, startY + (i * (buttonHeight + margin)) + buttonHeight / 2);
    }
  }

  void handleInput() {
    if (upPressed) {
      selectedOption = (selectedOption - 1 + options.length) % options.length;
      upPressed = false; // Reset flag after action
    }
    if (downPressed) {
      selectedOption = (selectedOption + 1) % options.length;
      downPressed = false; // Reset flag after action
    }
  }

  void performAction() {
    if (selectedOption == 0) {
      startGame();
    } else if (selectedOption == 1) {
      exit();
    }
  }

  void startGame() {
    println("Starting a new game...");
    newGame();
  }

  void resumeGame() {
    println("Resuming the game...");
    gamePaused = false;
  }

  // I used this mechanism because quiting directly from here makes the program crash
  void exit() {
    println("Exiting the game...");
    shouldExit = true;
  }
}
