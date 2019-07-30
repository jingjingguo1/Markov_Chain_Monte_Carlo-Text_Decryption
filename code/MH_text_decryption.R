# Load and clean book data

rlink <- file("data/warAndPeaceBook.txt", "rb")
book <- readChar(rlink,file.info('data/warAndPeaceBook.txt')$size)
close(rlink)
bdata <- gsub("[^a-z., :]+", "", tolower(book))
bdata <- substring(bdata,7000,nchar(bdata)-5000)
bds <- strsplit(bdata,"")
t_bds <- table(bds)
f_bds <- t_bds/sum(t_bds)
barplot(f_bds,width = 1)

# Estimate T
txt <- bds[[1]]
length_txt <- length(txt)
T <- table(txt[1:length_txt - 1], txt[2:length_txt])
T <- T /rowSums(T)
format(round(T, 5))

# get Te
Te <- T + 1e-30
es <- rowSums(-Te*log(Te))
#which.min(es)
#which.max(es)

#Likelihood function
lk <- function(T, X, perm){
  # X <- strsplit(X, '')
  pX <- log(1/30)
  n <- length(X)
  for(i in 1:(n-1)){
    lastXChar <- unlist(X[i])
    nextXChar <- unlist(X[i+1])
    lastEngChar <- unlist(perm[lastXChar])
    nextEngChar <- unlist(perm[nextXChar])
    
    pt<- T[lastEngChar,nextEngChar]
    #show(pt)
    if(pt != 0){
      pX <- pX + log(pt)
    }
  }
  #show(pX)
  return(pX)
}

# Get original English message from X 
getTrueX <- function(X,perm){
  n <- length(X)
  #X <- strsplit(X,'')
  X <- unlist(X)
  for(i in 1:n){
    X[i] <- unlist(perm[X[i]])
  }
  return(X)
}


decrypt <- function(X,T){
  perm_old <- list(' '=' ', ','=',', '.'='.', ':'=':', 'a'='a','b'='b','c'='c','d'='d','e'='e','f'='f','g'='g','h'='h','i'='i','j'='j','k'='k','l'='l','m'='m','n'='n','o'='o','p'='p','q'='q','r'='r','s'='s','t'='t','u'='u','v'='v','w'='w','x'='x','y'='y','z'='z')
  lks <- vector("list", length=3000)
  alphabet <- names(perm_old)
  
  set.seed(32)
  
  for(i in 1:3000){
    perm_new <- perm_old
    #show(perm_old)
    l2swap <- sample(alphabet,2)
    
    perm_new[l2swap[1]] <- perm_old[l2swap[2]]
    perm_new[l2swap[2]] <- perm_old[l2swap[1]]
    
    #show(unlist(perm_old))
    
    f_n <- lk(T,X,perm_old)
    #show(f_n)
    f_star <- lk(T,X,perm_new)
    lks[i] <- f_n
    
    if( runif(1) < min(1, exp( f_star-f_n ) ) ){
      #accept
      perm_old <- perm_new
      
      trueX <- getTrueX(X,perm_old)
      X20 <- paste(unlist(trueX[1:20]),collapse='')
      trueX <- paste(unlist(trueX),collapse='')
    }
    if(i%%100==0){
      print(X20)
    }
  }
  return(list("perm" = perm_old, "trueX" = trueX,"lks" = lks))
}

# Read Message X
rlink <- file("data/message.txt", "rb")
rawX <- readChar(rlink,file.info('data/message.txt')$size)
close(rlink)

X <- unlist(strsplit(unlist(rawX),''))
X <- unlist(X)[1:length(X)-1]
out <- decrypt(X,Te)
