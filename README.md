# VLSI Placement Projects

A collection of RTL design and digital VLSI projects implemented using **Verilog/SystemVerilog concepts**, with simulation and verification using industry-relevant EDA tools.

The projects cover **Clock Domain Crossing (CDC), RISC-V processors, MIPS32 architecture, pipelined processors, and UART communication**.

---

## Projects

### 01. Asynchronous FIFO – Clock Domain Crossing

Designed and verified an **Asynchronous FIFO** for reliable data transfer between two independent clock domains.

**Key concepts:**
- Clock Domain Crossing (CDC)
- Gray-code pointers
- Synchronizer circuits
- FIFO full and empty detection
- Dual-clock memory
- Metastability considerations

**Implementation includes:**
- FIFO memory
- Read/write pointer logic
- Read-to-write clock-domain synchronizer
- Write-to-read clock-domain synchronizer
- Basic and advanced testbenches
- Simulation waveforms and utilization report

**Tools:** Verilog, Icarus Verilog, GTKWave

---

### 02. RISC-V Single-Cycle Processor

Implemented a **single-cycle RISC-V processor datapath** supporting fundamental RISC-V instruction types.

**Key concepts:**
- RISC-V ISA
- Program Counter
- Instruction memory
- Register file
- ALU
- Control unit
- Immediate generation
- Data memory
- Instruction decoding

**Supported instruction categories:**
- R-type
- I-type
- S-type
- Branch instructions

**Tools:** Verilog, Icarus Verilog

---

### 03. RISC-V 5-Stage Pipelined Processor

Implemented a **5-stage pipelined RISC-V processor** to improve instruction throughput compared with a single-cycle architecture.

**Pipeline stages:**
1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory Access (MEM)
5. Write Back (WB)

**Key concepts:**
- Pipeline registers
- Instruction-level parallelism
- ALU and control-path pipelining
- Data-path organization
- Pipeline timing

**Tools:** Verilog, Icarus Verilog

---

### 04. MIPS32 Single-Cycle Processor

Implemented a **MIPS32 single-cycle processor** based on the classic RISC datapath architecture.

**Key concepts:**
- MIPS32 instruction format
- Register file
- ALU
- Main control unit
- ALU control
- Instruction memory
- Data memory
- Sign extension
- Branch and jump operations

**Instruction categories:**
- R-type
- Load/store
- Branch
- Immediate instructions

**Tools:** Verilog, Icarus Verilog

---

### 05. UART Transmitter and Receiver

Designed and verified a **UART transmitter and receiver** for serial communication.

**Key features:**
- UART transmitter
- UART receiver
- Configurable baud rate
- Serial data transmission
- Serial data reception
- Start and stop bit handling
- Loopback-style verification

**Configuration:**
- Baud rate: 115200
- 8-bit data transmission

**Tools:** Verilog, Icarus Verilog, GTKWave

---

## Repository Structure

```text
VLSI-Placement-Projects/
│
├── 01_Async_FIFO_CDC/
│
├── 02_RISC_V_Single_Cycle/
│
├── 03_RISC_V_5_Stage_Pipelined/
│
├── 04_MIPS32_Single_Cycle/
│
├── 05_UART_Tx_Rx/
│
└── README.md
