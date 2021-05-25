function [y1] = calculate_rmse(bb,true_toe)

xx = length(bb);
mm = zeros(size(bb));

mm = (bb - true_toe).^2;
mean_mm = sum(mm)/xx;



y1 = sqrt(mean_mm);
end