colors = colors();

% chosenOfferProb = [trialdata.chosenOfferProb];
% chosenOfferVal = [trialdata.chosenOfferVal];
% chosenOfferEV = [trialdata.chosenOfferEV];
% unchosenOfferProb = [trialdata.unchosenOfferProb];
% unchosenOfferVal = [trialdata.unchosenOfferVal];
% unchosenOfferEV = [trialdata.unchosenOfferEV];
% EVaccuracy = [trialdata.EVaccuracy];
% accuracy = [trialdata.accuracy];

trialBin.color.offer1_on = colors.magenta1;
trialBin.color.offer1_off = colors.magenta4;
trialBin.color.offer2_on = colors.sapphire1;
trialBin.color.offer2_off = colors.sapphire4;
trialBin.color.choice_on = colors.orange1;

if ~exist('opt','var')
    plotColors.offer1EV_high = colors.magenta4;
    plotColors.offer1EV_mid = colors.magenta2;
    plotColors.offer1EV_low = colors.magenta1;
    plotColors.offer1EV_nS = [243 237 241]/255;
    
    plotColors.offer2EV_high = colors.purple4;
    plotColors.offer2EV_mid = colors.purple1;
    plotColors.offer2EV_low = colors.lightblue2;
    plotColors.offer2EV_nS = [230 237 238]/255;
    
    plotColors.offer2O1HiEV_high = colors.violet5;
    plotColors.offer2O1HiEV_mid = colors.violet3;
    plotColors.offer2O1HiEV_low = colors.violet2;
    plotColors.offer2O1HiEV_nS = [230 237 238]/255;
    
    plotColors.offer2O1LoEV_high = colors.turqoise4;
    plotColors.offer2O1LoEV_mid = colors.turqoise3;
    plotColors.offer2O1LoEV_low = colors.turqoise2;
    plotColors.offer2O1LoEV_nS = [230 237 238]/255;
    
    plotColors.offer2EV_high = colors.purple4;
    plotColors.offer2EV_mid = colors.purple1;
    plotColors.offer2EV_low = colors.lightblue2;
    plotColors.offer2EV_nS = [230 237 238]/255;
    
    plotColors.offerEVdiff_high = colors.orange4;
    plotColors.offerEVdiff_mid = colors.orange2;
    plotColors.offerEVdiff_low = colors.orange1;
    plotColors.offerEVdiff_nS = [255 231 213]/255;
    
    plotColors.chosenOfferSide_high = colors.sapphire4;
    plotColors.chosenOfferSide_mid = colors.sapphire1;
    plotColors.chosenOfferSide_low = colors.turqoise2;
    plotColors.chosenOfferSide_nS = [184 179 219]/255;
    
    plotColors.chosenOfferProb_high = colors.skyblue4;
    plotColors.chosenOfferProb_mid = colors.skyblue1;
    plotColors.chosenOfferProb_low = colors.gold3;
    plotColors.chosenOfferProb_nS = [255 240 197]/255;
    
    plotColors.chosenOfferVal_high = colors.skyblue4;
    plotColors.chosenOfferVal_mid = colors.skyblue1;
    plotColors.chosenOfferVal_low = colors.gold3;
    
    plotColors.chosenOfferEV_high = colors.blue3;
    plotColors.chosenOfferEV_mid = colors.blue1;
    plotColors.chosenOfferEV_low = colors.rust3;
    plotColors.chosenOfferEV_nS = [215 232 253]/255;
    
    plotColors.unchosenOfferProb_high = colors.gradient2;
    plotColors.unchosenOfferProb_mid = colors.gradient4;
    plotColors.unchosenOfferProb_low = colors.gradient6;
    
    plotColors.unchosenOfferVal_high = colors.gradient1;
    plotColors.unchosenOfferVal_mid = colors.gradient3;
    plotColors.unchosenOfferVal_low = colors.gradient5;
    
    plotColors.unchosenOfferEV_high = colors.orange4;
    plotColors.unchosenOfferEV_mid = colors.orange1;
    plotColors.unchosenOfferEV_low = colors.blue2;
    
    plotColors.accuracy_high = colors.green4;
    plotColors.accuracy_mid = colors.green4;
    plotColors.accuracy_low = colors.red4;
    plotColors.accuracy_nS = [229 219 219]/255;
    
    plotColors.EVaccuracy_high = colors.green2;
    plotColors.EVaccuracy_mid = colors.green1;
    plotColors.EVaccuracy_low = colors.red1;
    plotColors.EVaccuracy_nS = [209 255 209]/255;
    
    plotColors.difficulty_high = colors.violet6;
    plotColors.difficulty_mid = colors.violet2;
    plotColors.difficulty_low = colors.gold2;
    plotColors.difficulty_nS = [227 201 255]/255;
    
    plotColors.difficulty_accOnly_high = colors.turqoise4;
    plotColors.difficulty_accOnly_mid = colors.turqoise1;
    plotColors.difficulty_accOnly_low = colors.orange3;
    plotColors.difficulty_accOnly_nS = [227 201 255]/255;
    
    plotColors.chosenOffer_high = colors.magenta3;
    plotColors.chosenOffer_mid = colors.red2;
    plotColors.chosenOffer_low = colors.sapphire3;
    plotColors.chosenOffer_nS = [221 221 255]/255;
    
    plotColors.choiceTime_high = colors.orange3;
    plotColors.choiceTime_mid = colors.leaf1;
    plotColors.choiceTime_low = colors.leaf3;
    plotColors.choiceTime_nS = [224 236 228]/255;
    
    plotColors.entropy_high = colors.red1;
    plotColors.entropy_mid = colors.red2;
    plotColors.entropy_low = colors.red4;
    plotColors.entropy_nS = [243 237 241]/255; % it's the same as offer1EV's ns color
    
    plotColors.curvature_1H_high = colors.turqoise4;
    plotColors.curvature_1H_mid = colors.turqoise2;
    plotColors.curvature_1H_low = colors.turqoise1;
    plotColors.curvature_1H_nS = [227 201 255]/255;
    
    plotColors.curvature_all_high = colors.turqoise4;
    plotColors.curvature_all_mid = colors.turqoise2;
    plotColors.curvature_all_low = colors.turqoise1;
    plotColors.curvature_all_nS = [227 201 255]/255;
    
    plotColors.endDistance_high = colors.sapphire4;
    plotColors.endDistance_mid = colors.sapphire2;
    plotColors.endDistance_low = colors.sapphire1;
    plotColors.endDistance_nS = [227 201 255]/255;
    
    plotColors.maxDistance_high = colors.blue4;
    plotColors.maxDistance_mid = colors.blue2;
    plotColors.maxDistance_low = colors.blue1;
    plotColors.maxDistance_nS = [227 201 255]/255;
    
    plotColors.velocity_1H_high = colors.skyblue4;
    plotColors.velocity_1H_mid = colors.skyblue2;
    plotColors.velocity_1H_low = colors.skyblue1;
    plotColors.velocity_1H_nS = [227 201 255]/255;
    
    plotColors.velocity_all_high = colors.skyblue4;
    plotColors.velocity_all_mid = colors.skyblue2;
    plotColors.velocity_all_low = colors.skyblue1;
    plotColors.velocity_all_nS = [227 201 255]/255;
    
    plotColors.acceleration_1H_high = colors.teal4;
    plotColors.acceleration_1H_mid = colors.teal2;
    plotColors.acceleration_1H_low = colors.teal1;
    plotColors.acceleration_1H_nS = [227 201 255]/255;
    
    plotColors.acceleration_all_high = colors.teal4;
    plotColors.acceleration_all_mid = colors.teal2;
    plotColors.acceleration_all_low = colors.teal1;
    plotColors.acceleration_all_nS = [227 201 255]/255;
    
    plotColors.stateLikelihood_all_high = colors.teal4;
    plotColors.stateLikelihood_all_mid = colors.teal2;
    plotColors.stateLikelihood_all_low = colors.teal1;
    plotColors.stateLikelihood_all_nS = [227 201 255]/255;
    
    plotColors.offerXEV_high = colors.gray3;
    plotColors.offerXEV_mid = colors.gray3;
    plotColors.offerXEV_low = colors.gray3;
    plotColors.offerXEV_nS = colors.gray3;
    
    plotColors.likeSafe_high = colors.turqoise2;
    plotColors.likeSafe_mid = colors.teal1;
    plotColors.likeSafe_low = colors.red3;
    plotColors.likeSafe_nS = [227 201 255]/255;
    
