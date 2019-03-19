using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libgmsh"], :libgmsh),
#   ExecutableProduct(prefix, "gmsh", :gmsh),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/ahojukka5/GmshBuilder/releases/download/v4.1.5-1"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    MacOS(:x86_64) => ("$bin_prefix/gmsh.v4.1.5.x86_64-apple-darwin14.tar.gz", "08c9f1e6b3d5d6a79de9c447c9fbe5f79b2030ffece43cc29435ccabcb1a2b99"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/gmsh.v4.1.5.x86_64-linux-gnu.tar.gz", "e1b1c7ca1f7dc8e66fa49ee07409f2943471beeee87f461a4870c26a4747e101"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
