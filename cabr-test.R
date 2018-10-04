# clear global environment
rm(list=ls())
dev.off()

library(ggplot2)


pathin ='/Users/ethan/Desktop/cabr-test'
setwd(pathin)

file = 'abr12.csv'
df_temp = read.csv(file, sep = ';')

names(df_temp) <- c("point", "time_ms", "d", "uV", "B1", "B2", "B3", "B4")


#df <- data.frame("time_ms" = df_temp$time_ms)

df$abr12 <- df_temp$uV

df$grand_mean <- rowMeans(df[,-1])

ggplot(data=df, aes(x= time_ms, y=abr6)) + geom_point() + geom_line()
ggplot(data=df, aes(time_ms)) + 
  geom_line(aes(y = abr6, colour = "abr6")) + 
  geom_line(aes(y = abr7, colour = "abr7")) +
  geom_line(aes(y = abr8, colour = "abr8")) +
  geom_line(aes(y = abr9, colour = "abr9")) +
  geom_line(aes(y = abr10, colour = "abr10")) +
  geom_line(aes(y = abr11, colour = "abr11")) +
  geom_line(aes(y = abr12, colour = "abr12"))

ggplot(data=df, aes(x= time_ms, y=abr6)) + geom_point() + geom_line() + ggtitle("abr6")
ggplot(data=df, aes(x= time_ms, y=abr7)) + geom_point() + geom_line() + ggtitle("abr7")
ggplot(data=df, aes(x= time_ms, y=abr8)) + geom_point() + geom_line() + ggtitle("abr8")
ggplot(data=df, aes(x= time_ms, y=abr9)) + geom_point() + geom_line() + ggtitle("abr9")
ggplot(data=df, aes(x= time_ms, y=abr10)) + geom_point() + geom_line() + ggtitle("abr10")
ggplot(data=df, aes(x= time_ms, y=abr11)) + geom_point() + geom_line() + ggtitle("abr11")
ggplot(data=df, aes(x= time_ms, y=abr12)) + geom_point() + geom_line() + ggtitle("abr12")

# abr 11 and 12 are identical

library(tuneR)

newWobj <- readWave("da_40.wav")
newWobj
plot(newWobj)
w = newWobj@left

library(scales)

ws <- rescale(w, to = c(min(df$abr11), max(df$abr11)))
#437 0 onset
#717 7ms delay cochlea to rostral brainstem transfer
wpad1 <- c(rep(NA, 437),ws)
#wpad1 <- c(rep(NA, 717),ws)
wpad2 <- c(wpad1, rep(NA, length(df$time_ms) - length(wpad1)))
#w2 <- c(rep(0, length(df$time_ms) - length(ws)), ws)

df$wav <- wpad2
df$waveform <- df$wav + 0.5
ggplot(data=df, aes(time_ms)) + 
  geom_line(aes(y = abr11, colour = "abr11")) + 
  geom_line(aes(y = waveform, colour = "waveform"))
