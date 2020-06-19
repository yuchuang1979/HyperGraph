clear all;
% build H matri
legs = [0,2,4,5,6,8];

load attributes
hyperEs = [];

for i = 1:1:16
    if i==13
        for j=1:1:5
            hyperE = (attributes(:,i)==legs(j));
            hyperEs = [hyperEs,hyperE];
        end
    else
        hyperE = (attributes(:,i)== 1);
        hyperEs = [hyperEs,hyperE];
    end
end

H = hyperEs;
[n_v,n_e] = size(H);

% get D_{v}
Dv = diag(sum(H,2));

% get D_{e}
De = diag(sum(H,1));

% get W_{0}
W = eye(n_e);

alpha = 0.5;

% get y, since this is a semi-supervised work
load nameLabels
permed = randperm(n_v);
% we take 10 animals as labeled data. we make mammals as +1 and others as
% -1
labels = zeros(n_v,1);
for i=1:1:10
    ind = permed(i);
    if nameLabels(ind).label == 1
        labels(ind) = 1;
    else
        labels(ind) = -1;
    end
end

posSum = sum(labels>0);
negSum = sum(labels<0);

for i=1:1:length(labels)
    if labels(i)>0
        labels(i) = 1/posSum;
    end
    if labels(i)<0
        labels(i) = -1/negSum;
    end
end

labels_all = zeros(n_v,1);
for i=1:1:n_v
    if nameLabels(i).label == 1
        labels_all(i) = 1;
    else
        labels_all(i) = -1;
    end
end

mu = 5;

alpha = mu/(1+mu);


rho = 1;
%Now design the Q matrix in 1/2*x'*Q*x + m'*x
% at first define delta
delta = zeros(n_e,n_e);
for ind_e1 = 1:1:n_e
    for ind_e2 = ind_e1:1:n_e
        currentE1 = H(:,ind_e1);
        currentE2 = H(:,ind_e2);
        overlapE12 = currentE1.*currentE2;
        temp = (sum(overlapE12)).^2/sum(currentE1)/sum(currentE2);
        if temp>0.4
            delta(ind_e1,ind_e2) = temp;
            delta(ind_e2,ind_e1) = temp;
        else
            delta(ind_e1,ind_e2) = 0;
        end
    end
end

D_Sig = diag(sum(delta,2));

Q = 2*rho*( eye(n_e) - D_Sig^(-0.5)*delta*D_Sig^(-0.5) + (eye(n_e)-D_Sig^(-1)*delta)*(eye(n_e)-D_Sig^(-1)*delta)' );

save dataForHyper2