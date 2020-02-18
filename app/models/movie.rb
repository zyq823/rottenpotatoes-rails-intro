class Movie < ActiveRecord::Base
    
    # Part 2 - return a enumerable collection of appropriate movie ratings for controller method
    @@all_ratings = ['G', 'PG', 'PG-13', 'R'] 
    
    def self.all_ratings
        @@all_ratings
    end
end
