STORY_TYPE = /feature|bug|chore|release/
STORY_STATE = /unscheduled|unstarted|started|finished|delivered|accepted|rejected/

Transform /PIVOTAL|CURRENT/ do |placeholder|
  placeholder.
    gsub("PIVOTAL_API_KEY", "80f3c308cfdfbaa8f5a21aa524081690").
    gsub("PIVOTAL_TEST_PROJECT", "516377").
    gsub("PIVOTAL_USER", "Robotic Zach").
    gsub("CURRENT_CARD", current_card.id.to_s).
    gsub("CURRENT_BUG", current_card.id.to_s).
    gsub("CURRENT_CHORE", current_card.id.to_s).
    gsub("CURRENT_FEATURE", current_card.id.to_s)
end

Given /^I have configured the Git repos for Pivotal$/ do
  step %|a file named ".gitconfig" with:|, <<-EOT.gsub!(/^\s+\S/, '')
    |[pivotal]
    |  api-token = PIVOTAL_API_KEY
    |  full-name = PIVOTAL_USER
    |  integration-branch = develop
    |  project-id = PIVOTAL_TEST_PROJECT
  EOT
end

Given /^I have configured the Git repos for Pivotal with bogus information$/ do
  step %|a file named ".gitconfig" with:|, <<-EOT.gsub!(/^\s+\S/, '')
    |[pivotal]
    |  api-token = badtoken
    |  full-name = Bad Joe
    |  integration-branch = whoknows
    |  project-id = something
  EOT
end

Given /^I have a(?:n)? (#{STORY_STATE})?\s?Pivotal Tracker (#{STORY_TYPE})$/ do |status, type|
  options = {}
  options[:current_state] = status if status
  create_test_story type, options
end

Given /^I have a(?:n)? unestimated \s?Pivotal Tracker (#{STORY_TYPE})$/ do |type|
  options = { :estimate => -1 }
  create_test_story type, options
end

Given /^I have a(?:n)? (#{STORY_STATE})?\s?Pivotal Tracker (#{STORY_TYPE}) named "([^"]+)" with description "([^"]+)"$/ do |status, type, name, description|
  options = { :name => name, :description => description }
  options[:current_state] = status if status
  create_test_story type, options
end

Given /the feature is unestimated/ do
  update_test_story('feature', :estimate => -1)
end

Given /^I am on the "([^"]*)" branch$/ do |branch|
  `git checkout -b #{branch} > /dev/null 2>&1`
end

Given /^I have a "([^"]*)" branch$/ do |branch|
  `git branch #{branch} > /dev/null 2>&1`
end

Then /^I should be on the "([^"]*)" branch$/ do |branch|
  current_branch.should == branch
end

Then /^card (CURRENT_\w+) is marked is started in Pivotal Tracker$/ do |card_id|
  assert_card_is_started(card_id)
end
