# Add a declarative step here for populating the DB with movies.

Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
    log "Created movie: #{movie['title']}"
  end
end

Then(/(.*) seed movies should exist/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then(/^I should see "(.*)" before "(.*)" in the movie list$/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page_body = page.body
  pos1 = page_body.index(e1)
  pos2 = page_body.index(e2)
  
  expect(pos1).not_to be_nil, "Expected to find '#{e1}' on the page"
  expect(pos2).not_to be_nil, "Expected to find '#{e2}' on the page"
  expect(pos1).to be < pos2, "Expected '#{e1}' to appear before '#{e2}', but '#{e1}' was at position #{pos1} and '#{e2}' was at position #{pos2}"
end


# Make it easier to express checking or unchecking several boxes at once
#  "When I check only the following ratings: PG, G, R"

When(/I check the following ratings: (.*)/) do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(',').map(&:strip)
  
  # First uncheck all ratings
  Movie.all_ratings.each do |rating|
    uncheck("ratings_#{rating}")
  end
  
  # Then check only the specified ratings
  ratings.each do |rating|
    check("ratings_#{rating}")
  end
end

Then(/^I should (not )?see the following movies: (.*)$/) do |no, movie_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  movies = movie_list.split(',').map(&:strip)
  
  movies.each do |movie|
    if no
      expect(page).not_to have_content(movie)
    else
      expect(page).to have_content(movie)
    end
  end
end

Then(/^I should see all the movies$/) do
  # Make sure that all the movies in the app are visible in the table
  # Count the number of movie divs
  movie_divs = page.all('div[id^="movie_"]').count
  expect(movie_divs).to eq Movie.count
end

### Utility Steps Just for this assignment.

Then(/^debug$/) do
  # Use this to write "Then debug" in your scenario to open a console.
  require "byebug"
  byebug
  1 # intentionally force debugger context in this method
end

Then(/^debug javascript$/) do
  # Use this to write "Then debug" in your scenario to open a JS console
  page.driver.debugger
  1
end

Then(/complete the rest of of this scenario/) do
  # This shows you what a basic cucumber scenario looks like.
  # You should leave this block inside movie_steps, but replace
  # the line in your scenarios with the appropriate steps.
  raise "Remove this step from your .feature files"
end
