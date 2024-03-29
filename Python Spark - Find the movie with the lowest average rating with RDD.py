from pyspark import SparkConf, SparkContext

# This function just creates a Python dictionary we can later
# use to convert movie ID's to movie name while printing out
# the final results

def loadMoviesNames():
    movieNames={}
    with open("ml-100k/u,item")as f:
        for line in f:
            fields = line.split('|')
            movieName[int(fields[0])]=fields[1]
    return movieNames

# Take each line of u.data and convert it to (movieID, (rating,1,0))
# This way we can then add up all the ratings for each movie, and 
# the total number of ratings for each movie 
# (which lets us compute the average)

def parseInput(line):
    fields=line.split()
    return(int(fields[1]), (float(fields[2]),1.0))

if __name=="__main__":
    #the main script - create out SparkContext
    conf = SparkConf().setAppNmae("WorstMovies")
    sc=SparkContext(conf=conf)
    
# Load up our movie ID > Movie name loopkup table
    movieNmaes=LoadMovieNames()
    
# Load up the raw u.data file
    lines=sc.textFile("hdfs:///user/maia_dev/ml-100k/u.data")
    
# Convert to (movieID, (rating, 1.0))
    movieRatings = line.map(parseInput)
    
# Reduce to (movieID, (SumOfRatings, totalRatings))
    ratingTotalsAndCount = movieRatings.reduceByKey(lambda movie1, movie2:(movie1[0]+movie2[0],movie1[1]+movie2[1]))
# Map tp (MovieID,averageRating)
averageRatings=ratingTotalsAndCount.mapValues(lambda totalAndCount: totalAndCount[0]/totalAndCount[1])

# Sort by average rating
sortedMovies = averageRatings.sortBy(lambda x:x[1])


# take the top 10 results
    results = sortedMovies.take(10)

# print them out
for result in results:
    print(movieNmaes[result[0],result[1]])