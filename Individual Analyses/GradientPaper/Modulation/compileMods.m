function [R] = compileMods(Results)
R.currate.mods(1,1) = max(Results.data13.modrate.rate.E1EV1);
R.currate.mods(1,2) = max(Results.data13.modrate.rate.E2EV1);
R.currate.mods(1,3) = max(Results.data13.modrate.rate.E2EV2);
R.currate.mods(1,4) = max(Results.data13.modrate.rate.E0Choice);
R.currate.mods(1,5) = max(Results.data13.modrate.rate.E0ChoiceVal);
R.currate.mods(1,6) = max(Results.data13.modrate.rate.E0UnChoiceVal);
R.currate.mods(1,7) = max(Results.data13.modrate.rate.E3Choice);
R.currate.mods(1,8) = max(Results.data13.modrate.rate.E3ChoiceVal);
R.currate.mods(1,9) = max(Results.data13.modrate.rate.E3UnChoiceVal);
R.currate.mods(1,10) = max(Results.data13.modrate.rate.E1Side1);
R.currate.mods(1,11) = max(Results.data13.modrate.rate.E2Side);
R.currate.mods(1,12) = max(Results.data13.modrate.rate.E3ChoiceSide);
R.currate.mods(1,13) = max(Results.data13.modrate.rate.E0ChoiceSide);
R.currate.mods(1,14) = max(Results.data13.modrate.rate.Out);

R.currate.mods(2,1) = max(Results.data11.modrate.rate.E1EV1);
R.currate.mods(2,2) = max(Results.data11.modrate.rate.E2EV1);
R.currate.mods(2,3) = max(Results.data11.modrate.rate.E2EV2);
R.currate.mods(2,4) = max(Results.data11.modrate.rate.E0Choice);
R.currate.mods(2,5) = max(Results.data11.modrate.rate.E0ChoiceVal);
R.currate.mods(2,6) = max(Results.data11.modrate.rate.E0UnChoiceVal);
R.currate.mods(2,7) = max(Results.data11.modrate.rate.E3Choice);
R.currate.mods(2,8) = max(Results.data11.modrate.rate.E3ChoiceVal);
R.currate.mods(2,9) = max(Results.data11.modrate.rate.E3UnChoiceVal);
R.currate.mods(2,10) = max(Results.data11.modrate.rate.E1Side1);
R.currate.mods(2,11) = max(Results.data11.modrate.rate.E2Side);
R.currate.mods(2,12) = max(Results.data11.modrate.rate.E3ChoiceSide);
R.currate.mods(2,13) = max(Results.data11.modrate.rate.E0ChoiceSide);
R.currate.mods(2,14) = max(Results.data11.modrate.rate.Out);

R.currate.mods(3,1) = max(Results.data14.modrate.rate.E1EV1);
R.currate.mods(3,2) = max(Results.data14.modrate.rate.E2EV1);
R.currate.mods(3,3) = max(Results.data14.modrate.rate.E2EV2);
R.currate.mods(3,4) = max(Results.data14.modrate.rate.E0Choice);
R.currate.mods(3,5) = max(Results.data14.modrate.rate.E0ChoiceVal);
R.currate.mods(3,6) = max(Results.data14.modrate.rate.E0UnChoiceVal);
R.currate.mods(3,7) = max(Results.data14.modrate.rate.E3Choice);
R.currate.mods(3,8) = max(Results.data14.modrate.rate.E3ChoiceVal);
R.currate.mods(3,9) = max(Results.data14.modrate.rate.E3UnChoiceVal);
R.currate.mods(3,10) = max(Results.data14.modrate.rate.E1Side1);
R.currate.mods(3,11) = max(Results.data14.modrate.rate.E2Side);
R.currate.mods(3,12) = max(Results.data14.modrate.rate.E3ChoiceSide);
R.currate.mods(3,13) = max(Results.data14.modrate.rate.E0ChoiceSide);
R.currate.mods(3,14) = max(Results.data14.modrate.rate.Out);

R.currate.mods(4,1) = max(Results.data25.modrate.rate.E1EV1);
R.currate.mods(4,2) = max(Results.data25.modrate.rate.E2EV1);
R.currate.mods(4,3) = max(Results.data25.modrate.rate.E2EV2);
R.currate.mods(4,4) = max(Results.data25.modrate.rate.E0Choice);
R.currate.mods(4,5) = max(Results.data25.modrate.rate.E0ChoiceVal);
R.currate.mods(4,6) = max(Results.data25.modrate.rate.E0UnChoiceVal);
R.currate.mods(4,7) = max(Results.data25.modrate.rate.E3Choice);
R.currate.mods(4,8) = max(Results.data25.modrate.rate.E3ChoiceVal);
R.currate.mods(4,9) = max(Results.data25.modrate.rate.E3UnChoiceVal);
R.currate.mods(4,10) = max(Results.data25.modrate.rate.E1Side1);
R.currate.mods(4,11) = max(Results.data25.modrate.rate.E2Side);
R.currate.mods(4,12) = max(Results.data25.modrate.rate.E3ChoiceSide);
R.currate.mods(4,13) = max(Results.data25.modrate.rate.E0ChoiceSide);
R.currate.mods(4,14) = max(Results.data25.modrate.rate.Out);

