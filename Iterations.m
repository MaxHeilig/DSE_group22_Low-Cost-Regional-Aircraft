data = zeros(7,13);
j=1;
refDataWeights = xlsread('Regional Aircraft Info.xlsx', 'B7:AK13');
refDataS = xlsread('Regional Aircraft Info.xlsx', 'B38:AK38');
refDataWeights = transpose(refDataWeights);

for concept = [8, 9, 10, 13, 24, 25]
j = j + 1;
    if concept == 8
        CD0 = 0.024;
        A = 11;
        data(j,1) = concept;
        concept = 1;
    end
    if concept == 9
        CD0 = 0.024;
        A = 11;
        data(j,1) = concept;
        concept = 1;        
    end
    if concept == 10
        CD0 = 0.021;
        A = 8;
        data(j,1) = concept;
        concept = 2;        
    end
    if concept == 13
        CD0 = 0.021;
        A = 10;
        data(j,1) = concept;
        concept = 2;        
    end
    if concept == 24
        CD0 = 0.021;
        A = 8;
        data(j,1) = concept;
        concept = 2;        
    end
    if concept == 25
        CD0 = 0.021;
        A = 8;
        data(j,1) = concept;
        concept = 2;        
    end
    [WTO, OEW, S, ffBeginCruise, ffEndCruise, jet] = Class1EstFunc(concept, 0.5, 14, refDataWeights, refDataS);

    iterationnumber = 500;

    if jet
        h = 33000*0.3;
        for i = 1:iterationnumber
            Slist(i) = S;           
            [M, LD, a, CLopt] = OptimalCruise(h, S, A, WTO, ffBeginCruise, ffEndCruise, CD0);
            [Tto, Tcr, Vsto, Vstl, RC, VLO, sfc] = Performance(WTO, CD0, S, A, M, a, ffBeginCruise, ffEndCruise);
            [WTO, OEW, S, ffBeginCruise, ffEndCruise, jet] = Class1EstFunc(concept, M, LD, refDataWeights, refDataS, sfc);
            iterations(i) = i;
            
        end
        Vcr = M*a;
    else
        h = 25000*0.3;
        for i = 1:iterationnumber
            MTOW(i) = WTO;        
            [P_max, P_avg, P_cruise, Vstl, VLO, Vcr, M, CLopt, ROC, LD] = power_2(h, WTO, CD0, S, A, ffEndCruise);
            [WTO, OEW, S, ffBeginCruise, ffEndCruise, jet] = Class1EstFunc(concept, M, LD, refDataWeights, refDataS);
            iterations(i) = i;
        end
    end

    [taper, sweep, c_r, c_t, c_mac, b] = planform (M, S, A);
data(j,2) = OEW;
data(j,3) = WTO;
data(j,4) = S;
data(j,5) = A;
data(j,6) = b;
data(j,7) = c_mac;
data(j,8) = c_r;
data(j,9) = M;
data(j,10) = Vcr;
data(j,11) = h;
data(j,12) = CLopt;
data(j,13) = sweep;
data(j,14) = taper;
if jet
    data(j,15) = Tto/1000;
    data(j, 16) = Tto/(9.80665*WTO);
    [TW] = TakeOff(S, WTO);
    Tto = TW*WTO*9.80665;
    data(j,17) = Tto/1000;
    data(j, 18) = Tto/(9.80665*WTO);
else
    data(j,15) = P_max/1000;
data(j,19) = VLO;
data(j,20) = Vstl;
end
end
text = {'concept', 'OEW', 'WTO', 'S', 'A', 'b', 'c_mac', 'c_r', 'M', 'Vcr', 'h', 'CLopt','Sweep', 'Taper', 'T or P Lower Bound', 'T/W Lower Bound', 'T or P Upper Bound', 'T/W Upper Bound', 'V Lift Off', 'V Stall'};
xlswrite('Results.xlsx',data)
