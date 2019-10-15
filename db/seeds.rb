# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env.development?
  AdminUser.create({
    :email => "admin@example.com",
    :password => "password",
    :password_confirmation => "password",
  })
end


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
  {content: "Movie.all[3]", level_id: level_1.id },
  {content: "Movie.all.at(3)", level_id: level_1.id },
  
  {content: "Director.find(1)", level_id: level_2.id },
  {content: "Director.find_by(id:1)", level_id: level_2.id },
  {content: "Director.find_by(:id=>1)", level_id: level_2.id },
  {content: "Director.find_by({:id=>1})", level_id: level_2.id },
  {content: "Director.where(:id=>1).first", level_id: level_2.id },
  {content: "Director.where({:id=>1}).first", level_id: level_2.id },
  {content: "Director.where({:name=>\"Frank Darabont\"}).first", level_id: level_2.id },
  {content: "Director.where({:dob=>\"#{Date.parse("January 28, 1959")}\"}).first", level_id: level_2.id },
  {content: "Director.where({:bio=>\"\"}).first", level_id: level_2.id },
  {content: "Director.find_by({:id=>1})", level_id: level_2.id },
  {content: "Director.find_by({:name=>\"Frank Darabont\"})", level_id: level_2.id },
  {content: "Director.find_by({:dob=>\"#{Date.parse("January 28, 1959")}\"})", level_id: level_2.id },
  {content: "Director.find_by({:bio=>\"\"})", level_id: level_2.id },
  {content: "Director.all.first", level_id: level_2.id },
  {content: "Director.first", level_id: level_2.id },

  {content: "Movie.where(director_id:2).count", level_id: level_3.id },
  {content: "Movie.where(:director_id=>2).count", level_id: level_3.id },
  {content: "Movie.where({director_id:2}).count", level_id: level_3.id },
  {content: "Movie.where({:director_id=>2}).count", level_id: level_3.id },

  {content: "Movie.where(director_id:2).pluck(:title)", level_id: level_4.id },
  {content: "Movie.where({director_id:2}).pluck(:title)", level_id: level_4.id },
  {content: "Movie.where({director_id:2}).pluck(:title)", level_id: level_4.id },

  {content: "Role.where(movie_id:1).count", level_id: level_5.id },
  {content: "Role.where(:movie_id=>1).count", level_id: level_5.id },
  {content: "Role.where({:movie_id=>1}).count", level_id: level_5.id },
  {content: "Role.where({movie_id:1}).count", level_id: level_5.id },
  {content: "Actor.where(id:[1,2]).count", level_id: level_5.id },
  {content: "Actor.where(:id>[1,2]).count", level_id: level_5.id },
  {content: "Actor.where({:id>[1,2]}).count", level_id: level_5.id },
  {content: "Actor.where({id:[1,2]}).count", level_id: level_5.id },
  {content: "Actor.where({id:Role.where(movie_id:1).pluck(:actor_id)}).count", level_id: level_5.id },
  {content: "Actor.where({id:Role.where({movie_id:1}).pluck(:actor_id)}).count", level_id: level_5.id },
  {content: "Actor.where({id:Role.where({:movie_id=>1}).pluck(:actor_id)}).count", level_id: level_5.id },
  {content: "Actor.where({id:Role.where(:movie_id=>1).pluck(:actor_id)}).count", level_id: level_5.id },

  {content: "Movie.where(id:[1,6])", level_id: level_6.id },
  {content: "Movie.where({id:[1,6]})", level_id: level_6.id },
  {content: "Movie.where(id:[1,6])", level_id: level_6.id },
  {content: "Movie.where(:id=>[1,6])", level_id: level_6.id },
  {content: "Movie.where({:id=>[1,6]})", level_id: level_6.id },
  {content: "Movie.where(id:Role.where(actor_id:2).pluck(:movie_id))", level_id: level_6.id },
  {content: "Movie.where(:id=>Role.where(actor_id:2).pluck(:movie_id))", level_id: level_6.id },
  {content: "Movie.where({:id=>Role.where(actor_id:2).pluck(:movie_id)})", level_id: level_6.id },
  {content: "Movie.where({:id=>Role.where({actor_id:2}).pluck(:movie_id)})", level_id: level_6.id },
  {content: "Movie.where({:id=>Role.where({:actor_id=>2}).pluck(:movie_id)})", level_id: level_6.id },
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
  {id: 1, bio: "Three-time Oscar nominee Frank Darabont was born in a refugee camp in 1959 in Montbeliard, France, the son of Hungarian parents who had fled Budapest during the failed 1956 Hungarian revolution. Brought to America as an infant, he settled with his family in Los Angeles and attended Hollywood High School. His first job in movies was as a production assistant on the 1981 low-budget film, Hell Night (1981), starring Linda Blair. He spent the next six years working in the art department as a set dresser and in set construction while struggling to establish himself as a writer. His first produced writing credit (shared) was on the 1987 film, A Nightmare on Elm Street 3: Dream Warriors (1987), directed by Chuck Russell. Darabont is one of only six filmmakers in history with the unique distinction of having his first two feature films receive nominations for the Best Picture Academy Award: 1994's The Shawshank Redemption (1994) (with a total of seven nominations) and 1999's The Green Mile (1999) (four nominations). Darabont himself collected Oscar nominations for Best Adapted Screenplay for each film (both based on works by Stephen King), as well as nominations for both films from the Director's Guild of America, and a nomination from the Writers Guild of America for The Shawshank Redemption (1994). He won the Humanitas Prize, the PEN Center USA West Award, and the Scriptor Award for his screenplay of \"The Shawshank Redemption\". For \"The Green Mile\", he won the Broadcast Film Critics prize for his screenplay adaptation, and two People's Choice Awards in the Best Dramatic Film and Best Picture categories. His most recent feature as director, The Majestic (2001), starring Jim Carrey, was released in December 2001. His next film as director will be an adaptation of Ray Bradbury's classic science fiction novel, Fahrenheit 451 (2007), which Darabont is currently writing for Castle Rock and Icon Productions. He is currently executive-producing the thriller, Collateral (2004), for DreamWorks, with Michael Mann directing and Tom Cruise starring. Future produced-by projects include \"Way of the Rat\" at DreamWorks with Chuck Russell adapting and directing the CrossGen comic book series and \"Back Roads\", a Tawni O'Dell novel, also at DreamWorks, with Todd Field attached to direct. Darabont and his production company, \"Darkwoods Productions\", have an overall deal with Paramount Pictures.", dob: Date.parse("January 28, 1959"), name: "Frank Darabont"},
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
