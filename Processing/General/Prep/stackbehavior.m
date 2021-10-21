function [output,n2] = stackbehavior(input,output,n2)

n1=length(input);
for iJ = 1:n1
    if isempty(output)
        output{iJ,1} = input{iJ}.vars;
    else
        output{n2+iJ} = input{iJ}.vars;
    end
end
n2=length(output);

end