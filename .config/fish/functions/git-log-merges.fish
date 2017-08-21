function git-log-merges
	git log --first-parent --pretty='format:%aD    %h    %an    %s' $argv
end
