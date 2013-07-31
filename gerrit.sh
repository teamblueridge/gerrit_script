#!/bin/bash

name="Team BlueRidge Gerrit"
url="http://review.teamblueridge.org"
project="gerrit_script"
port="29418" #Keep this the default unless you know to do otherwise
branch="$1"
unfile="~/.ssh/tbr_username"
clear
function commit {
	while true; do
	read -p "Do you wish to commit all changes? [Y/N] " yn
	case $yn in
	[Yy]* ) echo "Good, let's continue"; git commit -a; break;;
	[Nn]* ) echo "Please commit your changes manually."; exit;;
	    * ) echo "Please answer Yes or No.";;
	done
}
function push-verify {
	echo "Your push information:"
	echo "======================================="
	echo "Username: $un"
	echo "Project:  $project"
	echo "Branch:   $branch"
	echo "======================================="
	while true; do
	read -p "Is this correct? [Y/N] " yn
	case $yn in
	[Yy]* ) echo "Good, let's continue"; do-push; break;;
	[Nn]* ) echo "Please start over. Exiting"; exit;;
	    * ) echo "Please answer Yes or No.";;
	done
}
function do-push {
	echo "Preparing to push..."
	git push "ssh://${un}@review.simonsickle.com:${port}/${project}.git HEAD:refs/for/$branch"
	if [ $? -eq 0 ]
	then
	echo "Done."
	else
	echo "Push failed. See output above as to why then try again."
	fi
}
function username-check {
	if [ -f $unfile ]
	then
	username-exist
	else
	username-create
	fi
}
function username-exist {
	echo "Welcome back to $name, $un!"
	echo "You've already been through setup already so let's continue!"
	echo "Your username is ${un}. To change this, execute 'rm -rf $unfile'."
}
function username-create {
	echo "Welcome to $name"
	echo "You need to setup your account."
	echo "If you don't have a $name account, please go to $url and create one."
	echo -n "What is your $name username: "
	read un
	mkdir -p $HOME/.ssh/ > /dev/null 2>&1
	echo $un > $unfile
	echo "Your username is ${un}. To change this, execute 'rm -rf $unfile'."
	echo "BE SURE YOUR SSH KEYS ARE MATCHED WITH GERRIT IN YOUR SETTINGS"
	echo "You can verify your SSH keys at:"
	echo "${url}#/settings/ssh-keys"
}

