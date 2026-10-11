# Spartan 7 FPGA 

## Project Overview
This project implements an LCD controller on an FPGA with:
- 16x2 character LCD interface
- Button input handling
- RGBY LEDs
- Designed for Vivado 2024.1 - 2025.1
- 10MHz clock frequency operation

## Features
- **LCD Control**:
  - 11-bit interface mode
  - Busy flag checking
  - Proper timing delays for reliable operation(the example code i gave has really bad timing, optimisation)
- **Input/Output**:
  - Button 
  - LED 

## Hardware Requirements
- Xilinx FPGA (Spartan-7)
- Standard 16x2 HD44780-compatible LCD
- 4x buttons
- 8 LEDs 
- at least 10MHz clock source

## Memory Map
| Address | Purpose          | Bits Description                     |
|---------|------------------|--------------------------------------|
| 0x400   | Switches         | SW 1 - 4                             |
| 0x404   | LEDs             | Pins D7-D0                           |
| 0x408   | LCD Data         | Data lines D7-D0                     |
| 0x40C   | LCD Control      | [2] - Enable, [1] - R/W, [0] - RS    |


