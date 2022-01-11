
library(rcompanion)
library(car)
library(dplyr)
library(effects)
library(multcomp)
library(gmodels)
library(ggplot2)
library("caret")
library("gvlma")
library("predictmeans")
library("e1071")
library("lmtest")


Wins <- read.csv("AllWinners.csv")
View(Wins)


# Testing Assumptions


Wins$Gender <- as.factor(Wins$Gender)
Wins$Jackpot <- as.factor(Wins$Jackpot)
### Normality
plotNormalHistogram(Wins$Amount)
#  positive skew
Wins$AmountSQRT <- sqrt(Wins$Amount)
plotNormalHistogram(Wins$AmountSQRT)
#  positive skew
Wins$AmountLOG <-log(Wins$Amount)
plotNormalHistogram(Wins$AmountLOG)
#better but negatively kurtotic. let's use Tukey's Ladder of Power Transformation 
Wins$AmountTUK <- transformTukey(Wins$Amount, plotit=FALSE)
plotNormalHistogram(Wins$AmountTUK)
#plot is the same as the log transformation. will use AmountLOG


### Homogeneity of Variance

leveneTest(Wins$AmountLOG~Gender, data=Wins)

# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value  Pr(>F)  
# group   3  2.8571 0.03665 *
#       485                  
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# Results were  significant, so the assumption is not met! use the Anova() to correct for violation

### Homogeneity of Regression Slopes

Homogeneity_RegrSlp = lm(Wins$AmountLOG~Jackpot, data=Wins)
anova(Homogeneity_RegrSlp)


# Analysis of Variance Table
# 
# Response: Wins$AmountLOG
# Df  Sum Sq Mean Sq F value    Pr(>F)    
# Jackpot     1 2114.17 2114.17  2600.6 < 2.2e-16 ***
#   Residuals 487  395.92    0.81                      
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# Unfortunately, since the p value is significant, our data does not meet the assumption of homogeneity of regression slopes. That means that whether someone won a jackpot or not actually does have an impact on the size of their prize, and that you should NOT use Jackpot as a covariate, but rather include it as a second independent variable in the model
.
### Sample size is met - need 20 per IV or CV and we have 2, so need at least 40 and there are 489 cases!

## Running the Analysis

ANCOVA = lm(AmountLOG~Jackpot + Gender*Jackpot, data=Wins)
Anova(ANCOVA,Type="I", white.adjust=TRUE)
# 
# Analysis of Deviance Table (Type II tests)
# 
# Response: AmountLOG
#                    Df     F        Pr(>F)    
# Jackpot            1    2661.3569  < 2e-16 ***
#   Gender           3    3.4708     0.01609 *  
#   Jackpot:Gender   3    0.4657     0.70637    
# Residuals      481                      
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# Gender does influence the size the prize. Controlling for whether or not it as a jackpot the influence disappears 
# -------------------------------------------

MenVWomen<- Wins %>% filter(Gender %in% c("M", "F"))
View(MenVWomen)

### Testing Assumptons

### Normality

MenVWomen$Gender <- as.factor(MenVWomen$Gender)
MenVWomen$Jackpot <- as.factor(MenVWomen$Jackpot)
### Normality
plotNormalHistogram(MenVWomen$Amount)
#  positive skew
MenVWomen$AmountSQRT <- sqrt(MenVWomen$Amount)
plotNormalHistogram(MenVWomen$AmountSQRT)
#  positive skew
MenVWomen$AmountLOG <-log(MenVWomen$Amount)
plotNormalHistogram(MenVWomen$AmountLOG)
#better but negatively kurtotic. let's use Tukey's Ladder of Power Transformation 
MenVWomen$AmountTUK <- transformTukey(MenVWomen$Amount, plotit=FALSE)
plotNormalHistogram(MenVWomen$AmountTUK)
#plot is the same as the log transformation. will use AmountLOG


### Homogeneity of Variance

leveneTest(MenVWomen$AmountLOG~Gender, data=MenVWomen)

# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value  Pr(>F)  
# group   1  5.1109 0.02446 *
#       312                  
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# Results were  significant, so the assumption is not met! use the Anova() to correct for violation

### Homogeneity of Regression Slopes

MVWHomogeneity_RegrSlp = lm(MenVWomen$AmountLOG~Jackpot, data=MenVWomen)
anova(MVWHomogeneity_RegrSlp)

# Analysis of Variance Table
# 
# Response: MenVWomen$AmountLOG
# Df  Sum Sq Mean Sq F value    Pr(>F)    
# Jackpot     1 1177.23 1177.23  1607.6 < 2.2e-16 ***
#   Residuals 312  228.47    0.73                      
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# Unfortunately, since the p value is significant, our data does not meet the assumption of homogeneity of regression slopes. That means that whether someone won a jackpot or not actually does have an impact on the size of their prize, and that you should NOT use Jackpot as a covariate, but rather include it as a second independent variable in the model
.
### Sample size is met - need 20 per IV or CV and we have 2, so need at least 40 and there are 314 cases!

## Running the Analysis

