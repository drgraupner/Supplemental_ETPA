B3LYP=load('spectrum_B3LYP');
B3LYP_G=load('spectrum_B3LYP_G');
B97MD4=load('spectrum_B97M-D4');
BLYP=load('spectrum_BLYP');
CAMB3LYP=load('spectrum_CAM-B3LYP');
HFS=load('spectrum_HFS');
M06=load('spectrum_M06');
M06L=load('spectrum_M06L');
M062X=load('spectrum_M062X');
M11L=load('spectrum_M11-L');
MN12L=load('spectrum_MN12-L');
%MN12SX=load('spectrum_MN12-SX');
MN15=load('spectrum_MN15');
MN15L=load('spectrum_MN15-L');
PBE=load('spectrum_PBE');PBEv=load('spectrum_PBE_vacuum');
PBE0=load('spectrum_PBE0');
%revM06L=load('spectrum_revM06-L');
revM11=load('spectrum_revM11');
REVPBE=load('spectrum_REVPBE');
REVPBE0=load('spectrum_REVPBE0');
TPSS=load('spectrum_TPSS');
TPSS0=load('spectrum_TPSS0');
TPSSh=load('spectrum_TPSSh');
wB97=load('spectrum_wB97');
wB97X=load('spectrum_wB97X');
wB97MD4=load('spectrum_wB97M-D4');
exp=load('rhodamine_b_exp_abs.dat');
flu=load('fluorescence');

