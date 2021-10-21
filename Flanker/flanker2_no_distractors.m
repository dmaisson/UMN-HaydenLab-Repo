% Flanker Task
% 
% Fixation comes on.
% Subject fixates the fixation (or centers the joystick on it. 
% Then a variable delay occurs (0-1 second, uniform distribution).
% Then the fixation disappears and simultaneously, a cue appears.
% The cue indicates one of two directions (left or right).
% A saccade to that direction results in a reward, there's no time limit.
% A saccade to the other target results in no reward.
% Either way there's a timeout (inter-trial interval) of 1-3 seconds (uniform distribution).
% 
% THE CUE:
% 
% there are two symbols that indicate a leftward movement (circle and star)
% there are two symbols that indicate a rightward movement (square and triangle)
% the valid cue is in the center.
%

% DETAILS: 
% all four cues are equally likely.
% on one third of trials, the cue appears alone
% one one third of trials, there are two flankers
% on one third of trials, there are four flankers
% 
% the flankers are chosen randomly and all match each other, but not necessarily the cue
% 
% as a result...
% on 1/4 of trials, the flankers match the cue
% on 1/4 trials, the flankers have the same meaning as the cue, but look different
% on 1/2 trials the flankers indicate the opposite direction as the cue

%% Flanker Task
% define the parameters of the trial
rule = randi(2); % 1 = Left; 2 = Right

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
ITI_stim = 2;
fail_image = 11; %makes a big 'X' if the wrong direction is chosen
if rule == 1 %if Left
    
%     shape = randi(2); % randomly pick from among the "Left Shapes"
%     if shape == 1
%         target = 7;
%     elseif shape == 2
%         target = 8;
%     end
%     
    
%%%% for only one central cue, choose between 7 or 8 for the cue to go left
target = 8;
%%%%

elseif rule == 2 %if Right
      
%     shape = randi(2); % randomly pick from among the "Right Shapes"
%     if shape == 1
%         target = 9;
%     elseif shape == 2
%         target = 10;
%     end


%%%% for only one central cue, choose between 9 or 10 for the cue to go
%%%% right
target = 10;
%%%%


end


% TASK:
delay_pre = 10; %delay between fixation and task
delay_post = randi([1000 3000]); %delay after trial
delay_fail = 4000; %delay if wrong choice

% scene 1: fixation
showcursor('on');
fix1 = SingleTarget(joy_);
fix1.Target = fixation_point;
fix1.Threshold = 1;
fth1 = FreeThenHold(fix1);
fth1.MaxTime = 10000;
fth1.HoldTime = 300;
scene1 = create_scene(fth1, 1);
run_scene(scene1);

% delay_pre epoch
idle(delay_pre);

% scene 2: choice presentation and response
fix2 = MultiTarget(joy_);
if rule == 1
    fix2.Target = [-1000 0;1000 0];
elseif rule == 2
    fix2.Target = [1000 0;-1000 0];
end
fix2.Threshold = 995; %this can be adjusted to move the boundary further/closer to the sample object
fix2.WaitTime = 9999999999999;
fix2.HoldTime = 10;  %keep this number low to prevent errors
scene2 = create_scene(fix2, target);
showcursor('on');
run_scene(scene2);

%creating a scene to play when joystick in the wrong direction
% fix3 = SingleTarget(joy_);
% fix3.Target = fail_image;
% fix3.Threshold = 500;
% fth3 = FreeThenHold(fix3);
% fth3.MaxTime = 10000;
% fth3.HoldTime = 7000;
% scene3 = create_scene(fix3, fail_image);

%%%%%%%%%%%%%
% creating a scene to play when joystick in the wrong direction
    fix3 = SingleTarget(joy_);
    fix3.Target = fail_image;
    fix3.Threshold = 150;
    wth = WaitThenHold(fix3);
    wth.WaitTime = 1000;
    wth.HoldTime = 2500;
    scene3 = create_scene(wth, fail_image);

if fix2.ChosenTarget == 1
    trialerror(0);
    goodmonkey(300, 'NumReward', 1); % 50ms of juice x 3
    return
elseif fix2.ChosenTarget == 2;
    showcursor('off');
    run_scene(scene3);
        if wth.Success
            trialerror(6);
%             goodmonkey(50, 'NumReward', 1);
        end

    return
end

idle(delay_post);