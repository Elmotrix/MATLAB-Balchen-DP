classdef BalchenObserver < BalchenVesselBase
    properties
        Ksu
        Ksw
        Kya
        Kc
        Xe_l %always in ship coordinate frame
        Xe_h %always in ship coordinate frame
        omega
        Ce %always in ship coordinate frame
        UseHighFreqObs
    end
    methods
        function obj = BalchenObserver(d,m,xi,A_F, A_L, L,uhfo)
            obj@BalchenVesselBase(d,m,A_F, A_L, L);
            obj.UseHighFreqObs = uhfo;
            obj.Ksu = [0.045, 0.001, 0.3, 0.07];
            obj.Ksw = obj.Ksu;
            obj.Kya = [0.145, 0.004, 0.7, 0.15];
            obj.Kc = [0.001, 0.001, 2.0];
            obj.Xe_l = VectorTranslate.TranslateFromNED(xi, xi(5));
            obj.Xe_h = zeros(6,1);
            obj.omega = zeros(3,1);
            obj.Ce = [0;0;0];
        end
        function [x_l, x_h, c, Wf] = GetSateEstimate(obj, y, dt, u, w) %return values in ship frame!
            Ysf = VectorTranslate.TranslateFromNED(y,y(3));
            Usf = VectorTranslate.TranslateFromNED(u,y(3));
            W = VectorTranslate.TranslateFromNED(w,y(3));
            Wf = obj.GetWindForce(obj.Xe_l,W); %updates wind vector to force vector
            e = obj.GetEstimationError(Ysf);
            [obj.Xe_l,obj.Xe_h,obj.Ce] = obj.Euler(obj.Xe_l, obj.Xe_h, obj.omega, e, dt, Usf, Wf, obj.Ce);
            obj.omega = obj.CalculateOmega(obj.Xe_h, obj.omega);
            x_l = obj.Xe_l;
            x_h = obj.Xe_h;
            c = obj.Ce;
        end
        function e = GetEstimationError(obj, y)
            e = zeros(3,1);
            if (obj.UseHighFreqObs)
                e(1) = y(1) - obj.Xe_l(1) -obj.Xe_h(1);
                e(2) = y(2) - obj.Xe_l(3) -obj.Xe_h(3);
                e(3) = y(3) - obj.Xe_l(5) -obj.Xe_h(5);
            else
                e(1) = y(1) - obj.Xe_l(1);
                e(2) = y(2) - obj.Xe_l(3);
                e(3) = y(3) - obj.Xe_l(5);
            end
        end
        function [x_l_next, x_h_next, c_next] = Euler(obj, x_l, x_h, omega, e, dt, u_k, wf, c)
            dx_l =  obj.LowFrequencyModel(x_l, e, u_k, wf, c);
            dx_h =  obj.HighFrequencyModel(x_h, e, omega);
            dc = obj.CurrentModel(e);
            x_l_next = x_l + dx_l*dt;
            x_h_next = x_h + dx_h*dt;
            c_next = c + dc*dt;
        end
        function dx = LowFrequencyModel(obj, xe, e, u, wf, c)
            dx = obj.LowFrequencyModelBase(xe,u,wf,c);
            dx(1) = dx(1) + obj.Ksu(1)*e(1);
            dx(2) = dx(2) + obj.Ksu(2)*e(1);
            dx(3) = dx(3) + obj.Ksw(1)*e(2);
            dx(4) = dx(4) + obj.Ksw(2)*e(2);
            dx(5) = dx(5) + obj.Kya(1)*e(3);
            dx(6) = dx(6) + obj.Kya(2)*e(3);
        end
        function dc = CurrentModel(obj, e)
            dc = obj.Kc'.*e;
        end
        function dx = HighFrequencyModel(obj, x_e, e, omega)
            dx = obj.HighFrequencyModelBase(x_e, omega);
            dx(1) = dx(1) + obj.Ksu(3)*e(1);
            dx(2) = dx(2) + obj.Ksu(4)*e(1);
            dx(3) = dx(3) + obj.Ksw(3)*e(2);
            dx(4) = dx(4) + obj.Ksw(4)*e(2);
            dx(5) = dx(5) + obj.Kya(3)*e(3);
            dx(6) = dx(6) + obj.Kya(4)*e(3);
        end
        function omega = CalculateOmega(obj, xe_h, omega)
            omega(1) =  omega(1) - (obj.Ksu(3)*xe_h(2)-obj.Ksu(4)*xe_h(1))*2*omega(1)/((obj.Ksu(3)*omega(1))^2+obj.Ksu(4)^2);
            omega(2) =  omega(2) - (obj.Ksw(3)*xe_h(4)-obj.Ksw(4)*xe_h(3))*2*omega(2)/((obj.Ksw(3)*omega(2))^2+obj.Ksw(4)^2);
            omega(3) =  omega(3) - (obj.Kya(3)*xe_h(6)-obj.Kya(4)*xe_h(5))*2*omega(3)/((obj.Kya(3)*omega(3))^2+obj.Kya(4)^2);
        end
    end
end