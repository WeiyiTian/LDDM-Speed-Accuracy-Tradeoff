%% for reaction time by histogram
% QMLE, quantile maximum likelihood estimation
% reference: Heathcote & Australia, and Mewhort, 2002.
% Chi-square, reference: Ratcliff & McKoon, 2007.
LL = log(0);
Chi2 = 0;
h = figure;
for vi = 1:6
  En(vi) = numel(rtmat(:,vi));
  RT_corr = rtmat(choicemat(:,vi) == 1,vi);
  RT_wro = rtmat(choicemat(:,vi) == 2,vi);
  if ~all(isnan(q(:,1,vi)))
    tmp = histogram(RT_corr, [0; q(:,1,vi); Inf], 'Visible',0);
    EN(:,1,vi) = tmp.Values;
  else
    EN(:,1,vi) = NaN(numel(q(:,1,vi))+1,1);
  end
  if ~all(isnan(q(:,2,vi)))
    tmp = histogram(RT_wro, [0; q(:,2,vi); Inf], 'Visible',0);
    EN(:,2,vi) = tmp.Values;
  else
    EN(:,2,vi) = NaN(numel(q(:,2,vi))+1,1);
  end
  f(:,:,vi) = log((EN(:,:,vi)/En(vi)));
  f(f(:,1,vi) == -Inf,1,vi) = log(.1/En(vi)); % set floor value of f at each point, to prevent -Inf
  f(f(:,2,vi) == -Inf,2,vi) = log(.1/En(vi)); % set floor value of f at each point, to prevent -Inf
  ON_adj(:,:,vi) = ON(:,:,vi)*En(vi)./On(vi);
end
close(h);
LL = sum(ON(:).*f(:),'omitnan');
Chi2vec = (EN - ON_adj).^2./EN;
Chi2 = sum(Chi2vec(:),'omitnan');
n = sum(~isnan(ON(:).*f(:)));
k = numel(params);
BIC = k*log(n) - 2*LL;
AIC = 2*k - 2*LL;
nLL = -LL;