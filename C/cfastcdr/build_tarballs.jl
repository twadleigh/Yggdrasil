# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "cfastcdr"
version = v"1.0.0"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/twadleigh/cfastcdr.git", "8052cee0db89b9955bef238d35b0451226a272ce")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
mkdir build
cd build
cmake ../cfastcdr/
make
make install
exit
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = expand_cxxstring_abis(supported_platforms())

# The products that we will ensure are always built
products = Product[
    LibraryProduct("libcfastcdr", :libcfastcdr_1)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
    Dependency(PackageSpec(url="https://github.com/twadleigh/FastCDR_jll", rev="main", build_version=v"1.0.0"), v"1")
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version=v"7")