else
if opt.analysis_bins == 2
    
    plotColors2.offer1EV_high = colors.magenta4;
    plotColors2.offer1EV_low = colors.magenta1;
    plotColors2.offer1EV_nS = [243 237 241]/255;
    
    plotColors2.offer2EV_high = colors.purple4;
    plotColors2.offer2EV_low = colors.lightblue2;
    plotColors2.offer2EV_nS = [230 237 238]/255;
    
    plotColors2.offerEVdiff_high = colors.orange4;
    plotColors2.offerEVdiff_low = colors.orange2;
    plotColors2.offerEVdiff_nS = [255 231 213]/255;
    
    plotColors2.chosenOfferSide_high = colors.sapphire4;
    plotColors2.chosenOfferSide_low = colors.turqoise2;
    plotColors2.chosenOfferSide_nS = [184 179 219]/255;
    
    plotColors2.chosenOfferProb_high = colors.gold3;
    plotColors2.chosenOfferProb_low = colors.gold1;
    plotColors2.chosenOfferProb_nS = [255 240 197]/255;
    
    plotColors2.chosenOfferEV_high = colors.blue3;
    plotColors2.chosenOfferEV_low = colors.rust3;
    plotColors2.chosenOfferEV_nS = [215 232 253]/255;
    
    plotColors2.unchosenOfferEV_high = colors.gradient2;
    plotColors2.unchosenOfferEV_low = colors.gradient6;
    
    plotColors2.accuracy_high = colors.green4;
    plotColors2.accuracy_mid = colors.green4;
    plotColors2.accuracy_low = colors.red4;
    plotColors2.accuracy_nS = [229 219 219]/255;
    
    plotColors2.EVaccuracy_high = colors.green2;
    plotColors2.EVaccuracy_mid = colors.green1;
    plotColors2.EVaccuracy_low = colors.red1;
    plotColors2.EVaccuracy_nS = [209 255 209]/255;
    
    plotColors2.difficulty_high = colors.violet6;
    plotColors2.difficulty_low = colors.gold2;
    plotColors2.difficulty_nS = [227 201 255]/255;
    
    plotColors2.difficulty_accOnly_high = colors.turqoise4;
    plotColors2.difficulty_accOnly_low = colors.orange3;
    plotColors2.difficulty_accOnly_nS = [227 201 255]/255;
    
    plotColors2.chosenOffer_high = colors.magenta3;
    plotColors2.chosenOffer_mid = colors.red2;
    plotColors2.chosenOffer_low = colors.sapphire3;
    plotColors2.chosenOffer_nS = [221 221 255]/255;
    
    plotColors2.choiceTime_high = colors.orange3;
    plotColors2.choiceTime_mid = colors.leaf1;
    plotColors2.choiceTime_low = colors.leaf3;
    plotColors2.choiceTime_nS = [224 236 228]/255;
    
    plotColors2.entropy_high = colors.red1;
    plotColors2.entropy_mid = colors.red2;
    plotColors2.entropy_low = colors.red4;
    plotColors2.entropy_nS = [243 237 241]/255;
   
    plotColors2.reward_high = colors.magenta4;
    plotColors2.reward_mid = colors.magenta2;
    plotColors2.reward_low = colors.magenta1;
    plotColors2.reward_nS = [243 237 241]/255;
    
    plotColors2.valDiff_high = colors.orange4;
    plotColors2.valDiff_mid = colors.orange2;
    plotColors2.valDiff_low = colors.orange1;
    plotColors2.valDiff_nS = [255 231 213]/255;
    
    plotColors2.decisionTrial_high = colors.violet6;
    plotColors2.decisionTrial_mid = colors.violet2;
    plotColors2.decisionTrial_low = colors.gold2;
    plotColors2.decisionTrial_nS = [227 201 255]/255;
    
    plotColors2.predatorTrial_high = colors.purple4;
    plotColors2.predatorTrial_mid = colors.purple1;
    plotColors2.predatorTrial_low = colors.lightblue2;
    plotColors2.predatorTrial_nS = [230 237 238]/255;
    
    plotColors2.curvature_1H_high = colors.turqoise4;
    plotColors2.curvature_1H_mid = colors.turqoise3;
    plotColors2.curvature_1H_low = colors.turqoise2;
    plotColors2.curvature_1H_nS = [227 201 255]/255;
    
    plotColors2.curvature_all_high = colors.turqoise4;
    plotColors2.curvature_all_mid = colors.turqoise2;
    plotColors2.curvature_all_low = colors.turqoise1;
    plotColors2.curvature_all_nS = [227 201 255]/255;
    
    plotColors2.endDistance_high = colors.sapphire4;
    plotColors2.endDistance_mid = colors.sapphire2;
    plotColors2.endDistance_low = colors.sapphire1;
    plotColors2.endDistance_nS = [227 201 255]/255;
    
    plotColors2.maxDistance_high = colors.blue4;
    plotColors2.maxDistance_mid = colors.blue2;
    plotColors2.maxDistance_low = colors.blue1;
    plotColors2.maxDistance_nS = [227 201 255]/255;
    
    plotColors2.velocity_1H_high = colors.skyblue4;
    plotColors2.velocity_1H_mid = colors.skyblue2;
    plotColors2.velocity_1H_low = colors.skyblue1;
    plotColors2.velocity_1H_nS = [227 201 255]/255;
    
    plotColors2.velocity_all_high = colors.skyblue4;
    plotColors2.velocity_all_mid = colors.skyblue2;
    plotColors2.velocity_all_low = colors.skyblue1;
    plotColors2.velocity_all_nS = [227 201 255]/255;
    
    plotColors2.acceleration_1H_high = colors.teal4;
    plotColors2.acceleration_1H_mid = colors.teal2;
    plotColors2.acceleration_1H_low = colors.teal1;
    plotColors2.acceleration_1H_nS = [227 201 255]/255;
    
    plotColors2.acceleration_all_high = colors.teal4;
    plotColors2.acceleration_all_mid = colors.teal2;
    plotColors2.acceleration_all_low = colors.teal1;
    plotColors2.acceleration_all_nS = [227 201 255]/255;
    
    plotColors2.likeSafe_high = colors.turqoise3;
    plotColors2.likeSafe_mid = colors.teal1;
    plotColors2.likeSafe_low = colors.red4;
    plotColors2.likeSafe_nS = [227 201 255]/255;
    
    
