require 'rails_helper'

Rails.application.load_seed

# Return Type: Record
describe "Query: Movie.find(1)" do
  it "lists one Movie record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.find(1)"
    click_on "Execute"

    movie = Movie.find(1)
    
    within "tbody" do
      expect(page).to have_css "tr", count: 1
    end

    expect(page).to have_selector 'td', text: movie.id
    expect(page).to have_selector 'td', text: movie.title
    expect(page).to have_selector 'td', text: movie.duration
    expect(page).to have_selector 'td', text: movie.description
    expect(page).to have_selector 'td', text: movie.director_id
  end

  it "says 'Your Query returned a Record'" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.find(1)"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Record'
  end
end

describe "Query: Director.find(1)" do
  it "lists one Director record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.find(1)"
    click_on "Execute"

    director = Director.find(1)
    
    within "tbody" do
      expect(page).to have_css "tr", count: 1
    end

    expect(page).to have_selector 'td', text: director.id
    expect(page).to have_selector 'td', text: director.name
    expect(page).to have_selector 'td', text: director.dob
    expect(page).to have_selector 'td', text: director.bio
  end
end

describe "Query: Actor.find(1)" do
  it "lists one Actor record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Actor.find(1)"
    click_on "Execute"

    actor = Actor.find(1)
    
    within "tbody" do
      expect(page).to have_css "tr", count: 1
    end

    expect(page).to have_selector 'td', text: actor.id
    expect(page).to have_selector 'td', text: actor.name
    expect(page).to have_selector 'td', text: actor.dob
    expect(page).to have_selector 'td', text: actor.bio
  end
end

describe "Query: Role.find(1)" do
  it "lists one Role record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Role.find(1)"
    click_on "Execute"

    role = Role.find(1)
    
    within "tbody" do
      expect(page).to have_css "tr", count: 1
    end

    expect(page).to have_selector 'td', text: role.id
    expect(page).to have_selector 'td', text: role.movie_id
    expect(page).to have_selector 'td', text: role.actor_id
    expect(page).to have_selector 'td', text: role.character_name
  end
end


# Return Type: Collection
describe "Query: Movie.all" do
  it "lists all Movie records with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.all"
    click_on "Execute"

    movies = Movie.all
    
    within "tbody" do
      expect(page).to have_css "tr", count: movies.count
    end
  end
end

describe "Query: Role.all" do
  it "lists all Role records with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Role.all"
    click_on "Execute"

    roles = Role.all
    
    within "tbody" do
      expect(page).to have_css "tr", count: roles.count
    end
    expect(page).to have_content "Collection"
  end
end

describe "Query: Director.all" do
  it "lists all Director records with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.all"
    click_on "Execute"

    directors = Director.all
    
    within "tbody" do
      expect(page).to have_css "tr", count: directors.count
    end
  end
end

describe "Query: Actor.all" do
  it "lists all Actor records with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Actor.all"
    click_on "Execute"

    actors = Actor.all
    
    within "tbody" do
      expect(page).to have_css "tr", count: actors.count
    end
  end
end

# Return Type: Column

describe "Query: Movie.first.title", type: :feature do
  it "says 'Your Query returned a Column'" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Column'
  end
end

describe "Query: Movie.first.title", type: :feature do
  it "says 'Your Query returned a Column'" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Column'
  end
end
# Return Type: Array

describe "Query: Movie.all.pluck(:title)", type: :feature do
  it "says 'Your Query returned an Array'" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.all.pluck(:title)"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Array'
  end
end

# Return Type: Error

describe "Query: m.title", type: :feature do
  it "says 'Your Query returned an Error'" do
    visit "/"
    
    fill_in "Enter a Query", with: "m.title"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Error'
  end
end

describe "Query: Doesn't break on empty input", type: :feature do
  it "redirects to level page'" do
    visit "/"
    
    fill_in "Enter a Query", with: ""
    click_on "Execute"
    
    expect(page.current_path).to eql "/levels/1"
  end
end

feature "Query:", type: :feature do

  scenario "Display Movie id" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "1"
  end

  scenario "Display Movie title" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie year" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie duration" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie description" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie director_id" do

  end
  
  scenario "Displays Movie title column value" do

    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end

  scenario "Display Director id" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.first.id"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "1"
  end

  scenario "Display Director name" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.first.name"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "Frank Darabont"
  end

  scenario "Display Director dob" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.first.dob"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: Date.parse("January 28, 1959")
  end

  scenario "Display Director bio" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.first.bio"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "Frank Darabont was born"
  end

  scenario "Allows mutliple queries in one line" do
    visit "/levels/2"
    
    fill_in "Enter a Query", with: "Director.find(Movie.find_by(title: \"The Shawshank Redemption\").director_id)"
    click_on "Execute"
    
    expect(page).to have_selector 'a', text: "Next Level"
  end


  pending "Display Actor id"
  pending "Display Actor name"
  pending "Display Actor dob"
  pending "Display Actor bio"

  pending "Display Role id"
  pending "Display Role movie_id"
  pending "Display Role actor_id"
  pending "Display Role character_name"
  
  pending "Returns collection result"
  pending "Returns record result"
  pending "Returns column result"
  pending "Returns array result"
  pending "Returns error result"
  


end

