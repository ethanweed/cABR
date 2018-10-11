
% Plot cross-phaseogram
% Datafile: csv imported as Matlab table with columns for conditions to be
% compared, plus a column for time. In this case, there were three
% conditions: ba, da, and ga syllables

%%
% extract vectors for each condition and time
ba = badaga{:,3};
da = badaga{:,4};
ga = badaga{:,5};
time = badaga{:,2};
%%

%%
% window each vector, in this case into 16 windows
bamat = reshape(ba,[],16);
damat = reshape(da,[],16);
gamat = reshape(ga,[],16);


%%

%f = linspace(100,1000,10);

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

x = Time;
y = Freq;
z = Phase;

%%
% make plots
% plot ABR wave
x1 = linspace(0,20,1024);
ax1 = subplot(2,1,1);
ax1 = plot(x1, da, x1, ga, 'LineWidth', 2);
xlim([1 x1(end)])
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

%%
% prepare data for contour or surface plotting
xi=linspace(0,20,16);
yi=linspace(min(y),max(y));
[XI YI]=meshgrid(xi,yi);
ZI = griddata(x,y,z,XI,YI);

%%
% plot phaseogram
contourf(XI,YI,ZI);
xlabel('Time (ms)');
ylabel('Frequency (Hz)')


%%
% plot surface plot
surf(XI,YI,ZI);