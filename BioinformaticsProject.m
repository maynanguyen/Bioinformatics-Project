% COMMENTS to define data expectations
% This script expects a .csv file input
% define -.csv file format....

% Read in .csv file
  data = csvread('Bioinformatics Data.csv',1); % actual file here!%
 % data = csvread('DrDan.csv', 1);   % example file here!

 % Make list of the data - rating and truth
  truth = data(:,1);
  rating = data(:,2);
  
  % find max rating value for any rating system
  truth_length = length(truth);
  max = rating(1);
  for i= 1:truth_length
      if rating(i)>max
          max=rating(i);
      end
  end

% Create ROC curve for thresholds 1-5
   figure(); 
    for i = (1:max)
    m = confmat(truth, rating, i);
    a1 = m(1,1);
    b1 = m(2,1);
    c1 = m(1,2);
    d1 = m(2,2);
      sens(i) = a1 / (a1+b1); % Make an array for sens, spec
      spec(i) = d1 / (d1+c1); 
     hold on;
   
    end
    sens(max+1) = 0;
    spec(max+1) = 1;
  %   plot (1-spec, sens, '*');
     line (1-spec, sens);     
    title('ROC Curve');
    ylabel('sensitivity or TPF');
    xlabel('1-specificity or FPF');
     
    hold off;
    % Calculates area under ROC curve
    % need neg sign because for low thresholds, 1-spec is higher, 
    % basically x moves right to left or in the negative direction
    area= -(trapz(1-spec, sens));
    
    
    % Find the best threshold using the distance formula
    % Our arrays are 1-spec, sens
    for i = 1:max+1
        x = 1-spec(i);
        x2 = 0;
        y = sens(i);
        y2 = 1;
        dist(i) = sqrt (((x-x2)^2) + ((y-y2)^2));
    end
    dist = fliplr(dist); % flip the array that went R->L so you can decide threshold value
    min_dist = dist(1);
    for i=1:6
        if dist(i) < min_dist
            min_dist = dist(i); % new min_dist
            threshold = i-1; %subtract 1 because first point is (0,0), new best threshold
        end
    end
% The best threshold is the point closest to (0,1), found above

% For the best threshold, find the results.
matrix = confmat(truth, rating, threshold);
    A = matrix(1,1);
    B = matrix(2,1);
    C = matrix(1,2);
    D = matrix(2,2);
sensitivity = A / (A+B);
specificity = D / (D+C);
accuracy = (A+D)/(A+B+C+D);
prevalence = (A+B) / (A+B+C+D);
PPV = A / (A+C);
NPV = D / (B+D);


% This function creates a confusion matrix for a given data set and
% threshold.
function confusion_matrix = confmat(truth, rating, threshold)
truth_length = length(truth); % length of both arrays
A=0; B=0; C=0; D=0; % initialize variables
% Make confusion matrix, for each threshold
         for i = (1:truth_length)          %iterate through the arrays using same index
          if (truth(i) == 1) %             if prediction (with selected threshold value) = true or false
              if (rating(i) >= threshold)
               A = A+1;     % A = truth & predicted
               else
                 B =B+1;    % B = truth & not predicted
              end
            else if (truth(i) == 0)
                   if (rating(i) >= threshold)
                    C = C+1;    % C = not truth & predicted 
                     else 
                    D = D+1;    % D = not truth & not predicted
                   end
                end
         end
         end
confusion_matrix = [A,C;B,D];
end

% Output results & conclusion


