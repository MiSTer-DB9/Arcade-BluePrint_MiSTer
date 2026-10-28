//============================================================================
//  board_template.sv - start a new Blue Print-core board by copying this file (NOT in files.qip, never compiled).
//  Copyright (C) 2026 Rodimus
//
//  Boards never instantiate a CPU, sound chip, ROM store or board RAM. They live ONCE in the dispatcher
//  rtl/blueprint_board.sv: Z80s z80_0 (main) / z80_1 (sound), AY-3-8910s ay_0 / ay_1 (chip_pool_pkg buses), the shared
//  ROM blocks (eprom_4k: main 1-6, tile 0-1, sprite R/B/G on index 0; sound 1-2 on index 1) and the 6 board RAM pool
//  blocks (ram_pool_pkg: 0 = work 2K (port B = hiscore), 1 = video 1K, 2 = color 1K, 3 = scroll 256, 4 = sprite 256,
//  5 = sound 1K).
//  To add a board: copy this file to rtl/boards/<board>/<board>.sv, add it to files.qip + verilator/Makefile, instance
//  it in the dispatcher, put its buses on variant muxes (z80_*_i, ay_*_i, pool_i, ROM read addresses) and tie the pool
//  blocks it doesn't use to '0. A RAM bigger than its block = grow the block, never a private dpram_dc / spram.
//  ROM images: an index-0 window + a read port exported to the dispatcher (load decode by the download address only).
//  A RAM / chip that truly can't pool = "// POOL-EXCEPTION: <reason>" on its instance line + a Pool contract row
//  (Claude/ vault note). verilator/common/pool_check.sh (POOL_MODS in verilator/Makefile) enforces it.
//============================================================================

module board_template
(
    input  logic        clk_40m,
    input  logic        reset,          // active low, as BluePrint_CPU / BluePrint_SND
    input  logic        pause,

    // shared Z80s (pool slots z80_0 / z80_1)
    output chip_pool_pkg::z80_i_t   z80_0_i,
    input  chip_pool_pkg::z80_o_t   z80_0_o,
    // shared AY-3-8910s (pool slots ay_0 / ay_1)
    output chip_pool_pkg::ay_i_t    ay_0_i,
    input  chip_pool_pkg::ayio_o_t  ay_0_o,

    // shared ROM blocks (read ports)
    output logic [11:0] rom_cpu_a,
    input  logic  [7:0] rom1_D,

    // board RAM pool (rtl/ram_pool_pkg.sv): 6 blocks, tie the unused ones to '0
    output ram_pool_pkg::pram_i_t [5:0] pr_i,
    input  ram_pool_pkg::pram_o_t [5:0] pr_o,

    input  logic  [7:0] p1_controls,
    input  logic [15:0] dip_sw,

    output logic        ce_pix,
    output logic  [4:0] red,
    output logic  [4:0] green,
    output logic  [4:0] blue,
    output logic        video_hsync,
    output logic        video_vsync,
    output logic        video_hblank,
    output logic        video_vblank,
    output logic signed [15:0] sound
);

endmodule
