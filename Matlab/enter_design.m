if run_button == 1     
    design
    stop(runtime_pulse)
    clear data
    xstep = 0;
    
    % Log command
    this_time = string(datetime('now', 'Format', 'yyyy-MM-dd-hh-mm-ss-ms'));
    command_log.entry(command_log.n).time = this_time;            
    command_log.entry(command_log.n).action = 'enter design';
    command_log.n = command_log.n + 1;

end