% Eyeball a logistic model to log pOn/pOff
% See the README file for how to use this script.

clear;

marking = 0; % 0 back, 1 head

if marking == 0
  resDir = './back/';
elseif marking == 1
  resDir = './head/';
end

for pigMode = 2 % 1 or 2 or 1:2

  load(sprintf('%srespHistPig%dmark%dOff', resDir, pigMode, marking)); 
  respHistOff = respHist;
  load(sprintf('%srespHistPig%dmark%dOn', resDir, pigMode, marking)); 
  respHistOn = respHist;
  
  % YOU NEED TO CHANGE lambda, mu and scl for each case below.
  if (pigMode == 1)
    if marking == 1
      lambda = 16;
      mu = 0.30;
      scl = 5.5;
      
      
    elseif marking == 0
      lambda = 16;
      mu = 0.38;
      scl = 6.5;
    end
    
  elseif (pigMode == 2)

  % YOU NEED TO CHANGE lambda, mu and scl for each case below.
    if marking == 1
      lambda = 30;
      mu = 0.12;
      scl = 7;
    elseif marking == 0
      lambda = 20;
      mu = 0.28;
      scl = 6.3;
    end
    
  end
  
  if (pigMode == 3)

  % YOU NEED TO CHANGE lambda, mu and scl for each case below.
   if marking == 1
      lambda = 16;
      mu = 0.30;
      scl = 5.5;
      
      
    elseif marking == 0
      lambda = 22;
      mu = 0.24;
      scl = 5.0;
    end
    
  end
  
  

  respHistOn = respHistOn/sum(respHistOn);
  respHistOff = respHistOff/sum(respHistOff);

  figure(1); clf;
  plot(log(respHistOn + 0.001), 'b');
  hold on; 
  plot(log(respHistOff + 0.001), 'r');
  title('Log Histogram of P-on (b) vs P-off (r)');
  fprintf(2, 'Hit any key to continue...');
  pause;
  fprintf(2, '\n');

  x = (1:length(respHistOff))/length(respHistOff);


  model = scl * (1 - exp(-lambda*(x-mu)))./(1+exp(-lambda*(x-mu)));


  figure(2); clf;
  plot(x, log(respHistOn + 0.0001)-log(respHistOff+0.0001), 'b');
  hold on; plot(x, model, 'g');
  title('Log (P-on / P-off) (b), Logistic model (g)');
  fprintf(2, 'If you are not satisfied with the fit, reset the\n');
  fprintf(2, 'logistic params and rerun fitLogOdds\n');
  
  if true
    load(sprintf('%shog%dmark%d', resDir, pigMode, marking));
    hogParams.lambda = lambda;
    hogParams.mu = mu;
    hogParams.scl = scl;
    save(sprintf('%shog%dmark%d', resDir, pigMode, marking), ...
         '-V6', 'hogParams');
  end
   
  fprintf(2, 'Hit any key to continue...');
  pause;
  fprintf(2, '\n');

end