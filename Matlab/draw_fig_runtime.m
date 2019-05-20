
%% Prepare figure
fig_design = figure(2);
clf
set(fig_design, 'NumberTitle', 'off', 'Name', horzcat('Neurorobot Runtime (restarts = ', num2str(restarts), ')'))
set(fig_design, 'menubar', 'none', 'toolbar', 'none')
set(fig_design, 'position', fig_pos, 'color', fig_bg_col) 
fig_design.UserData = 10; % This indicates runtime mode

% Prepare axes
if brain_view_tiled
    draw_network_view_ax
else
    draw_whole_brain_ax
end

left_eye_ax = axes('position', [0.02 0.58 0.23 0.36], 'xtick', [], 'ytick', [], 'linewidth', 2); box on
right_eye_ax = axes('position', [0.75 0.58 0.23 0.36], 'xtick', [], 'ytick', [], 'linewidth', 2); box on
activity_ax = axes('position', [0.04 0.09 0.94 0.14], 'linewidth', 2);

% Manual controls
if bg_brain
    button_1_pos = [0.02 0.27 0.23 0.05];
    button_1 = uicontrol('Style', 'pushbutton', 'String', 'Network view', 'units', 'normalized', 'position', button_1_pos);
    set(button_1, 'Callback', 'brain_view_tiled = 1; stop(runtime_pulse); voluntary_restart = 1;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])
    button_2_pos = [0.02 0.34 0.23 0.05];
    button_2 = uicontrol('Style', 'pushbutton', 'String', 'Whole rbain view', 'units', 'normalized', 'position', button_2_pos);
    set(button_2, 'Callback', 'brain_view_tiled = 0; stop(runtime_pulse); voluntary_restart = 1;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])       
    
    drive_bar_pos = [0.75 0.3 0.23 0.2];
    drive_bar_ax = axes('position', drive_bar_pos);
    if ~isempty(network_drive)
        drive_bar = bar(network_drive(2:end,1));
    else
        drive_bar = bar(0);
    end
    drive_bar_ax.Color = fig_bg_col;
    set(drive_bar_ax, 'FontSize', bfsize - 6, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    xlabel('Drive', 'FontSize', bfsize, 'fontname', gui_font_name);
    ylim([0 255])
    set(drive_bar_ax, 'xtick', 1:nnetworks-1, 'xticklabels', 1:nnetworks-1, 'ytick', [], 'Box', 'off', 'ycolor', fig_bg_col)
elseif manual_controls
    left_pos = [0.75 0.37 0.07 0.05];
    right_pos = [0.91 0.37 0.07 0.05];
    forward_pos =[0.81 0.44 0.11 0.05];
    backward_pos = [0.81 0.3 0.11 0.05];
    hold_pos = [0.83 0.37 0.07 0.05];
    button_left = uicontrol('Style', 'pushbutton', 'String', 'Left', 'units', 'normalized', 'position', left_pos);
    set(button_left, 'Callback', 'manual_control = 1;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])
    button_right = uicontrol('Style', 'pushbutton', 'String', 'Right', 'units', 'normalized', 'position', right_pos);
    set(button_right, 'Callback', 'manual_control = 2;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])
    button_forward = uicontrol('Style', 'pushbutton', 'String', 'Forward', 'units', 'normalized', 'position', forward_pos);
    set(button_forward, 'Callback', 'manual_control = 3;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])
    button_backward = uicontrol('Style', 'pushbutton', 'String', 'Backward', 'units', 'normalized', 'position', backward_pos);
    set(button_backward, 'Callback', 'manual_control = 4;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])
    button_hold = uicontrol('Style', 'pushbutton', 'String', 'Hold', 'units', 'normalized', 'position', hold_pos);
    set(button_hold, 'Callback', 'manual_control = 5;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.9 0.9 0.9])
    manual_control_title = uicontrol('style', 'text', 'string', 'Manual control', 'units', 'normalized', 'position', [0.75 0.5 0.23 0.05], 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'horizontalalignment', 'center', 'backgroundcolor', fig_bg_col);
elseif brain_facts
    brain_fact_ax = axes('position', [0.75 0.25 0.23 0.31]);
    image(imread('brain_fact_1.png'))
    set(brain_fact_ax, 'xtick', [], 'ytick', [], 'xcolor', 'k', 'ycolor', 'k', 'linewidth', 4)
end

% Activity axes
axes(activity_ax)
hold on
if nneurons
    [y, x] = find(spikes_loop);
    if isempty(x)
        x = ms_per_step * nsteps_per_loop + 1; % edited for appearence
        y = 1;
    end
    vplot = plot(x, y, 'linestyle', 'none', 'marker', '.', 'markersize', 15, 'color', 'k');
    this_val = nneurons;
else
    vplot = plot(1, ms_per_step * nsteps_per_loop, 'linestyle', 'none', 'marker', '.', 'markersize', 15, 'color', 'k');
    this_val = 1;
end
vplot_front = plot([0 0], [0 this_val + 1], 'color', 'r', 'linewidth', 2);
xlim([0 ms_per_step * nsteps_per_loop + 0])
ylim([0 this_val + 1])
set(gca, 'xtick', [], 'ytick', 1:round(nneurons/5):nneurons, 'yticklabels', 1:round(nneurons/5):nneurons, 'fontsize', bfsize - 6, 'ydir', 'reverse', 'xcolor', 'k', 'ycolor', 'k', 'fontname', gui_font_name, 'fontweight', gui_font_weight)
ylabel('Neuron', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
box on

% Initialize camera streams
axes(left_eye_ax)
show_left_eye = image(zeros(left_yx(1), left_yx(2), 3, 'uint8'));
title('Left eye', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
set(left_eye_ax, 'xtick', [], 'ytick', [])

axes(right_eye_ax)
show_right_eye = image(zeros(right_yx(1), right_yx(2), 3, 'uint8'));
title('Right eye', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
set(right_eye_ax, 'xtick', [], 'ytick', [])

% Create runtime buttons
button_design = uicontrol('Style', 'pushbutton', 'String', 'Design', 'units', 'normalized', 'position', [0.02 0.02 0.176 0.05]);
set(button_design,'Callback', 'run_button = 1;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.8 0.8 0.8])

button_save = uicontrol('Style', 'pushbutton', 'String', 'Save', 'units', 'normalized', 'position', [0.216 0.02 0.176 0.05]);
set(button_save,'Callback', 'run_button = 2;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.8 0.8 0.8])

button_pause = uicontrol('Style', 'pushbutton', 'String', 'Restart', 'units', 'normalized', 'position', [0.412 0.02 0.176 0.05]);
set(button_pause,'Callback', 'if run_button ~= 3 run_button = 3; else exit_pause; end', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.8 0.8 0.8])

button_stop = uicontrol('Style', 'pushbutton', 'String', 'Stop', 'units', 'normalized', 'position', [0.608 0.02 0.176 0.05]);
set(button_stop,'Callback', 'run_button = 4;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.8 0.8 0.8])

button_reward = uicontrol('Style', 'pushbutton', 'String', 'Dopamine', 'units', 'normalized', 'position', [0.804 0.02 0.176 0.05]);
set(button_reward,'Callback', 'run_button = 5;', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight, 'BackgroundColor', [0.8 0.8 0.8])


if second_screen_analysis

    % Vis pref vals
    axes(analysis_1_ax) 
    draw_analysis_1 = bar(rand(n_vis_prefs, 2), 'facecolor', [0.2 0.4 0.8]);
    set(gca, 'ylim', [-150 150])
    title('Sensor inputs', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    xlabel('Sensor', 'FontSize', bfsize - 2, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    ylabel('Input', 'FontSize', bfsize - 2, 'fontname', gui_font_name, 'fontweight', gui_font_weight)        

    % Total input
    axes(analysis_2_ax)
    draw_analysis_2 = bar(rand(1, nneurons), 'facecolor', [0.2 0.4 0.8]);
    set(gca, 'ylim', [-300 300])
    title('Total input (sensors + synapses) to neurons', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    xlabel('Neuron', 'FontSize', bfsize - 2, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    ylabel('Input', 'FontSize', bfsize - 2, 'fontname', gui_font_name, 'fontweight', gui_font_weight) 

    % Motor out and time
    axes(analysis_3_ax)
    draw_analysis_3 = bar([0 0], 'facecolor', [0.2 0.4 0.8]);
    set(gca, 'ylim', [-400 400])
    title('Motor outputs', 'FontSize', bfsize, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    set(gca, 'xticklabel', {'Left motor', 'Right motor', 'Time / step'}, 'FontSize', bfsize - 2, 'fontname', gui_font_name, 'fontweight', gui_font_weight)
    ylabel('Output', 'FontSize', bfsize - 2, 'fontname', gui_font_name, 'fontweight', gui_font_weight)    
   
elseif ext_cam_id
    
    % Video ax
    axes(ext_ax)
    cla
    axis([1 720 1 720])
    set(gca, 'ydir', 'reverse')
    ext_im = image(zeros(720, 720, 3, 'uint8'));
    
end