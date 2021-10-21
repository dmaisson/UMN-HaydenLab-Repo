function [x,y,z] = printTrajectoryFigs_lineOffset(inputX,inputY,inputZ,standard)

fxoffset = inputX(1) - standard(1); 
x = inputX - fxoffset;
fyoffset = inputY(1) - standard(2); 
y = inputY - fyoffset;
fzoffset = inputZ(1) - standard(3); 
z = inputZ - fzoffset;

end