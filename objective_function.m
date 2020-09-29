%%Harshini Gangapuram
% Access ID: fr8393

%%Objective function program for Assignment 3
% To calculate the Transformation matrix with the initial guesses of s,
% theta, tx and ty given in assignment3.m file and calculate the error
% with the selected points of the fixed and moving images


function [out]= objective_function(z)
S=z(1);
theta=z(2);
tx=z(3);
ty=z(4);
global x1 y1 x2 y2

Tt=[1 0 tx; 0 1 ty; 0 0 1]; %Translation matrix
Tr=[cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]; %Rotation Matrix
Ts=[S 0 0; 0 S 0; 0 0 1]; %Scaling matrix
T=Ts*Tr*Tt; %Transformation matrix
for i=1:4
        f=T*[x2(i);y2(i);1];
        f=[f(1,1);f(2,1)];
        %Finding the error or the minimum distance between the fixed and
        %moving image coordinates
        out=sum(sqrt((x1(i)-f).^2+(y1(i)-f).^2)); 
       
end
end