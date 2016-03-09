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

function get_conda_prefix 
	echo (python -c "import sys; print(sys.prefix)")
end

set -l _THIS_DIR (get_dirname (status --current-filename))

if eval $_THIS_DIR/conda ..checkenv $argv
	python $_THIS_DIR/activate.fish.py $argv
	run_scripts "deactivate"
	set _NEW_PATH (echo (eval $_THIS_DIR/conda ..deactivate) | tr ':' \n)
	set -x PATH $_NEW_PATH
	if eval $_THIS_DIR/conda ..changeps1
		if functions -q conda_old_prompt
			functions -e fish_prompt
			functions -c conda_old_prompt fish_prompt
			functions -e conda_old_prompt
		end
	end
else
	exit 1
end

if set -g _NEW_PATH (echo (eval $_THIS_DIR/conda ..activate $argv) | tr ':' \n)
	set -x PATH $_NEW_PATH
	switch $argv
		case '*/*'
			set -x CONDA_DEFAULT_ENV (get_abs_filename $argv)
		case '*'
			set -x CONDA_DEFAULT_ENV $argv	
	end
	
	set ENV_BIN_DIR $PATH[1]
	set -x CONDA_ENV_PATH (get_dirname $ENV_BIN_DIR)

	if eval $_THIS_DIR/conda ..changeps1
		functions -c fish_prompt conda_old_prompt
		functions -e fish_prompt
		function fish_prompt
			set_color red
			echo "($CONDA_DEFAULT_ENV) "(conda_old_prompt)
		end
	end
else
	exit 1
end

run_scripts "activate"


