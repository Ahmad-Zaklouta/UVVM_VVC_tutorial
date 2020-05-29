--========================================================================================================================
-- This VVC was generated with Bitvis VVC Generator
--========================================================================================================================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

--========================================================================================================================
--========================================================================================================================
package stream_bfm_pkg is

  --========================================================================================================================
  -- Types and constants for STREAM BFM 
  --========================================================================================================================
  constant C_SCOPE : string := "STREAM BFM";

  -- Optional interface record for BFM signals
  type t_stream_if is record
  --<USER_INPUT> Insert all BFM signals here
    tlast  : std_logic;       
    tdata  : std_logic_vector;
    tvalid : std_logic;       
    tready : std_logic;         
  -- Example:
  -- cs      : std_logic;          -- to dut
  -- addr    : unsigned;           -- to dut
  -- rena    : std_logic;          -- to dut
  -- wena    : std_logic;          -- to dut
  -- wdata   : std_logic_vector;   -- to dut
  -- ready   : std_logic;          -- from dut
  -- rdata   : std_logic_vector;   -- from dut
  end record;

  -- Configuration record to be assigned in the test harness.
  type t_stream_bfm_config is
  record
    --<USER_INPUT> Insert all BFM config parameters here
    -- Example:
    -- max_wait_cycles          : integer;
    -- max_wait_cycles_severity : t_alert_level;
    id_for_bfm               : t_msg_id;
    -- id_for_bfm_wait          : t_msg_id;
    -- id_for_bfm_poll          : t_msg_id;
    clock_period             : time;  -- Needed in the VVC
  end record;

  -- Define the default value for the BFM config
  constant C_STREAM_BFM_CONFIG_DEFAULT : t_stream_bfm_config := (
    --<USER_INPUT> Insert defaults for all BFM config parameters here
    -- Example:
    -- max_wait_cycles          => 10,
    -- max_wait_cycles_severity => failure,
    id_for_bfm               => ID_BFM,
    -- id_for_bfm_wait          => ID_BFM_WAIT,
    -- id_for_bfm_poll          => ID_BFM_POLL,
    clock_period             => 0 ns
  );



  --========================================================================================================================
  -- BFM procedures 
  --========================================================================================================================


  --<USER_INPUT> Insert BFM procedure declarations here, e.g. read and write operations
  function init_stream_if_signals (vvc_is_source  : boolean;
                                   vvc_data_width : natural;
                                   vvc_is_monitor : boolean) return t_stream_if;
  
  procedure wiggle (   
    -- BFM generic parameters from VVC  
    constant GC_VVC_IS_SOURCE               : in boolean;
    constant GC_VVC_CHECK_TLAST             : in boolean;
    constant GC_VVC_TDATA_WIDTH             : in positive;
    constant GC_VVC_IS_MONITOR              : in boolean;
    constant GC_VVC_VIOLATE_SRC_TVALID_RULE : in boolean;
    constant GC_VVC_CHECK_SRC_TVALID_SIGNAL : in boolean;
    constant GC_VVC_DONT_CHECK_JUST_REPORT  : in boolean;
  
    -- BFM dynamic execution parameters
    constant c_tdata            : in std_logic_vector; 
    constant c_tdata_width      : in natural;
    constant c_tlast            : in std_logic;
    constant c_dont_check       : in boolean;
    constant c_called_as_source : in boolean;
    constant c_msg              : in string;
    
    -- BFM ports connecting to VVC ports
    signal clk            : in    std_logic; 
    signal stream_if      : inout t_stream_if;  
            
    -- BFM misc.
    constant scope        : in string              := C_SCOPE;
    constant msg_id_panel : in t_msg_id_panel      := shared_msg_id_panel;
    constant config       : in t_stream_bfm_config := C_STREAM_BFM_CONFIG_DEFAULT);
  
  
  -- It is recommended to also have an init function which sets the BFM signals to their default state


end package stream_bfm_pkg;


--========================================================================================================================
--========================================================================================================================

