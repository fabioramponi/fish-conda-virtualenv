#!/usr/local/bin/fish

function get_realpath
    echo (python -c 'from __future__ import print_function;import os,sys;print(os.path.realpath(sys.argv[1]))' $argv)
end

function get_dirname -d 'get the dir containing the given file'
	echo (get_realpath (dirname $argv[1]))
end

function run_scripts -d 'run all scripts in a directory'
	set -l _PREFIX $PATH[1]/..
	set -l _CONDA_D (echo $_PREFIX/etc/conda/$argv[1].d)
	if test -d $_CONDA_D
		for fn in (find $_CONDA_D -name "*.sh")
			source $fn
		end
	end
end

function get_abs_filename -d 'get absolute path given a filename'
	echo (get_dirname $argv[1])/(basename $argv[1])
end


set -l _THIS_DIR (get_dirname (status --current-filename))

set _ABS_SCRIPT_LOCATION (get_abs_filename (status --current-filename))

while test -L $_ABS_SCRIPT_LOCATION
	set _DIR (readlink (dirname $_ABS_SCRIPT_LOCATION))
	set _ABS_SCRIPT_LOCATION (readlink $_ABS_SCRIPT_LOCATION)
	switch $_ABS_SCRIPT_LOCATION
		case '/*'
		case '*'
			set _ABS_SCRIPT_LOCATION (echo "$_DIR/$_ABS_SCRIPT_LOCATION")
	end
end

run_scripts "deactivate"

if set -g _NEW_PATH (echo (eval $_THIS_DIR/conda ..activateroot) | tr ':' \n)
	set -x PATH $_NEW_PATH
	set -e CONDA_DEFAULT_ENV
	set -e CONDA_ENV_PATH
	if eval $_THIS_DIR/conda ..changeps1
		functions -e fish_prompt
		functions -c conda_old_prompt fish_prompt 
		functions -e conda_old_prompt
	end
else
	exit 1
end



