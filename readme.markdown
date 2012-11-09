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

## The workflow

1. Assign the card to yourself (or have someone assign it to you)
2. From _master_, **git start <card\_type>**, where card\_type is either 'bug', 'chore', 'feature', or the card number.  A new branch will be created, and you will be automatically  switched to it.  The story will also be marked as started.
3. WRITE ALL THE CODE!, create pull request, merge into master.
4. **git finish**. This will destroy the local and remote branches, and mark the story as finished.

### git start - Starting the next available Feature/Bug/Chore

    git start <card_type>
    
Replace card\_type in the above command to start the next available card in your Pivotal project, e.g.:

    1 git-pivotal:master % git start feature
    Retrieving latest features from Pivotal Tracker for John Wood...
    Story: Test the tracker gem
    URL:   http://www.pivotaltracker.com/story/show/38895179

    Start feature 38895179 - Test the tracker gem? (Y/n): Y
    Updating feature status in Pivotal Tracker...
    Enter branch name [38895179-test-the-tracker-gem]: 
    git branch
    Creating remote branch '38895179-test-the-tracker-gem'
    git push origin origin:refs/heads/38895179-test-the-tracker-gem
    Total 0 (delta 0), reused 0 (delta 0)
    To git@github.com:centro/git-pivotal.git
     * [new branch]      origin/HEAD -> 38895179-test-the-tracker-gem
    git fetch origin
    Switched to a new branch '38895179-test-the-tracker-gem'
    git branch 38895179-test-the-tracker-gem origin/38895179-test-the-tracker-gem
    Branch 38895179-test-the-tracker-gem set up to track remote branch 38895179-test-the-tracker-gem from origin.
    git checkout 38895179-test-the-tracker-gem
    Switched to branch '38895179-test-the-tracker-gem'
    2 git-pivotal:38895179-test-the-tracker-gem %

### git finish
When on a feature branch, this command will close the associated story in Pivotal Tracker and remove the feature branch.

    3 git-pivotal:1234567-testing % git finish
    Marking Story 1234567 as finished...
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

The project id is best placed within your project's git config:

    git config -f .git/config pivotal.project-id 88888

If you're not interested in storing these options in git, you can pass them into git pivotal as command line arguments.  See the usage guides for more details.

