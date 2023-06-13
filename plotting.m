function plotting(y,sp,u,N,dt,x_h,x_l,omega_array,x_h_e,x_l_e,y2)
time = linspace(0, N*dt, N)';

figure(1),
subplot(211);plot(time/60,sp(1,:),time/60,y(1,:),'g-');ylabel('position north [m]');title('North direction');ldg = legend('set point','North position');grid
subplot(212);plot(time/60,u(1,:),'r-'); ylabel('control north [N]');xlabel('time [min]');ldg.Location = 'southeast'; grid

figure(2),
subplot(211);plot(time/60,sp(3,:),time/60,y(2,:),'g-');ylabel('position east [m]');title('East direction');ldg = legend('set point','East position');grid
subplot(212);plot(time/60,u(2,:),'r-');xlabel('time [min]'); ylabel('control east [N]');xlabel('time [min]');ldg.Location = 'southeast';grid

figure(3),
subplot(211);plot(time/60,sp(5,:)*180/pi,time/60,y(3,:)*180/pi,'g-');ylabel('position in yaw [deg]');title('Yaw direction');ldg = legend('set point','Yaw position');grid
subplot(212);plot(time/60,u(3,:),'r-');xlabel('time [min]'); ylabel('control in yaw [N]');xlabel('time [min]');ldg.Location = 'southeast'; grid

figure(4);grid
plot(y(2,:)',y(1,:)');xlabel('East position [m]'); ylabel('North position [m]');
title('position in NED coordinate system');

figure(5),
subplot(311);plot(time/60,x_h(2,:),'g-',time/60,x_h_e(2,:),'r-');ylabel('surge [m/s]');title('HF velocity');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(312);plot(time/60,x_h(4,:),'g-',time/60,x_h_e(4,:),'r-');ylabel('sway [m/s]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(313);plot(time/60,x_h(6,:),'g-',time/60,x_h_e(6,:),'r-');xlabel('time [min]'); ylabel('yaw [rad/s]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid

figure(6),
subplot(311);plot(time/60,x_l(2,:),'g-',time/60,x_l_e(2,:),'r-');ylabel('surge [m/s]');title('LF velocity');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(312);plot(time/60,x_l(4,:),'g-',time/60,x_l_e(4,:),'r-');ylabel('sway [m/s]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(313);plot(time/60,x_l(6,:),'g-',time/60,x_l_e(6,:),'r-');xlabel('time [min]'); ylabel('yaw [rad/s]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid

figure(7),
subplot(311);plot(time/60,omega_array(1,:),'g-');ylabel('Omega in surge');title('Omega');grid
subplot(312);plot(time/60,omega_array(2,:),'r-');xlabel('time [min]'); ylabel('Omega in sway');grid
subplot(313);plot(time/60,omega_array(3,:),'b-');xlabel('time [min]'); ylabel('Omega in Yaw');grid

figure(8),
subplot(311);plot(time/60,x_h(1,:),'g-',time/60,x_h_e(1,:),'r-');ylabel('surge [m]');title('HF position');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(312);plot(time/60,x_h(3,:),'g-',time/60,x_h_e(3,:),'r-');ylabel('sway [m]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(313);plot(time/60,x_h(5,:),'g-',time/60,x_h_e(5,:),'r-');xlabel('time [min]'); ylabel('yaw [rad]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid

figure(9),
subplot(311);plot(time/60,x_l(1,:),'g-',time/60,x_l_e(1,:),'r-');ylabel('surge [m]');title('LF position');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(312);plot(time/60,x_l(3,:),'g-',time/60,x_l_e(3,:),'r-');ylabel('sway [m]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid
subplot(313);plot(time/60,x_l(5,:),'g-',time/60,x_l_e(5,:),'r-');xlabel('time [min]'); ylabel('yaw [rad]');ldg = legend('Simulated','Estimated');ldg.Location = 'southeast';grid

figure(10),
subplot(311);plot(time/60,y2(1,:),'g-',time/60,y(1,:),'r--');ylabel('North [m]');title('NED position');ldg = legend('Simplified','Original');ldg.Location = 'southeast';grid
subplot(312);plot(time/60,y2(2,:),'g-',time/60,y(2,:),'r--');ylabel('East [m]');ldg = legend('Simplified','Original');ldg.Location = 'southeast';grid
subplot(313);plot(time/60,y2(3,:),'g-',time/60,y(3,:),'r--');xlabel('time [min]'); ylabel('Yaw [rad]');ldg = legend('Simplified','Original');ldg.Location = 'southeast';grid

figure(11),
subplot(311);plot(time/60,y(1,:)-y2(1,:),'r-');ylabel('North [m]');title('Simplified position offsett');grid
subplot(312);plot(time/60,y(2,:)-y2(2,:),'r-');ylabel('East [m]');grid
subplot(313);plot(time/60,y(3,:)-y2(3,:),'r-');xlabel('time [min]'); ylabel('Yaw [rad]');grid
