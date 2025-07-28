% Change the value for prefix to the name used for
% the ORCA calculation (eg 'mol' for mol.inp)
prefix = 'PBE_tddft';

Sgrid=0.5:.0004:5.5; % Enter in eV 
%Sgrid=[];
Igrid=0.5:.0004:2.1; % Enter in eV 
%Egrid=Sgrid'+Igrid;
Rgrid=zeros(numel(Sgrid),numel(Igrid));
Agrid=zeros(numel(Sgrid),numel(Igrid));

% Enter values for variables
% Frequency of pump and idler should be given in nanometers
% Entanglement times should be given in seconds
Tent = 1e-13;   % Entanglement time in seconds
epsilons = [1; 0; 0];   % Polarization vector for signal
epsiloni = [1; 0; 0];   % Polarization vector for idler
iGAMMA = 0.1; % phenomenological dephasing parameter
              % More in depth tuning of dephasing matrix can be done
              % in line 28

file1 = [prefix '.mat'];
load(file1);  % Loads in MU (transition dipole matrix) and EIG (eigenenergies)

% Converts energy in nm and time in seconds to atomic units
Tent = Tent/2.4188843265864e-17;
iGAMMA = iGAMMA/27.211386245981;

GAMMA = [0.0, repelem(iGAMMA, length(EIG) - 1)]';  % phenomenological dephasing parameter matrix
a=numel(Igrid);b=numel(Sgrid);
parfor j=1:numel(Sgrid)
for i=1:a
    cycle=['Signal Frequency = ' num2str(Sgrid(j)) ' eV   Idler Frequency = ' num2str(Igrid(i)) ' eV']

omegap = Igrid(i)+Sgrid(j);  % Pump frequency in nm/eV
avgomegai = Igrid(i);   % Central frequency of idler in nm/eV
%omegap = 45.563352529132/omegap; % Convert nm to Eh
omegap = omegap/27.211386245981; % Convert eV to Eh
%avgomegai = 45.563352529132/avgomegai; % Convert nm to Eh
avgomegai = avgomegai/27.211386245981; % Convert eV to Eh

S= etpa(omegap,avgomegai,Tent,epsilons,epsiloni,EIG,MU,GAMMA);

Rgrid(j,i)=real(S);
Agrid(j,i)=imag(S);

%if j==3;halt;end

end
end
%{
figure;
mesh(Egrid,Igrid,Rgrid');
axis([1 13 0.5 6.5]);view(2);
set(gca,'FontSize',24);
xlabel('Pump Wavelength (eV)'); 
ylabel('Idler Wavelength (eV)');
cb=colorbar();
ylabel(cb,'Absorption','Rotation',270);
%}
figure;
mesh(Sgrid,Igrid,Rgrid');
xlim tight; ylim tight;view(2);
set(gca,'FontSize',24);
xlabel('Signal Energy (eV)'); 
ylabel('Idler Energy (eV)');
cb=colorbar();
ylabel(cb,'Absorption','Rotation',270);
if max(max(Rgrid))>=1000;ax=gca;ax.OuterPosition=[0 0 0.971428571428572 1];end

Rgrid=[Igrid
       Rgrid];
Engrid=[0 Sgrid]';
Rgrid=[Engrid Rgrid];
Agrid=[Igrid
       Agrid];
Agrid=[Engrid Agrid];

filename='sRgrid_i2_1-s5_5'; %filename=['Rgrid_' num2str(Egrid(j))];
save(filename,'Rgrid','-ascii')
filename='sAgrid_i2_1-s5_5'; %filename=['Agrid_' num2str(Egrid(j))];
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
