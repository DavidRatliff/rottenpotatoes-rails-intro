class Movie < ActiveRecord::Base
    @@all_ratings = %w(G PG PG-13 R)
    
    def self.all_ratings
        @@all_ratings
    end

    def self.with_ratings(ratings)
        Movie.where(rating: ratings)    
    end
end
