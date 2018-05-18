function [WTO, OEW, S, ffBeginCruise, ffEndCruise] = Class1EstFunc(concept, M, LD, refDataWeights, refDataS, sfc)

g = 9.81;

refDataWeights = transpose(refDataWeights);

if nargin < 5
    error('fuck you are stupid')
end

if nargin > 6
    error('fuck you are stupid')
end

if concept == 2
    
    jet = true;
    refdata = [9:24 27 29:32];
    refdataS = [9:17 19:24 27 29:32];
    
elseif concept == 1
    
    jet = false;
    refdata = [1:8 25 26 28 33 34];
    refdataS = [1:8 25 26 28 33 34];
    
else 
    error('fuck you are stupid')    
end

if jet
    
    % Class I weight estimation based on lecture slides from AE1222-II
    
    % Read ref. Aircraft Data
    
    % Regression for OEW as a function of MTOW for jets
    
    MTOW = transpose(refDataWeights(refdata,1));
    OEW = transpose(refDataWeights(refdata,3));
    
    X = [ones(length(MTOW), 1) transpose(MTOW)];
    b = (X)\transpose(OEW);
    
    %% Regression for S as a function of W for jets
    
    S = (refDataS(refdataS));
    W = transpose(refDataWeights(refdataS,1));
    
    % bws1 = W/S;
    
    X1 = [ones(length(W), 1) transpose(W)];
    bws = (X1)\transpose(S);
    
    
    %%
    
    % fuel fractions
    
    enginestart = 0.990;
    taxi = 0.990;
    takeoff = 0.995;
    climb = 0.980;
    descent = 0.990;
    landing = 0.995;
    
    %% fuel fractions for cruise and loiter are determined with brequet
    
    range1 = 2500000; %in meters
    range2 = 300; %alternate in meters
    enduranceLoiter = 1800; %loiter time in seconds
    LDjetmax = 17;
    LDjetcruise = LD;
    cj = 0.7;
    cj = cj*0.4536*(1/(4.45*3600));
    if nargin > 5
        cj = sfc;
    end
    
    %% speeds
    
    cruisespeedM = M;
    cruisealt = 35000; % in feet
    cruisetempK = 273+15-1.98*(cruisealt/1000); % in degrees
    cruisesos = sqrt(1.4*288.05*cruisetempK);
    mach2velcruise = cruisespeedM*cruisesos;
    
    %% Payload
    
    pax = 75; % number of passengers
    weightPerPax = 92; % in kg
    payloadWeight = pax*weightPerPax;
    
    %% cruise fuel for jet
    
    ffcruise1jet = exp(range1/((mach2velcruise/(g*cj))*(LDjetcruise)));
    
    ffcruise2jet = exp(range2/((mach2velcruise/(g*cj))*(LDjetcruise)));
    
    ffloiterjet = exp(enduranceLoiter/((1/(g*cj))*(LDjetmax)));
    
    % total fuel fractions for jet then becomes:
    
    mffjet = enginestart*taxi*takeoff*climb*(1/ffcruise1jet)*descent*climb*(1/ffcruise2jet)*descent*(1/ffloiterjet)*landing;
    
    
    %% Takeoffweight is then for jet
    
    WTOjet = (b(1) + payloadWeight)/(1-(b(2)+(1-mffjet)+0.001));
    
    %%
    
    fueljet = (1-mffjet)*WTOjet;
    
    %% determining max fuel as function of MTOW
    
    MTOW2 = transpose(refDataWeights([10 16 17 19 27 29:32],1));
    MFW = transpose(refDataWeights([10 16 17 19 27 29:32],6));
    
    % b12 = MTOW2/MFW;
    
    X2 = [ones(length(MTOW2), 1) transpose(MTOW2)];
    b2 = (X2)\transpose(MFW);
    
    mffjetnocruise = enginestart*taxi*takeoff*climb*descent*climb*(1/ffcruise2jet)*descent*(1/ffloiterjet)*landing;
    
    ffnocruise = 1-mffjetnocruise;
    
    fuelnocruise = ffnocruise*WTOjet;
    
    totfuelmax = (b2(1) + b2(2)*WTOjet);
    
    fuelcruise = totfuelmax-fuelnocruise;
    
    ffcruise = fuelcruise/WTOjet;
    
    Rangejetmaxfuel = (mach2velcruise/(g*cj))*(LDjetcruise)*log(1/(1-ffcruise));
    
    %%
    
    paxnumjetmaxfuel = pax - (totfuelmax-fueljet)/92;
    
    %% no payload
    
    WTOjetnp = WTOjet - (paxnumjetmaxfuel*92);
    
    
    
    mffjetnocruise = enginestart*taxi*takeoff*climb*descent*climb*(1/ffcruise2jet)*descent*(1/ffloiterjet)*landing;
    
    ffnocruise = 1-mffjetnocruise;
    
    fuelnocruisenp = ffnocruise*WTOjetnp;
    
    totfuelmaxnp = totfuelmax;
    
    fuelcruisenp = totfuelmaxnp-fuelnocruisenp;
    
    ffcruisenp = fuelcruisenp/WTOjetnp;
    
    Rangejetmaxfuelnp = (mach2velcruise/(g*cj))*(LDjetcruise)*log(1/(1-ffcruisenp));
    
    
    %% Function outputs
    
    S = (bws(1) + bws(2).*WTOjet);
    WTO = WTOjet;
    OEW = b(1)+b(2)*WTOjet;
    ffBeginCruise = enginestart*taxi*takeoff*climb;
    ffEndCruise = enginestart*taxi*takeoff*climb*(1/ffcruise1jet);
    
