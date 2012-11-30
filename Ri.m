function M=Ri(m,n,s,alpha)

ROWS=31;
COLS=31;
xLim=(COLS-1)/2;
yLim=(ROWS-1)/2;

X=repmat([-xLim:xLim],ROWS,1);
Y=repmat([yLim:-1:-yLim]',1,COLS);
R=X.^2+Y.^2;

M=1/(pi*(alpha*s)^2)*exp(-R/(alpha*s)^2);