library ieee;
use ieee.std_logic_1164.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

library vip_stream;
use vip_stream.stream_bfm_pkg.all;
use vip_stream.vvc_methods_pkg.all;

entity stream_fifo_tb is
end entity;

architecture arch of stream_fifo_tb is

  constant C_SCOPE : string := "stream_fifo_tb";
  constant C_CLK_PERIOD : time    := 1 ns;
  constant C_DATA_WIDTH : natural := 16;
  constant C_DATA_DEPTH : natural := 32;
  
  signal clk    : std_logic;
  signal clk_en : boolean := false;
  
begin
  i_test_harness : entity work.stream_fifo_th
    generic map (
      GC_DATA_WIDTH => C_DATA_WIDTH,
      GC_DATA_DEPTH => C_DATA_DEPTH,
      GC_CLK_PERIOD => C_CLK_PERIOD)
    port map (
      clk    => clk,
      clk_en => clk_en);
      
  sequencer : process
  begin
    disable_log_msg(ALL_MESSAGES);
    enable_log_msg (ID_CONSTRUCTOR);
    enable_log_msg (ID_SEQUENCER);
  
    await_uvvm_initialization(VOID); -- Wait for UVVM to finish initialization

    wait for C_CLK_PERIOD;
    clk_en <= true;
    
    log(ID_SEQUENCER, "----------------------------------------", C_SCOPE);   
    log(ID_SEQUENCER, "-- test bench sequence starts here      ", C_SCOPE);
    log(ID_SEQUENCER, "----------------------------------------", C_SCOPE);
    
    stream       (STREAM_VVCT, 0, x"1234", '1', "Transaction 0", true , false);
    stream       (STREAM_VVCT, 1, x"1234", '1', "Transaction 0", false, true); 
    stream       (STREAM_VVCT, 0, x"5678", '1', "Transaction 1", true , false);
    stream       (STREAM_VVCT, 1, x"5678", '1', "Transaction 1", false, false); 
    stream_write (STREAM_VVCT, 0, x"abcd", '1', "Transaction 2");
    stream_expect(STREAM_VVCT, 1, x"abcd", '1', "Transaction 2");    

    stream_write (STREAM_VVCT, 0, x"aa55", '1', "Transaction 3");
    stream_read  (STREAM_VVCT, 1, x"aa55", '1', "Transaction 3");

    stream_write (STREAM_VVCT, 0, x"fedc", '1', "Transaction 4");
    stream_read  (STREAM_VVCT, 1,               "Transaction 4");

    await_completion(VVC_BROADCAST, 10 ns, "Wait for all VVCs to finish");

    wait for C_CLK_PERIOD;
    report_alert_counters(FINAL); -- Report final counters and print conclusion for simulation (Success/Fail)
    log(ID_LOG_HDR, "SIMULATION COMPLETED", C_SCOPE);
   
    -- Finish the simulation
    std.env.stop;
    wait;  -- to stop completely  

  end process; -- sequencer
  
end architecture;