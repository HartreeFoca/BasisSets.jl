push!(LOAD_PATH, "../src/")

using BasisSets
using Documenter

makedocs(
    sitename = "BasisSets.jl",
    modules = [BasisSets],
    pages = [
        "Home" => "index.md",
        "API" => ["Input" => "input.md"],
    ],
)

deploydocs(; repo = "github.com/HartreeFoca/BasisSets.jl.git")