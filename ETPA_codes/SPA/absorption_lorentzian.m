%clear;
spectra = 1; % Set to 1 for Absorption Spectra
             % Set to 2 for Transient Absorption Spectra
steps = 10000; % Defines number of \Delta E steps
Xmin = 0; % Energy range minimum to calculate absorption spectra in eV
Xmax = 10; % Energy range maximum to calculate absorption spectra in eV
GAMMA = 0.1; % Broadening Factor

files=dir('*.mlab');
for i=1:numel(files)
    file=strsplit(files(i).name,'.');
    iinit=strsplit(char(file(1)),'_');
    init(i)=iinit(1);
    prefix(i)=file(1);
end
%prefix=[prefix 'B3LYP_tddft' 'B3LYP_G_tddft'];init=[init 'B3LYP' 'B3LYP_G'];
clear files;clear file;clear iinit;
%halt

for k=1:numel(prefix)
    prefix2=prefix(k);
    filename = [char(prefix2) '.mlab'];
    data1 = load(filename);

    energy=[];os_str=[];
    if spectra == 1
        for i=1:numel(data1(:,1))
            if data1(i,1) == 0
                energy = [energy data1(i,4)];
                os_str = [os_str data1(i,6)];
            end
        end
    elseif spectra == 2
        for i=1:numel(data1(:,1))
            energy = [energy data1(i,4)];
            os_str = [os_str data1(i,6)];
        end
    else
        error('spectra must be set to either 1 or 2');
    end

    dx = (Xmax-Xmin)/steps;
    for i=1:steps
        x_ev(i) = Xmin+(dx*i);
    end

    for j=1:steps
        polar=0;
        for i=1:numel(energy)
            polar=polar+os_str(i)/((energy(i)^2)-(x_ev(j)+1i*GAMMA)^2);
        end
        refract(j)=real(polar);
        absorp(j)=imag(polar);
    end

    abs_spectra = [x_ev' absorp'];
    filename2 = ['spectrum_' char(init(k))];
    save(filename2,'abs_spectra','-ascii');

    %exp=load('rhodamine_b_exp_abs.dat');

    figure;
    plot(x_ev,absorp,'b-','linewidth',2);
    %axis([-.005 .31 -.5 5]); 
    %axis([-5 4 0 3.1]);
    set(gca,'FontSize',24);
    xlabel('Energy (eV)'); 
    ylabel('Absorption');

    figure;
    plot(1239.841984./x_ev,absorp,'b-','linewidth',2);
    axis([200 1250 0 inf]);
    ylim tickaligned;
    set(gca,'FontSize',24);
    xlabel('Wavelength (nm)'); 
    ylabel('Absorption');
end
%{
figure;
plot(1239.841984./x_ev,absorp/max(absorp),'b-','linewidth',2);
hold on;
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2); 
axis([200 1250 0 1.02]);
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Normalized Absorption');
xline(410,'-.','410 nm','LineWidth',2,'HandleVisibility','off');
%}
