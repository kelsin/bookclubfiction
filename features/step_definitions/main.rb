Given(/^a logged in user$/) do
  @user = User.create(:uid => 12345, :provider => "goodreads", :extra_votes => 5)
  visit("/users/auth/goodreads")
end

When(/^I request "(.*?)"$/) do |path|
  visit(path)
end
