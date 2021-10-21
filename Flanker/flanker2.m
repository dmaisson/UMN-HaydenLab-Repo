% Flanker Task
% 
% Fixation comes on.
% Subject fixates the fixation (or centers the joystick on it. 
% Then a variable delay occurs (0-1 second, uniform distribution).
% Then the fixation disappears and simultaneously, a cue appears.
% The cues are stochastic offers of variable probability and random
% selected magnitudes.
% The first offer disappears and a delay is introduced.
% Then the second offer appears and it MAY be flanked by 0,2, or 4
% distractors
% The monkey is free to choose the moment the second offer appears
% 
% THE CUE:
% 
% Two offers, presented asychronously. They are some combination of
% probability and magnitude (as in normal stagops). Only the second offer
% is flanked and is done so variably by either 0, 2, or 4 flankers which
% may or may not match one another on either side of the actual offer. The
% choice can be made as soon as the second offer appears.
%

% DETAILS: 
% all four cues are equally likely.
% on one third of trials, the cue appears alone
% one one third of trials, there are two flankers
% on one third of trials, there are four flankers
% 
% the flankers are chosen randomly


%% Flanker Task
% define the parameters of the trial
prob1 = round(rand,2);
prob2 = round(rand,2);
mag1 = randi(3);
mag2 = randi(3);
color_err = 'red';
if mag1 == 1
    color1 = [17 17 17];
    prob1 = 1;
elseif mag1 == 2
    color1 = 'blue';
elseif mag1 == 3
    color1 = 'green';
end
if mag2 == 1
    color2 = [17 17 17];
    prob2 = 1;
elseif mag2 == 2
    color2 = 'blue';
elseif mag2 == 3
    color2 = 'green';
end
flankers = randi(3); % 1 = no flankers; 2 = 2 flankers; 3 = 4 flankers

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
ITI_stim = 2;
fail_image = 11;
if rule == 1 %if Left
    shape = randi(2); % randomly pick from among the "Left Shapes"
    if shape == 1
        target = 7;
    elseif shape == 2
        target = 8;
    end
elseif rule == 2 %if Right
    shape = randi(2); % randomly pick from among the "Right Shapes"
    if shape == 1
        target = 9;
    elseif shape == 2
        target = 10;
    end
end

if flankers == 2
    distractor1 = 3;
    distractor2 = 5;
elseif flankers == 3
    distractor1 = 3;
    distractor2 = 4;
    distractor3 = 5;
    distractor4 = 6;
end


% TASK:
delay_pre = randi(1000);
delay_post = randi([1000 3000]);
delay_fail = 100;

% scene 1: fixation
showcursor('on');
fix1 = SingleTarget(joy_);
fix1.Target = fixation_point;
fix1.Threshold = 1;
fth1 = FreeThenHold(fix1);
fth1.MaxTime = 10000;
fth1.HoldTime = 1000;
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
fix2.HoldTime = 50;
if flankers == 1
    scene2 = create_scene(fix2, target);
elseif flankers == 2
    scene2 = create_scene(fix2, [target distractor1 distractor2]);
elseif flankers == 3
    scene2 = create_scene(fix2, [target distractor1 distractor2 distractor3 distractor4]);
end
showcursor('on');
run_scene(scene2);

%creating a scene to play when joystick in the wrong direction
fix3 = SingleTarget(joy_);
fix3.Target = fail_image;
fix3.Threshold = 500;
fth3 = FreeThenHold(fix3);
fth3.MaxTime = 10000;
fth3.HoldTime = 3000;
scene3 = create_scene(fix3, fail_image);


if fix2.ChosenTarget == 1
    trialerror(0);
    goodmonkey(150, 'NumReward', 1); % 50ms of juice x 3
    return
elseif fix2.ChosenTarget == 2;
        idle(delay_fail);
        run_scene(scene3);
        trialerror(6);
    return
end

idle(delay_post);