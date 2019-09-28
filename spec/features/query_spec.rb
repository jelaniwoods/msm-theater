require 'rails_helper'

Rails.application.load_seed

describe "Query: Movie.find(1)" do
  it "lists one Movie record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.find(1)"
    click_on "Submit"

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
    click_on "Submit"

    movie = Movie.find(1)
    
    expect(page).to have_content "Your Query returned a Record"
  end
end

describe "Query: Director.find(1)" do
  it "lists one Director record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.find(1)"
    click_on "Submit"

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
    click_on "Submit"

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
    click_on "Submit"

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

feature "Query:", type: :feature do

  scenario "Display Movie id" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first"
    click_on "Submit"
    
    expect(page).to have_selector 'td', text: "1"
  end

  scenario "Display Movie title" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Submit"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie year" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Submit"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie duration" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Submit"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie description" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Submit"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end
  
  scenario "Display Movie director_id" do

  end
  
  scenario "Displays Movie title column value" do

    visit "/"
    
    fill_in "Enter a Query", with: "Movie.first.title"
    click_on "Submit"
    
    expect(page).to have_selector 'td', text: "The Shawshank Redemption"
  end

  pending "Display Director id"

  pending "Display Director name"
  pending "Display Director dob"
  pending "Display Director bio"

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

