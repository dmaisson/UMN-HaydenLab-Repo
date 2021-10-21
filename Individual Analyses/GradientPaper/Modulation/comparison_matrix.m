function [Results] = comparison_matrix(Results,Prepped)

mod = ModRate_forPreselect(Prepped.data13,300);
Results.compare.choice(1,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(1,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.data11,300);
Results.compare.choice(2,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(2,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.data14,300);
Results.compare.choice(3,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(3,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.data25,300);
Results.compare.choice(4,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(4,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.data32,300);
Results.compare.choice(5,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(5,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.dataPCC,300);
Results.compare.choice(6,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(6,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.dataVS,300);
Results.compare.choice(7,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(7,:) = mod.modrate.rate.ChoiceSide;
mod = ModRate_forPreselect(Prepped.data24,300);
Results.compare.choice(8,:) = mod.modrate.rate.Choice;
Results.compare.choiceside(8,:) = mod.modrate.rate.ChoiceSide;

end
