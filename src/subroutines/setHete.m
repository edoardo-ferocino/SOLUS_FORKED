%==========================================================================
% This version of steHete requires the geometry of the honomogeneity
%
% N. Ducros - Departamento di Fisica - Politecnico di Milano - 15/01/09
% N. Ducros - Departamento di Fisica - Politecnico di Milano - 02/02/09
% N. Ducros - Departamento di Fisica - Politecnico di Milano - 06/07/09
%==========================================================================

function [DOT,hete] = setHete(DOT,hete)

%==========================================================================
%%                           OPTIONS
%==========================================================================
%-- default --%
if not(isfield(hete,'profile')),  hete.profile  = 'gaussian'; end
if not(isfield(hete,'distrib')),  hete.distrib  = 'OFF';      end 
if not(isfield(hete,'geometry')), hete.geometry = 'sphere';   end

%==========================================================================
%%                           MAIN
%==========================================================================
switch upper(hete.geometry)
    
    case 'SPHERE'
    disp('+++ Sphere')
    [DOT, hete] = sphere3D(DOT, hete);
    
    case 'CYLINDER'
    disp('+++ Cylinder')
    [DOT, hete] = cylinder3D(DOT, hete);
    
    case 'USIMAGE'
    disp('+++ Distance Transform');
    [DOT,~] = prior3D(DOT, hete);
    

end

for itype = 1: size(hete.type,2)
    disp(sprintf('Setting pesudo-inhomogeneities for %s', hete.type{itype}));
    if isfield(hete, 'randinhom') 
        if hete.randinhom(1) ~= 0  &&  hete.randinhom(2) ~= 0
            [DOT.opt.(hete.type{itype}), ~] = AddPseudoInhom(DOT.opt.(hete.type{itype}),...
                                                             [DOT.grid.Nx, DOT.grid.Ny, DOT.grid.Nz ] , ...
                                                             hete.randinhom(1)/DOT.grid.dx,...
                                                             hete.randinhom(2) );
        end
    end
end


end