function es12()

l = [9 10]; % length of the signals

for i = 1:size(l,2)
    % generate random signal and filter it in the Fourier domain
    [s, s_f, ss] = signal(l(i));

    % plot original and filtered signals
    subplot(2,size(l,2),i);
    hold on;
    plot(s);
    plot(s_f);
    title(sprintf('N = %d', l(i)));

    % plot spectrum
    subplot(2,size(l,2),size(l,2)+i);
    plot(ss); 
end

end

% l is the length of the signal
function [a, a_f, as] = signal(l)
a = rand(1,l);                   % random signal
s = fftshift(fft(a));            % shifted spectrum
as = abs(s);                     % abs of the spectrum
s(1:(2-mod(l,2))) = 0; s(l) = 0; % cancel some high frequencies
a_f = ifft(ifftshift(s));        % transform back
end
