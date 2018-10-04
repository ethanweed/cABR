
da_grandaverage = da40{513:933,6};
gax = linspace(0,40, length(da_grandaverage));
plot(gax, da_grandaverage, 'LineWidth', 2, 'LineColor', 'black');
title('ABR response to "da" syllable');
xlabel('Time (ms)')
ylabel('µV')


dawave = dasound{:,1};


ba = badaga{:,3};
da = badaga{:,4};
ga = badaga{:,5};
time = badaga{:,2};

bamat = reshape(ba,[],16);
damat = reshape(da,[],16);
gamat = reshape(ga,[],16);

f = linspace(100,1000,10);

for i = 1:16
	[pxy,f] = cpsd(damat(:,i),gamat(:,i),[],[],[],43700);
	P = angle(pxy);
	Q = unwrap(P);
	phase(:,i) = Q;
	freq(:,i) = f;
	t(:,i) = i;
end

Phase = reshape(phase,[],1);
Freq = reshape(freq,[],1);
Time = reshape(t,[],1);

% make plots
x = Time;
y = Freq;
z = Phase;



% plot ABR wave
x1 = linspace(0,20,1024);
ax1 = subplot(2,1,1);
ax1 = plot(x1, da, x1, ga, 'LineWidth', 2);
xlim([1 x1(end)])
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

% plot phaseogram
xi=linspace(0,20,16);
yi=linspace(min(y),max(y));
[XI YI]=meshgrid(xi,yi);
ZI = griddata(x,y,z,XI,YI);


contourf(XI,YI,ZI);
xlabel('Time (ms)');
ylabel('Frequency (Hz)')

surf(XI,YI,ZI);