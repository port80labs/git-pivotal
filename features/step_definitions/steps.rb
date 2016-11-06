STORY_TYPE = /feature|bug|chore|release/
STORY_STATE = /unscheduled|unstarted|started|finished|delivered|accepted|rejected/

Transform /PIVOTAL|CURRENT/ do |placeholder|
  placeholder.
    gsub("PIVOTAL_API_KEY", ENV['PIVOTAL_API_KEY']).
    gsub("PIVOTAL_TEST_PROJECT", ENV['PIVOTAL_TEST_PROJECT']).
    gsub("PIVOTAL_USER", ENV['PIVOTAL_USER']).
    gsub("CURRENT_CARD", current_card.id.to_s)
end

Given "I debug" do
  require 'pry'
  binding.pry
end

Given /^I have configured the Git repos for Pivotal$/ do
  step %|a file named ".gitconfig" with:|, <<-EOT.gsub!(/^\s+\S/, '')
    |[pivotal]
    |  api-token = PIVOTAL_API_KEY
    |  full-name = PIVOTAL_USER
    |  project-id = PIVOTAL_TEST_PROJECT
    |  verbose    = false
  EOT
end

Given /^I have configured the Git repos for Pivotal with bogus information$/ do
  step %|a file named ".gitconfig" with:|, <<-EOT.gsub!(/^\s+\S/, '')
    |[pivotal]
    |  api-token          = badtoken
    |  full-name          = Bad Joe
    |  project-id         = something
    |  remote             = origin
    |  verbose            = false
  EOT
end

Given /^the "([^"]+)" commented on the card "([^"]+)"$/ do |author, text|
  comment_on_story :author => author, :text => text
end

Given /^the (#{STORY_TYPE}|card) is labeled "([^"]+)"$/ do |type, labels|
  update_test_story :labels => labels
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

Given /the card is a (#{STORY_TYPE})/ do |type|
  update_test_story :story_type => type
end

Given /the (#{STORY_TYPE}) is unestimated/ do |type|
  update_test_story :estimate => -1
end

Given /the (#{STORY_TYPE}) is (#{STORY_STATE})/ do |type, state|
  update_test_story :current_state => state
end

Given /^I am on the "([^"]*)" branch$/ do |branch|
  `git checkout -b #{branch} > /dev/null 2>&1`
end

Given /^I have a "([^"]*)" branch$/ do |branch|
  `git branch #{branch} > /dev/null 2>&1`
end

When /^the current card is refreshed$/ do
  refresh_current_card!
end

Then /^the card CURRENT_CARD should (not )?have the "([^"]*)" label$/ do |negate, label|
  if negate
    current_card.labels.to_s.should_not include(label)
  else
    current_card.labels.to_s.should include(label)
  end
end

Then /^the card CURRENT_CARD should have the comment by "([^"]*)":$/ do |author, str|
  current_card.notes.all.last.tap do |note|
    note.author.should eq(author)
    note.text.should include(str)
  end
end

Then /^the card CURRENT_CARD should not have the comment:$/ do |str|
  current_card.notes.all.detect{ |n| n.text.include?(str) }.should be_nil
end


Then /^I should be on the "([^"]*)" branch$/ do |branch|
  current_branch.should == branch
end

Then /^card (CURRENT_\w+) is marked is started in Pivotal Tracker$/ do |card_id|
  assert_card_is_started(card_id)
end

Then /^the output should contain each line:$/ do |str|
  str.split("\n").each do |line|
    assert_partial_output(line, all_output)
  end
end
