classdef BalchenVesselBase < handle
    properties
        D;
        M;
        A_F;
        A_L;
        L;
    end
    methods
        function obj = BalchenVesselBase(d,m,A_F, A_L, L)
            %A_F = 500;%frontal windage area [m^2]
            %A_L = 1100; %lateral windage area [m^2]
            %Long = 73.2; % over all length of the vessel [m]
            obj.D = d;
            obj.M = m;
            obj.A_F = A_F;
            obj.A_L = A_L;
            obj.L = L;
        end
        function dx = LowFrequencyModelBase(obj, x, u, wf, c)
            dx = zeros(6,1);
            dx(1) = x(2);
            dx(2) = (1/obj.M(1))*(u(1)+wf(1)) - (obj.D(1)/obj.M(1))*abs(x(2)-c(1))*(x(2)-c(1));
            dx(3) = x(4);
            dx(4) = (1/obj.M(2))*(u(2)+wf(2)) - (obj.D(2)/obj.M(2))*abs(x(4)-c(2))*(x(4)-c(2));
            dx(5) = x(6);
            dx(6) = (1/obj.M(3))*(u(3)+wf(3)+c(3)) - (obj.D(3)/obj.M(3))*abs(x(6))*(x(6)) - (obj.D(4)/obj.M(3))*abs(x(4)-c(2))*(x(4)-c(2));
        end
        function dx = HighFrequencyModelBase(obj, x_h, omega)
            dx = zeros(6,1);
            dx(1) = x_h(2);
            dx(2) = (omega(1)^2)*x_h(1)*(-1);
            dx(3) = x_h(4);
            dx(4) = (omega(2)^2)*x_h(3)*(-1);
            dx(5) = x_h(6);
            dx(6) = (omega(3)^2)*x_h(5)*(-1);
        end
        function F_w = GetWindForce(obj, X, W)
            C_x = 0.6;
            C_y = 0.8;
            C_n = 0.1;
            u_rw = X(2) - W(1);%u_w; % wind relative speed in surge - v_su
            v_rw = X(4) - W(2);%v_w; % wind relative speed in sway - v_sw
            V_r = sqrt(u_rw^2 + v_rw^2);%wind relative speed
            rho = 1.23; % wind density [kg\m^3]
            F_w_su = 0.5*rho*C_x*obj.A_F*cos(X(5)-W(3))* V_r^2;
            F_w_sw = 0.5*rho*C_y*obj.A_L*sin(X(5)-W(3))* V_r^2;
            N_w = 0.5*rho*C_n*obj.A_L*obj.L*sin(2*(X(5)-W(3)))* V_r^2;
            F_w = [F_w_su, F_w_sw, N_w]';
        end
    end
end