figure; %Figure 3 LDA/GGA eV Normalized Absorption with Experiment
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'b--','linewidth',2,'DisplayName','Absorption');
hold on;
plot(flu(:,1),flu(:,2)/max(flu(:,2)),'r--','linewidth',2,'DisplayName','Fluorescence');
%plot(BLYP(:,1),BLYP(:,2)/max(BLYP(:,2)),'-','linewidth',2,'DisplayName','BLYP','Color','#D95319');
%plot(PBE(:,1),PBE(:,2)/max(PBE(:,2)),'--','linewidth',2,'DisplayName','Ethanol','Color','#0072BD');
%plot(PBEv(:,1),PBEv(:,2)/max(PBEv(:,2)),'-','linewidth',2,'DisplayName','Vacuum','Color','#D95319');
%axis([2 6 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Normalized Absorption');
halt
figure; %Figure 1 LDA/GGA eV Absorption
plot(HFS(:,1),HFS(:,2),'-','linewidth',2,'DisplayName','HFS','Color','#0072BD');
hold on;
plot(BLYP(:,1),BLYP(:,2),'-','linewidth',2,'DisplayName','BLYP','Color','#D95319');
plot(PBE(:,1),PBE(:,2),'-','linewidth',2,'DisplayName','PBE','Color','#EDB120');
plot(REVPBE(:,1),REVPBE(:,2),'-','linewidth',2,'DisplayName','REVPBE','Color','#7E2F8E');
%axis([-.005 .31 -.5 5]); 
axis([2 6 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Absorption');

figure; %Figure 2 LDA/GGA nm Absorption
plot(1239.841984./HFS(:,1),HFS(:,2),'-','linewidth',2,'DisplayName','HFS','Color','#0072BD');
hold on;
plot(1239.841984./BLYP(:,1),BLYP(:,2),'-','linewidth',2,'DisplayName','BLYP','Color','#D95319');
plot(1239.841984./PBE(:,1),PBE(:,2),'-','linewidth',2,'DisplayName','PBE','Color','#EDB120');
plot(1239.841984./REVPBE(:,1),REVPBE(:,2),'-','linewidth',2,'DisplayName','REVPBE','Color','#7E2F8E');
axis([200 650 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Absorption');

figure; %Figure 3 LDA/GGA eV Normalized Absorption with Experiment
plot(1239.841984./exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(HFS(:,1),HFS(:,2)/max(HFS(:,2)),'-','linewidth',2,'DisplayName','HFS','Color','#0072BD');
plot(BLYP(:,1),BLYP(:,2)/max(BLYP(:,2)),'-','linewidth',2,'DisplayName','BLYP','Color','#D95319');
plot(PBE(:,1),PBE(:,2)/max(PBE(:,2)),'-','linewidth',2,'DisplayName','PBE','Color','#EDB120');
plot(REVPBE(:,1),REVPBE(:,2)/max(REVPBE(:,2)),'-','linewidth',2,'DisplayName','REVPBE','Color','#7E2F8E');
axis([2 6 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Normalized Absorption');

figure; %Figure 4 LDA/GGA nm Normalized Absorption with Experiment
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(1239.841984./HFS(:,1),HFS(:,2)/max(HFS(:,2)),'-','linewidth',2,'DisplayName','HFS','Color','#0072BD');
plot(1239.841984./BLYP(:,1),BLYP(:,2)/max(BLYP(:,2)),'-','linewidth',2,'DisplayName','BLYP','Color','#D95319');
plot(1239.841984./PBE(:,1),PBE(:,2)/max(PBE(:,2)),'-','linewidth',2,'DisplayName','PBE','Color','#EDB120');
plot(1239.841984./REVPBE(:,1),REVPBE(:,2)/max(REVPBE(:,2)),'-','linewidth',2,'DisplayName','REVPBE','Color','#7E2F8E');
axis([200 650 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Normalized Absorption');

figure; %Figure 5 Hybrid eV Absorption
plot(B3LYP(:,1),B3LYP(:,2),'-','linewidth',2,'DisplayName','B3LYP','Color','#0072BD');
hold on;
plot(B3LYP_G(:,1),B3LYP_G(:,2),'-','linewidth',2,'DisplayName','B3LYP/G','Color','#D95319');
plot(PBE0(:,1),PBE0(:,2),'-','linewidth',2,'DisplayName','PBE0','Color','#EDB120');
plot(REVPBE0(:,1),REVPBE0(:,2),'-','linewidth',2,'DisplayName','REVPBE0','Color','#7E2F8E');
%axis([-.005 .31 -.5 5]); 
axis([2 6 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Absorption');

figure; %Figure 6 Hybrid nm Absorption
plot(1239.841984./B3LYP(:,1),B3LYP(:,2),'-','linewidth',2,'DisplayName','B3LYP','Color','#0072BD');
hold on;
plot(1239.841984./B3LYP_G(:,1),B3LYP_G(:,2),'-','linewidth',2,'DisplayName','B3LYP/G','Color','#D95319');
plot(1239.841984./PBE0(:,1),PBE0(:,2),'-','linewidth',2,'DisplayName','PBE0','Color','#EDB120');
plot(1239.841984./REVPBE0(:,1),REVPBE0(:,2),'-','linewidth',2,'DisplayName','REVPBE0','Color','#7E2F8E');
axis([200 650 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Absorption');

figure; %Figure 7 Hybrid eV Normalized Absorption with Experiment
plot(1239.841984./exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(B3LYP(:,1),B3LYP(:,2)/max(B3LYP(:,2)),'-','linewidth',2,'DisplayName','B3LYP','Color','#0072BD');
plot(B3LYP_G(:,1),B3LYP_G(:,2)/max(B3LYP_G(:,2)),'-','linewidth',2,'DisplayName','B3LYP/G','Color','#D95319');
plot(PBE0(:,1),PBE0(:,2)/max(PBE0(:,2)),'-','linewidth',2,'DisplayName','PBE0','Color','#EDB120');
plot(REVPBE0(:,1),REVPBE0(:,2)/max(REVPBE0(:,2)),'-','linewidth',2,'DisplayName','REVPBE0','Color','#7E2F8E');
axis([2 6 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Normalized Absorption');

figure; %Figure 8 Hybrid nm Normalized Absorption with Experiment
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(1239.841984./B3LYP(:,1),B3LYP(:,2)/max(B3LYP(:,2)),'-','linewidth',2,'DisplayName','B3LYP','Color','#0072BD');
plot(1239.841984./B3LYP_G(:,1),B3LYP_G(:,2)/max(B3LYP_G(:,2)),'-','linewidth',2,'DisplayName','B3LYP/G','Color','#D95319');
plot(1239.841984./PBE0(:,1),PBE0(:,2)/max(PBE0(:,2)),'-','linewidth',2,'DisplayName','PBE0','Color','#EDB120');
plot(1239.841984./REVPBE0(:,1),REVPBE0(:,2)/max(REVPBE0(:,2)),'-','linewidth',2,'DisplayName','REVPBE0','Color','#7E2F8E');
axis([200 650 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Normalized Absorption');

figure; %Figure 9 Meta-GGA eV Absorption
plot(B97MD4(:,1),B97MD4(:,2),'-','linewidth',2,'DisplayName','B97M-D4','Color','#0072BD');
hold on;
plot(M06L(:,1),M06L(:,2),'-','linewidth',2,'DisplayName','M06-L','Color','#D95319');
plot(M11L(:,1),M11L(:,2),'-','linewidth',2,'DisplayName','M11-L','Color','#EDB120');
plot(MN12L(:,1),MN12L(:,2),'-','linewidth',2,'DisplayName','MN12-L','Color','#7E2F8E');
plot(MN15L(:,1),MN15L(:,2),'-','linewidth',2,'DisplayName','MN15-L','Color','#77AC30');
%plot(revM06L(:,1),revM06L(:,2),'-','linewidth',2,'DisplayName','revM06-L','Color','#4DBEEE');
plot(TPSS(:,1),TPSS(:,2),'-','linewidth',2,'DisplayName','TPSS','Color','#A2142F');
axis([2 6 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Absorption');

figure; %Figure 10 Meta-GGA nm Absorption
plot(1239.841984./B97MD4(:,1),B97MD4(:,2),'-','linewidth',2,'DisplayName','B97M-D4','Color','#0072BD');
hold on;
plot(1239.841984./M06L(:,1),M06L(:,2),'-','linewidth',2,'DisplayName','M06-L','Color','#D95319');
plot(1239.841984./M11L(:,1),M11L(:,2),'-','linewidth',2,'DisplayName','M11-L','Color','#EDB120');
plot(1239.841984./MN12L(:,1),MN12L(:,2),'-','linewidth',2,'DisplayName','MN12-L','Color','#7E2F8E');
plot(1239.841984./MN15L(:,1),MN15L(:,2),'-','linewidth',2,'DisplayName','MN15-L','Color','#77AC30');
%plot(1239.841984./revM06L(:,1),revM06L(:,2),'-','linewidth',2,'DisplayName','revM06-L','Color','#4DBEEE');
plot(1239.841984./TPSS(:,1),TPSS(:,2),'-','linewidth',2,'DisplayName','TPSS','Color','#A2142F');
axis([200 650 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Absorption');

figure; %Figure 11 Meta-GGA eV Normalized Absorption with Experiment
plot(1239.841984./exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(B97MD4(:,1),B97MD4(:,2)/max(B97MD4(:,2)),'-','linewidth',2,'DisplayName','B97M-D4','Color','#0072BD');
plot(M06L(:,1),M06L(:,2)/max(M06L(:,2)),'-','linewidth',2,'DisplayName','M06-L','Color','#D95319');
plot(M11L(:,1),M11L(:,2)/max(M11L(:,2)),'-','linewidth',2,'DisplayName','M11-L','Color','#EDB120');
plot(MN12L(:,1),MN12L(:,2)/max(MN12L(:,2)),'-','linewidth',2,'DisplayName','MN12-L','Color','#7E2F8E');
plot(MN15L(:,1),MN15L(:,2)/max(MN15L(:,2)),'-','linewidth',2,'DisplayName','MN15-L','Color','#77AC30');
%plot(revM06L(:,1),revM06L(:,2)/max(revM06L(:,2)),'-','linewidth',2,'DisplayName','revM06-L','Color','#4DBEEE');
plot(TPSS(:,1),TPSS(:,2)/max(TPSS(:,2)),'-','linewidth',2,'DisplayName','TPSS','Color','#A2142F');
axis([2 6 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Normalized Absorption');

figure; %Figure 12 Meta-GGA nm Normalized Absorption with Experiment
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(1239.841984./B97MD4(:,1),B97MD4(:,2)/max(B97MD4(:,2)),'-','linewidth',2,'DisplayName','B97M-D4','Color','#0072BD');
plot(1239.841984./M06L(:,1),M06L(:,2)/max(M06L(:,2)),'-','linewidth',2,'DisplayName','M06-L','Color','#D95319');
plot(1239.841984./M11L(:,1),M11L(:,2)/max(M11L(:,2)),'-','linewidth',2,'DisplayName','M11-L','Color','#EDB120');
plot(1239.841984./MN12L(:,1),MN12L(:,2)/max(MN12L(:,2)),'-','linewidth',2,'DisplayName','MN12-L','Color','#7E2F8E');
plot(1239.841984./MN15L(:,1),MN15L(:,2)/max(MN15L(:,2)),'-','linewidth',2,'DisplayName','MN15-L','Color','#77AC30');
%plot(1239.841984./revM06L(:,1),revM06L(:,2)/max(revM06L(:,2)),'-','linewidth',2,'DisplayName','revM06-L','Color','#4DBEEE');
plot(1239.841984./TPSS(:,1),TPSS(:,2)/max(TPSS(:,2)),'-','linewidth',2,'DisplayName','TPSS','Color','#A2142F');
axis([200 650 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Normalized Absorption');

figure; %Figure 13 Hybrid Meta-GGA eV Absorption
plot(M06(:,1),M06(:,2),'-','linewidth',2,'DisplayName','M06','Color','#0072BD');
hold on;
plot(M062X(:,1),M062X(:,2),'-','linewidth',2,'DisplayName','M06-2X','Color','#D95319');
%plot(MN12SX(:,1),MN12SX(:,2),'-','linewidth',2,'DisplayName','MN12-SX','Color','#EDB120');
plot(MN15(:,1),MN15(:,2),'-','linewidth',2,'DisplayName','MN15','Color','#7E2F8E');
plot(revM11(:,1),revM11(:,2),'-','linewidth',2,'DisplayName','revM11','Color','#77AC30');
plot(TPSS0(:,1),TPSS0(:,2),'-','linewidth',2,'DisplayName','TPSS0','Color','#4DBEEE');
plot(TPSSh(:,1),TPSSh(:,2),'-','linewidth',2,'DisplayName','TPSSh','Color','#A2142F');
axis([2 6 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Absorption');

figure; %Figure 14 Hybrid Meta-GGA nm Absorption
plot(1239.841984./M06(:,1),M06(:,2),'-','linewidth',2,'DisplayName','M06','Color','#0072BD');
hold on;
plot(1239.841984./M062X(:,1),M062X(:,2),'-','linewidth',2,'DisplayName','M06-2X','Color','#D95319');
%plot(1239.841984./MN12SX(:,1),MN12SX(:,2),'-','linewidth',2,'DisplayName','MN12-SX','Color','#EDB120');
plot(1239.841984./MN15(:,1),MN15(:,2),'-','linewidth',2,'DisplayName','MN15','Color','#7E2F8E');
plot(1239.841984./revM11(:,1),revM11(:,2),'-','linewidth',2,'DisplayName','revM11','Color','#77AC30');
plot(1239.841984./TPSS0(:,1),TPSS0(:,2),'-','linewidth',2,'DisplayName','TPSS0','Color','#4DBEEE');
plot(1239.841984./TPSSh(:,1),TPSSh(:,2),'-','linewidth',2,'DisplayName','TPSSh','Color','#A2142F');
axis([200 650 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Absorption');

figure; %Figure 15 Hybrid Meta-GGA eV Normalized Absorption with Experiment
plot(1239.841984./exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(M06(:,1),M06(:,2)/max(M06(:,2)),'-','linewidth',2,'DisplayName','M06','Color','#0072BD');
plot(M062X(:,1),M062X(:,2)/max(M062X(:,2)),'-','linewidth',2,'DisplayName','M06-2X','Color','#D95319');
%plot(MN12SX(:,1),MN12SX(:,2)/max(MN12SX(:,2)),'-','linewidth',2,'DisplayName','MN12-SX','Color','#EDB120');
plot(MN15(:,1),MN15(:,2)/max(MN15(:,2)),'-','linewidth',2,'DisplayName','MN15','Color','#7E2F8E');
plot(revM11(:,1),revM11(:,2)/max(revM11(:,2)),'-','linewidth',2,'DisplayName','revM11','Color','#77AC30');
plot(TPSS0(:,1),TPSS0(:,2)/max(TPSS0(:,2)),'-','linewidth',2,'DisplayName','TPSS0','Color','#4DBEEE');
plot(TPSSh(:,1),TPSSh(:,2)/max(TPSSh(:,2)),'-','linewidth',2,'DisplayName','TPSSh','Color','#A2142F');
axis([2 6 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Normalized Absorption');

figure; %Figure 16 Hybrid Meta-GGA nm Normalized Absorption with Experiment
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(1239.841984./M06(:,1),M06(:,2)/max(M06(:,2)),'-','linewidth',2,'DisplayName','M06','Color','#0072BD');
plot(1239.841984./M062X(:,1),M062X(:,2)/max(M062X(:,2)),'-','linewidth',2,'DisplayName','M06-2X','Color','#D95319');
%plot(1239.841984./MN12SX(:,1),MN12SX(:,2)/max(MN12SX(:,2)),'-','linewidth',2,'DisplayName','MN12-SX','Color','#EDB120');
plot(1239.841984./MN15(:,1),MN15(:,2)/max(MN15(:,2)),'-','linewidth',2,'DisplayName','MN15','Color','#7E2F8E');
plot(1239.841984./revM11(:,1),revM11(:,2)/max(revM11(:,2)),'-','linewidth',2,'DisplayName','revM11','Color','#77AC30');
plot(1239.841984./TPSS0(:,1),TPSS0(:,2)/max(TPSS0(:,2)),'-','linewidth',2,'DisplayName','TPSS0','Color','#4DBEEE');
plot(1239.841984./TPSSh(:,1),TPSSh(:,2)/max(TPSSh(:,2)),'-','linewidth',2,'DisplayName','TPSSh','Color','#A2142F');
axis([200 650 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Normalized Absorption');

figure; %Figure 17 Range Separated Hybrid eV Absorption
plot(CAMB3LYP(:,1),CAMB3LYP(:,2),'-','linewidth',2,'DisplayName','CAM-B3LYP','Color','#0072BD');
hold on;
plot(wB97(:,1),wB97(:,2),'-','linewidth',2,'DisplayName','\omegaB97','Color','#D95319');
plot(wB97MD4(:,1),wB97MD4(:,2),'-','linewidth',2,'DisplayName','\omegaB97M-D4','Color','#EDB120');
plot(wB97X(:,1),wB97X(:,2),'-','linewidth',2,'DisplayName','\omegaB97X','Color','#7E2F8E');
axis([2 6 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Absorption');

figure; %Figure 18 Range Separated Hybrid nm Absorption
plot(1239.841984./CAMB3LYP(:,1),CAMB3LYP(:,2),'-','linewidth',2,'DisplayName','CAM-B3LYP','Color','#0072BD');
hold on;
plot(1239.841984./wB97(:,1),wB97(:,2),'-','linewidth',2,'DisplayName','\omegaB97','Color','#D95319');
plot(wB97MD4(:,1),wB97MD4(:,2),'-','linewidth',2,'DisplayName','\omegaB97M-D4','Color','#EDB120');
plot(1239.841984./wB97X(:,1),wB97X(:,2),'-','linewidth',2,'DisplayName','\omegaB97X','Color','#7E2F8E');
axis([200 650 0 3]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Absorption');

figure; %Figure 19 Range Separated Hybrid eV Normalized Absorption with Experiment
plot(1239.841984./exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(CAMB3LYP(:,1),CAMB3LYP(:,2)/max(CAMB3LYP(:,2)),'-','linewidth',2,'DisplayName','CAM-B3LYP','Color','#0072BD');
plot(wB97(:,1),wB97(:,2)/max(wB97(:,2)),'-','linewidth',2,'DisplayName','\omegaB97','Color','#D95319');
plot(wB97MD4(:,1),wB97MD4(:,2)/max(wB97MD4(:,2)),'-','linewidth',2,'DisplayName','\omegaB97M-D4','Color','#EDB120');
plot(wB97X(:,1),wB97X(:,2)/max(wB97X(:,2)),'-','linewidth',2,'DisplayName','\omegaB97X','Color','#7E2F8E');
axis([2 6 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
set(gca,'FontSize',24);
xlabel('Energy (eV)'); 
ylabel('Normalized Absorption');

figure; %Figure 12 Meta-GGA nm Normalized Absorption with Experiment
plot(exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
hold on;
plot(1239.841984./CAMB3LYP(:,1),CAMB3LYP(:,2)/max(CAMB3LYP(:,2)),'-','linewidth',2,'DisplayName','CAM-B3LYP','Color','#0072BD');
plot(1239.841984./wB97(:,1),wB97(:,2)/max(wB97(:,2)),'-','linewidth',2,'DisplayName','\omegaB97','Color','#D95319');
plot(1239.841984./wB97MD4(:,1),wB97MD4(:,2)/max(wB97MD4(:,2)),'-','linewidth',2,'DisplayName','\omegaB97M-D4','Color','#EDB120');
plot(1239.841984./wB97X(:,1),wB97X(:,2)/max(wB97X(:,2)),'-','linewidth',2,'DisplayName','\omegaB97X','Color','#7E2F8E');
axis([200 650 0 1.1]);
lgd = legend;
%lgd.NumColumns=2;
legend('Location','best');
legend('boxoff');
%ylim tickaligned;
set(gca,'FontSize',24);
xlabel('Wavelength (nm)'); 
ylabel('Normalized Absorption');