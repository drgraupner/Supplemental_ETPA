function S= etpa(omegap,avgomegai,Tent,epsilons,epsiloni,EIG,MU,GAMMA)
% omegap is pump frequency
% avgomegai is central frequency of idler
% Tent is entanglement time
% epsilons and epsilons are polarization vectors for signal and idler (3x1 matrices)
% EIG is eigenstate energies of molecule (Nx1 matrix)
% MU is transition dipole array (NxNx3 array)
% GAMMA is phenomenological dephasing parameter matrix (Nx1 matrix)
v=reshape(eye([3,3]),[9,1]);
Stemp=zeros([3,1]);
SIZE=length(EIG);
[~,ng]=min(EIG);
for nf=1:SIZE
    if EIG(nf)>EIG(ng)
        X=zeros([9,1]);
        for ne=1:SIZE
            if EIG(nf)>EIG(ne) && EIG(ne)>EIG(ng)
                X=X+kron(reshape(MU(ne,ng,:),[3,1]),reshape(MU(nf,ne,:),[3,1])).*((exp(Tent*(avgomegai-EIG(ne)+EIG(ng)+1i*GAMMA(ne)))-1)/((omegap-EIG(nf)+EIG(ng)+1i*GAMMA(nf))*(Tent*(avgomegai-EIG(ne)+EIG(ng)+1i*GAMMA(ne)))));%(1i*Tent*(avgomegai-EIG(ne)+EIG(ng)+1i*GAMMA(ne)))));
            end
        end
        Z=reshape(X*(X'),[3,3,3,3]);
        Stemp=Stemp+[(v.')*(reshape(Z,[9,9])*v);(v.')*(reshape(permute(Z,[1,3,2,4]),[9,9])*v);(v.')*(reshape(permute(Z,[1,4,2,3]),[9,9])*v)];
    end
end
M=[4,-1,-1;-1,4,-1;-1,-1,4]./30;
S=[(epsilons.'*epsiloni)*(conj(epsilons).'*conj(epsiloni)),(epsilons.'*conj(epsilons))*(epsiloni.'*conj(epsiloni)),(epsilons.'*conj(epsiloni))*(epsiloni.'*conj(epsilons))]*M*Stemp;
clear v;
clear M;
clear Stemp;
clear SIZE;
clear nf;
clear ne;
clear ng;
end