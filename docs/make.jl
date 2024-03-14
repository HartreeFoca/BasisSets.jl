using BasisSets
using Documenter

push!(LOAD_PATH, "../src/")

makedocs(
    sitename = "BasisSets.jl",
    modules = [BasisSets],
    pages = [
        "Home" => "index.md",
        "API" => ["Input" => "input.md"],
    ],
)

deploydocs(;
    repo="github.com/HartreeFoca/BasisSets.jl.git",
    devbranch="main",
    branch="main",
    deploy_config = auto_detect_deploy_system()
)