MVWANCOVA = lm(AmountLOG~Jackpot + Gender*Jackpot, data=MenVWomen)
Anova(MVWANCOVA,Type="I", white.adjust=TRUE)

# Analysis of Deviance Table (Type II tests)
# 
# Response: AmountLOG
# Df         F Pr(>F)    
# Jackpot          1 1288.9029 <2e-16 ***
#   Gender           1    0.0803 0.7771    
# Jackpot:Gender   1    0.3113 0.5773    
# Residuals      310                     
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# When comparing Men to Women, Gender does not influence the size the prize even controlling for whether or not it was a jackpot.
# -------------------------------------------
### ANOVA on just Jackpot wins
JWins$Amount <- as.numeric(JWins$Amount)
### Testing Assumptons

### Normality

JWins$Gender <- as.factor(JWins$Gender)
JWins$Amount <- as.numeric(JWins$Amount)

### Normality
plotNormalHistogram(JWins$Amount)
#  positive skew
JWins$AmountSQRT <- sqrt(JWins$Amount)
plotNormalHistogram(JWins$AmountSQRT)
#  positive skew
JWins$AmountLOG <-log(JWins$Amount)
plotNormalHistogram(JWins$AmountLOG)
# approximately normality

# Homogeneity of Variance
bartlett.test(JWins$AmountLOG ~ Gender, data=JWins)

# Bartlett test of homogeneity of variances
# 
# data:  JWins$AmountLOG by Gender
# Bartlett's K-squared = 9.6895, df = 3, p-value = 0.0214

fligner.test(AmountLOG ~ Gender, data=JWins)

# Fligner-Killeen test of homogeneity of variances
# 
# data:  JWins$AmountLOG by Gender
# Fligner-Killeen:med chi-squared = 7.7846, df = 3, p-value = 0.05068


# Does not meet the assumption for homogeneity of variance

# Sample Size
# n = 224, minium requirement of 20 cases is met

# Do the Test, with unequal variance
ANOVA1 <- lm(AmountLOG ~ Gender, data=JWins)
Anova(ANOVA1, Type="II", white.adjust=TRUE)

# Analysis of Deviance Table (Type II tests)
# 
# Response: AmountLOG
#            Df   F       Pr(>F)
# Gender      3   1.7764  0.1526
# Residuals 220              
> 


# Do the Post Hocs with unequal variance
pairwise.t.test(JWins$AmountLOG, JWins$Gender, p.adjust="bonferroni", pool.sd = FALSE)

# Pairwise comparisons using t tests with non-pooled SD 
# 
# data:  JWins$AmountLOG and JWins$Gender 
# 
#          F    M    Mixed
#   M     1.00  -     -    
#   Mixed 1.00  1.00  -    
#   Unk   0.18  0.30  0.46 
# 
# P value adjustment method: bonferroni 

# Find means and draw conclusions
JWinsMeans <- JWins %>% group_by(Gender) %>% summarize(Mean = mean(Amount))
# A tibble: 4 x 2
# Gender       Mean
# <fct>       <dbl>
# 1 F       93696552.
# 2 M      107261728.
# 3 Mixed  106522059.
# 4 Unk    514289130.

# Both the ANOVA and the post hoc analysis indicate that there is no significant difference in Jackpot Amount between the gender categories
# -------------------------------------------
# ANOVA on NonJackpot Wins

### Testing Assumptons

### Normality

NJWins$Gender <- as.factor(NJWins$Gender)
NJWins$Amount <- as.numeric(NJWins$Amount)

### Normality
plotNormalHistogram(NJWins$Amount)
#  positive skew, negative kurtosis
NJWins$AmountSQRT <- sqrt(NJWins$Amount)
plotNormalHistogram(NJWins$AmountSQRT)
#  better but still has negative kurtosis
NJWins$AmountLOG <-log(NJWins$Amount)
plotNormalHistogram(NJWins$AmountLOG)
# too far. negative skew, negative kurtosis, use square root

# Homogeneity of Variance
## only performing Flign-Killeen Test sinc distribution is not normal

fligner.test(AmountSQRT ~ Gender, data=NJWins)

# Fligner-Killeen test of homogeneity of variances
# 
# data:  AmountSQRT by Gender
# Fligner-Killeen:med chi-squared = 4.4972, df = 3, p-value = 0.2125


# Meets the assumption for homogeneity of variance

# Sample Size
# n = 265, minium requirement of 20 cases is met

# Do the Test, with unequal variance
ANOVA2 <- aov(AmountSQRT ~ Gender, data=NJWins)
summary(ANOVA2)

#              Df   Sum Sq   Mean Sq  F value  Pr(>F)
# Gender        3   717809    239270   1.858   0.137
# Residuals     261 33612720  128784               

  
  
# Do the Post Hocs with equal variance
  pairwise.t.test(NJWins$AmountSQRT, NJWins$Gender, p.adjust="bonferroni")

  # Pairwise comparisons using t tests with pooled SD 
  # 
  # data:  NJWins$AmountSQRT and NJWins$Gender 
  # 
  #          F     M   Mixed
  #       M  1.00  -    -    
  #   Mixed  1.00  1.00 -    
  #     Unk  0.39  0.46 0.12 
  # 
  # P value adjustment method: bonferroni 

