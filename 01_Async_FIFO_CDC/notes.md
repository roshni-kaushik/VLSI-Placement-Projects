# Asynchronous FIFO (Clifford Cummings Style)

## Objective

Design and verify an Asynchronous FIFO using Verilog.

## Features

- Parameterized FIFO
- Dual Clock
- Dual Port Memory
- Binary Pointer
- Gray Pointer
- Two Flip-Flop Synchronizer
- Full Flag
- Empty Flag

## Tools

Editor:
VS Code

Simulator:
Icarus Verilog 12.0

Waveform:
GTKWave

## Commands

iverilog -o async_fifo.out async_fifo.v tb_async_fifo.v

vvp async_fifo.out

gtkwave fifo.vcd

# Part 1 - RTL Infrastructure

## Objective

Create all registers and wires required by the asynchronous FIFO before implementing the logic.

## Components Declared

- FIFO Memory
- Binary Write Pointer
- Binary Read Pointer
- Gray Write Pointer
- Gray Read Pointer
- Synchronizer Registers
- Next-State Wires
- Full/Empty Status Wires

## Memory

Depth = 2^ADDR_WIDTH

Example:

ADDR_WIDTH = 4

Depth = 16

Memory:

16 × 8 bits

## Why ADDR_WIDTH+1 bits?

Pointers use one extra MSB.

Purpose:

- Detect wrap-around.
- Distinguish FULL from EMPTY.

# Part 2 - Pointer Logic

## Added

- Binary Write Pointer
- Binary Read Pointer
- Binary → Gray Conversion
- Write Pointer Register
- Read Pointer Register
- Memory Write Logic
- Memory Read Logic
- Two Flip-Flop Synchronizers

## New Concept

Pointer Flow

Binary Pointer

↓

Gray Pointer

↓

Synchronizer

↓

Other Clock Domain

## Why Gray?

Only one bit changes between consecutive values.

Reduces CDC errors.

# Part 3 - Status Logic

## Added

- Full Detection
- Empty Detection

## Full Condition

Next Write Gray Pointer

==

Read Gray Pointer
with two MSBs inverted

Meaning:

The write pointer has caught up to the read pointer after wrapping around.

## Empty Condition

Next Read Gray Pointer

==

Synchronized Write Gray Pointer

Meaning:

No unread data remains.

# Module 1 : fifomem

Purpose

Stores FIFO data.

Responsibilities

- Write data
- Read data

Does NOT know

- Gray code
- Synchronizers
- Full calculation
- Empty calculation

Address Width

Memory uses ADDRSIZE bits.

The extra pointer MSB is ignored because it is only used for wrap-around detection.

# Module 2 : sync_r2w

Purpose

Synchronize the Read Gray Pointer into the Write Clock Domain.

Technique

Two Flip-Flop Synchronizer

Why?

Prevent metastability when crossing clock domains.

Pipeline

Read Pointer

↓

FF1

↓

FF2

↓

Write Logic

Important

Always synchronize Gray pointers, not binary pointers.

# Module 3 : sync_w2r

Purpose

Synchronize the Write Gray Pointer into the Read Clock Domain.

Pipeline

Write Pointer

↓

FF1

↓

FF2

↓

Read Logic

Key Idea

The read logic never uses the raw write pointer.
It always uses the synchronized version.

Reason

Avoid metastability during clock-domain crossing.

# Module 4 : wptr_full (Part 1)

Responsibilities

- Binary Write Pointer
- Gray Write Pointer
- Memory Address Generation

Important

Binary Pointer

↓

Increment

↓

Gray Conversion

↓

Synchronizer

↓

Read Domain

Memory Address

Uses only the lower ADDRSIZE bits.

Extra MSB

Used only for wrap-around detection.

# Module 5 : rptr_empty

Purpose

Generate the Read Pointer and Empty Flag.

Responsibilities

- Binary Read Pointer
- Gray Read Pointer
- Read Address
- Empty Detection

Empty Equation

rgraynext == rq2_wptr

Meaning

The read pointer has caught up with the synchronized write pointer.

After Reset

rempty = 1

because the FIFO initially contains no data.

# Module 6 : async_fifo (Top Module)

## Purpose

The top module connects all the submodules of the asynchronous FIFO.

## Instantiated Modules

1. fifomem
2. sync_r2w
3. sync_w2r
4. wptr_full
5. rptr_empty

## Responsibilities

- Connect write-side logic.
- Connect read-side logic.
- Connect synchronizers.
- Connect FIFO memory.
- Route internal signals.

## Important Observation

The top module contains almost no logic.

Its job is only to instantiate modules and connect them together.

## Data Flow

Write Side

Write Request
↓

Write Pointer
↓

Memory

Read Side

Read Request
↓

Read Pointer
↓

Memory

CDC

Read Pointer
↓

sync_r2w
↓

Write Logic

Write Pointer
↓

sync_w2r
↓

Read Logic

# Module 7 : Testbench

Purpose

Verify the complete asynchronous FIFO.

Features

- Independent Write Clock
- Independent Read Clock
- Reset Generation
- Write Transactions
- Read Transactions
- VCD Generation
- Console Display

Clock Frequencies

Write Clock

Period = 10 ns

Frequency = 100 MHz

Read Clock

Period = 14 ns

Frequency ≈ 71.4 MHz

Simulation Flow

Reset

↓

Write Data

↓

Read Data

↓

Finish

GTKWave File

fifo.vcd

Useful Signals

wclk
rclk

winc
rinc

wdata
rdata

wptr
rptr

wfull
rempty

waddr
raddr

