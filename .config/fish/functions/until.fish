function until --description 'run command until it suceeds'
	while true
		eval $argv
		sleep 1
	end
end
