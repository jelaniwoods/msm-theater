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

  


