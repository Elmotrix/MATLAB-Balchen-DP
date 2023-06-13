classdef BalchenVesselModel < BalchenVesselBase
    properties
        X_l; %always in ship coordinate frame
        X_h; %always in ship coordinate frame
        omega;
        Y; %always in NED coordinate frame
        sigma;
        rtd;
        r;
    end
    methods
        function obj = BalchenVesselModel(d,m,xi, sigma, A_F, A_L, L)
            obj@BalchenVesselBase(d,m,A_F, A_L, L);
            obj.sigma = sigma;
            obj.r = obj.GenerateRandomValues();
            obj.X_l = VectorTranslate.TranslateFromNED(xi, xi(5));
            obj.X_h = zeros(6,1);
            obj.omega = zeros(3,1);
            obj.rtd = pi/180;
            obj.Y = obj.GetY();
        end
        function Y = ProgressModel(obj, dt, u, w, c, time)
            W = VectorTranslate.TranslateFromNED(w, obj.Y(3));
            C = VectorTranslate.TranslateFromNED(c, obj.Y(3));
            U = VectorTranslate.TranslateFromNED(u, obj.Y(3));
            W = obj.GetWindForce(obj.X_l,W); %updates wind vector to force vector
            obj.r = obj.GenerateRandomValues();
            [obj.X_l, obj.X_h, obj.omega] = obj.Euler(dt, U, W, C, time);
            obj.Y = GetY(obj);
            Y = obj.Y;
        end
        function Y = GetY(obj)
            Y = [obj.X_l(1) + obj.X_h(1) + obj.r(1)
                obj.X_l(3) + obj.X_h(3) + obj.r(2)
                obj.X_l(5) + obj.X_h(5) + obj.r(3)*obj.rtd];
            Y = VectorTranslate.TranslateToNED(Y, Y(3));
        end
        function [x_l_next, x_h_next, omega_next] = Euler(obj, dt, u_k, wf, c, time)
            dx_l = obj.LowFrequencyModel(u_k,wf,c);
            x_l_next = obj.X_l + dx_l*dt;
            do = obj.OmegaModel();
            omega_next = obj.omega + do*dt;
            %omega_next = [dt,dt,dt];
            %omega_next = min(omega_next,1);
            %omega_next = max(omega_next,-1);
            dx_h = obj.HighFrequencyModel(obj.X_h);
            %dx_h = obj.SimpleHighFrequencyModel(obj.X_h, time);
            x_h_next = obj.X_h + dx_h*dt;

            %K1 = obj.HighFrequencyModel(obj.X_h);
            %K2 = obj.HighFrequencyModel(obj.X_h+K1.*(dt/2));
            %K3 = obj.HighFrequencyModel(obj.X_h+K2.*(dt/2));
            %K4 = obj.HighFrequencyModel(obj.X_h+K3.*dt);
            %x_h_next = obj.X_h + (dt/6).*(K1+2.*K2+2.*K3 + K4);
        end
        function dx = LowFrequencyModel(obj, u, wf, c)
            dx = obj.LowFrequencyModelBase(obj.X_l, u, wf, c);
            dx(2) = dx(2)+obj.r(4);
            dx(4) = dx(4)+obj.r(5);
            dx(6) = dx(6)+obj.r(6)*obj.rtd;
        end
        function dx = SimpleHighFrequencyModel(obj, X_h, t)
            dx = zeros(6,1);
            dx(1) = X_h(2);
            dx(2) = cos(t/pi)*0.007 + obj.r(7);
            dx(3) = X_h(4);
            dx(4) = cos(t/pi)*0.007 + obj.r(8);
            dx(5) = X_h(6);
            dx(6) = cos(t/pi)*0.007 + obj.r(9)*obj.rtd;
        end
        function dx = HighFrequencyModel(obj, X_h)
            dx = obj.HighFrequencyModelBase(X_h, obj.omega);
            dx(2) = dx(2)+obj.r(7);
            dx(4) = dx(4)+obj.r(8);
            dx(6) = dx(6)+obj.r(9)*obj.rtd;
        end
        function do = OmegaModel(obj)
            do = zeros(3,1);
            do(1) = obj.r(10);
            do(2) = obj.r(11);
            do(3) = obj.r(12)*obj.rtd;
        end
        function r = GenerateRandomValues(obj)
            r = zeros(12,1);
            r(1) = normrnd(0, obj.sigma(1));
            r(2) = normrnd(0, obj.sigma(1));
            r(3) = normrnd(0, obj.sigma(1));
            r(4) = normrnd(0, obj.sigma(2));
            r(5) = normrnd(0, obj.sigma(2));
            r(6) = normrnd(0, obj.sigma(2));
            r(7) = normrnd(0, obj.sigma(3));
            r(8) = normrnd(0, obj.sigma(3));
            r(9) = normrnd(0, obj.sigma(3));
            r(10) = normrnd(0, obj.sigma(4));
            r(11) = normrnd(0, obj.sigma(4));
            r(12) = normrnd(0, obj.sigma(4));
        end
    end
end

