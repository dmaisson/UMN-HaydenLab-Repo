% Flanker Task
% 
% Fixation comes on.
% Subject fixates the fixation (or centers the joystick on it. 
% Then the fixation disappears and simultaneously, a offer appears.
% The offers are stochastic offers of variable probability and random
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
offer_shape = [4 1 2 8]; %these need to be changed to reflect degrees for monkeylogic
color_err = [1 0 0]; %RGB here is red
if mag1 == 1
    color1 = [1 1 0]; %RGB here is yellow
    prob1 = 1;
elseif mag1 == 2
    color1 = [0 0 1]; %RGB here is blue
elseif mag1 == 3
    color1 = [0 1 0]; %RGB here is green
end
if mag2 == 1
    color2 = [1 1 0];
    prob2 = 1;
elseif mag2 == 2
    color2 = [0 0 1];
elseif mag2 == 3
    color2 = [0 1 0];
end

offer1 = offer_shape;
offer1(4) = offer1(4)*prob1;
offer2 = offer_shape;
offer2(4) = offer2(4)*prob2;

position1 = randi(2); % if this is 1 then the offer is on the left, 2 = right
if position1 == 1
    position2 = 2;
elseif position1 == 2
    position2 = 1;
end

flankers = randi(3); % 1 = no flankers; 2 = 2 flankers; 3 = 4 flankers

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
ITI_stim = 2;

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
delay_post = 3000; %change here to change the length of the ITI

% scene 1: fixation
showcursor('on');
fix1 = SingleTarget(joy_);
fix1.Target = fixation_point;
fix1.Threshold = 1;
fth1 = FreeThenHold(fix1);
fth1.MaxTime = 10000;
fth1.HoldTime = 100;
scene1 = create_scene(fth1, 1);
run_scene(scene1);

% scene 2: offer 1 presentation
showcursor('on');
offer1_obj = PolygonGraphic(null_);
if position1 == 1
offer1_obj.List = {color_err,color_err,offer_shape(3:4),offer_shape(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375];...
    color1,color1,offer1(3:4),offer1(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375]}; %change offer location and vertices location to be on left
elseif position1 == 2
offer1_obj.List = {color_err,color_err,offer_shape(3:4),offer_shape(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375];...
    color1,color1,offer1(3:4),offer1(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375]}; %change offer location and vertices location to be on right
end
first_offer = MultiTarget(offer1_obj);
first_offer.Target = offer1_obj.List{:,4};
first_offer.Threshold = 1;
first_offer.HoldTime = 400;
scene2 = create_scene(first_offer);
run_scene(scene2);

idle(600);

% scene 3: choice presentation and response
showcursor('on');
offer2_obj = PolygonGraphic(mouse_);
if position2 == 1
offer2_obj.List = {color_err,color_err,offer_shape(3:4),offer_shape(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375];...
    color2,color2,offer2(3:4),offer2(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375]};
elseif position2 == 2
offer2_obj.List = {color_err,color_err,offer_shape(3:4),offer_shape(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375];...
    color2,color2,offer2(3:4),offer2(1:2),[0.5 1; 0.375 0.625; 0 0.625; 0.25 0.375]};
end
second_offer = MultiTarget(offer2_obj);
second_offer.Target = offer2_obj.List{:,4};
second_offer.Threshold = 1;
wth = WaitThenHold(second_offer);
wth.WaitTime = 999999999999999999999;
wth.HoldTime = 100;

if flankers == 1
    scene3 = create_scene(wth);
elseif flankers == 2
    scene3 = create_scene(wth, [second_offer.Target distractor1 distractor2]);
elseif flankers == 3
    scene3 = create_scene(wth, [second_offer.Target distractor1 distractor2 distractor3 distractor4]);
end
run_scene(scene3);

idle(delay_post);