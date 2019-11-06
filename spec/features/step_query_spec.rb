require 'rails_helper'

Rails.application.load_seed

describe "Query: r = Role.find(1)" do
  it "stores in variable, one Role record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "r = Role.find(1)"
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

describe "Query: random_money_time = Role.find(1)" do
  it "stores in variable, one Role record with all columns" do
    visit "/"
    
    fill_in "Enter a Query", with: "random_money_time = Role.find(1)"
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

describe "Removing Step Query" do
  it "Removes the correct Step Query" do
    visit "/"
    
    fill_in "Enter a Query", with: "random_money_time = Role.find(1)"
    click_on "Step"

    fill_in "Enter a Query", with: "random_money_time.last"
    click_on "Step"

    within "ul" do
      expect(page).to have_css "li", count: 2
    end
    
    find(:xpath, "//a[@href='/remove_step/0']").click
    
    within "ul" do
      expect(page).to have_css "li", count: 1
    end

    expect(page).to have_xpath("//a[@href='/remove_step/0']")
    expect(page).to have_content("Error")
  end
end

describe "Removing all Step Queries in reverse order" do
  it "returns Movie.all" do
    visit "/"
    
    fill_in "Enter a Query", with: "random_money_time = Role.all"
    click_on "Step"
    
    fill_in "Enter a Query", with: "random_money_time.last"
    click_on "Step"
    
    within "ul" do
      expect(page).to have_css "li", count: 2
    end
    
    # click_link "/remove_step/1"
    find(:xpath, "//a[@href='/remove_step/1']").click
    
    within "ul" do
      expect(page).to have_css "li", count: 1
    end
    
    find(:xpath, "//a[@href='/remove_step/0']").click

    # redirect_to results page with Movie.all query
    within "tbody" do
      expect(page).to have_css "tr", count: Movie.all.count
    end
  end
end

describe "Removing last Step Query" do
  it "returns Movie.all" do
    visit "/"
    
    fill_in "Enter a Query", with: "random_money_time = Role.all"
    click_on "Step"
    
    fill_in "Enter a Query", with: "random_money_time.last"
    click_on "Step"
    
    within "ul" do
      expect(page).to have_css "li", count: 2
    end
    
    # click_link "/remove_step/1"
    find(:xpath, "//a[@href='/remove_step/1']").click
    
    within "ul" do
      expect(page).to have_css "li", count: 1
    end
    
    find(:xpath, "//a[@href='/remove_step/0']").click

    # redirect_to results page with Movie.all query
    within "tbody" do
      expect(page).to have_css "tr", count: Movie.all.count
    end
  end
end
