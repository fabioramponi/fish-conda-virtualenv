function get_dirname -d 'get the dir containing the given file'
	echo (realpath (dirname $argv[1]))
end

function print_help 
	echo "Usage:"
	echo " fish conda-env.fish {install, uninstall}"
end

set argc (echo (count $argv))

set _THIS_DIR (get_dirname (status --current-filename))
set _FISH_FUNCTIONS_DIR (realpath ~/.config/fish/functions)
set _CONDA_ROOT_DIR (python -c "from __future__ import print_function; from conda.config import root_dir; print(root_dir)")
set _CONDA_BIN_DIR (echo $_CONDA_ROOT_DIR"/bin")

if [ $argc = '1' ]
	switch $argv
		case "install"
			echo $_THIS_DIR
			echo $_CONDA_ROOT_DIR
			echo $_CONDA_BIN_DIR
			echo $_FISH_FUNCTIONS_DIR
			cp $_THIS_DIR/conda/activate.fish $_CONDA_BIN_DIR
			cp $_THIS_DIR/conda/activate.fish.py $_CONDA_BIN_DIR
			cp $_THIS_DIR/conda/deactivate.fish $_CONDA_BIN_DIR
			function activate 
				echo (which activate.fish)
			end
			function deactivate 
				echo (which deactivate.fish)
			end
			funcsave activate
			funcsave deactivate
			exit
		case "uninstall"
			echo $_CONDA_ROOT_DIR
			echo $_FISH_FUNCTIONS_DIR
			rm -rf $_CONDA_BIN_DIR/activate.fish
			rm -rf $_CONDA_BIN_DIR/activate.fish.py
			rm -rf $_CONDA_BIN_DIR/deactivate.fish
			rm -rf $_FISH_FUNCTIONS_DIR/activate.fish
			rm -rf $_FISH_FUNCTIONS_DIR/deactivate.fish
			functions -e activate
			functions -e deactivate
			exit
		case '*'
			print_help
	end
else
	print_help
end


