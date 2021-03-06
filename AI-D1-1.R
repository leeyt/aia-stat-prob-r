# 18/30
# 解決中文顯示問題
# Sys.setlocale(category="LC_ALL", locale = "en_US.UTF-8")
score2015.orig <- read.table("data/score2015.txt", header=T, sep = "\t", encoding = "UTF-8")
dim(score2015.orig)
head(score2015.orig)
summary(score2015.orig[, 3:ncol(score2015.orig)])
table(score2015.orig["出席次數"])

# 19/30
score2015 <- score2015.orig
score2015[is.na(score2015)] <- 0
colMeans(score2015[, 5:11])
apply(score2015[, 5:11], 1, mean)
apply(score2015[, 5:11], 2, sd)
x <- score2015[,"小考1"]
min(x)
max(x)
sum(x)
mean(x)
mean(x, trim=0.1)
median(x)

# R 沒有內建的眾數函數
Mode <- function(x, na.rm = FALSE) {
  if(na.rm) x = x[!is.na(x)]
  ux <- unique(x)
  ifelse(length(x)==length(ux),
         "no mode",
         ux[which.max(tabulate(match(x, ux)))])
}

Mode(x)
quantile(x)
quantile(x, prob= seq(0, 100, 10)/100)
range(x)
sd(x)
var(x)

# 29/30
library("corpcor")
library("MASS")
n <- 6    # try 20, 500
p <- 10   # try 100, 10
set.seed(123456)
# generate random pxp covariance matrix
sigma <- matrix(rnorm(p * p), ncol = p)
sigma <- crossprod(sigma) + diag(rep(0.1, p))

# mvrnorm {MASS}:
#   mvrnorm(n = 1, mu, Sigma, ...)

# simulate multivariate-normal data of sample size n
x <- mvrnorm(n, mu=rep(0, p), Sigma=sigma)
# estimate covariance matrix
s1 <- cov(x)
s2 <- cov.shrink(x)
par(mfrow=c(1,3))
image(t(sigma)[,p:1], main="true cov", xaxt="n", yaxt="n")
image(t(s1)[,p:1], main="empirical cov", xaxt="n", yaxt="n")
image(t(s2)[,p:1], main="shrinkage cov", xaxt="n", yaxt="n")

# squared error
sum((s1 - sigma) ^ 2)
sum((s2 - sigma) ^ 2)

# 30/30

# compare positive definiteness
is.positive.definite(sigma)
is.positive.definite(s1)
is.positive.definite(s2)

# compare ranks and condition
rc <- rbind(
  data.frame(rank.condition(sigma)),
  data.frame(rank.condition(s1)),
  data.frame(rank.condition(s2)))
rownames(rc) <- c("true", "empirical", "shrinkage")
rc

# compare eigenvalues
e0 <- eigen(sigma, symmetric = TRUE)$values
e1 <- eigen(s1, symmetric = TRUE)$values
e2 <- eigen(s2, symmetric = TRUE)$values
matplot(data.frame(e0, e1, e2), type = "l", ylab="eigenvalues", lwd=2)
legend("top", legend=c("true", "empirical", "shrinkage"), lwd=2, lty=1:3, col=1:3)
