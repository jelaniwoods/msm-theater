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
