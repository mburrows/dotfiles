# BATS specific fish configuration

set -Ux PATH $PATH $HOME/.local/bin $HOME/system_tests/scripts
set -Ux MANPATH $MANPATH $HOME/local/share/man

function compiler_env_clang -d "Set compiler to icecream clang"
    set -gx ICECC_VERSION $HOME/.icecream/3e23e81a35e996099334d076e895678a.tar.gz
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

set -Ux ECN_ENVIRONMENT {$USER}_beta
set -Ux ECN_BIN /opt/ecn/users/mburrows/bin
set -Ux ECN_SRC /opt/ecn/users/mburrows/source/ecn/source

# npm global install locally
set NPM_PACKAGES {$HOME}/.npm-packages
set -Ux PATH {$NPM_PACKAGES}/bin $PATH

abbr -a md "~/cpp/bb debug -j32"
abbr -a mr "~/cpp/bb release -j32"
abbr -a icemon "env USE_SCHEDULER=pcodev1.uk.bats.com icemon"
abbr -a ut "$ECN_BIN/ecn_unit_test --show_progress=yes"
abbr -a utl "$ECN_BIN/ecn_unit_test --log_level=unit_scope"
abbr -a utlr "$ECN_BIN/ecn_unit_test --log_level=unit_scope --run_test="
abbr -a utr "$ECN_BIN/ecn_unit_test --show_progress=yes --run_test="
abbr -a pt "~/cpp/ecn_unit_test/parallel_test -1"
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
