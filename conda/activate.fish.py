from __future__ import print_function
import sys
from conda.cli.activate import binpath_from_arg
import os
import os.path
from os.path import join

binpath = binpath_from_arg(sys.argv[1])
try:
    import conda.config
    if binpath != join(conda.config.root_dir, 'bin'):
        prefix = join(binpath, '..')
        root_dir = conda.config.root_dir
        root_activate_fish = join(root_dir, 'bin', 'activate.fish')
        root_deactivate_fish = join(root_dir, 'bin', 'deactivate.fish')
        prefix_activate_fish = join(prefix, 'bin', 'activate.fish')
        prefix_deactivate_fish = join(prefix, 'bin', 'deactivate.fish')
        if not os.path.lexists(prefix_activate_fish):
            os.symlink(root_activate_fish, prefix_activate_fish)
        if not os.path.lexists(prefix_deactivate_fish):
            os.symlink(root_deactivate_fish, prefix_deactivate_fish)
except (IOError, OSError) as e:
    import errno
    if e.errno == errno.EPERM or e.errno == errno.EACCES:
        sys.exit("Cannot activate environment {}, do not have write access to write conda symlink".format(sys.argv[2]))
    raise
sys.exit(0)