R.currate.mods(5,1) = max(Results.data32.modrate.rate.E1EV1);
R.currate.mods(5,2) = max(Results.data32.modrate.rate.E2EV1);
R.currate.mods(5,3) = max(Results.data32.modrate.rate.E2EV2);
R.currate.mods(5,4) = max(Results.data32.modrate.rate.E0Choice);
R.currate.mods(5,5) = max(Results.data32.modrate.rate.E0ChoiceVal);
R.currate.mods(5,6) = max(Results.data32.modrate.rate.E0UnChoiceVal);
R.currate.mods(5,7) = max(Results.data32.modrate.rate.E3Choice);
R.currate.mods(5,8) = max(Results.data32.modrate.rate.E3ChoiceVal);
R.currate.mods(5,9) = max(Results.data32.modrate.rate.E3UnChoiceVal);
R.currate.mods(5,10) = max(Results.data32.modrate.rate.E1Side1);
R.currate.mods(5,11) = max(Results.data32.modrate.rate.E2Side);
R.currate.mods(5,12) = max(Results.data32.modrate.rate.E3ChoiceSide);
R.currate.mods(5,13) = max(Results.data32.modrate.rate.E0ChoiceSide);
R.currate.mods(5,14) = max(Results.data32.modrate.rate.Out);

R.currate.mods(6,1) = max(Results.dataPCC.modrate.rate.E1EV1);
R.currate.mods(6,2) = max(Results.dataPCC.modrate.rate.E2EV1);
R.currate.mods(6,3) = max(Results.dataPCC.modrate.rate.E2EV2);
R.currate.mods(6,4) = max(Results.dataPCC.modrate.rate.E0Choice);
R.currate.mods(6,5) = max(Results.dataPCC.modrate.rate.E0ChoiceVal);
R.currate.mods(6,6) = max(Results.dataPCC.modrate.rate.E0UnChoiceVal);
R.currate.mods(6,7) = max(Results.dataPCC.modrate.rate.E3Choice);
R.currate.mods(6,8) = max(Results.dataPCC.modrate.rate.E3ChoiceVal);
R.currate.mods(6,9) = max(Results.dataPCC.modrate.rate.E3UnChoiceVal);
R.currate.mods(6,10) = max(Results.dataPCC.modrate.rate.E1Side1);
R.currate.mods(6,11) = max(Results.dataPCC.modrate.rate.E2Side);
R.currate.mods(6,12) = max(Results.dataPCC.modrate.rate.E3ChoiceSide);
R.currate.mods(6,13) = max(Results.dataPCC.modrate.rate.E0ChoiceSide);
R.currate.mods(6,14) = max(Results.dataPCC.modrate.rate.Out);

R.currate.mods(7,1) = max(Results.dataVS.modrate.rate.E1EV1);
R.currate.mods(7,2) = max(Results.dataVS.modrate.rate.E2EV1);
R.currate.mods(7,3) = max(Results.dataVS.modrate.rate.E2EV2);
R.currate.mods(7,4) = max(Results.dataVS.modrate.rate.E0Choice);
R.currate.mods(7,5) = max(Results.dataVS.modrate.rate.E0ChoiceVal);
R.currate.mods(7,6) = max(Results.dataVS.modrate.rate.E0UnChoiceVal);
R.currate.mods(7,7) = max(Results.dataVS.modrate.rate.E3Choice);
R.currate.mods(7,8) = max(Results.dataVS.modrate.rate.E3ChoiceVal);
R.currate.mods(7,9) = max(Results.dataVS.modrate.rate.E3UnChoiceVal);
R.currate.mods(7,10) = max(Results.dataVS.modrate.rate.E1Side1);
R.currate.mods(7,11) = max(Results.dataVS.modrate.rate.E2Side);
R.currate.mods(7,12) = max(Results.dataVS.modrate.rate.E3ChoiceSide);
R.currate.mods(7,13) = max(Results.dataVS.modrate.rate.E0ChoiceSide);
R.currate.mods(7,14) = max(Results.dataVS.modrate.rate.Out);

R.currate.mods(8,1) = max(Results.data24.modrate.rate.E1EV1);
R.currate.mods(8,2) = max(Results.data24.modrate.rate.E2EV1);
R.currate.mods(8,3) = max(Results.data24.modrate.rate.E2EV2);
R.currate.mods(8,4) = max(Results.data24.modrate.rate.E0Choice);
R.currate.mods(8,5) = max(Results.data24.modrate.rate.E0ChoiceVal);
R.currate.mods(8,6) = max(Results.data24.modrate.rate.E0UnChoiceVal);
R.currate.mods(8,7) = max(Results.data24.modrate.rate.E3Choice);
R.currate.mods(8,8) = max(Results.data24.modrate.rate.E3ChoiceVal);
R.currate.mods(8,9) = max(Results.data24.modrate.rate.E3UnChoiceVal);
R.currate.mods(8,10) = max(Results.data24.modrate.rate.E1Side1);
R.currate.mods(8,11) = max(Results.data24.modrate.rate.E2Side);
R.currate.mods(8,12) = max(Results.data24.modrate.rate.E3ChoiceSide);
R.currate.mods(8,13) = max(Results.data24.modrate.rate.E0ChoiceSide);
R.currate.mods(8,14) = max(Results.data24.modrate.rate.Out);

end