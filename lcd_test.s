#this code initialises the screen and sets the blinking cursor
.global _start
.section .text
#40c lcd control bits
#408 lcd data bits
_start:
li t2, 0x14  # 20+ cycle delay  enable
li t3, 0x0d  # 13+ cycle delay  data drive
li t4, 0x30  # 48+ cycle delay  pulse spacing


#==============reading bit 7================
_read_busy:
li t1, 0x40c # Memory address of control LCD
# read 
li t5, 0b001
sw t5, 0(t1)

#enable
li t5, 0b101
sw t5, 0(t1)

#enable delay
_loop_20:
addi t2, t2, -1
bne t2, zero, _loop_20 
li t2, 0x14

#read data drive delay 
_loop_13:
addi t3, t3, -1
bne t3, zero, _loop_13
li t3, 0xd

#Store status byte into reg 6
li t1, 0x408 # Memory address of data LCD
lw t6, 0(t1)
#bit mask
andi t6, t6, 0x80

#disable
li t5, 0b001
li t1, 0x40c # Memory address of control LCD
sw t5, 0(t1)

_loop_48:
addi t4, t4, -1
bne t4, zero, _loop_48 
li t4, 0x30

bne t6, zero, _read_busy

#==============Writing first characters==============

#set control pattern
li t0, 0b000
li t1, 0x40c
sw t0, 0(t1)

#Set data pattern
li t0, 0b00111000
li t1, 0x408
sw t0, 0(t1)

#Enable write
li t1, 0x40c # Memory address of control LCD
li t0, 0b100
sw t0, 0(t1)

#Enable delay
_1loop_20:
addi t2, t2, -1
bne t2, zero, _1loop_20 
li t2, 0x14

#Disable write
li t5, 0b000
sw t5, 0(t1)

#==============Writing second characters==============

# Wait for LCD to be ready again
_read_busy2:
li t1, 0x40c # Memory address of control LCD
# read 
li t5, 0b001
sw t5, 0(t1)

#enable
li t5, 0b101
sw t5, 0(t1)

#enable delay
_loop_20_2:
addi t2, t2, -1
bne t2, zero, _loop_20_2 
li t2, 0x14

#read data drive delay 
_loop_13_2:
addi t3, t3, -1
bne t3, zero, _loop_13_2
li t3, 0xd

#Store status byte into reg 6
li t1, 0x408 # Memory address of data LCD
lw t6, 0(t1)
#bit mask
andi t6, t6, 0x80

#disable
li t5, 0b001
li t1, 0x40c # Memory address of control LCD
sw t5, 0(t1)

_loop_48_2:
addi t4, t4, -1
bne t4, zero, _loop_48_2 
li t4, 0x30

bne t6, zero, _read_busy2

# Now write the second data (0000 1111)

#set control pattern
li t0, 0b000
li t1, 0x40c
sw t0, 0(t1)

#Set data pattern
li t0, 0b00001111
li t1, 0x408
sw t0, 0(t1)

#Enable write
li t1, 0x40c # Memory address of control LCD
li t0, 0b100
sw t0, 0(t1)

#Enable delay
_2loop_20:
addi t2, t2, -1
bne t2, zero, _2loop_20 
li t2, 0x14

#Disable write
li t5, 0b000
sw t5, 0(t1)

loop:
j loop
