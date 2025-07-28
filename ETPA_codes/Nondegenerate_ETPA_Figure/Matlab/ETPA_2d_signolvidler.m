Rgrid=load('sRgrid_i2_1-s5_5');
Egrid=Rgrid(2:end,1);
Igrid=Rgrid(1,2:end);
Rgrid(1,:)=[];Rgrid(:,1)=[];

figure%(OuterPosition=[476 360 580 499],InnerPosition=[476 360 560 420]);
mesh(Egrid,Igrid,Rgrid');
%axis([200 650 600 1250]);
xlim tight; ylim tight;
view(2);ax=gca;%ax.Units="pixels";
set(gca,'FontSize',24);
xlabel('Signal Energy (eV)'); 
ylabel('Idler Energy (eV)');
cb=colorbar();ax.OuterPosition=[0 0 0.971428571428572 1];%[1 1 544 420];%[0 0 0.892857142857143 1];
ylabel(cb,'Absorption','Rotation',270);

%{
annotation("rectangle",ax.Position,Color='blue',LineWidth=2)
annotation("rectangle",ax.OuterPosition,Color='red',LineWidth=2)
annotation("rectangle",ax.tightPosition,Color='green',LineWidth=2)
%}