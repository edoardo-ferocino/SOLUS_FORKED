function [J_semi_PCBC] = J_Semi_Inf_PCBC_TR_3D(t,mua,mus,cs,A,ri,rj,XX,YY,ZZ,vi)
% function [J_semi_PCBC] = J_Semi_Infinite_PCBC_TR_3D(t,mua,mus,cs,A,ri,rj,XX,YY,ZZ,vi)
% CORRETTO DA ANDREA FARINA
% Jacobian for the Semi-infinite homogeneous space geometry
% The Jacobian is calculated for the 'perturbation Contrast, i.e. dR/R'
% with R DE green's function in the Time Domain for the reflectance
% The Jacobian is calculated for an inclusion placed in the medium where is
% assumed an absorption variation dmua with respect to the background
% If C=dR/R is the contrast, the Jacobian J is the coefficient J=dC/dmua 
% for the flux (Reflectance) calculated with the PCBC
% mua absorption coefficient (mm^-1)
% mus reduced scattering coefficient (mm^-1)
% cs speed of light (mm/ps)
% A factor that accounts Fresnel reflections
% kap diffusion coefficient
% vi volume of the inclusion (mm^3)
% t time (ps)
% ri position vector of the source (mm)
% rj position vector of the detector (mm)
% rk position vector of the inclusion (mm)
% rhoik distance between source and inclusion
% rhojk distance between detector and inclusion
% rhoji distance between detector and source
% It is used the the Born approximation applied to
% the DE solved with the Extrapolated Boundary Condition
% G0_semi_PCBC: Unperturbed Fluence, Reflectance=(1/2A)*Fluence
% dG_semi_PCBC: Perturbation for the Fluence, Reflectance=(1/2A)*Fluence
% G_semi_PCBC: Contrast or relative perturbation for fluence and
% refletcance
%---------------------------------------------------------------

kap = 1/(3*(mus));
ze=2*A*kap;
n=numel(XX);
nt=length(t);
%% check that the vector is column
if isrow(t)
    t = t';
end
%%
 if ri(3) > 0
    z0=ri(3);     
 elseif ri(3)==0
    z0=1/mus; 
    ri(3)=z0;
 end
      
z12plus=z0;
z12minus=-2*ze-z0;
%z23plus=rk(3);
z23plus=ZZ;
%z23minus=-2*ze-rk(3);
z23minus=-2*ze-ZZ;

%rhoijsq=(ri-rj)*(ri-rj)'; 
r12plus=sqrt((XX-ri(1)).^2+(YY-ri(2)).^2+(ZZ-z12plus).^2);
r12minus=sqrt((XX-ri(1)).^2+(YY-ri(2)).^2+(ZZ-z12minus).^2);
r23plus=sqrt((rj(1)-XX).^2+(rj(2)-YY).^2+(rj(3)-z23plus).^2);
r23minus=sqrt((rj(1)-XX).^2+(rj(2)-YY).^2+(rj(3)-z23minus).^2);
%ri(3)=z12minus;         % the value is superscript
%rhoijsq_minus=(ri-rj)*(ri-rj)';

rho12plus=reshape(r12plus,[1 n]);
rho12minus=reshape(r12minus,[1 n]);
rho23plus=reshape(r23plus,[1 n]);
rho23minus=reshape(r23minus,[1 n]);

muinv=1./(4*kap*cs*t);  %verticale

%fact=exp(muinv*rhoijsq);







J_semi_PCBC=-repmat(cs.^2.*(4*pi*kap*cs).^(-5/2).*t.^(-3/2).*exp(-mua*cs*t),[1 n]).*(...
    +exp(-muinv*(rho12plus+rho23plus).^2).*repmat((1./rho12plus+1./rho23plus),[nt 1])...
    -exp(-muinv*(rho12plus+rho23minus).^2).*repmat((1./rho12plus+1./rho23minus),[nt 1])...
    -exp(-muinv*(rho12minus+rho23plus).^2).*repmat((1./rho12minus+1./rho23plus),[nt 1])...
    +exp(-muinv*(rho12minus+rho23minus).^2).*repmat((1./rho12minus+1./rho23minus),[nt 1]));


% J_semi_PCBC=-vi*1/(4*pi*kap).*(...
%     +exp(-muinv*(rho12plus+rho23plus).^2).*repmat((1./rho12plus+1./rho23plus),[nt 1])...
%     -exp(-muinv*(rho12plus+rho23minus).^2).*repmat((1./rho12plus+1./rho23minus),[nt 1])...
%     -exp(-muinv*(rho12minus+rho23plus).^2).*repmat((1./rho12minus+1./rho23plus),[nt 1])...
%     +exp(-muinv*(rho12minus+rho23minus).^2).*repmat((1./rho12minus+1./rho23minus),[nt 1]))./...
%     repmat(exp(-muinv*rhoijsq)-exp(-muinv*rhoijsq_minus),[1 n]);


%G0_semi_PCBC=(exp(-muinv*rhoijsq)-exp(-muinv*rhoijsq_minus))*ones([1 n]);
%G0_semi_PCBC=repmat(exp(-muinv*rhoijsq)-exp(-muinv*rhoijsq_minus),[1 n]);
%J_semi_PCBC=dG_semi_PCBC./(2*A)%G0_semi_PCBC;
%G0_semi_PCBC/(2*A)
%J_semi_PCBC=vi*J_semi_PCBC./G0_semi_PCBC;
J_semi_PCBC=vi*J_semi_PCBC./(2*A);
J_semi_PCBC(isnan(J_semi_PCBC))=0;

end