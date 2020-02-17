class Movie < ActiveRecord::Base
    #defining a method to select distinct movie ratings
    def self.all_ratings
        Movie.distinct.pluck(:rating)
    end
end