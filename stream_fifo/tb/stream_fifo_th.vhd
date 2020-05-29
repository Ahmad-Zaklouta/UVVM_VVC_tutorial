library ieee;
use ieee.std_logic_1164.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

library vip_stream;
use vip_stream.stream_bfm_pkg.all;
use vip_stream.vvc_methods_pkg.all;

entity stream_fifo_th is
  generic (
    GC_DATA_WIDTH : natural;
    GC_DATA_DEPTH : natural;
    GC_CLK_PERIOD : time);
  port (
    clk    : out std_logic;
    clk_en : in boolean);
end entity;

architecture arch of stream_fifo_th is

  signal source : t_stream_if (tdata(GC_DATA_WIDTH-1 downto 0));
  signal sink   : t_stream_if (tdata(GC_DATA_WIDTH-1 downto 0));
  
begin
  i_ti_uvvm_engine : entity uvvm_vvc_framework.ti_uvvm_engine;
  p_clock : clock_generator(clk, clk_en, GC_CLK_PERIOD, "clk");
  
  DUT : entity work.stream_fifo
    generic map (
      GC_DATA_WIDTH => GC_DATA_WIDTH,
      GC_DATA_DEPTH => GC_DATA_DEPTH)  
    port map (
      clk             => clk          , 
      -- FIFO data input
      fifo_in_tdata   => source.tdata ,
      fifo_in_tlast   => source.tlast ,
      fifo_in_tvalid  => source.tvalid,
      fifo_in_tready  => source.tready,
      -- FIFO data output
      fifo_out_tdata  => sink.tdata   ,
      fifo_out_tlast  => sink.tlast   ,
      fifo_out_tvalid => sink.tvalid  ,
      fifo_out_tready => sink.tready  );

  vip_stream_source : entity vip_stream.stream_vvc
    generic map (
      GC_INSTANCE_IDX    => 0,
      GC_VVC_IS_SOURCE   => true,            
      GC_VVC_TDATA_WIDTH => GC_DATA_WIDTH)  
    port map (
      clk           => clk   ,
      stream_vvc_if => source);  
  
  vvc_stream_sink : entity vip_stream.stream_vvc
    generic map (
      GC_INSTANCE_IDX    => 1,
      GC_VVC_IS_SOURCE   => false,            
      GC_VVC_TDATA_WIDTH => GC_DATA_WIDTH)  
    port map (
      clk           =>  clk  ,
      stream_vvc_if => sink);  
      
  p_th : process
  begin
    wait for 0 ns;  
    for i in 0 to 1 loop
      shared_stream_vvc_config(i).bfm_config.clock_period := GC_CLK_PERIOD;
      
      for j in t_msg_id'left to t_msg_id'right loop
        shared_stream_vvc_config(i).msg_id_panel(j) := DISABLED;
      end loop;
      
      shared_stream_vvc_config(i).msg_id_panel(ID_BFM) := ENABLED;
    end loop;
    wait;    
  end process;      
      
end architecture;