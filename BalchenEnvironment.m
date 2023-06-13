classdef BalchenEnvironment < handle
   properties
       V_w
       betta
       V_c
       gamma
   end
   methods
       function obj = BalchenEnvironment()
           [V_w,betta,V_c,gamma] = BalchenEnvironment.GenerateStaticValvues();
           obj.V_c=V_c;
           obj.V_w = V_w;
           obj.betta = betta;
           obj.gamma = gamma;
       end
       function w = GetWind(obj) 
           w = [cos(obj.betta)*obj.V_w, sin(obj.betta)*obj.V_w, obj.betta]';
       end
       function c = GetCurrent(obj) 
           c = [cos(obj.gamma)*obj.V_c, sin(obj.gamma)*obj.V_c, obj.gamma]';
       end
   end
   methods(Static)
       function [V_w,betta,V_c,gamma] = GenerateRandomValvues() 
           V_w = rand(1) * 10;
           betta = rand(1) * 2*pi;
           V_c = rand(1) * 0.5;
           gamma = rand(1) * 2*pi;
       end
   end
   methods(Static)
       function [V_w,betta,V_c,gamma] = GenerateStaticValvues() 
           V_w = 5;
           betta = pi/4;
           V_c = 0.3;
           gamma = 2*pi/3;
       end
   end
end