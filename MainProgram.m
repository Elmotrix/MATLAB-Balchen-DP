

%[sp,N,dt] = SimulationSettings.Standard();
%[sp,N,dt] = SimulationSettings.Long();
[sp,N,dt] = SimulationSettings.Medium();
%[sp,N,dt] = SimulationSettings.Short();
x = sp(:,1);%in worls coordinate frame

m1 = 4 * 10^6;%[kg]
m2 = 4 * 10^7;%[kg]
m3 = 4.7 * 10^10; % [kg.m^2]
d1 =  5*10^-5; % [N/(m/s)^2]
d2 = 21*10^-5;% [N/(m/s)^2]
d3 = 1.1*10^-10;% [Nm/(rad/s)^2]
d4 = 201*10^-15;% [Nm/(m/s)^2]
Drag = [d1 d2 d3 d4]';
DragZero = zeros(4,1);
M = [m1 m2 m3]';
sigma = [0.5;0.0025;0.0;0.0]; %0.05,0.5
useHighFrequencyObserver = 0;

VesselSimple = BalchenVesselModel(DragZero,M,x,sigma,500,1100,73.2);
Vessel = BalchenVesselModel(Drag,M,x,sigma,500,1100,73.2);

Env = BalchenEnvironment();
Controller = BalchenControl(Drag,M,x,500,1100,73.2,useHighFrequencyObserver);


%rng('default');
x_h_array = zeros(6,N);
x_l_array = zeros(6,N);
x_h_e_array = zeros(6,N);
x_l_e_array = zeros(6,N);
y_array = zeros(3,N);
y_array2 = zeros(3,N);
u_array = zeros(3,N);
omega_array = zeros(3,N);
u = zeros(3,1);


y = Vessel.Y;
for i = 1:N
    s = sp(:,i);
    if (i == 300)
        a = 1;
    end
    wind = Env.GetWind();
    current = Env.GetCurrent();
    u = Controller.GetU(y, dt, sp(:,i), wind);
    u_array(:,i) = u;
    y = Vessel.ProgressModel(dt,u,wind,current,i*dt);
    y_array(:,i) = y;
    y_array2(:,i) = VesselSimple.ProgressModel(dt,u,wind,current,i*dt);
    x_h_array(:,i) = Vessel.X_h;
    x_l_array(:,i) = Vessel.X_l;
    x_h_e_array(:,i) = Controller.Xe_h;
    x_l_e_array(:,i) = Controller.Xe_l;
    omega_array(:,i) = Vessel.omega;
end

plotting(y_array,sp,u_array,N,dt,x_h_array,x_l_array,omega_array,x_h_e_array,x_l_e_array,y_array2);

dy = y_array(1,:)-y_array2(1,:);
covariance = dy*dy'/N;
disp("Covar North:"+ covariance)

dy = y_array(2,:)-y_array2(2,:);
covariance = dy*dy'/N;
disp("Covar east:"+ covariance)

dy = y_array(3,:)-y_array2(3,:);
covariance = dy*dy'/N;
disp("Covar yaw:"+ covariance)

disp(wind)
disp(current)
