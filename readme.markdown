[![Build Status](https://secure.travis-ci.org/zdennis/git-pivotal.png)](http://travis-ci.org/#!/zdennis/git-pivotal)

This is based on https://github.com/trydionel/git-pivotal but has an extended vision and set of goals to achieve.

Things like:

* Make the existing API more intuitive:
 * git-bug, git-chore, git-feature should not be separate CLI commands. The common action is start, so goal here is to support "git-start _card\_type_"
* Users should be able to interact with specific cards when possible.
 * e.g. "git start 123456" should start card 123456. 
 * being generic (interacting with next available or specific should apply to all applicable commands)
* Add more commands to interact with Pivotal:
 * git block
 * git unblock
 * git comments
 * git label 
 * git unstart
 * git accept
* Add verbosity and dry-run support to commands to communicate to the users what commands will be run
* Add before/after hooks extension points so people do not have to modify the project in order to do something custom. 
  * e.g. if you want to build a changelog as card's are finished, this should be able to be done by hooking into the "git finish" command and not require altering the code-base
* better support for handling merge conflicts (_this may be nothing more than communicating better to the user if a merge conflict happens when issuing a command_)

The main vision for this is simple: Encourage and support good practices and be flexible. 

More README to come. See ISSUES for things I want to tackle in this project.


### git start - Starting the next available Feature/Bug/Chore

    git start <card_type>
    
Replace card\_type in the above command to start the next available card in your Pivotal project, e.g.:

    1 git-pivotal:master % git start feature
    Collecting latest stories from Pivotal Tracker...
    Story: Test git pivotal
    URL:   http://www.pivotaltracker.com/story/show/1234567
    Updating story status in Pivotal Tracker...
    Enter branch name (will be prepended by 1234567) [feature]: testing
    Creating 1234567-testing branch...
    2 git-pivotal:1234567-testing %

    
### git finish
When on a feature branch, this command will close the associated story in Pivotal Tracker, merge the branch into your integration branch (`master` by default) and remove the feature branch.

    3 git-pivotal:1234567-testing % git finish
    Marking Story 1234567 as finished...
    Merging 1234567-testing into master
    Removing 1234567-testing branch
    4 git-pivotal:master %

### git info
When on a feature/bug/chore branch, this command will display the story information as recorded in Pivotal Tracker.

    5 git-pivotal:1234567-testing % git info
    Story:        Test git pivotal
    URL:          http://www.pivotaltracker.com/story/show/1234567
    Description:  The awesome story description
    6 git-pivotal:1234567-testing % 

## Installation

_This section is out of date and applies to the original project. It needs to be updated._

To install git-pivotal, simply run

    [sudo] gem install git-pivotal

## Configuration

Once installed, git pivotal needs three bits of info: your Pivotal Tracker API Token, your name as it appears in Pivotal Tracker and your Pivotal Tracker project id.  The former two are best set as a global git config options:

    git config --global pivotal.api-token 9a9a9a9a9a9a9a9a9a9a
    git config --global pivotal.full-name "Jeff Tucker"

If you prefer to merge back to a branch other than master when you've finished a story, you can configure that:

    git config --global pivotal.integration-branch develop

If you only want to pick up bugs/features/chores that are already assigned to you, set:

    git config --global pivotal.only-mine true

The project id is best placed within your project's git config:

    git config -f .git/config pivotal.project-id 88888

If you would rather have the story id appended to the branch name (feature-123456) instead of prepending (123456-feature), you can configue that:

    git config -f .git/config pivotal.append-name true

If you're not interested in storing these options in git, you can pass them into git pivotal as command line arguments.  See the usage guides for more details.