package body stream_bfm_pkg is

  --<USER_INPUT> Insert BFM procedure implementation here.
  
  --------------------------------------------------------------------------
  -- Initialization function, sets DUT interface to default values
  --------------------------------------------------------------------------
  function init_stream_if_signals (vvc_is_source  : boolean;
                                   vvc_data_width : natural;
                                   vvc_is_monitor : boolean) return t_stream_if is
    variable init_if : t_stream_if(tdata(vvc_data_width-1 downto 0));    
  begin
    if vvc_is_source then
      init_if.tdata  := (others => '-');
      init_if.tlast  := '-';
      init_if.tvalid := '0';
      init_if.tready := 'Z';
    else
      init_if.tdata  := (others => 'Z');
      init_if.tlast  := 'Z';
      init_if.tvalid := 'Z';
      if vvc_is_monitor then
        init_if.tready := 'Z';
      else
        init_if.tready := '0';
      end if;
    end if;
    return init_if;
  end function;  

  --------------------------------------------------------------------------
  -- BFM procedure wiggle, drives the DUT interface
  --------------------------------------------------------------------------
  procedure wiggle (   
    -- BFM generic parameters from VVC  
    constant GC_VVC_IS_SOURCE               : in boolean;
    constant GC_VVC_CHECK_TLAST             : in boolean;
    constant GC_VVC_TDATA_WIDTH             : in positive;
    constant GC_VVC_IS_MONITOR              : in boolean;
    constant GC_VVC_VIOLATE_SRC_TVALID_RULE : in boolean;
    constant GC_VVC_CHECK_SRC_TVALID_SIGNAL : in boolean;
    constant GC_VVC_DONT_CHECK_JUST_REPORT  : in boolean;

    -- BFM dynamic execution parameters
    constant c_tdata            : in std_logic_vector; 
    constant c_tdata_width      : in natural;
    constant c_tlast            : in std_logic;
    constant c_dont_check       : in boolean;
    constant c_called_as_source : in boolean;
    constant c_msg              : in string;
    
    -- BFM ports connecting to VVC ports
    signal clk            : in    std_logic; 
    signal stream_if      : inout t_stream_if;  
            
    -- BFM misc.  
    constant scope        : in string              := C_SCOPE;
    constant msg_id_panel : in t_msg_id_panel      := shared_msg_id_panel;
    constant config       : in t_stream_bfm_config := C_STREAM_BFM_CONFIG_DEFAULT) is
    
    variable v_normalized_data : std_logic_vector (stream_if.tdata'length-1 downto 0);
    variable v_check_ok : boolean;
    
  begin
    -- log(config.id_for_bfm, "=== I WAS HERE! : " & c_msg, scope, msg_id_panel);
    
    --------------------------------------------------------------------------
    -- Check that clock_period has been set
    --------------------------------------------------------------------------
    if config.clock_period = 0 ns then
      alert (ERROR, "You forgot to set the clk_config parameter in the BFM configuration record", scope);
    end if;    
  
    --------------------------------------------------------------------------
    -- Check that cdm call mode matches VVC mode
    --------------------------------------------------------------------------
    if c_called_as_source /= GC_VVC_IS_SOURCE then
      alert (ERROR, "CDM call does not match VVC mode with generic parameter GC_VVC_IS_SOURCE => " & to_string(GC_VVC_IS_SOURCE), scope);
    end if;

    --------------------------------------------------------------------------
    -- Check that width of provided parameter matches generic data width
    --------------------------------------------------------------------------
    if GC_VVC_DONT_CHECK_JUST_REPORT = false and c_dont_check = false then
      if c_tdata_width /= GC_VVC_TDATA_WIDTH then    
        alert (ERROR, "CDM parameter tdata " 
                    & to_string(c_tdata(c_tdata_width-1 downto 0), HEX, AS_IS, INCL_RADIX)
                    & " with width "
                    & to_string(c_tdata_width) 
                    & " does not match generic GC_VVC_DATA_WIDTH => "
                    & to_string(GC_VVC_TDATA_WIDTH), scope);
      end if;                    
    end if;
    
    --------------------------------------------------------------------------
    -- All sanity checks are OK. Normalize data.
    --------------------------------------------------------------------------  
    v_normalized_data := normalize_and_check (c_tdata, stream_if.tdata, ALLOW_WIDER, "data_value", "stream_write data", c_msg);
    
    --------------------------------------------------------------------------
    -- Wait 1/10 (10%) into the clock cycle
    --------------------------------------------------------------------------  
    wait_until_given_time_after_rising_edge(clk, (config.clock_period*1)/10); 
       
    if GC_VVC_IS_SOURCE then
      --------------------------------------------------------------------------
      -- Write
      -------------------------------------------------------------------------     
      stream_if.tdata  <= v_normalized_data;
      stream_if.tlast  <= c_tlast;
      stream_if.tvalid <= '1';
    elsif not GC_VVC_IS_MONITOR then
      --------------------------------------------------------------------------
      -- Check or Read
      --------------------------------------------------------------------------     
      stream_if.tready <= '1';
    end if;
    
    --------------------------------------------------------------------------
    -- wait 9/10 (90%) into the clock cycle, and check valid/ready
    --------------------------------------------------------------------------  
    wait_until_given_time_after_rising_edge(clk, (config.clock_period*9)/10);    
    
    if GC_VVC_IS_SOURCE then
      --------------------------------------------------------------------------
      -- Write
      -------------------------------------------------------------------------     
      while stream_if.tready /= '1' loop -- using "/= '1'" instead of "= '0'" on purpose
        wait for config.clock_period;	  
      end loop;   
      log(config.id_for_bfm, "==> stream_write  (" & to_string(v_normalized_data, HEX, AS_IS, INCL_RADIX) & ") completed. " & add_msg_delimiter(c_msg), scope, msg_id_panel);
    else
      --------------------------------------------------------------------------
      -- Check or Read
      --------------------------------------------------------------------------     
      while stream_if.tvalid /= '1' or stream_if.tready /= '1' loop -- using "/= '1'" instead of "= '0'" on purpose   
        wait for config.clock_period;
      end loop;     
      
      if GC_VVC_DONT_CHECK_JUST_REPORT = true or c_dont_check = true then
        --------------------------------------------------------------------------
        -- Just read (don't Check)
        --------------------------------------------------------------------------     
        log(config.id_for_bfm, "<== stream_read   (" & to_string(stream_if.tdata, HEX, AS_IS, INCL_RADIX) & ") completed. " & add_msg_delimiter(c_msg), scope, msg_id_panel);
      else 
        --------------------------------------------------------------------------
        -- Check
        --------------------------------------------------------------------------     
        v_check_ok := check_value(stream_if.tdata, v_normalized_data, ERROR, c_msg, scope, HEX_BIN_IF_INVALID, AS_IS, ID_NEVER, msg_id_panel);

        if v_check_ok then
          log(config.id_for_bfm, "<== stream_expect (" & to_string(stream_if.tdata, HEX, AS_IS, INCL_RADIX) & ") completed. " & add_msg_delimiter(c_msg), scope, msg_id_panel);
        end if;   

        if GC_VVC_CHECK_TLAST and (stream_if.tlast /= c_tlast) then      
          alert (ERROR, "Failed => received last '" & to_string(stream_if.tlast) & "' does not match expected last '" & to_string(c_tlast) 
            & "' for beat " & to_string(stream_if.tdata, HEX, AS_IS, INCL_RADIX), scope);
        end if;
      end if;
    end if;
    
    --------------------------------------------------------------------------
    -- Wait for rising edge, and de-assert valid/ready
    --------------------------------------------------------------------------      
    wait until rising_edge(clk);
    if GC_VVC_IS_SOURCE then
      stream_if.tvalid <= '0';
    elsif GC_VVC_IS_MONITOR /= false then
      stream_if.tready <= '0';
    end if;   

  end procedure; -- wiggle

end package body stream_bfm_pkg;

