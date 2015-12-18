function [err, thres, parity, stumpResp, r] = trainStump(f, useAbs, X, y, ...
                                                  w, debug)
  %[err, thres, parity, stumpResp, r] = trainStump(f, useAbs, X, y, ...
  %                                                w, debug)
  % Input:
  %  f - N dimensional projection vector.
  %  useAbs - boolean, whether to use f(:)' * X or abs(f(:)' * X) as
  %     the feature.
  %  X  - N x K training matrix.
  %  y  - 1 x K label matrix, with y(k) = 1 indicating target, 0
  %       non-target.
  %  w  - 1 x K vector of weights.  Precondition: w(k) >= 0, sum_k w(k) > 0
  %  debug = 0, 1, or 2 for no info, histogram plot, more info,
  %         respectively.
  % Output
  %  err - (double) minimum weighted error of weak classifier (see (2) in
  %        the assignment handout).
  %  thres - (double) the optimum threshold theta_1 in (1) of the assignment.
  %  parity - (-1 or 1) the optimum parity theta_2 in (1) of the assignment.
  %  stumpResp - binary, 1 by K, optimum weak classifier response on X,
  %             i.e., the value of h(x,theta) in (1) of the assignment, 
  %             for the optimum parameters theta.
  %  r  - double 1 by K, the continuous valued response u(f(:)' * X)
  %       used by the optimum weak classifier (see (1) in the assignment).

  sumW = sum(w);
  
  sumWNon = sum(w .* (y == 0));

  r = f(:)' * X;
  if useAbs
    r = abs(r);
  end
  
  if debug & any(y > 0) & any(y == 0)
    % Plot histogram of (unweighted) responses.
    [hTarg, hxTarg] = histo(r(y>0), 101);
    hTarg = hTarg/(sum(hTarg) * (hxTarg(2) - hxTarg(1)));
    [hNon, hxNon] = histo(r(y==0), 101);
    hNon = hNon/(sum(hNon) * (hxNon(2) - hxNon(1)));
    figure(100); clf;
    plot(hxTarg, hTarg, 'g');
    hold on;
    plot(hxNon, hNon, 'r');
    xlabel('Response');
    ylabel('Probability');
    pause(0.1);
  end
  
  %%%%%% YOU NEED TO FILL IN CODE HERE
  %% You can change anything in this M-file (except the parameters
  %% and return values)
  %K = size(r,2);
  weightTar = w.*(y==1);
  weightNon = w.*(y==0);
  D = [r' weightTar' weightNon'];
  
  D = sortrows(D)';
  
  % parity 1
  trueTargPosCumSum = fliplr(cumsum(fliplr(D(2,:))));
  falseTargPosCumSum = cumsum(D(3,:));
  totalPosCumSum = trueTargPosCumSum + falseTargPosCumSum;
  [errSum_p1, index]= min(totalPosCumSum);
  theta1_p1 = D(1,index);
  
  % parity -1
  trueTargPosCumSum = cumsum(D(2,:));
  falseTargPosCumSum = fliplr(cumsum(fliplr(D(3,:))));
  totalPosCumSum = trueTargPosCumSum + falseTargPosCumSum;
  [errSum_n1, index]= min(totalPosCumSum);
  theta1_n1 = D(1,index);
  
  if( errSum_p1 < errSum_n1) 
     thres = theta1_p1;
     parity = 1;
     stumpResp = r <= thres;
     err = errSum_p1/sumW;
  else 
     thres = theta1_n1;
     parity = -1;
     stumpResp = r > thres;
     err = errSum_n1/sumW;
  end
  %fprintf('True/False Pos. Rates: %f, %f, thres: %f, parity: %i, err: %f\n', ...
   %         sum(stumpResp(y>0) >0)/sum(y>0), sum(stumpResp(y==0) >0)/sum(y==0),thres, parity,err);

  if debug
    % Plot threshold on histogram figure
    figure(100); hold on;
    ax = axis;
    plot([thres, thres], ax(3:4), 'k');
    title('Hist. of Weak Classifier, Targ/Non (g/r), Threshold (k)');
    pause(0.1);
  end

  return;

  
