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
flankers = randi(3); % 1 = no flankers; 2 = 2 flankers; 3 = 4 flankers

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
ITI_stim = 2;
if rule == 1 %if Left
    shape = randi(2); % randomly pick from among the "Left Shapes"
    if shape == 1
        target = 3;
    elseif shape == 2
        target = 4;
    end
elseif rule == 2 %if Right
    shape = randi(2); % randomly pick from among the "Right Shapes"
    if shape == 1
        target = 5;
    elseif shape == 2
        target = 6;
    end
end
if flankers == 2
    distractor1 = randi([3 6]);
    distractor2 = distractor1;
elseif flankers == 3
    distractor1 = randi([3 6]);
    distractor2 = distractor1;
    distractor3 = distractor1;
    distractor4 = distractor1;
end
if flankers == 2
    reposition_object([distractor1 distractor2],[-5 0; 5 0]);
elseif flankers == 3
    reposition_object([distractor1 distractor2 distractor3 distractor4],[-5 0; 5 0; -10 0; 10 0]);
end

% define time intervals (in ms):
% wait_for_fix = 10000; %time limit for monkey to fixate within the target area
delay_pre = randi(1000); %random amount of time after fixation but before objects appear
max_reaction_time = 9999999; %total trial time (no limit)
delay_post = randi([1000 3000]); %time delay in between trials
% fixation window (in degrees):
fix_radius = 1;  %size of fixation area

% TASK:
% showcursor('on');

% initial fixation:
% toggleobject(fixation_point);
% [ontarget, rt] = eyejoytrack('acquiretarget', fixation_point, fix_radius, wait_for_fix);

fix1 = SingleTarget(joy_);
fix1.Target = fixation_point;
fix1.Threshold = fix_radius;
fth1 = FreeThenHold(fix1);
fth1.MaxTime = 10000;
fth1.HoldTime = 1000;
scene1 = create_scene(fth1);
run_scene(scene1);
% if fth1.Success
%     dashboard(1, 'Success');
% elseif 0 == fth.BreakCount
%     dashboard(1, 'No fixation');
% else
%     dashboard(1, 'Fixation break');
% end



% if ~ontarget
%      trialerror(4); % no fixation
%      toggleobject(fixation_point)
%      return
% end


% delay_pre epoch
% ontarget = eyejoytrack('holdtarget', ITI_stim, fix_radius, delay_pre);
idle(delay_pre/1000);

% choice presentation and response
if flankers == 1
    toggleobject([fixation_point target]); % simultaneously turns off fix point and displays target & distractors
elseif flankers == 2
    toggleobject([fixation_point target distractor1 distractor2]);
elseif flankers == 3
    toggleobject([fixation_point target distractor1 distractor2 distractor3 distractor4]);
end
%%%%%%%%%%%
% target_radius = 7;
%do we need to change the radius?  When the trial is
% running, the fixation radius is still there then the trial ends in a
% error when the cursor is moved to the radius

% [ontarget, rt] = eyejoytrack('holdtarget', target, target_radius, max_reaction_time); % rt will be used to update the graph on the control screen
%%%%%%%%%%%%The above line helps stop the trials from auto ending, but does
%%%%%%%%%%%%not actually complete the trial.  Then the program can't be
%%%%%%%%%%%%ended, so it needs to be reset via ctrl alt del.

[x_deg, y_deg] = joystick_position;
% if ~ontarget % max_reaction_time has elapsed and is still on target 
%      trialerror(1); % no response
%      if flankers == 1
%         toggleobject(target)
%      elseif flankers == 2
%         toggleobject([target distractor1 distractor2])
%      elseif flankers == 3
%         toggleobject([target distractor1 distractor2 distractor3 distractor4])
%      end
%     return
% end
% if (x_deg > -5 && x_deg < 5)
%      trialerror(2); % no or late response (did not move left or right by enough)
%      if flankers == 1
%         toggleobject(target)
%      elseif flankers == 2
%         toggleobject([target distractor1 distractor2])
%      elseif flankers == 3
%         toggleobject([target distractor1 distractor2 distractor3 distractor4])
%      end
%     return
% end

% move to correct direction, then reward
if rule == 1 %if Left is the correct direction
    if x_deg < -5
         trialerror(0); % saccade correct direction
         return
    elseif x_deg > 5
        trialerror(6); % saccade incorrect direction
        return
    end
elseif rule == 2 %if Right is the correct direction
    if x_deg > 5
         trialerror(0); % saccade correct direction
         return
    elseif x_deg < -5
        trialerror(6); % saccade incorrect direction
        return
    end
end
goodmonkey(50, 'NumReward', 3); % 50ms of juice x 3

if flankers == 1
    toggleobject(target);
elseif flankers == 2
    toggleobject([target distractor1 distractor2]); %turn off remaining objects
elseif flankers == 3
    toggleobject([target distractor1 distractor2 distractor3 distractor4]); %turn off remaining objects
end

% delay_post epoch (this may not be the right way...maybe just use pause
% toggleobject(ITI_stim);
% ontarget = eyejoytrack('holdtarget', ITI_stim, fix_radius, delay_post);
% toggleobject(ITI_stim);
% pause(delay_post/1000);