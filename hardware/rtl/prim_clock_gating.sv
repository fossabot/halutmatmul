// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Example clock gating module for yosys synthesis

module prim_clock_gating (
  input  clk_i,
  input  en_i,
  input  test_en_i,
  output clk_o
);

`ifdef ASAP7_USELVT

  ICGx1_ASAP7_75t_L latch (
    .CLK (clk_i),
    .ENA (en_i),
    .SE  (test_en_i),
    .GCLK(clk_o)
  );

`elsif ASAP7_USESLVT

  ICGx1_ASAP7_75t_SL latch (
    .CLK (clk_i),
    .ENA (en_i),
    .SE  (test_en_i),
    .GCLK(clk_o)
  );

`else

  reg en_latch;

  always_latch begin
    if (!clk_i) begin
      en_latch = en_i | test_en_i;
    end
  end
  assign clk_o = en_latch & clk_i;

`endif

endmodule