# Find means and draw conclusions
NJWinsMeans <- NJWins %>% group_by(Gender) %>% summarize(Mean = mean(Amount))
NJWinsMeans
# A tibble: 4 x 2
# Gender     Mean
# <fct>     <dbl>
#   1 F      1345265.
# 2 M      1401054.
# 3 Mixed  1149327.
# 4 Unk    1761905.

# Both the ANOVA and the post hoc analysis indicate that there is no significant difference in NonJackpot Amount between the gender categories
# -------------------------------------------
Wins %>% group_by(Gender) %>% summarize(count=n())
# Gender count
# <fct>  <int>
# 1 F        102
# 2 M        212
# 3 Mixed    108
# 4 Unk       67

JWins<- Wins %>% filter(Jackpot == "Y")
View(JWins)

JWins %>% group_by(Gender) %>% summarize(count=n())
# Gender count
# <fct>  <int>
# 1 F         29
# 2 M         81
# 3 Mixed     68
# 4 Unk       46
                                        
NJWins<- Wins %>% filter(Jackpot == "N")
View(NJWins)

NJWins %>% group_by(Gender) %>% summarize(count=n())

# Gender count
# <fct>  <int>
# 1 F         73
# 2 M        131
# 3 Mixed     40
# 4 Unk       21
# -------------------------------------------

CrossTable(Wins$Gender, Wins$Jackpot, fisher=TRUE, chisq = TRUE, expected = TRUE, sresid=TRUE, format="SPSS")

# Cell Contents
#   |-------------------------|
#   |                   Count |
#   |         Expected Values |
#   | Chi-square contribution |
#   |             Row Percent |
#   |          Column Percent |
#   |           Total Percent |
#   |            Std Residual |
#   |-------------------------|
#   
#   Total Observations in Table:  489 
# 
#                | Wins$Jackpot 
# Wins$Gender    |        N  |        Y  | Row Total | 
#   -------------|-----------|-----------|-----------|
#   F            |       73  |       29  |      102  | 
#                |   55.276  |   46.724  |           | 
#                |    5.683  |    6.723  |           | 
#                |   71.569% |   28.431% |   20.859% | 
#                |   27.547% |   12.946% |           | 
#                |   14.928% |    5.930% |           | 
#                |    2.384  |   -2.593  |           | 
#   -------------|-----------|-----------|-----------|
#   M            |      131  |       81  |      212  | 
#                |  114.888  |   97.112  |           | 
#                |    2.260  |    2.673  |           | 
#                |   61.792% |   38.208% |   43.354% | 
#                |   49.434% |   36.161% |           | 
#                |   26.789% |   16.564% |           | 
#                |    1.503  |   -1.635  |           | 
#   -------------|-----------|-----------|-----------|
#          Mixed |       40  |       68  |      108  | 
#                |   58.528  |   49.472  |           | 
#                |    5.865  |    6.939  |           | 
#                |   37.037% |   62.963% |   22.086% | 
#                |   15.094% |   30.357% |           | 
#                |    8.180% |   13.906% |           | 
#                |   -2.422  |    2.634  |           | 
#   -------------|-----------|-----------|-----------|
#            Unk |       21  |       46  |       67  | 
#                |   36.309  |   30.691  |           | 
#                |    6.455  |    7.636  |           | 
#                |   31.343% |   68.657% |   13.701% | 
#                |    7.925% |   20.536% |           | 
#                |    4.294% |    9.407% |           | 
#                |   -2.541  |    2.763  |           | 
#   -------------|-----------|-----------|-----------|
#   Column Total |      265  |      224  |      489  | 
#                |   54.192% |   45.808% |           | 
#   -------------|-----------|-----------|-----------|
#   
#   
#   Statistics for All Table Factors
# 
# 
# Pearson's Chi-squared test 
# ------------------------------------------------------------
# Chi^2 =  44.23379     d.f. =  3     p =  1.346095e-09 
# 
# 
#  
# Fisher's Exact Test for Count Data
# ------------------------------------------------------------
#   Alternative hypothesis: two.sided
# p =  1.053806e-09 
# 
# 
# Minimum expected frequency: 30.69121

# Check Assumption of Expected Frequencies
# the expected value is  greater than 5 for each cell. assumption met. 

#Interpret Results
# p=  1.346095e-09 , which is significant at p<0.05. Therefore the Gender
# does influence Jackpot Status. Fewer Women were Jackpot Winners than 
# expected, while more Mixed Gender group were Jackpot Winners than 
# expected. More winners whose gender was unknown were Jackpot Winners.

# -------------------------------------------

ggplot(Wins, aes(x = factor(Gender), y = Amount)) + geom_boxplot()+ scale_y_log10()
ggplot(JWins, aes(x = factor(Gender), y = Amount)) + geom_boxplot()+scale_y_log10()
ggplot(NJWins, aes(x = factor(Gender), y = Amount)) + geom_boxplot()
