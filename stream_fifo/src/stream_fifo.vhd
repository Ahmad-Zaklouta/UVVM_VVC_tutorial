library ieee;
use ieee.std_logic_1164.all;

entity stream_fifo is
  generic (
    GC_DATA_WIDTH : natural;
    GC_DATA_DEPTH : natural);
  port (
    clk             : in  std_logic;
    
    fifo_in_tdata   : in  std_logic_vector(GC_DATA_WIDTH-1 downto 0);
    fifo_in_tlast   : in  std_logic;
    fifo_in_tvalid  : in  std_logic;
    fifo_in_tready  : out std_logic;
    
    fifo_out_tdata  : out std_logic_vector(GC_DATA_WIDTH-1 downto 0);
    fifo_out_tlast  : out std_logic;
    fifo_out_tvalid : out std_logic;
    fifo_out_tready : in  std_logic);
end entity;

architecture arch of stream_fifo is

  signal fifo_in_data      : std_logic_vector (GC_DATA_WIDTH downto 0);
  signal fifo_out_data     : std_logic_vector (GC_DATA_WIDTH downto 0);
  
begin -- architecture

  fifo_in_data   <= fifo_in_tlast & fifo_in_tdata;
  fifo_out_tdata <= fifo_out_data (GC_DATA_WIDTH-1 downto 0);
  fifo_out_tlast <= fifo_out_data (GC_DATA_WIDTH);
  
  DUT : entity work.tiny_fifo
  generic map (
    GC_WIDTH => GC_DATA_WIDTH+1, -- FIFO data width
    GC_DEPTH => GC_DATA_DEPTH)   -- FIFO data depth, <= 32
  port map (
    clk            => clk            , 
    
    -- FIFO data input
    fifo_in_data   => fifo_in_data   ,
    fifo_in_valid  => fifo_in_tvalid ,
    fifo_in_ready  => fifo_in_tready ,
    -- FIFO data output
    fifo_out_data  => fifo_out_data  ,
    fifo_out_valid => fifo_out_tvalid,
    fifo_out_ready => fifo_out_tready,
    
    -- status signals
    fifo_index     => open);

end architecture;