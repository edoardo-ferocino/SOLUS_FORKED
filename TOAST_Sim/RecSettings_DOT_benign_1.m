%==========================================================================
%%                      RECONSTRUCTION DOMAIN: CW or TD
%==========================================================================
REC.domain = 'td';          % CW or TD: data type to be inverted

% -------------------------------------------------------------------------
REC.time.roi = [98,280];% ROI in time-step unit. If omitted, the ROI will be 
                        % selected dinamically by the user.
NUM_TW = 10;            % Number of Time Windows within ROI
% =========================================================================
%%                        Initial parameter estimates 
% =========================================================================
% In this section all the parameter for the inverse solver are setted.
% --------------------------- Optical properties --------------------------
REC.opt.mua0 = 0.0004;%0.0036;%0.0004;    % absorption [mm-1]
REC.opt.musp0 = 0.37;%1.05;%0.39;      % reduced scattering [mm-1]
REC.opt.nB = 1.4;
% ---------------------- Solver and regularization ------------------------
REC.solver.tau = 1e-2;            % regularisation parameter
REC.solver.type = 'born';         % 'born','GN': gauss-newton, 
                                  % 'USprior': Simon's strutural prior
                                  % 'LM': Levenberg-Marquardt,
                                  % 'l1': L1-based minimization
                                  % 'fit': fitting homogeneous data
% =========================================================================
%%                            US prior 
% =========================================================================
REC.solver.prior = [];
% =========================================================================
%%                     load a precomputed jacobian 
% =========================================================================
% Pay attention! The jacobian depends on source-detectors configuration,
% optical properties of the background and number of time-windows.
REC.solver.prejacobian.load = true;
REC.solver.prejacobian.path = '../results/precomputed_jacobians/J';
