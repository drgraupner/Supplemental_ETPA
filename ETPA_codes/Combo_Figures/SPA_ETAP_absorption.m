OPA_PBE=load("spectrum_PBE");
ETPA_PBE=load("Rgrid_symmetric_4");%ETPA(1,:)=[];
OPA_PBEv=load('spectrum_PBE_vacuum');
ETPA_PBEv=load("Rgrid_symmetric_vacuum")
exp=load('rhodamine_6g_exp_abs.dat');

figure;
t=tiledlayout('vertical');%,'TileSpacing','none');
nexttile
plot(OPA_PBE(:,1),OPA_PBE(:,2)./max(OPA_PBE(:,2)),'r-','linewidth',2,'DisplayName','Ethanol'); hold on;
plot(OPA_PBEv(:,1),OPA_PBEv(:,2)./max(OPA_PBEv(:,2)),'b--','linewidth',2,'DisplayName','Vacuum');
axis([2 4.3 0 1.05]);%ylim tickaligned;
lgd = legend;legend('boxoff');
lgd.Units="pixels";legend('Position',[387 332 120 56.5]);
%lgd.Position=[347.8 299 108 56.5];
xticks([2 2.5 3 3.5 4]);
ylabel('SPA');
set(gca,'FontSize',24);
xlabel('Energy (eV)');
ylabel(t,'Normalized Absorption','FontSize',26);
text(2.033333333333334,0.774678111587983,sprintf("(a)\nR6G"),"FontSize",26);
%text(3.3,.9,"Single Photon Absorption","FontSize",16)
nexttile
plot(2.*ETPA_PBE(1:2301,1),ETPA_PBE(1:2301,2)./max(ETPA_PBE(1:2301,2)),'r-','linewidth',2,'DisplayName','PBE');hold on;
plot(2.*ETPA_PBEv(1:2301,1),ETPA_PBEv(1:2301,2)./max(ETPA_PBEv(1:2301,2)),'b--','linewidth',2,'DisplayName','B3LYP');
axis([2 4.3 0 1.05]);%ylim tickaligned; %tight;
set(gca,'FontSize',24); 
ylabel('ETPA');xticks([2 2.5 3 3.5 4]);
xlabel('Idler Energy (           , eV)'); 
%text(2.08,.87,sprintf("Entangled Two \nPhoton Absorption"),"FontSize",16)
text(3.22,-0.508140895615541,'\boldmath$2\times\overline{\omega}_i$','Interpreter','latex',"FontSize",26)
text(2.033333333333334,0.774678111587983,sprintf("(b)\nR6G"),"FontSize",26);


f=figure;Ax(1)=axes(f);
%t=tiledlayout('vertical');%,'TileSpacing','none');
%nexttile
a1=plot(OPA_PBE(:,1),OPA_PBE(:,2)./max(OPA_PBE(:,2)),'r--','linewidth',2,'DisplayName','PBE','Parent',Ax(1)); hold on;
a4=plot(1239.841984./exp(:,1),exp(:,2)/max(exp(:,2)),'k--','linewidth',2,'DisplayName','Experiment');
%a2=plot(1239.841984./OPA_B3LYP(:,1),OPA_B3LYP(:,2)./max(OPA_B3LYP(:,2)),'r-','linewidth',2,'DisplayName','B3LYP','Parent',Ax(1));
%a3=plot(1239.841984./OPA_TPSS(:,1),OPA_TPSS(:,2)./max(OPA_TPSS(:,2)),'g-','linewidth',2,'DisplayName','TPSS','Parent',Ax(1));
%a4=plot(nan,nan,'k-','linewidth',2,'DisplayName','Exp','Parent',Ax(1));
axis([1 4 0 1.05]);%ylim tickaligned;
%legend([b1 b2 b3],{'PBE','B3LYP','TPSS'});legend('boxoff');
%legend('Location','best');lgd.Units="pixels";%lgd.NumColumns=2;
%lgd.Position=[288 272 216 83];title(lgd,'ETPA')
%xticks([2 2.5 3 3.5 4 4.5]);
%ylabel('SPA');
set(gca,'FontSize',24);Ax(2)=copyobj(Ax(1),gcf);delete(get(Ax(2),'Children'));
set(Ax(2), 'Color', 'none', 'XTick', [], 'YAxisLocation', 'right', 'Box', 'Off', 'Visible', 'off','Position',[0.1323 0.1619 0.7727 0.7631])
xlabel('Energy (eV)');
ylabel('Normalized Absorption','FontSize',26);
%text(280,.85,sprintf("Single Photon \nAbsorption"),"FontSize",16)
%nexttile
b1=plot(ETPA_PBE(1:2301,1),ETPA_PBE(1:2301,2)./max(ETPA_PBE(1:2301,2)),'r-','linewidth',2,'DisplayName','PBE','Parent',Ax(2));%hold on;
%b2=plot(1239.841984./ETPA_B3LYP(1:2601,1),ETPA_B3LYP(1:2601,2)./max(ETPA_B3LYP(1:2601,2)),'r--','linewidth',2,'DisplayName','B3LYP','Parent',Ax(2));
%b3=plot(1239.841984./ETPA_TPSS(1:2601,1),ETPA_TPSS(1:2601,2)./max(ETPA_TPSS(1:2601,2)),'g--','linewidth',2,'DisplayName','TPSS','Parent',Ax(2));
b4=plot(nan,nan,'k-','linewidth',2,'DisplayName','Exp','Parent',Ax(1));
%axis([540 1240 0 1.05]);%ylim tickaligned; %tight;
%set(gca,'FontSize',24); 
%ylabel('ETPA');%xticks([2 2.5 3 3.5 4 4.5]);
%xlabel('Idler Wavelength (nm)'); 
%text(971,.85,sprintf("ETPA"),"FontSize",16)
xtics=[1239.841984./1000 1239.841984./400];
text(3.4,1,sprintf("R6G"),"FontSize",26)
%lgd1=legend(Ax(1),[a1 a2 a3],{'PBE','B3LYP','TPSS'},'Box','off',Units='pixels',Position=[236 270 216 113.5]);title(lgd1,'SPA')
%lgd2=legend(Ax(2),[b1 b2 b3],{'PBE','B3LYP','TPSS'},'Box','off',Units='pixels',Position=[344 270 216 113.5]);title(lgd2,'ETPA')
lgd1=legend(Ax(1),[a1 a4],{'Computed','Experimental'},'Box','off',Units='pixels',Position=[317 279 217 87]);title(lgd1,'SPA')
lgd2=legend(Ax(2),[b1 b4],{'Computed','Experimental'},'Box','off',Units='pixels',Position=[317 198 217 87]);title(lgd2,'ETPA')
%lgd1=legend(Ax(1),[a1 a4],{'SPA','Exp'},'Box','off',Units='pixels',Position=[332 267 216 113.5]);%title(lgd1,'SPA')
%lgd2=legend(Ax(2),[b1],{'ETPA'},'Box','off',Units='pixels',Position=[338 267 216 113.5]);%title(lgd2,'ETPA')



