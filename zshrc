
# Vi mode
bindkey -v
setopt functionargzero
setopt globdots
setopt histignorealldups hist_ignore_space extendedhistory

bindkey -s ^f "tmux-sessioniser\n"

ulimit -n 10240

# Better bare git clone for using git worktrees
__git_worktree_clone() {
	if [ $# -eq 0 ]; then
    echo "No arguments supplied, must supply clonable URI."
		exit 1
	fi
	if [ -z "$2" ]; then
		dir_name=$(basename "$1")
		if test $? -ne 0; then
			echo "Failed to get the base name of the repo, try supplying it as the second argument."
			exit 1
		fi
	else
		dir_name=$2
	fi
	mkdir -p $dir_name && pushd $dir_name > /dev/null
	git clone --bare "$1" .bare 2>&1 | sed "s|\.bare|${dir_name}|g"
	echo "gitdir: ./.bare" > .git
	popd > /dev/null
}

source $HOME/.config/op/plugins.sh
