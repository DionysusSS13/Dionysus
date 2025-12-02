# DOWNLOADING

<!-- Holy fuck this was so outdated -->

###### Be aware that this guide is not the be-all-end-all, and there are edge cases that aren't covered here. If you ever have questions, you're encouraged to send a message in #coding-general so you can get the help you need.

1. Install github desktop, or an equivalent client, and link your github account. Github desktop is recommended unless you're planning on cherrypicking commits, in which case, something that can handle multiple remotes (repositories) seamlessly like smartgit (or god forbid, gitkraken) is recommended.

2. Go to our repo https://github.com/DionysusSS13/Dionysus and press `fork` in the top right. Once it's done, open your git client's clone menu, and paste in the URL to your freshly forked repo. This will take a while, so go play a game or read up on some of the [other documentation](./) while you wait.

## Do not clone the repo into a folder with cloud storage (onedrive) enabled. IT WILL NOT WORK AND WILL CLOG UP YOUR BANDWIDTH.

3. **Create a new branch.** (And ideally name it something related to your future PR.) Do NOT make changes on your master branch unless you want headaches in the future.

4. Go code!

### PR Madness

1. So you now have code/sprites/etc. that you want to commit? Good! You now want to check all the files, give the commit a name and press the commit button! It's recommended to do this more or less as often as you run the game to test, though realistically, you can do this as often as you want. Treat it like your save button, if you wish.

2. Now, all you have to do is go into your forked repository under your account, and there should be a button to create a PR with the branch you've just pushed to in the top!
    - If there's no button, you'll want to press the branches dropdown (usually displaying `master`), and select your branch, then you can press the contribute button, and create a PR from there.

### Post PR Madness

1. Now you've made your PR, and now you want to create a new one, so now what? All you have to do is go to master in your repo, press the `sync fork` button, and update the branch.

2. Then you want to go into your git client, and make a new branch from master! Simple!

### I Have a Merge Conflict, Now What?

This is a tricky one, sometimes it's as simple as accepting remote's changes, or keeping your local ones, but there's no real catch-all answer.

If you're coding, you're gonna have to figure out what you need to keep or throw out. If you need help with this, don't be afraid to send a message in the #coding-general channel.

If you're mapmaking, install the [git hooks](../../tools/hooks/), and merge master into your branch via your git client (NOT THE GITHUB WEBSITE). It'll be able to handle all the conflicts, though you'll likely have to enter the editor and make sure no conflict markers are present on the conflicting maps.

If you're spritemaking, install the [git hooks](../../tools/hooks/) and merge master into your branch via your git client (NOT THE GITHUB WEBSITE). It _should_ be able to handle the conflicts for you, otherwise, you might have to resort to downloading the remote sprites, and manually pasting the ones that should be kept into your DMI.
