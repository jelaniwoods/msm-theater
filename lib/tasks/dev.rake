namespace(:dev) do
  desc "Hydrate the database with some dummy data to look at so that developing is easier"
  task({ :prime => :environment}) do

    Movie.delete_all
    movies = [
      {id: 1, description: "", duration: 0, title: "The Shawshank Redemption", year: 1994, director_id: },
      {id: 2, description: "", duration: 0, title: "The Godfather", year: 1972, director_id: },
      {id: 3, description: "", duration: 0, title: "The Godfather: Part II", year: 1974, director_id: },
      {id: 6, description: "", duration: 0, title: "The Dark Knight", year: 2008, director_id: },
      {id: 21, description: "", duration: 0, title: "City of God", year: 2002, director_id: },
    ]

    Director.delete_all

    directors = [
      {id: 1, bio: "", dob: Date.parse("January 28, 1959"), name: "Frank Darabont"},
      {id: 2, bio: "", dob: Date.parse("April 7, 1939"), name: "Francis Ford Coppola"},
      {id: 5, bio: "", dob: Date.parse("July 30, 1970"), name: "Christopher Nolan"},
      {id: 17, bio: "", dob: Date.parse("1966"), name: "Katia Lund"},
    ]

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
  end
end
