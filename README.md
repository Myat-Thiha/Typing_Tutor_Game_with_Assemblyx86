# Assembly x86 Typing Tutor Game

## Overview

This program is an assembly x86 typing tutor game developed using the Irvine library. It features two gaming modes: Original Mode and Floating Mode. The Original Mode requires users to type displayed strings correctly, marking incorrect characters until the user inputs the correct ones. Floating Mode presents falling words that users must type to remove. The game includes difficulty levels (easy, medium, hard) that affect the speed of falling words.
Link to the Youtube for this program: https://www.youtube.com/watch?v=eDFZMBJ6NN8
## Features

- **Original Mode:** Users type displayed strings; incorrect inputs are marked.
- **Floating Mode:** Falling words require user input to remove.
- **Difficulty Levels:** Easy, medium, and hard levels with varying word fall speeds.

## How to Run

1. Ensure you have the Irvine library installed and properly configured.
2. Compile the source code using your preferred x86 assembler (e.g., MASM).
3. Run the compiled executable to start the game.

## Controls

- **Original Mode:** Type the correct characters displayed on the screen. Incorrect characters will be marked until corrected.
- **Floating Mode:** Type the falling words to remove them. Allow words to hit the bottom screen results in a loss.

## Difficulty Levels

- **Easy:** Slower word fall speeds.
- **Medium:** Moderate word fall speeds.
- **Hard:** Faster word fall speeds.

## File Structure

- `main.asm`: Contains the main game logic.
- `irvine32.inc`: Irvine library include file.
- `irvine32.lib`: Irvine library linking file.

## Development Environment

- **Assembler:** MASM (Microsoft Macro Assembler) or compatible.
- **IDE:** Visual Studio, Visual Studio Code, Notepad++, or similar text editors.
- **Operating System:** Windows (for Irvine library compatibility).

## Credits

- **Irvine Library:** Used for input/output operations and console manipulation.
