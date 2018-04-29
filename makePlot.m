%result = hpacode(.5);
%clValues = (.5:.016:1.3);
paramterValues = (-8:.32:8);
%neutralPointValues = [1:50];
dependentValues = [1:50];
count = 1;
%{
results = hpacode(5,1);
d = results.CDtot;
dependentValues(count) = d;
disp(d);
count = count + 1;
%}
%comments for testing one run case

for i = -8:.32:8
    
    results = hpacode(i,2);
    d = results.CDtot;
    dependentValues(count) = d;
    disp(d);
    count = count + 1;
end

plot(paramterValues, dependentValues);
XY = [paramterValues; dependentValues];
xlswrite("alphaCDWingProject", XY);
