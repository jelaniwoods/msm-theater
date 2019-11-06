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
  it "Removes the right Step Query" do
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

    # Click on /remove_step/index
    # click_on ""
  end
end