elseif opt.analysis_bins == 3
    
    plotColors.offer1EV_high = colors.magenta4;
    plotColors.offer1EV_mid = colors.magenta2;
    plotColors.offer1EV_low = colors.magenta1;
    plotColors.offer1EV_nS = [243 237 241]/255;
    
    plotColors.offer2EV_high = colors.purple4;
    plotColors.offer2EV_mid = colors.purple1;
    plotColors.offer2EV_low = colors.lightblue2;
    plotColors.offer2EV_nS = [230 237 238]/255;
    
    plotColors.offer2O1HiEV_high = colors.violet5;
    plotColors.offer2O1HiEV_mid = colors.violet3;
    plotColors.offer2O1HiEV_low = colors.violet2;
    plotColors.offer2O1HiEV_nS = [230 237 238]/255;
    
    plotColors.offer2O1LoEV_high = colors.turqoise4;
    plotColors.offer2O1LoEV_mid = colors.turqoise3;
    plotColors.offer2O1LoEV_low = colors.turqoise2;
    plotColors.offer2O1LoEV_nS = [230 237 238]/255;
    
    plotColors.offerEVdiff_high = colors.orange4;
    plotColors.offerEVdiff_mid = colors.orange2;
    plotColors.offerEVdiff_low = colors.orange1;
    plotColors.offerEVdiff_nS = [255 231 213]/255;
    
    plotColors.chosenOfferSide_high = colors.sapphire4;
    plotColors.chosenOfferSide_mid = colors.sapphire1;
    plotColors.chosenOfferSide_low = colors.turqoise2;
    plotColors.chosenOfferSide_nS = [184 179 219]/255;
    
    plotColors.chosenOfferProb_high = colors.skyblue4;
    plotColors.chosenOfferProb_mid = colors.skyblue1;
    plotColors.chosenOfferProb_low = colors.gold3;
    plotColors.chosenOfferProb_nS = [255 240 197]/255;
    
    plotColors.chosenOfferVal_high = colors.skyblue4;
    plotColors.chosenOfferVal_mid = colors.skyblue1;
    plotColors.chosenOfferVal_low = colors.gold3;
    
    plotColors.chosenOfferEV_high = colors.blue3;
    plotColors.chosenOfferEV_mid = colors.blue1;
    plotColors.chosenOfferEV_low = colors.rust3;
    plotColors.chosenOfferEV_nS = [215 232 253]/255;
    
    plotColors.unchosenOfferProb_high = colors.gradient2;
    plotColors.unchosenOfferProb_mid = colors.gradient4;
    plotColors.unchosenOfferProb_low = colors.gradient6;
    
    plotColors.unchosenOfferVal_high = colors.gradient1;
    plotColors.unchosenOfferVal_mid = colors.gradient3;
    plotColors.unchosenOfferVal_low = colors.gradient5;
    
    plotColors.unchosenOfferEV_high = colors.orange4;
    plotColors.unchosenOfferEV_mid = colors.orange1;
    plotColors.unchosenOfferEV_low = colors.blue2;
    
    plotColors.accuracy_high = colors.green4;
    plotColors.accuracy_mid = colors.green4;
    plotColors.accuracy_low = colors.red4;
    plotColors.accuracy_nS = [229 219 219]/255;
    
    plotColors.EVaccuracy_high = colors.green2;
    plotColors.EVaccuracy_mid = colors.green1;
    plotColors.EVaccuracy_low = colors.red1;
    plotColors.EVaccuracy_nS = [209 255 209]/255;
    
    plotColors.difficulty_high = colors.violet6;
    plotColors.difficulty_mid = colors.violet2;
    plotColors.difficulty_low = colors.gold2;
    plotColors.difficulty_nS = [227 201 255]/255;
    
    plotColors.difficulty_accOnly_high = colors.turqoise4;
    plotColors.difficulty_accOnly_mid = colors.turqoise1;
    plotColors.difficulty_accOnly_low = colors.orange3;
    plotColors.difficulty_accOnly_nS = [227 201 255]/255;
    
    plotColors.chosenOffer_high = colors.magenta3;
    plotColors.chosenOffer_mid = colors.red2;
    plotColors.chosenOffer_low = colors.sapphire3;
    plotColors.chosenOffer_nS = [221 221 255]/255;
    
    plotColors.choiceTime_high = colors.orange3;
    plotColors.choiceTime_mid = colors.leaf1;
    plotColors.choiceTime_low = colors.leaf3;
    plotColors.choiceTime_nS = [224 236 228]/255;
    
    plotColors.entropy_high = colors.red1;
    plotColors.entropy_mid = colors.red2;
    plotColors.entropy_low = colors.red4;
    plotColors.entropy_nS = [243 237 241]/255;
    
    plotColors.curvature_1H_high = colors.turqoise4;
    plotColors.curvature_1H_mid = colors.turqoise2;
    plotColors.curvature_1H_low = colors.turqoise1;
    plotColors.curvature_1H_nS = [227 201 255]/255;
    
    plotColors.curvature_all_high = colors.turqoise4;
    plotColors.curvature_all_mid = colors.turqoise2;
    plotColors.curvature_all_low = colors.turqoise1;
    plotColors.curvature_all_nS = [227 201 255]/255;
    
    plotColors.endDistance_high = colors.sapphire4;
    plotColors.endDistance_mid = colors.sapphire2;
    plotColors.endDistance_low = colors.sapphire1;
    plotColors.endDistance_nS = [227 201 255]/255;
    
    plotColors.maxDistance_high = colors.blue4;
    plotColors.maxDistance_mid = colors.blue2;
    plotColors.maxDistance_low = colors.blue1;
    plotColors.maxDistance_nS = [227 201 255]/255;
    
    plotColors.velocity_1H_high = colors.skyblue4;
    plotColors.velocity_1H_mid = colors.skyblue2;
    plotColors.velocity_1H_low = colors.skyblue1;
    plotColors.velocity_1H_nS = [227 201 255]/255;
    
    plotColors.velocity_all_high = colors.skyblue4;
    plotColors.velocity_all_mid = colors.skyblue2;
    plotColors.velocity_all_low = colors.skyblue1;
    plotColors.velocity_all_nS = [227 201 255]/255;
    
    plotColors.acceleration_1H_high = colors.teal4;
    plotColors.acceleration_1H_mid = colors.teal2;
    plotColors.acceleration_1H_low = colors.teal1;
    plotColors.acceleration_1H_nS = [227 201 255]/255;
    
    plotColors.acceleration_all_high = colors.teal4;
    plotColors.acceleration_all_mid = colors.teal2;
    plotColors.acceleration_all_low = colors.teal1;
    plotColors.acceleration_all_nS = [227 201 255]/255;
    
    plotColors.stateLikelihood_all_high = colors.teal4;
    plotColors.stateLikelihood_all_mid = colors.teal2;
    plotColors.stateLikelihood_all_low = colors.teal1;
    plotColors.stateLikelihood_all_nS = [227 201 255]/255;
    
    plotColors.stateLikelihood_1Q_high = colors.teal4;
    plotColors.stateLikelihood_1Q_mid = colors.teal2;
    plotColors.stateLikelihood_1Q_low = colors.teal1;
    plotColors.stateLikelihood_1Q_nS = [227 201 255]/255;
    
    plotColors.offerXEV_high = colors.gray3;
    plotColors.offerXEV_mid = colors.gray2;
    plotColors.offerXEV_low = colors.gray1;
    plotColors.offerXEV_nS = colors.gray2;
    
    plotColors.likeSafe_high = colors.turqoise2;
    plotColors.likeSafe_mid = colors.teal1;
    plotColors.likeSafe_low = colors.red3;
    plotColors.likeSafe_nS = [227 201 255]/255;
    
