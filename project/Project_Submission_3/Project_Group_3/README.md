Project Overview:

This project implements a complete chess game using pygame, where a player can compete against a computer that selects moves using the minimax algorithm and alpha-beta pruning with configurable depth and evaluation functions.
The system is modular, making it easy to upgrade the engine, integrate pruning, or add advanced heuristics.


Folder Structure:

CHESS-MINIMAX 
│
├── __pycache__/          # Auto-generated Python cache
├── assets/               # Sounds, fonts, etc.
├── images/               # Chess piece images and board graphics
│
├── __init__.py           # Package initializer
├── .gitignore            # Files to exclude from Git
│
├── ChessEngine.py        # Rules, move validation, board representation
├── ChessMain.py          # Pygame GUI + main event loop
├── SmartMoveFinder.py    # AI (Minimax + evaluation)
│
├── requirements.txt      # Python dependencies
└── README.md             # Project documentation


Architecture Overview:
ChessEngine.py:-

Board representation
All legal move generation
Rules engine
Check / checkmate logic
Undo and move logging

ChessMain.py:-

Pygame window
Rendering the board
Processing user events
Highlighting
Animation

SmartMoveFinder.py:-

Minimax search
Alpha Beta Pruning
Evaluation function
Best move selection
Search depth control

How to run:-

python ChessMain.py