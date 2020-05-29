--========================================================================================================================
-- This VVC was generated with Bitvis VVC Generator
--========================================================================================================================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library uvvm_vvc_framework;
use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;

use work.stream_bfm_pkg.all;
use work.vvc_cmd_pkg.all;
use work.td_target_support_pkg.all;

--========================================================================================================================
--========================================================================================================================
package vvc_methods_pkg is

  --========================================================================================================================
  -- Types and constants for the STREAM VVC 
  --========================================================================================================================
  constant C_VVC_NAME     : string := "STREAM_VVC";

  signal STREAM_VVCT       : t_vvc_target_record := set_vvc_target_defaults(C_VVC_NAME);
  alias  THIS_VVCT         : t_vvc_target_record is STREAM_VVCT;
  alias  t_bfm_config is t_stream_bfm_config;

  -- Type found in UVVM-Util types_pkg
  constant C_STREAM_INTER_BFM_DELAY_DEFAULT : t_inter_bfm_delay := (
    delay_type                          => NO_DELAY,
    delay_in_time                       => 0 ns,
    inter_bfm_delay_violation_severity  => WARNING
  );

  type t_vvc_config is
  record
    inter_bfm_delay                       : t_inter_bfm_delay;-- Minimum delay between BFM accesses from the VVC. If parameter delay_type is set to NO_DELAY, BFM accesses will be back to back, i.e. no delay.
    cmd_queue_count_max                   : natural;          -- Maximum pending number in command queue before queue is full. Adding additional commands will result in an ERROR.
    cmd_queue_count_threshold             : natural;          -- An alert with severity 'cmd_queue_count_threshold_severity' will be issued if command queue exceeds this count. Used for early warning if command queue is almost full. Will be ignored if set to 0.
    cmd_queue_count_threshold_severity    : t_alert_level;    -- Severity of alert to be initiated if exceeding cmd_queue_count_threshold
    result_queue_count_max                : natural;
    result_queue_count_threshold_severity : t_alert_level;
    result_queue_count_threshold          : natural;
    bfm_config                            : t_stream_bfm_config; -- Configuration for the BFM. See BFM quick reference
    msg_id_panel                          : t_msg_id_panel;   -- VVC dedicated message ID panel
  end record;

  type t_vvc_config_array is array (natural range <>) of t_vvc_config;

  constant C_STREAM_VVC_CONFIG_DEFAULT : t_vvc_config := (
    inter_bfm_delay                       => C_STREAM_INTER_BFM_DELAY_DEFAULT,
    cmd_queue_count_max                   => C_CMD_QUEUE_COUNT_MAX, --  from adaptation package
    cmd_queue_count_threshold             => C_CMD_QUEUE_COUNT_THRESHOLD,
    cmd_queue_count_threshold_severity    => C_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY,
    result_queue_count_max                => C_RESULT_QUEUE_COUNT_MAX,
    result_queue_count_threshold_severity => C_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY,
    result_queue_count_threshold          => C_RESULT_QUEUE_COUNT_THRESHOLD,
    bfm_config                            => C_STREAM_BFM_CONFIG_DEFAULT,
    msg_id_panel                          => C_VVC_MSG_ID_PANEL_DEFAULT
  );

  type t_vvc_status is
  record
    current_cmd_idx       : natural;
    previous_cmd_idx      : natural;
    pending_cmd_cnt       : natural;
  end record;

  type t_vvc_status_array is array (natural range <>) of t_vvc_status;

  constant C_VVC_STATUS_DEFAULT : t_vvc_status := (
    current_cmd_idx      => 0,
    previous_cmd_idx     => 0,
    pending_cmd_cnt      => 0
  );

  -- Transaction information to include in the wave view during simulation
  type t_transaction_info is
  record
    operation       : t_operation;
    msg             : string(1 to C_VVC_CMD_STRING_MAX_LENGTH);
    --<USER_INPUT> Fields that could be useful to track in the waveview can be placed in this record.
    -- Example:
    -- addr            : unsigned(C_VVC_CMD_ADDR_MAX_LENGTH-1 downto 0);
    -- data            : std_logic_vector(C_VVC_CMD_DATA_MAX_LENGTH-1 downto 0);
  end record;

  type t_transaction_info_array is array (natural range <>) of t_transaction_info;

  constant C_TRANSACTION_INFO_DEFAULT : t_transaction_info := (
    --<USER_INPUT> Set the data fields added to the t_transaction_info record to 
    -- their default values here.
    -- Example:
    -- addr                => (others => '0'),
    -- data                => (others => '0'),
    operation           =>  NO_OPERATION,
    msg                 => (others => ' ')
  );


  shared variable shared_stream_vvc_config : t_vvc_config_array(0 to C_MAX_VVC_INSTANCE_NUM-1) := (others => C_STREAM_VVC_CONFIG_DEFAULT);
  shared variable shared_stream_vvc_status : t_vvc_status_array(0 to C_MAX_VVC_INSTANCE_NUM-1) := (others => C_VVC_STATUS_DEFAULT);
  shared variable shared_stream_transaction_info : t_transaction_info_array(0 to C_MAX_VVC_INSTANCE_NUM-1) := (others => C_TRANSACTION_INFO_DEFAULT);


  --========================================================================================================================
  -- Methods dedicated to this VVC 
  -- - These procedures are called from the testbench in order to queue BFM calls 
  --   in the VVC command queue. The VVC will store and forward these calls to the
  --   STREAM BFM when the command is at the from of the VVC command queue.
  --========================================================================================================================


  --<USER_INPUT> Please insert the VVC procedure declarations here 
  procedure stream (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string;
    constant called_as_source : in boolean;
    constant dont_check       : in boolean);  
    
  procedure stream_write (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
  
  procedure stream_write (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
    
  procedure stream_expect (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
 
  procedure stream_expect (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
 
  procedure stream_read (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
 
  procedure stream_read (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
 
  procedure stream_read (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    --constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  );
   
  --Example with single VVC channel: 
  -- procedure stream_write(
  --   signal   VVCT               : inout t_vvc_target_record;
  --   constant vvc_instance_idx   : in integer;
  --   constant addr               : in unsigned;
  --   constant data               : in std_logic_vector;
  --   constant msg                : in string
  -- );

  --Example with multiple VVC channels: 
  -- procedure stream_write(
  --   signal   VVCT               : inout t_vvc_target_record;
  --   constant vvc_instance_idx   : in integer;
  --   constant channel            : in t_channel;
  --   constant addr               : in unsigned;
  --   constant data               : in std_logic_vector;
  --   constant msg                : in string
  -- );


end package vvc_methods_pkg;


package body vvc_methods_pkg is


  --========================================================================================================================
  -- Methods dedicated to this VVC
  --========================================================================================================================

  --<USER_INPUT> Please insert the VVC procedure implementations here.
  procedure stream (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string;
    constant called_as_source : in boolean;
    constant dont_check       : in boolean
  ) is
    constant proc_name : string := get_procedure_name_from_instance_name(vvc_instance_idx'instance_name);
    constant proc_call : string := proc_name & "(" & to_string(VVCT, vvc_instance_idx)  -- First part common for all
        & ", " & to_string(tdata, HEX, AS_IS, INCL_RADIX) & ")";
    variable v_normalised_data  : std_logic_vector(shared_vvc_cmd.tdata'length-1 downto 0)
      := normalize_and_check(tdata, shared_vvc_cmd.tdata, ALLOW_NARROWER, "tdata", "shared_vvc_cmd.tdata",
      proc_call & " called with to wide tdata. " & add_msg_delimiter(msg));
  begin 
    set_general_target_and_command_fields(VVCT, vvc_instance_idx, proc_call, msg, QUEUED, CMD_STREAM);
    shared_vvc_cmd.tdata            := v_normalised_data;
    shared_vvc_cmd.called_as_source := called_as_source;
    shared_vvc_cmd.tdata_width      := tdata'length;
    shared_vvc_cmd.tlast            := tlast;
    shared_vvc_cmd.dont_check       := dont_check;
    send_command_to_vvc(VVCT);
  end procedure;  

  procedure stream_write (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, tdata, tlast, msg, true, false);
  end procedure;
  
  procedure stream_write (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, tdata, '1', msg, true, false);
  end procedure;
  
  procedure stream_expect (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, tdata, tlast, msg, false, false);
  end procedure;
 
  procedure stream_expect (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, tdata, '1', msg, false, false);
  end procedure;
 
  procedure stream_read (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, "0", '1', msg, false, true);
  end procedure;
 
  procedure stream_read (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, "0", '1', msg, false, true);
  end procedure;
 
  procedure stream_read (
    signal   VVCT             : inout t_vvc_target_record;
    constant vvc_instance_idx : in integer;
    --constant tdata            : in std_logic_vector;
    --constant tlast            : in std_logic;
    constant msg              : in string
    --constant called_as_source : in boolean;
    --constant dont_check       : in boolean
  ) is
  begin
    stream (VVCT, vvc_instance_idx, "0", '1', msg, false, true);
  end procedure;

  
  -- These procedures will be used to forward commands to the VVC executor, which will
  -- call the corresponding BFM procedures. 
  -- Example using single channel:
  -- procedure stream_write( 
  --   signal   VVCT               : inout t_vvc_target_record;
  --   constant vvc_instance_idx   : in integer;
  --   constant addr               : in unsigned;
  --   constant data               : in std_logic_vector;
  --   constant msg                : in string
  -- ) is
  --   constant proc_name : string := "stream_write";
  --   constant proc_call : string := proc_name & "(" & to_string(VVCT, vvc_instance_idx)  -- First part common for all
  --            & ", " & to_string(addr, HEX, AS_IS, INCL_RADIX) & ", " & to_string(data, HEX, AS_IS, INCL_RADIX) & ")";
  --   constant v_normalised_addr    : unsigned(C_VVC_CMD_ADDR_MAX_LENGTH-1 downto 0) := 
  --            normalize_and_check(addr, shared_vvc_cmd.addr, ALLOW_WIDER_NARROWER, "addr", "shared_vvc_cmd.addr", proc_call & " called with to wide addr. " & msg);
  --   constant v_normalised_data    : std_logic_vector(C_VVC_CMD_DATA_MAX_LENGTH-1 downto 0) := 
  --            normalize_and_check(data, shared_vvc_cmd.data, ALLOW_WIDER_NARROWER, "data", "shared_vvc_cmd.data", proc_call & " called with to wide data. " & msg);
  -- begin
  -- -- Create command by setting common global 'VVCT' signal record and dedicated VVC 'shared_vvc_cmd' record
  -- -- locking semaphore in set_general_target_and_command_fields to gain exclusive right to VVCT and shared_vvc_cmd
  -- -- semaphore gets unlocked in await_cmd_from_sequencer of the targeted VVC
  --   set_general_target_and_command_fields(VVCT, vvc_instance_idx, proc_call, msg, QUEUED, WRITE);
  --   shared_vvc_cmd.addr                               := v_normalised_addr;
  --   shared_vvc_cmd.data                               := v_normalised_data;
  --   send_command_to_vvc(VVCT);
  -- end procedure;

  -- Example using multiple channels:
  -- procedure stream_receive(
  --   signal   VVCT               : inout t_vvc_target_record;
  --   constant vvc_instance_idx   : in integer;
  --   constant channel            : in t_channel;
  --   constant msg                : in string;
  --   constant alert_level        : in t_alert_level := ERROR
  -- ) is
  --   constant proc_name : string := "stream_receive";
  --   constant proc_call : string := proc_name & "(" & to_string(VVCT, vvc_instance_idx, channel) & ")";
  -- begin
  -- -- Create command by setting common global 'VVCT' signal record and dedicated VVC 'shared_vvc_cmd' record
  -- -- locking semaphore in set_general_target_and_command_fields to gain exclusive right to VVCT and shared_vvc_cmd
  -- -- semaphore gets unlocked in await_cmd_from_sequencer of the targeted VVC
  --   set_general_target_and_command_fields(VVCT, vvc_instance_idx, channel, proc_call, msg, QUEUED, RECEIVE);
  --   shared_vvc_cmd.operation     := RECEIVE;
  --   shared_vvc_cmd.alert_level   := alert_level;
  --   send_command_to_vvc(VVCT);
  -- end procedure;

end package body vvc_methods_pkg;
