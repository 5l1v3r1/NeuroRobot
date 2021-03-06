
%% Start of pulse code
nstep = nstep + 1;
xstep = xstep + 1;
if rak_only && ~rem(nstep, 7)
    if pulse_led_flag_1
        pulse_led_flag_1 = 0;
        rak_cam.writeSerial('d:610;d:521')
    else
        pulse_led_flag_1 = 1;
        rak_cam.writeSerial('d:611;d:520')
    end
end
if rak_only && ~rem(nstep, 11)
    if pulse_led_flag_2
        pulse_led_flag_2 = 0;
        rak_cam.writeSerial('d:621;d:530;')
    else
        pulse_led_flag_2 = 1;
        rak_cam.writeSerial('d:620;d:531')
    end
end
if rak_only && ~rem(nstep, 17)
    if pulse_led_flag_3
        pulse_led_flag_3 = 0;
        rak_cam.writeSerial('d:631;d:520;')
    else
        pulse_led_flag_3 = 1;
        rak_cam.writeSerial('d:630;d:521')
    end
end
step_timer = tic;
lifetime = toc(life_timer);
if lifetime == 5 * 60
    disp(horzcat('Lifetime = ', num2str(round(lifetime)), ' s'))
elseif lifetime == 5 * 60 && lifetime < 5 * 60 * 60
    disp(horzcat('Lifetime = ', num2str(round(lifetime/60)), ' min'))
elseif lifetime >= 5 * 60 * 60
    disp(horzcat('Lifetime = ', num2str(round(lifetime/60/60)), ' hrs'))
end

%% Update brain
update_brain
draw_step

%% Update motors
% disp('3')
update_motors
left_eye_frame = large_frame(left_cut(1):left_cut(2), left_cut(3):left_cut(4), :);
right_eye_frame = large_frame(right_cut(1):right_cut(2), right_cut(3):right_cut(4), :);    
show_left_eye.CData = left_eye_frame;
show_right_eye.CData = right_eye_frame;

%% Get visual input
get_visual_input

%% Process visual input
% disp('4')
process_visual_input

%% Process audio input
% disp('5')
process_audio_input

%% Serial
% disp('6')
if rak_only
    rak_get_serial
elseif bluetooth_present
    bluetooth_get_distance
end

%% Interface
% disp('7')
if run_button == 2
    save_brain
end
enter_pause % if run_button == 3
enter_reward % if run_button == 5
update_ext_cam
if nstep == nsteps_per_loop
    nstep = 0;
    step_duration_in_ms = round(nanmedian(step_times * 1000));
    disp(horzcat('Step time = ', num2str(step_duration_in_ms), ' ms (pulse period = ', num2str(pulse_period * 1000), ' ms), xstep = ', num2str(xstep)))
end
if ~use_webcam && rak_only && ~rak_cam.isRunning() % This screws with DIY no?
    disp('error: rak_cam exists but is not running')
    sound(flipud(gong), 8192 * 7)
    disp('solution 1: make sure you are connected to the correct wifi network')
    disp('solution 2: try the connect button again')
    disp('solution 3: restart matlab (be persistent)')
    disp('solution 4: restart matlab and the robot')    
    disp('rak_cam no longer running. rak_fail = 1.')
    rak_fail = 1;
    % Try camera restart here? seems to cause crash
end
if run_button == 4 || rak_fail
    stop(runtime_pulse)
end

%% Record data
% disp('8')
if save_data_and_commands
    if nneurons
        rec_timer = tic;
        data.firing(:,xstep) = firing;
        data.connectome(:,:,xstep) = connectome;
        data.rec_time(xstep) = toc(rec_timer);
        data.timestamp(xstep) = string(datetime('now', 'Format', 'yyyy-MM-dd-hh-mm-ss-ms'));
    end
end


% End of pulse code
enter_design % if run_button = 1
drawnow

try % This avoids error due to stop code deleting step_timer before it's called here
    step_times(nstep + 1) = toc(step_timer);
catch
end
if run_button == 6
    
    %% Make annotation
    make_annotation
    
    %% Return
    run_button = 0;
    
end
