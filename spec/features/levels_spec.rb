require "rails_helper"

Rails.application.load_seed

describe "Query: Movie.all" do
  it "should list movie rows" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.all"
    click_on "Execute"
    
    visit "/levels/1/results"

    expect(page).to have_content('id')
    expect(page).to have_content('title')
    expect(page).to have_content('year')
    expect(page).to have_content('duration')
    expect(page).to have_content('director_id')

  end
end

describe "Query: Director.all" do
  it "should list director rows" do
    visit "/"
    
    fill_in "Enter a Query", with: "Director.all"
    click_on "Execute"
    
    visit "/levels/1/results"

    expect(page).to have_content('id')
    expect(page).to have_content('name')
    expect(page).to have_content('dob')
    expect(page).to have_content('bio')
  end
end

describe "Query: Actor.all" do
  it "should list actor rows" do
    visit "/"
    
    fill_in "Enter a Query", with: "Actor.all"
    click_on "Execute"
    
    visit "/levels/1/results"

    expect(page).to have_content('id')
    expect(page).to have_content('name')
    expect(page).to have_content('dob')
    expect(page).to have_content('bio')
  end
end

describe "Query: Role.all" do
  it "should list role rows" do
    visit "/"
    
    fill_in "Enter a Query", with: "Role.all"
    click_on "Execute"
    
    visit "/levels/1/results"

    expect(page).to have_content('id')
    expect(page).to have_content('movie_id')
    expect(page).to have_content('actor_id')
    expect(page).to have_content('character_name')
  end
end

describe "Query: Random Invalid text" do
  it "should display error: Uh oh" do
    # expect(page.find("th").text).eql ("Error")
    visit "/"

    fill_in "Enter a Query", with: "asdfghjkl"
    click_on "Execute"

    expect(page).to have_selector 'th', text: 'Error'
  end
end

describe "Query: Movie.find(0)" do
  it "should display error: Record not found" do
    visit "/"

    fill_in "Enter a Query", with: "Movie.find(0)"
    click_on "Execute"

    expect(page).to have_selector 'td', text: 'Record not found'

  end
end

# describe "Query: Movie.first.banana_nut" do
#   it "should display error: Attribute doesn't exist for Record" do
#     pending "something else getting finished"
#   end
# end

RSpec.feature "Query: Movie.first.banana_nut", type: :feature do
  pending "should display error: Attribute doesn't exist for Record"
end
