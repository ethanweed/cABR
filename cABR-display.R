# clear global environment
rm(list=ls())
dev.off()

library(ggplot2)


#pathin <- '/Users/ethan/Dropbox/Research/Projects/Projects_current/cABR/cABR-test-2018/cabr_April13/data'
#pathin <-'/Users/ethan/Desktop/ethan-october/'
#pathin <- '/Users/ethan/Dropbox/Research/Projects/Projects_current/cABR/cABR-test-2018/test-04-04-18/data/125us/'
pathin <- '/Users/ethan/Dropbox/Research/Projects/Projects_current/cABR/the-golden-signal/'
setwd(pathin)

file = 'click_right.csv'

file1 = 'da40rarefz.csv'
file2 = 'da40condfz.csv'
file3 = 'da40altfz.csv'


df = read.csv(file, sep = ',')

df1 = read.csv(file1, sep = ',')
df2 = read.csv(file2, sep = ',')
df3 = read.csv(file3, sep = ',')




names(df) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")

names(df1) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")
names(df2) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")
names(df3) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")

df <-subset(df, df$uV > 0)

df1 <- subset(df1, df1$uV>0)
df2 <- subset(df2, df2$uV>0)
df3 <- subset(df3, df3$uV>0)

df1 <- df1[1:240,]
df3 <- df3[1:240,]

df$uV <- df$uV*-1

df1$uV <- df1$uV*-1
df2$uV <- df2$uV*-1
df3$uV <- df3$uV*-1

ggplot(data=df, aes(x= time_ms, y=uV)) + geom_line(size = 1, color = "black") + xlim(-10,60)


# make a single df with all three consonants
df <- data.frame("time_ms" = df1$time_ms, 
                  "ba" = df1$uV, 
                  "da" = df2$uV,
                  "ga" = df3$uV)
df$uV <- rowMeans(df[,-1])

# make a single df with all three polarities
df <- data.frame("time_ms" = df1$time_ms, 
                 "rare" = df1$uV, 
                 "alt" = df2$uV,
                 "cond" = df3$uV)
df$uV <- rowMeans(df[,-1])

library(clipr)
write_clip(df)

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
  geom_line(aes(y = ba, color = "ba")) +
  geom_line(aes(y = da, color = "da")) +
  geom_line(aes(y = ga, color = "ga")) +
  ggtitle("/da/")
  


# plot all three polarities
ggplot(data=df, aes(time_ms )) + 
  geom_line(aes(y = rare, color = "rarefaction")) +
  geom_line(aes(y = cond, color = "condensation")) +
  geom_line(aes(y = alt, color = "alternating")) +
  ggtitle("/da/") + 
  xlim(-10,65)


# plot 2 at a time for figure
ggplot(data=df, aes(time_ms )) +
  geom_line(aes(y = ba, colour = "ba", size = 1.2)) +
  geom_line(aes(y = ga, colour = "ga", size = 1.2)) +
  xlim(2,16) +
  theme_classic()


# plot sum
ggplot(data=df, aes(x= time_ms, y=uV)) + geom_line(size = 2.2, color = "black") + xlim(-10,65)

#########
library(phonTools)

wavfile <- 'da_40.wav'
wavfile <- 'wave.wav'

sound <- loadsound(wavfile)

pitchtrack(sound)
spectrogram (sound)
pitchtrack (sound, addtospect = TRUE)






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


 
