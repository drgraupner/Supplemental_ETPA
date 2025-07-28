% Change the value for prefix to the name used for
% the ORCA calculation (eg 'mol' for mol.inp)
prefix = 'PBE_tddft';

Igrid=1:.0005:3; % Enter value for Idler in nm or eV.
           % Comment out the next line if entered in eV.
%Igrid=1239.841984./Igrid; % Converts nm to eV
Rgrid=zeros(numel(Igrid),1);
Agrid=zeros(numel(Igrid),1);

% Enter values for variables
% Frequency of pump and idler should be given in nanometers
% Entanglement times should be given in seconds
Tent = 1e-13;   % Entanglement time in seconds
epsilons = [1; 0; 0];   % Polarization vector for signal
epsiloni = [0; 1; 0];   % Polarization vector for idler
iGAMMA = .1; % phenomenological dephasing parameter
              % More in depth tuning of dephasing matrix can be done
              % in line 28

file1 = [prefix '.mat'];
load(file1);  % Loads in MU (transition dipole matrix) and EIG (eigenenergies)

% Converts energy in nm and time in seconds to atomic units
Tent = Tent/2.4188843265864e-17; % Conversion of Time to Atomic Units
%Tent = Tent/6.582119569e-16; % Conversion of Time to Natural Units
iGAMMA = iGAMMA/27.211386245981; % Conversion of GAMMA to Atomic Units

GAMMA = [0.0, repelem(iGAMMA, length(EIG) - 1)]';  % phenomenological dephasing parameter matrix
a=numel(Igrid);%b=numel(Egrid);

for i=1:a
    cycle=['Pump Frequency = ' num2str(2*Igrid(i)) ' nm   Idler Frequency = ' num2str(Igrid(i)) ' nm']

omegap = 2*Igrid(i);  % Pump frequency in nm
avgomegai = Igrid(i);   % Central frequency of idler in nm
omegap = omegap/27.211386245981; % Conversion of Pump Frequency to 
                                 % Atomic Units
avgomegai = avgomegai/27.211386245981; %Conversion of Idler Frequency to
                                       % Atomic Units
%omegap = 45.563352529132/omegap; % Conversion of Pump Frequency to 
                                 % Atomic Units
%avgomegai = 45.563352529132/avgomegai; %Conversion of Idler Frequency to
                                       % Atomic Units
%omegap = 1239.841984/omegap; % Conversion of Pump Frequency to 
                             % Natural Units
%avgomegai = 1239.841984/avgomegai; %Conversion of Idler Frequency to
                                   % Natural Units

S= etpa(omegap,avgomegai,Tent,epsilons,epsiloni,EIG,MU,GAMMA);

Rgrid(i)=real(S);
Agrid(i)=imag(S);

%if i==4;halt;end

end


FFgrid=fft(Agrid);
Rgrid=[Igrid' Rgrid];
%Engrid=[0 Egrid]';
%Rgrid=[Engrid Rgrid];
Agrid=[Igrid' Agrid];
%Agrid=[Engrid Agrid];

filename='Rgrid_symmetric_per'; %filename=['Rgrid_' num2str(Egrid(j))];
save(filename,'Rgrid','-ascii')
filename='Agrid_symmetric_per'; %filename=['Agrid_' num2str(Egrid(j))];
save(filename,'Agrid','-ascii')

%{
figure(Position=[1 1 1000 1000]); %Figure 16
hold on
for j=1:numel(Igrid)
    filename=['Sgrid_' num2str(Igrid(j))];
    legendname=[num2str(Igrid(j)) ' nm'];
    Sgrid=load(filename);
plot(Egrid,Sgrid,'linewidth',2,'DisplayName',legendname);
end
xlim tight
ylim padded
lgd = legend;
lgd.NumColumns = 2;
title(lgd,'Idler Energy');
legend('boxoff');
xline(410,'-.','410 nm','LineWidth',2,'HandleVisibility','off');
legend('Location','eastoutside');
%axis([200 1250 0 inf]);
set(gca,'FontSize',24);
xlabel('Probe Wavelength (nm)'); 
ylabel('Absorption Probablity');
%}
figure;hold on;
plot(Igrid,Rgrid(:,2),'b-','linewidth',2);
axis([1 2.3 0 inf]);
ylim tickaligned; %tight;
set(gca,'FontSize',24);
xlabel('Idler Energy (eV)'); 
ylabel('Absorption');
%{
figure;hold on;
plot(Igrid,Rgrid(2,2:end),'b-','linewidth',2);
axis([450 1250 0 inf]);
ylim tickaligned; %tight;
set(gca,'FontSize',24);
xlabel('Idler Wavelength (nm)'); 
ylabel('Absorption');
text(1000,5000,"Pump Wavelength = 405nm","FontSize",20)
{
figure;
plot(Igrid,Agrid(2,2:end),'b-','linewidth',2);
axis([200 1250 0 inf]);
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Absorption');
%}