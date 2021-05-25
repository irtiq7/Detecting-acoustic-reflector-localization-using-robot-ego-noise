%% For estimating pitch based on harmonic summation model

function [arg_f, Harmonic_max, Z0] = get_fundamental_freq(wavdata, Fs, f_min, f_max, resolution, L_max)
    % Parameter check
    N = length(wavdata);
    if f_min < Fs/N
        disp('The f_min should be more than the frequency resolution(Fs / N).')
    else
        disp('The f_max should be less than sampling rate Fs.')
    % Define the range of frequencies
    f_list = linspace(f_min, f_max, resolution);
    
    % Generate the z-vector and harmnic summation list
    s = (0:N);
    Harmonic_sum = zeros(length(f_list), 1);
    Z_list = zeros(length(f_list), 1);
    
    for ii = 1:length(f_list)
        % Construct the zc and zs matrix
        zc = zeros(length(f_list, 1));
        zs = zeros(length(f_list, 1));
        for ll = 1:length(L_max+1)
            zc(ll) = cos(2*pi*f_list(ii)*ll*z/Fs);
            zs(ll) = sin(2*pi*f_list(ii)*ll*z/Fs);
        end
        zc = zc';
        zs = zs';
        
        Z = [zc;zs];
        Z_list(ii) = Z;
        
        %Compute the harmonic summation
        Zx = Z'.*wavdata;
        Harmonic_sum(ii) = Zx'.*Zx;
        Z_list(ii)=Z;
    end
    arg_i = max(Harmonic_sum);
    
    %Fundamental frequency
    arg_f = f_list(arg_i);
    %Maximum value
    Harmonic_max = Harmonic_sum(arg_i);
    
    Z0 = Z_list(arg_i);
end