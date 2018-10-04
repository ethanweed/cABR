# clear global environment
rm(list=ls())
dev.off()

library(ggplot2)


pathin <- '/Users/ethan/Dropbox/Research/Projects/Projects_current/cABR/cABR-test-2018/cabr_April13/data'
#pathin <-'/Users/ethan/Desktop/cABR-test-2018/test-28-03-18/data/'
setwd(pathin)

#file = 'da40altfz.csv'

file1 = 'cba1.csv'
file2 = 'cda1.csv'
file3 = 'cga1.csv'


df = read.csv(file, sep = ',')

df1 = read.csv(file1, sep = ',')
df2 = read.csv(file2, sep = ',')
df3 = read.csv(file3, sep = ',')


names(df) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")

names(df1) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")
names(df2) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")
names(df3) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")

ggplot(data=df, aes(x= time_ms, y=uV)) + geom_line(size = 1, color = "black") + xlim(0,42)


# make a single df with all three consonants
df <- data.frame("time_ms" = df1$time_ms, 
                  "ba" = df1$uV, 
                  "da" = df2$uV,
                  "ga" = df3$uV)
df$uV <- rowMeans(df[,-1])



# plot grand average
ggplot(data=df, aes(x= time_ms, y=uV)) +
  geom_line(size = 1.8, color = "black") +
  theme_classic() +
  theme(text=element_text(family="Arial", size=10)) +
  xlab('time (ms)') + 
  ylab('micro Volts') +
  xlim(0,42)

# plot all three consonants
ggplot(data=df, aes(time_ms )) + 
  geom_line(aes(y = ba, colour = "ba")) +
  geom_line(aes(y = da, colour = "da")) +
  geom_line(aes(y = ga, colour = "ga")) +
  xlim(-2,42) +
  ggtitle("ba vs da vs ga")

# plot 2 at a time for figure
ggplot(data=df, aes(time_ms )) +
  geom_line(aes(y = ba, colour = "da", size = 1.8)) +
  geom_line(aes(y = ga, colour = "ga", size = 1.8)) +
  xlim(0,20) +
  theme_classic()


# plot alternating only
ggplot(data=df, aes(x= time_ms, y=uV1)) + geom_line(size = 2.2, color = "red") + xlim(0,42)

####################
# try reading in several waves, and see if they match up. 

library(tuneR)
library(seewave)
wave <- df$uV
savewav(wave, 8000)

library(tuneR)
newWobj <- readWave("da_40.wav")
newWobj
plot(newWobj)
w = newWobj@left



newWobj <- readWave("da_40.wav")

library(scales)
ws <- rescale(w, to = c(min(df$uV), max(df$uV)))
plot(ws)
#wpad1 <- c(rep(NA, 1024),ws)
#wpad2 <- c(wpad1, rep(NA, length(df$time_ms) - length(wpad1)))

#df$wav <- ws
#ggplot(data=df, aes(time_ms)) + 
#  geom_line(aes(y = uV, colour = "uV")) + 
  
  
library(fftw)
library(spectral)

z<-FFT(df$ba)

plot.frequency.spectrum <- function(X.k, xlimits=c(0,length(X.k))) {
  plot.data  <- cbind(0:(length(X.k)-1), Mod(X.k))
  
  # TODO: why this scaling is necessary?
  plot.data[2:length(X.k),2] <- 2*plot.data[2:length(X.k),2] 
  
  plot(plot.data, t="h", lwd=2, main="", 
       xlab="Frequency (Hz)", ylab="Strength", 
       xlim=xlimits, ylim=c(0,max(Mod(plot.data[,2]))))
}

# Plot the i-th harmonic
# Xk: the frequencies computed by the FFt
#  i: which harmonic
# ts: the sampling time points
# acq.freq: the acquisition rate
plot.harmonic <- function(Xk, i, ts, acq.freq, color="red") {
  Xk.h <- rep(0,length(Xk))
  Xk.h[i+1] <- Xk[i+1] # i-th harmonic
  harmonic.trajectory <- get.trajectory(Xk.h, ts, acq.freq=acq.freq)
  points(ts, harmonic.trajectory, type="l", col=color)
}

plot.frequency.spectrum(z, xlimits=c(0,200))
plot.frequency.spectrum(z)


  geom_line(aes(y = wav, colour = "wav"))
  
  
write.csv(file='da_40.csv', x=df)
write.csv(file='da-sound.csv', x=w)


 