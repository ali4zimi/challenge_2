// I created this menu recently to manage the states of the game
// I plan to add more options such as resume game, settings, map designer

class Menu {
  String[] baseOptions = {"New Game", "Resume Game", "Map Designer", "Settings", "Exit Game"};
  String[] options = baseOptions;
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
    background(50);
    textSize(32);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Main Menu", width / 2, height / 4);

    for (int i = 0; i < options.length; i++) {
      if (i == selectedOption) {
        fill(255, 0, 0);
      } else {
        fill(0, 255, 0);
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
    String selected = options[selectedOption];

    if (selected.equals("New Game")) {
      newGame();
    } else if (selected.equals("Resume Game")) {
      resumeGame();
    } else if (selected.equals("Map Designer")) {
      openMapDesigner();
    } else if (selected.equals("Settings")) {
      openSettings();
    } else if (selected.equals("Exit Game")) {
      exit();
    }
  }

  void newGame() {
    println("Starting a new game...");

    gameState = GameState.PLAYING;
    initNewGame();
  }

  void resumeGame() {
    println("Resuming the game...");
    gameState = GameState.PLAYING;
  }

  void openMapDesigner() {
    println("Opening map designer...");
    //gameState = "mapDesigner";
  }

  void openSettings() {
    println("Opening settings...");
    //gameState = "settings";
  }


  void show() {
    switch (gameState) {
    case PAUSED:
      menu.options = new String[]{"Resume Game", "New Game", "Map Designer", "Settings", "Exit Game"};
      break;
    default:
      menu.options = new String[]{"New Game", "Map Designer", "Settings", "Exit Game"};
    }

    handleInput();
    draw();
  }

  // I used this mechanism because quiting directly from here makes the program crash
  void exit() {
    println("Exiting the game...");
    shouldExit = true;
  }
}
