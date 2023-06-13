classdef BalchenControl < BalchenObserver
    properties
        Gsu
        Gsw
        Gya
        U
    end
    methods
        function obj = BalchenControl(d,m,xi,A_F, A_L, L,uhfo)
            obj@BalchenObserver(d,m,xi,A_F, A_L, L,uhfo);
            obj.Gsu = [-3*10^4, -1.15*10^6];
            obj.Gsw = [-3*10^4, -1.55*10^6];
            obj.Gya = [-2*10^8, -5*10^9];
            obj.U=zeros(3,1);
        end
        function u = GetU(obj, y, dt, ref, w)
            [x_l, x_h, c, Wf] = GetSateEstimate(obj, y, dt, obj.U, w);
            D = obj.D;
            ref = VectorTranslate.TranslateFromNED(ref,y(3));
            e = x_l - ref;
            u = zeros(3,1);
            u(1) = obj.Gsw * [e(1);e(2)] - Wf(1) + D(1) * abs(x_l(2)-c(1)) * (x_l(2)-c(1));
            u(2) = obj.Gsu * [e(3);e(4)] - Wf(2) + D(2) * abs(x_l(4)-c(2)) * (x_l(4)-c(2));
            u(3) = obj.Gya * [e(5);e(6)] - Wf(3) + D(4) * abs(x_l(4)-c(2)) * (x_l(4)-c(2)) - c(3);
            %u_lim = 5000;
            %u = min(max(u,-u_lim),u_lim);
            u = VectorTranslate.TranslateToNED(u,y(3));
            obj.U = u;
        end
    end
end