end

if jet == false
    
    % Class I weight estimation based on lecture slides from AE1222-II
    
    % Read ref. Aircraft Data
    
    %% Regression for S as a function of W for jets
    
    S = (refDataS(refdataS));
    W = transpose(refDataWeights(refdataS,1));
        
    X1 = [ones(length(W), 1) transpose(W)];
    bws = (X1)\transpose(S);

        
    %% Fuel fractions
    
    % for props
    
    enginestartp = 0.990;
    taxip = 0.995;
    takeoffp = 0.995;
    climbp = 0.985;
    descentp = 0.985;
    landingp = 0.995;
    
    %% fuel fractions for cruise and loiter are determined with brequet
    
    range1 = 2000000; %in meters
    range2 = 300; %alternate in meters
    enduranceLoiter = 1800; %loiter time in seconds
    LDpropmax = 15;
    LDpropcruise = 12;
    cp = 0.4;
    cp = cp*(0.4536)*(1/(735.5*3600));
    np = 0.85;
    if nargin > 5
        cp = sfc;
    end
    
    %% Payload
    
    pax = 70; % number of passengers
    weightPerPax = 92; % in kg
    payloadWeight = pax*weightPerPax;
    
    %% speeds
    
    cruisealtp = 25000; % in feet
    cruisetempKp = 273+15-1.98*(cruisealtp/1000); % in degrees
    cruisesosp = sqrt(1.4*288.05*cruisetempKp);
    mach2velcruiseprop = M*cruisesosp;
    
    
    %% for props
    
    % Regression for OEW as a function of MTOW for props

    MTOWp = transpose(refDataWeights(refdata,1));
    OEWp = transpose(refDataWeights(refdata,3));

        
    Xp = [ones(length(MTOWp), 1) transpose(MTOWp)];
    bp = (Xp)\transpose(OEWp);
    
    %% cruise fuel for prop
    
    ffcruise1prop = exp(range1/((np/(g*cp))*(LDpropcruise)));
    
    ffcruise2prop = exp(range2/((np/(g*cp))*(LDpropcruise)));
    
    ffloiterprop = exp(enduranceLoiter/((np/(mach2velcruiseprop*g*cp))*(LDpropmax)));
    
    % total fuel fractions for prop then becomes:
    
    mffprop = enginestartp*taxip*takeoffp*climbp*(1/ffcruise1prop)*descentp*climbp*(1/ffcruise2prop)*descentp*(1/ffloiterprop)*landingp;
    
    %% Takeoffweight is then for prop
    
    WTOprop = (bp(1) + payloadWeight)/(1-(bp(2)+(1-mffprop)+0.001));
    
    
    %% fueltotal

    fuelprop = (1-mffprop)*WTOprop;
    
        
    %% determining max fuel as function of MTOW
    
    MTOW2p = transpose(refDataWeights(refdata,1));
    MFWp = transpose(refDataWeights(refdata,6));
        
    X2p = [ones(length(MTOW2p), 1) transpose(MTOW2p)];
    b2p = (X2p)\transpose(MFWp);
    
    mffpropnocruise = enginestartp*taxip*takeoffp*climbp*descentp*climbp*(1/ffcruise2prop)*descentp*(1/ffloiterprop)*landingp;
    
    ffnocruisep = 1-mffpropnocruise;
    
    fuelnocruisep = ffnocruisep*WTOprop;
    
    totfuelmaxp = (b2p(1) + b2p(2)*WTOprop);
    
    fuelcruisep = totfuelmaxp-fuelnocruisep;
    
    ffcruisep = fuelcruisep/WTOprop;
    
    Rangepropmaxfuel = (np/(g*cp))*(LDpropcruise)*log(1/(1-ffcruisep));
    
    %%
    
    paxnumpropmaxfuel = pax - (totfuelmaxp-fuelprop)/92;
    
    % no payload
    
    WTOpropnp = WTOprop - (paxnumpropmaxfuel*92);
    
    
    
    mffpropnocruise = enginestartp*taxip*climbp*descentp*climbp*(1/ffcruise2prop)*descentp*(1/ffloiterprop)*landingp;
    
    ffnocruise = 1-mffpropnocruise;
    
    fuelnocruisenp = ffnocruise*WTOpropnp;
    
    totfuelmaxnp = (b2p(1) + b2p(2)*WTOpropnp);
    
    fuelcruisenp = totfuelmaxnp-fuelnocruisenp;
    
    ffcruisenp = fuelcruisenp/WTOpropnp;
    
    Rangepropmaxfuelnp = (np/(g*cp))*(LDpropcruise)*log(1/(1-ffcruisenp));
    
    %% function outputs
    
        %% Function outputs
    
    S = (bws(1) + bws(2).*WTOprop);
    WTO = WTOprop;
    OEW = bp(1)+bp(2)*WTOprop;
    ffBeginCruise = enginestartp*taxip*takeoffp*climbp;
    ffEndCruise = enginestartp*taxip*takeoffp*climbp*(1/ffcruise1prop);
    
    
end