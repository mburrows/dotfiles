# BATS specific fish configuration

set -Ux PATH $PATH $HOME/.local/bin $HOME/system_tests/scripts
set -Ux MANPATH $MANPATH $HOME/local/share/man
set -Ux LD_LIBRARY_PATH /opt/bats/lib /opt/bats/lib64

function compiler_env_clang -d "Set compiler to icecream clang"
    set -gx ICECC_VERSION $HOME/.icecream/d9a591e3756b738f0231588be2c56489.tar.gz
    set -gx ICECC_CC /opt/bats/bin/clang
    set -gx ICECC_CXX /opt/bats/bin/clang++
    set -gx BUILD_DIR /builds/$USER/clang
    set -gx CC clang
    set -gx CXX clang++
end

function compiler_env_gcc -d "Set compiler to icecream gcc"
    set -gx ICECC_VERSION $HOME/.icecream/22b3d3d5f879cab4c24348e1d977e4b0.tar.gz
    set -gx ICECC_CC /opt/rh/devtoolset-7/root/usr/bin/gcc
    set -gx ICECC_CXX /opt/rh/devtoolset-7/root/usr/bin/g++
    set -gx BUILD_DIR /builds/$USER/gcc
    set -gx CC gcc
    set -gx CXX g++
end

# Default to clang compilation
compiler_env_clang

set -Ux ECN_ENVIRONMENT {$USER}_cedx
set -Ux ECN_BIN /opt/ecn/users/mburrows/bin
set -Ux ECN_SRC /opt/ecn/users/mburrows/source/ecn/source

# npm global install locally
set NPM_PACKAGES {$HOME}/.npm-packages
set -Ux PATH {$NPM_PACKAGES}/bin $PATH

abbr -a md "~/cpp/bb --icecream debug -j32"
abbr -a mr "~/cpp/bb --icecream release -j32"
abbr -a mc "~/cpp/bb --icecream configure -f -l8 --variant=debug"
abbr -a mclean "~/cpp/bb --icecream clean -j32 -l8"
abbr -a icemon "env USE_SCHEDULER=pcodev5 icemon"
abbr -a ut "$ECN_BIN/ecn_unit_test"
abbr -a utl "$ECN_BIN/ecn_unit_test --log_level=unit_scope"
abbr -a utlr "$ECN_BIN/ecn_unit_test --log_level=unit_scope --run_test="
abbr -a utr "$ECN_BIN/ecn_unit_test --run_test="
abbr -a pt "$ECN_BIN/ecn_unit_test -P --fuzzy"
abbr -a wg "wgrep -P --line-buffered"
abbr -a wr "wrange -r"
abbr -a wf "wtail -f"
abbr -a pw "prt_wire"
abbr -a pf "prt_fix --nohb"
abbr -a tf "tail -F"
abbr -a pks "pkill ecn_ ; pkill mtf_ ; pkill test_orderentry ; pkill test_topclient"
abbr -a sth "~/system_tests/scripts/sth.py"

function utg -d "Search for a unit test"
    eval $ECN_BIN/ecn_unit_test --list | grep -i $argv
end

eval (dircolors -c ~/.dir_colors)
