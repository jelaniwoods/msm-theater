require 'rails_helper'

Rails.application.load_seed

# Create
describe "Query: Movie.new" do
  it "fails to use the new method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "Movie.new"
    click_on "Execute"


    expect(movie_count).to eql Movie.count
    expect(page).to have_content "invalid"
  end

end

describe "Query: Movie.create" do
  it "fails to use the create method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "Movie.create"
    click_on "Execute"

    expect(movie_count).to eql Movie.count
    expect(page).to have_content "invalid"
  end
end

describe "Query: Movie.new.save" do
  it "fails to use the save method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "Movie.new.save"
    click_on "Execute"

    expect(movie_count).to eql Movie.count
    expect(page).to have_content "invalid"
  end
end

describe "Step Query: Movie.new.save" do
  it "fails to use the save method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "m = Movie.last"
    click_on "Step"
    fill_in "Enter a Query", with: 'm.title = "New Title"'
    click_on "Step"
    fill_in "Enter a Query", with: "m.save"
    click_on "Step"

    expect(movie_count).to eql Movie.count
    expect(page).to have_content "Nil"
  end
end


# Update
describe "Query: Movie.find(1).update(title: 'mean')" do
  it "fails to use the destroy method" do
    visit "/"
    
    movie_title = Movie.find(1).title
    fill_in "Enter a Query", with: 'Movie.find(1).update(title: "mean")'
    click_on "Execute"


    expect(movie_title).to eql Movie.find(1).title
    expect(page).to have_content "invalid"
  end

end

describe "Query: Movie.all.update_all(title: 'mean')" do
  it "fails to use the destroy method" do
    visit "/"
    
    movie_title = Movie.find(1).title
    fill_in "Enter a Query", with: "Movie.all.update_all(title: 'mean')"
    click_on "Execute"


    expect(movie_title).to eql Movie.find(1).title
    expect(page).to have_content "invalid"
  end

end


# Destroy
describe "Query: Movie.find(1).destroy" do
  it "fails to use the destroy method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "Movie.find(1).destroy"
    click_on "Execute"


    expect(movie_count).to eql Movie.count
    expect(page).to have_content "invalid"
  end

end

describe "Query: Movie.find(1).delete" do
  it "fails to use the delete method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "Movie.find(1).delete"
    click_on "Execute"


    expect(movie_count).to eql Movie.count
    expect(page).to have_content "invalid"
  end

end

describe "Query: Movie.all.destroy_all" do
  it "fails to use the destroy_all method" do
    visit "/"
    
    movie_count = Movie.count
    fill_in "Enter a Query", with: "Movie.all.destroy_all"
    click_on "Execute"


    expect(movie_count).to eql Movie.count
    expect(page).to have_content "invalid"
  end

end

describe "Query: Actor.all.delete_all" do
  it "fails to use the delete_all method" do
    visit "/"
    
    actor_count = Actor.count
    fill_in "Enter a Query", with: "Actor.all.delete_all"
    click_on "Execute"


    expect(actor_count).to eql Actor.count
    expect(page).to have_content "invalid"
  end

end

