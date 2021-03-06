#File path
# setwd("~/GitHub/markov-processes")
setwd("C:/Users/p/Documents/GitHub/markov-processes")

source('transition_matrix.R')
source('value_iteration.R')
source('simulation_game.R')

#---------Cr�ation des strat�gies et matrice de r�sultats-------------------

opt_policy_rule1 <- v_iter(p_secure1,p_normal1,p_risk1,Cost)[[1]]
opt_policy_rule2 <- v_iter(p_secure2,p_normal2,p_risk2,Cost)[[1]]
always_dice1 <- c(rep(1,15))
always_dice2 <- c(rep(2,15))
always_dice3 <- c(rep(3,15))
set.seed(1234)  # pour avoir toujours la m�me strat�gie random
random_dice <- sample(c(1,2,3),15,replace=TRUE)
policy_list_rule1 <- list(opt_policy_rule1,always_dice1,always_dice2,always_dice3,random_dice)
policy_list_rule2 <- list(opt_policy_rule2,always_dice1,always_dice2,always_dice3,random_dice)

result_matrix_rule1 <- matrix(ncol=5,nrow=14)
result_matrix_rule2 <- matrix(ncol=5,nrow=14)
colnames(result_matrix_rule1) <- c("Optimal policy","Dice 1","Dice 2", "Dice 3", "Random dice")
colnames(result_matrix_rule2) <- c("Optimal policy","Dice 1","Dice 2", "Dice 3", "Random dice")

#---------Simulation des jeux � partir de toutes les cases-------------------

# simulation des jeux pour la r�gle 1
for(i in 1 : 5){
  for ( j in 1 : 14){
    result_matrix_rule1[j,i] <- mean(simulation_game(1,policy_list_rule1[[i]],j))
  }
}
write.table(result_matrix_rule1,"result_matrix_rule1.txt")

# simulation des jeux pour la r�gle 2
for(i in 1 : 5){
  for ( j in 1 : 14){
    result_matrix_rule2[j,i] <- mean(simulation_game(2,policy_list_rule2[[i]],j))
  }
}
write.table(result_matrix_rule2,"result_matrix_rule2.txt")

#---------Relire les tables de r�sultats--------------------------------------

result_matrix_rule1 <- read.table("result_matrix_rule1.txt")
result_matrix_rule2 <- read.table("result_matrix_rule2.txt")

#---------Resultats � partir de la case 1 : Boxplots-R�gle 1------------------------

windows()
par(mfrow=c(1,5),oma=c(0,0,0,0))
for( i in 1 : 5){
  boxplot(simulation_game(1,policy_list_rule1[[i]],1),main=colnames(result_matrix_rule1)[i],ylim=c(0,50),cex.main=1.8)
}

#---------Resultats � partir de la case 1 : Boxplots-R�gle 2------------------------

windows()
par(mfrow=c(1,5))
par(mfrow=c(1,5),oma=c(0,0,0,0))
for( i in 1 : 5){
  boxplot(simulation_game(2,policy_list_rule2[[i]],1),main=colnames(result_matrix_rule2)[i],ylim=c(0,120),cex.main=1.8)
}

#--------Comparaison des ecart-type--------------------------

variance_matrix_rule1<-matrix(ncol=5,nrow=1)
colnames(variance_matrix_rule1) <- c("Optimal policy","Dice 1","Dice 2", "Dice 3", "Random dice")
rownames(variance_matrix_rule1)<- c("Ecart-type")
variance_matrix_rule2<-variance_matrix_rule1

for( i in 1 : 5){
  
  variance_matrix_rule1[1,i]<-sd(simulation_game(1,policy_list_rule1[[i]],1))
  variance_matrix_rule2[1,i]<-sd(simulation_game(2,policy_list_rule2[[i]],1))
  
}

write.table(variance_matrix_rule1,"variance_matrix_rule1.txt")
write.table(variance_matrix_rule2,"variance_matrix_rule2.txt")