elseif opt.analysis_bins == 4
    
    plotColors4.offer1EV_high = colors.magenta3;
    plotColors4.offer1EV_mid = colors.magenta1;
    plotColors4.offer1EV_low = colors.skyblue2;
    plotColors4.offer1EV_nS = [243 237 241]/255;
    
    plotColors4.offer2EV_high = colors.purple4;
    plotColors4.offer2EV_mid = colors.purple1;
    plotColors4.offer2EV_low = colors.lightblue2;
    plotColors4.offer2EV_nS = [230 237 238]/255;
    
    plotColors4.offerEVdiff_high = colors.orange4;
    plotColors4.offerEVdiff_mid = colors.orange2;
    plotColors4.offerEVdiff_low = colors.orange1;
    plotColors4.offerEVdiff_nS = [255 231 213]/255;
    
    plotColors4.chosenOfferSide_high = colors.sapphire4;
    plotColors4.chosenOfferSide_mid = colors.sapphire1;
    plotColors4.chosenOfferSide_low = colors.turqoise2;
    plotColors4.chosenOfferSide_nS = [184 179 219]/255;
    
    plotColors4.chosenOfferProb_high = colors.gold3;
    plotColors4.chosenOfferProb_mid = colors.gold2;
    plotColors4.chosenOfferProb_low = colors.gold1;
    plotColors4.chosenOfferProb_nS = [255 240 197]/255;
    
    plotColors4.chosenOfferVal_high = colors.pine3;
    plotColors4.chosenOfferVal_mid = colors.pine1;
    plotColors4.chosenOfferVal_low = colors.gold2;
    
    plotColors4.chosenOfferEV_high = colors.blue3;
    plotColors4.chosenOfferEV_mid = colors.blue1;
    plotColors4.chosenOfferEV_low = colors.rust3;
    plotColors4.chosenOfferEV_nS = [215 232 253]/255;
    
    plotColors4.unchosenOfferProb_high = colors.gradient2;
    plotColors4.unchosenOfferProb_mid = colors.gradient4;
    plotColors4.unchosenOfferProb_low = colors.gradient6;
    
    plotColors4.unchosenOfferVal_high = colors.gradient1;
    plotColors4.unchosenOfferVal_mid = colors.gradient3;
    plotColors4.unchosenOfferVal_low = colors.gradient5;
    
    plotColors4.unchosenOfferEV_high = colors.orange4;
    plotColors4.unchosenOfferEV_mid = colors.orange1;
    plotColors4.unchosenOfferEV_low = colors.blue2;
    
    plotColors4.accuracy_high = colors.green4;
    plotColors2.accuracy_mid = colors.green4;
    plotColors4.accuracy_low = colors.red4;
    plotColors4.accuracy_nS = [229 219 219]/255;
    
    plotColors4.EVaccuracy_high = colors.green2;
    plotColors4.EVaccuracy_mid = colors.green1;
    plotColors4.EVaccuracy_low = colors.red1;
    plotColors4.EVaccuracy_nS = [209 255 209]/255;
    
    plotColors4.difficulty_high = colors.violet6;
    plotColors4.difficulty_mid = colors.violet2;
    plotColors4.difficulty_low = colors.gold2;
    plotColors4.difficulty_nS = [227 201 255]/255;
    
    plotColors4.difficulty_accOnly_high = colors.turqoise4;
    plotColors4.difficulty_accOnly_mid = colors.turqoise1;
    plotColors4.difficulty_accOnly_low = colors.orange3;
    plotColors4.difficulty_accOnly_nS = [227 201 255]/255;
    
    plotColors4.chosenOffer_high = colors.magenta3;
    plotColors4.chosenOffer_mid = colors.red2;
    plotColors4.chosenOffer_low = colors.sapphire3;
    plotColors4.chosenOffer_nS = [221 221 255]/255;
    
    plotColors4.choiceTime_high = colors.orange3;
    plotColors4.choiceTime_mid = colors.leaf1;
    plotColors4.choiceTime_low = colors.leaf3;
    plotColors4.choiceTime_nS = [224 236 228]/255;
    
    plotColors4.entropy_high = colors.red1;
    plotColors4.entropy_mid = colors.red2;
    plotColors4.entropy_low = colors.red4;
    plotColors4.entropy_nS = [243 237 241]/255;
    
    plotColors4.curvature_1H_high = colors.turqoise4;
    plotColors4.curvature_1H_mid = colors.turqoise2;
    plotColors4.curvature_1H_low = colors.turqoise1;
    plotColors4.curvature_1H_nS = [227 201 255]/255;
    
    plotColors4.curvature_all_high = colors.turqoise4;
    plotColors4.curvature_all_mid = colors.turqoise2;
    plotColors4.curvature_all_low = colors.turqoise1;
    plotColors4.curvature_all_nS = [227 201 255]/255;
    
    plotColors4.endDistance_high = colors.sapphire4;
    plotColors4.endDistance_mid = colors.sapphire2;
    plotColors4.endDistance_low = colors.sapphire1;
    plotColors4.endDistance_nS = [227 201 255]/255;
    
    plotColors4.maxDistance_high = colors.blue4;
    plotColors4.maxDistance_mid = colors.blue2;
    plotColors4.maxDistance_low = colors.blue1;
    plotColors4.maxDistance_nS = [227 201 255]/255;
    
    plotColors4.velocity_1H_high = colors.skyblue4;
    plotColors4.velocity_1H_mid = colors.skyblue2;
    plotColors4.velocity_1H_low = colors.skyblue1;
    plotColors4.velocity_1H_nS = [227 201 255]/255;
    
    plotColors4.velocity_all_high = colors.skyblue4;
    plotColors4.velocity_all_mid = colors.skyblue2;
    plotColors4.velocity_all_low = colors.skyblue1;
    plotColors4.velocity_all_nS = [227 201 255]/255;
    
    plotColors4.acceleration_1H_high = colors.teal4;
    plotColors4.acceleration_1H_mid = colors.teal2;
    plotColors4.acceleration_1H_low = colors.teal1;
    plotColors4.acceleration_1H_nS = [227 201 255]/255;
    
    plotColors4.acceleration_all_high = colors.teal4;
    plotColors4.acceleration_all_mid = colors.teal2;
    plotColors4.acceleration_all_low = colors.teal1;
    plotColors4.acceleration_all_nS = [227 201 255]/255;
    
    plotColors4.likeSafe_high = colors.turqoise2;
    plotColors4.likeSafe_mid = colors.teal1;
    plotColors4.likeSafe_low = colors.red3;
    plotColors4.likeSafe_nS = [227 201 255]/255;
    
end
end