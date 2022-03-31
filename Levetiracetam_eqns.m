function dydt = Levetiracetam_eqns(t,y,p)

q = p.q; % mg/hr (levetiracetam IV injection dose)
V = p.V; % L (volume of central compartment)
ka = p.kA; % hr-1 (absorption rate constant)
kc = p.kCL; % hr-1 (clearance rate constant)

dydt = zeros(3,1);

% 1 = Dc, levetiracetam in the central compartment (mg/L)
% 2 = Dcl, levetiracetam in the clearance compartment (mg)
% 3 = Dg, levetiracetam in the gut compartment (mg)

dydt(1) = q/V + ka*y(3)/V - kc*y(1);
dydt(2) =                   kc*y(1)*V;
dydt(3) =     - ka*y(3);