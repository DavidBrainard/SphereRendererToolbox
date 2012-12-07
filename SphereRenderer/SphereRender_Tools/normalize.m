function B = normalize(A)

% Ntemp1=sum(A.^2)
% Ntemp2=sqrt(Ntemp1)
% Ntemp3=repmat(Ntemp2,3,1)
% B=A./Ntemp3

B=A./repmat(sqrt(sum(A.^2)),3,1);

%B = A(1:3)./repmat(sqrt(sum(A(1:3,:).^2)),3,1);