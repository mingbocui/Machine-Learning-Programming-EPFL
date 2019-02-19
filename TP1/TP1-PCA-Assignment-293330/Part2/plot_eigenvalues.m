function [lambda] = plot_eigenvalues( L )
%PLOT_EIGENVALUES Simple plotting function to visualize eigenvalues
%   The student should convert the Eigenvalue matrix to a vector and 
%   visualize the values as a 2D plot.
%   input -----------------------------------------------------------------
%   
%       o L      : (N x N), Diagonal Matrix composed of lambda_i 
%   output -----------------------------------------------------------------
%
%       o lambda  : (N x 1), Vector of eigenvalues lambda_i 

% Extract lambda
% Plot eigenvalues
lambda = diag(L);
plot(lambda,'b--')
xlabel("Eigenvector index")
ylabel("Eigenvalues")
title("Eigenvalues")
grid on
ax = gca;
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
ax.Layer = 'top';

end

