require 'rails_helper'

Rails.application.load_seed


feature "Level 1 Query:", type: :feature do

  scenario "Movie.where(id: 6)" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.where(id: 6)"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "6"
    expect(page).to have_selector 'td', text: "The Dark Knight"
    expect(page).to have_selector 'td', text: "2008"
    expect(page).to have_selector 'td', text: "5"
  end

  scenario "Movie.all[3]" do
    visit "/"
    
    fill_in "Enter a Query", with: "Movie.all[3]"
    click_on "Execute"
    
    expect(page).to have_selector 'td', text: "The Dark Knight"
  end
  
end

