require "rails_helper"

feature 'User' do
  before do
    User.create(username: 'AhIsCool',
                full_name: 'Alex Handy',
                bio: 'Cooler than you megalolz',
                follows: '0',
                followed_by: '1000000000')
    User.create(username: 'AmIsBetter',
                full_name: 'Ashleigh',
                bio: 'The coolest EVER',
                follows: '0',
                followed_by: '1000000001')
  end
  scenario 'visits homepage and sees user details' do
    visit('/')
    expect(page).to have_content('AhIsCool')
    expect(page).to have_content('Alex Handy')
    expect(page).to have_content('Cooler than you megalolz')
    expect(page).to have_content('0')
    expect(page).to have_content('1000000000')
  end

  scenario 'users are sorted by "followed by"' do
    visit '/'
    within('table.table tbody tr:nth-child(1)') do
      expect(page).to have_content 'Ashleigh'
    end
  end

  scenario 'can follow a link to the user\'s instagram page' do
    visit '/'
    expect(page).to have_selector "a[href='https://instagram.com/AhIsCool']"
  end

  scenario 'can search a term in various cases and will output a user with that term in lowercase in their bio' do
    visit '/'
    fill_in 'Search', with: 'COOlest'
    click_button 'Search'
    expect(page).to have_content 'The coolest EVER'
    expect(page).to have_content 'Ashleigh'
    expect(page).not_to have_content 'Cooler than you megalolz'
    expect(page).not_to have_content 'Alex Handy'
  end

  xscenario 'can search a term in capitals and will output a user with that term in bio in upper case' do
    visit '/'
    fill_in 'Search', with: 'ever'
    click_button 'Search'
    expect(page).to have_content 'The coolest EVER'
    expect(page).to have_content 'Ashleigh'
    expect(page).not_to have_content 'Cooler than you megalolz'
    expect(page).not_to have_content 'Alex Handy'
  end

  xscenario 'can search a term and will output a user with that term in bio regardless of state' do
    visit '/'
    fill_in 'Search', with: 'cooler'
    click_button 'Search'
    expect(page).not_to have_content 'The coolest EVER'
    expect(page).not_to have_content 'Ashleigh'
    expect(page).to have_content 'Cooler than you megalolz'
    expect(page).to have_content 'Alex Handy'
  end
end