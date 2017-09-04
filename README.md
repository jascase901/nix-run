# nix-run
wrapper script to launch programs in nix-shells

This alias in my bash rc allows for me to run gl programs with this script
'''
alias nix-run="LD_LIBRARY_PATH=/usr/lib/nvidia-375/ guile -e main ~/nix-run/nix-run.scm"
'''
