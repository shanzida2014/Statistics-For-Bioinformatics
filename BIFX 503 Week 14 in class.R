## This program shows in-class examples for BIFX 503 Week 14
## Cluster analysis


library(datasets)
library(MASS)

###########################################################################################################################
## Review: PCA of Iris Data
###########################################################################################################################

?iris

# subset - leave species out

iris.q <- iris[,1:4]

scaled.iris <- scale(iris.q)

corr.iris <- cor(scaled.iris)
heatmap(corr.iris, symm = TRUE, revC = TRUE, margins=c(10,10), col=cm.colors(256))

pca1 <- princomp(scaled.iris, cor=TRUE)
plot(pca1, type="lines")
summary(pca1)

pca2 <- prcomp(scaled.iris, tol = 0.5)
summary(pca2)
pca2$rotation

###########################################################################################################################
## Cluster Analysis 1 -- Hierarchical Agglomerative Clustering
###########################################################################################################################

## Example One -- Simulated Data

## Generate simulated data: three clusters

set.seed(1234)
x <- rnorm(12, rep(1:3, each = 4), 0.2)
y <- rnorm(12, rep(c(1, 2, 1), each = 4), 0.2)

plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

# combine x and y into data frame format
sim.df <- data.frame(x=x, y=y)
sim.df

## Hierarchical Clustering Example

# calculate distance matrix, Euclidian distance is the default
mydist <- dist(sim.df)
mydist

# perform clustering on distance matrix
myclust <- hclust(mydist, method="average")

# plot dendrogram
plot(myclust)

# cut tree into three clusters
groups <- cutree(myclust, k=3)
rect.hclust(myclust, k=3, border="red")


## Example Two -- Iris Data

## Scatter plot matrix
sp.cols <- character(nrow(iris))
sp.cols <- "black"
sp.cols[iris$Species == "setosa"] <- "cornflowerblue"
sp.cols[iris$Species == "versicolor"] <- "mediumseagreen"
sp.cols[iris$Species == "virginica"] <- "orchid"

species_labels <- iris[,5]

pairs(iris.q, col=sp.cols, lower.panel=NULL, cex.labels=2, pch=19, cex=1.2)

par(xpd = TRUE)
legend(x = 0.05, y = 0.4, cex=2, legend=as.character(levels(species_labels)), fill=unique(sp.cols))
par(xpd = NA)

# calculate distance matrix

iris.dist <- dist(iris.q)
iris.dist2 <- dist(iris.q, method="manhattan")

# cluster analysis using "complete" method

iris.clust <- hclust(iris.dist)
iris.clust2 <- hclust(iris.dist2)
iris.clust3 <- hclust(iris.dist, method="average")
iris.clust4 <- hclust(iris.dist2, method="average")

# plot dendrogram

plot(iris.clust, main="euclidean, complete")
plot(iris.clust2, main="manhattan, complete")
plot(iris.clust3, main="euclidean, average")
plot(iris.clust4, main="manhattan, average")


# cut tree into three clusters

iris.groups <- cutree(iris.clust, k=3)
rect.hclust(iris.clust, k=3, border="red")


## Class exercise -- USArrests data

?USArrests

ua.dist <- dist(USArrests)
ua.clust <- hclust(ua.dist)
plot(ua.clust)



###########################################################################################################################
## Cluster Analysis 2 -- K-Means Clustering
###########################################################################################################################

## Example One -- Simulated Data

mykmeans <- kmeans(sim.df, centers = 3)
mykmeans$cluster
mykmeans$centers  

plot(x, y, col = "blue", pch = 19, cex = 2)
points(mykmeans$centers, col = "red", pch = 12, cex = 2)


## Example Two -- Iris Data

iris.kmeans <- kmeans(iris.q, centers=3)
iris.kmeans$cluster

iris.clusters <- cbind(iris, iris.kmeans$cluster)
iris.clusters$Cluster <- iris.kmeans$cluster

table(iris.clusters$Species, iris.clusters$Cluster)

## Setosa accurately classified -- all in cluster 2
## Versicolor all in cluster 1 with the exception of two plants
## Virginica -- most in cluster 3


## Re-do scatter plot matrix, using cluster assignment

pairs(iris.q, col=iris.kmeans$cluster, pch=19, lower.panel = NULL)

## 1=black 2=red 3=green


