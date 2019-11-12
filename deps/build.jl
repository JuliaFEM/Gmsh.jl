using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libgmsh"], :libgmsh),
]

local download_info

if get(ENV, "GMSH_USE_SDK", "false") == "true" # Download official SDK binaries
	bin_prefix = "http://gmsh.info/bin"
	println("Downloading SDK binaries from $bin_prefix")
	download_info = Dict(
		# since v4.2.3, Linux SDK will cause segment fault if being `dlopen`
		Linux(:x86_64, :glibc) => ("$bin_prefix/Linux/gmsh-4.2.2-Linux64-sdk.tgz", "ea6a6d36da41b9e777111e055c416ffe994d57c7e3debf174b98e4c09b3b33d7"),
		Windows(:x86_64) => ("$bin_prefix/Windows/gmsh-4.4.1-Windows64-sdk.zip", "094207b56e23e462f2e11ffc2d7006f88c641b62fa9d01522f731dcf00e321a9"),
		MacOS(:x86_64) => ("$bin_prefix/MacOSX/gmsh-4.4.1-MacOSX-sdk.tgz", "40c13c22f0bff840fc827e5f4530668b2818c1472593370ebf302555df498f9e"),
	)
else # Download binaries from ahojukka5/GmshBuilder
	bin_prefix = "https://github.com/ahojukka5/GmshBuilder/releases/download/v4.4.1"
	println("Downloading binaries from $bin_prefix")
	download_info = Dict(
		MacOS(:x86_64) => ("$bin_prefix/gmsh.v4.4.1.x86_64-apple-darwin14.tar.gz", "a29d761a6826bbca16e500b195c1ddd22487fd62ae8be99930e3755a1e170c33"),
		Linux(:x86_64, libc=:glibc) => ("$bin_prefix/gmsh.v4.4.1.x86_64-linux-gnu.tar.gz", "f9bb150e70877ad1c2da1edae697f5275776ffcff9c682f666d58f032c87ae89"),
	)
end

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
