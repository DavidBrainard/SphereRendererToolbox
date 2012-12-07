function r=sigmoid(x,range,center)
a=5/range;
b=center;

r=1./(1+exp(a*(-x+b)));
% 
% plot(x,r);
% grid on;