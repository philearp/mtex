function [U,S,V] = svd(T)
% singular value decomposition of a rank two tensor
%
% Syntax
%   S = svd(T)
%   [U,S,V] = svd(T)
%
% Input
%  T - list of M rank 2 @tensor
%
% Output
%  S - 3xM sorted singular values, starting with the largest
%  U - 3xM left singular @vector3d
%  V - 3xM right singular @vector3d
%


A = matrix(T' * T);
[V,S] = eig3(A(1,1,:),A(1,2,:),A(1,3,:),A(2,2,:),A(2,3,:),A(3,3,:));
%[V,S] = eig(T' * T);
V = flipud(V);
S = flipud(sqrt(S));

if nargout <= 1, U = S; end
if nargout == 3
  U = normalize(vector3d(EinsteinSum(T,[1 -1],V,-1)));
end
