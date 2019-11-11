require 'rails_helper'

Rails.application.load_seed

describe "Query: afghldiba" do
  it "says 'Your Query returned an Error'" do
    visit "/"
    
    fill_in "Enter a Query", with: "afghldiba"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Error'
  end
end

describe "Query: Movies.count" do
  it "says 'Your Query returned an Error'" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movies.count"
    click_on "Execute"
    
    expect(page).to have_selector 'div', text: 'Error'
  end
end

describe "Step Query: m = Movie.where(title: \"The Dark Knight\")" do
  it "says 'Your Query returned an Error'" do
    visit "/"
    
    fill_in "Enter a Query", with: "m = Movie.where(title: \"The Dark Knight\")"
    click_on "Step"    
    
    fill_in "Enter a Query", with: "m.title"
    click_on "Step"
    
    expect(page).to have_selector 'div', text: 'Error'
  end
end

describe "Step Query: Invalid column for Table" do
  it "says 'Your Query returned an Error'" do
    visit "/"
    
    fill_in "Enter a Query", with: "m = \"The Dark Knight\""
    click_on "Step"    
    
    fill_in "Enter a Query", with: "Director.where(title: m)"
    click_on "Step"
    
    expect(page).to have_selector 'div', text: 'Error'
  end
end

describe "Query: Movie.where(name: 'anything')" do
  it "should display error: Attribute doesn't exist for Record" do
    visit "/"

    fill_in "Enter a Query", with: "Movie.where(name: \"anything\")"
    click_on "Execute"

    expect(page).to have_content("Movie does not have the column, name")
  end
end


