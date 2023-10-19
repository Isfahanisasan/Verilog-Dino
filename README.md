# Verilog Dino Game
This Verilog project implements a simplified version of the classic "Dino Game" that can be played on Google Chrome when there is no internet connection. The game is designed to run on a Nexys 3 FPGA board and utilizes various modules to create a VGA-based game with a seven-segment LED display for score tracking. 


## File Structure
The project consists of several Verilog modules and associated files:

clock_divider.v: This module generates multiple clock signals, including a 25MHz clock for VGA synchronization, a 20Hz clock for game logic, and a 500Hz clock for updating the seven-segment LED display.

debouncer.v: The debouncer module filters noisy button inputs (reset and jump buttons) and ensures reliable button presses by eliminating glitches.

gamecontroller.v: This module acts as the main controller, integrating other modules and handling VGA synchronization, button inputs, game logic, and LED display updates.

gamelogic.v: This module controls the game's logic, including player and obstacle movement, collision detection, and scoring.

Seven_segment_LED_Display_Controller.v: This module manages the seven-segment LED display, converting the player's score into a displayable format and activating specific segments to display the digits.

vga.v: The VGA module handles VGA synchronization, pixel generation, and screen display.

## Simulation and Synthesis
Before deploying the code to the Nexys 3 FPGA board, it's essential to simulate and synthesize the design to catch any errors and verify its functionality. Tools like Xilinx Vivado can be used for synthesis, and simulation can be performed with tools like ModelSim.

## Usage
To use this project on a Nexys 3 FPGA board, follow these steps:

1- Set up the Nexys 3 FPGA board and ensure it's properly connected to your computer.

2- Use Xilinx Vivado or a similar tool to synthesize the Verilog code and generate the bitstream file for programming the FPGA.

3- Program the FPGA board with the generated bitstream file.

4- Connect a VGA monitor to the FPGA board to view the game display.

5- Use the jump and reset buttons on the FPGA board to control the game.

Enjoy playing the Dino Game on your FPGA!
