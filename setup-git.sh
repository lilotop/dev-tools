#!/bin/sh

# Git Config Setup

# run this file to setup recommended aliases 
# for a list of available aliases, run "git alias"

function setupAlias {
    # name, command, description
    if [ $# -gt 2 ]; then
        echo -e "setting up git alias   \e[96m$1\e[39m -> \e[32m$3\e[39m"
        git config --global alias-desc.$1 "$3"
    else
        echo -e "setting up git alias   \e[96m$1\e[39m -> \e[32m$2\e[39m"
        git config --global alias-desc.$1 "$2"
    fi
    git config --global alias.$1 "$2"
}


setupAlias co checkout
setupAlias br branch
setupAlias ci commit
setupAlias stf 'status'
setupAlias st 'status -s -b' 'show just a list of the modified files and branch info'
setupAlias local-commits 'log @{upstream}..HEAD' 'list of local commits not pushed yet'
setupAlias remote-commits 'log HEAD..@{upstream}' 'list of remote commits not pulled yet'
setupAlias where 'branch -r --contains' 'list remote branches that contain a specific commit (usage: git where <commit-sha1>)'
setupAlias push-1st-time "push -u origin $( git branch | sed -n -e 's/^\* \(.*\)/\1/p')" 'push a branch for the first time, setting the remote tracking branch to origin <local-branch-name>'

# go to pull request page (tested on bitbucket, on a windows10 machine)
# explanation:
# start - starts the app associated with the file/protocol type supplied (in windows)
# git remote -v displays the current fetch and push URLs, this is piped to the S
# the first "sed" command finds the first instance of a line that begins with "origin http" and returns just the url and without the ".git" part.
# the second "sed" command is the same one we use at push-1st-time, it gets the name of the current branch
setupAlias pr "!start $(git remote -v | sed -n -e '0,/.*/s/^origin.*\(http.*\).*\.git.*$/\1/p')/pull-requests/new?source=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')" 'go to pull request page (tested on bitbucket, on a windows10 machine)'

setupAlias su 'submodule update --init --recursive' 'update all sub-modules recursively and init new sub-modules if any'
setupAlias unstage 'reset HEAD --'
setupAlias last 'log -1 HEAD' 'show details of the latest commit'
setupAlias sdiff 'diff --submodule' 'show changes in all sub-modules'
setupAlias stm "submodule foreach --recursive 'git st'" 'short status of all sub-modules'
setupAlias stmfull "submodule foreach --recursive 'git status -v -v'" 'full status of all sub-modules'
setupAlias "alias" "config --get-regexp ^alias-desc\." 'list all available aliases with their descriptions'
setupAlias alias-cmds "config --get-regexp ^alias[^-]" 'list the commands of all available aliases'

# attempts on a fancier git alias listing
# git config --get-regexp ^alias-desc\. | sed -n -e 's/^alias-desc\.\(\w*\) \(.*\)/\1 -> \2/p'
# echo -e $(git config --get-regexp ^alias-desc\. | sed -n -e 's/^alias-desc\.\(\w*\) \(.*\)/\\e[96m\1\\e[39m -> \\e[32m\2\\e[39m/p')



echo "setting up some additional config values..."
git config status.submodulesummary 1
git config push.recurseSubmodules check

echo -e "Use \e[96mgit alias\e[39m to view available aliases."
echo -e "\e[1mDone.\e[0m"