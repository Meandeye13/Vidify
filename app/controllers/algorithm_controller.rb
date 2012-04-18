#Kmeans algorithm
def kMeans(centroids,partions,users,k)
	groupRound++
	partions.each do |partion|
		partion.clear()
	end
	
	
	for user in uesers
		closet = findClosestCentroid(centroids,user)
		partions[closet].push_back(user)
	end
  
	oldCentroids = centroids
	getCentroids(centroids,partions,k)
	
	if(compareCentroids(centroids,oldCentroids))
		kMeans(centroids,partions,users,k)
	else
		return
	end
end

def 

#Ending conditionn: is this new gneration any different?
def compareCentroids(centroids, oldCentroids)
	for centroid in centroids
		close = findClosestCentroid(oldCentroids, centroid)
		if(userDiff(oldCentroids[close], centroid) > 0.0)
			return true
		end
	end
	return false
end

#Compares to two users
def userDiff(userOne, userTwo)
	return 1.0
end

def findClosestCentroid(centroids,target)
	best = -1
	val = -1.0
	i=0
	for centroid in centroids
		float diff = userDiff(centroid,u)
		if(best == -1)
			best=i
			val= diff
		end

		if(diff < val)
			val=diff
			best=i
		end
		i=i+1
	end

	return best
end

#Finds the centroid for each partion
def getCentroids(centroids,partions,k)
	centroids.clear()	
	for (0..k-1).each do |i|
		centroids->push_back(findCentroid(partions[i]))
	end
end

def findCentroid(partion)
	return partion[0]
end