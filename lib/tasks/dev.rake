namespace(:dev) do
  desc "Hydrate the database with some dummy data to look at so that developing is easier"
  task({ :prime => :environment}) do

    levels = [
      {number: 1, directions: "What is the Movie record with an id of 6?"},
      {number: 2, directions: "Who directed Shawshank Redemption?"},
      {number: 3, directions: "How many movies has Francis Ford Coppola directed?"},
      {number: 4, directions: "What are the names of the movies Coppola directed?"},
      {number: 5, directions: "How many actors were in the Shawshank Redemption?"},
      {number: 6, directions: "What films has Morgan Freeman been in?"},
    ]

    Level.import(levels, {:validate => false})

    level_1 = Level.find(1)
    level_2 = Level.find(2)
    level_3 = Level.find(3)
    level_4 = Level.find(4)
    level_5 = Level.find(5)
    level_6 = Level.find(6)

    answers = [
      {content: "Movie.where({:id=>6}).first", level_id: level_1.id },
      {content: "Movie.where({:id=>6}).at(0)", level_id: level_1.id },
      {content: "Movie.where({:id=>6})[0]", level_id: level_1.id },
      {content: "Movie.where(:id=>6)[0]", level_id: level_1.id },
      {content: "Movie.where(:id=>6).first", level_id: level_1.id },
      {content: "Movie.where(:id=>6).at(0)", level_id: level_1.id },
      {content: "Movie.where(id:6).at(0)", level_id: level_1.id },
      {content: "Movie.where(id:6)[0]", level_id: level_1.id },
      {content: "Movie.where(id:6).first", level_id: level_1.id },
      {content: "Movie.find(6)", level_id: level_1.id },
      {content: "Movie.find_by(id:6)", level_id: level_1.id },
      {content: "Movie.find_by(:id=>6)", level_id: level_1.id },
      {content: "Movie.find_by({:id=>6})", level_id: level_1.id },
      {content: "Movie.first", level_id: level_1.id },
      {content: "Movie.all.first", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
      # {content: "", level_id: level_1.id },
    ]

    Answer.import(answers, {:validate => false})



    Movie.delete_all
    movies = [
      {id: 1, description: "", duration: 0, title: "The Shawshank Redemption", year: 1994, director_id: 1},
      {id: 2, description: "", duration: 0, title: "The Godfather", year: 1972, director_id: 2},
      {id: 3, description: "", duration: 0, title: "The Godfather: Part II", year: 1974, director_id: 17},
      {id: 6, description: "", duration: 0, title: "The Dark Knight", year: 2008, director_id: 5},
      {id: 21, description: "", duration: 0, title: "City of God", year: 2002, director_id: 2},
    ]

    Movie.import(movies, {:validate => false})

    Director.delete_all

    directors = [
      {id: 1, bio: "", dob: Date.parse("January 28, 1959"), name: "Frank Darabont"},
      {id: 2, bio: "", dob: Date.parse("April 7, 1939"), name: "Francis Ford Coppola"},
      {id: 5, bio: "", dob: Date.parse("July 30, 1970"), name: "Christopher Nolan"},
      {id: 17, bio: "", dob: nil, name: "Katia Lund"},
    ]

    Director.import(directors, {:validate => false})
    Actor.delete_all

    actors = [
      {id: 1, dob: Date.parse("Octorber 16, 1968"), name: "Tim Robbins"},
      {id: 2, dob: Date.parse("June 1, 1937"), name: "Morgan Freeman"},
      {id: 17, dob: Date.parse("April 25, 1940"), name: "Al Pacino"},
      {id: 20, dob: Date.parse("January 5, 1931"), name: "Robert Duvall"},
      {id: 24, dob: Date.parse("February 24, 1928"), name: "Al Leeieri"},
      {id: 25, dob: Date.parse("January 5, 1946"), name: "Diane Keaton"},
      {id: 27, dob: Date.parse("April 25, 1946"), name: "Talia Shire"},
      {id: 31, dob: Date.parse("Auguest 17, 1943"), name: "Robert De Niro"},
      {id: 71, dob: Date.parse("January 30, 1974"), name: "Christian Bale"},
      {id: 72, dob: Date.parse("April 4, 1979"), name: "Heath Ledger"},
      {id: 75, dob: Date.parse("November 16, 1977"), name: "Maggie Gyllenhall"},
      {id: 76, dob: Date.parse("March 21, 1958"), name: "Gary Oldman"},
      {id: 77, dob: Date.parse("September 7, 1977"), name: "Monique Gabriela Curnen"},
      {id: 79, dob: Date.parse("May 25, 1976"), name: "Cillian Murphy"},
      {id: 263, dob: Date.parse("May 21, 1983"), name: "Alexandre Rodrigues"},
      {id: 269, dob: Date.parse("June 8, 1970"), name: "Seu Jorge"},
      {id: 271, dob: Date.parse("April 15, 1983"), name: "Alice Braga"},
    ]

    Actor.import(actors, {:validate => false})

    Role.delete_all

    roles = [
      {id: 1, character_name: "Andy Dufresne", actor_id: 1, movie_id: 1},
      {id: 2, character_name: "Ellis Boyd 'Red' Redding", actor_id: 2, movie_id: 1},
      {id: 17, character_name: "Michael Corleone", actor_id: 17, movie_id: 2},
      {id: 20, character_name: "Tom Hagen", actor_id: 20, movie_id: 2},
      {id: 24, character_name: "Sollozzo", actor_id: 24, movie_id: 2},
      {id: 25, character_name: "Kay Adams", actor_id: 25, movie_id: 2},
      {id: 27, character_name: "Connie", actor_id: 27, movie_id: 2},
      {id: 31, character_name: "Michel", actor_id: 17, movie_id: 3},
      {id: 32, character_name: "Tom Hagen", actor_id: 20, movie_id: 3},
      {id: 33, character_name: "Kay", actor_id: 25, movie_id: 3},
      {id: 34, character_name: "Vito Corleone (as Robert DeNiro)", actor_id: 31, movie_id: 3},
      {id: 36, character_name: "Connie Corleone", actor_id: 27, movie_id: 3},
      {id: 76, character_name: "Bruce Wayne", actor_id: 71, movie_id: 6},
      {id: 77, character_name: "Joker", actor_id: 72, movie_id: 6},
      {id: 80, character_name: "Rachel", actor_id: 75, movie_id: 6},
      {id: 81, character_name: "Gordon", actor_id: 76, movie_id: 6},
      {id: 82, character_name: "Lucius Fox", actor_id: 2, movie_id: 6},
      {id: 83, character_name: "Ramirez", actor_id: 77, movie_id: 6},
      {id: 85, character_name: "Scarecrow", actor_id: 79, movie_id: 6},
      {id: 298, character_name: "Buscape - Rocket", actor_id: 263, movie_id: 21},
      {id: 304, character_name: "Mane Galinha - Knockout Ned", actor_id: 269, movie_id: 21},
      {id: 306, character_name: "Angelica", actor_id: 271, movie_id: 21},
    ]

    Role.import(roles, {:validate => false})

  end
end
