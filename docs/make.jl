using Documenter, BasisSets

push!(LOAD_PATH, "../src/")

makedocs(
    modules  = [BasisSets],
    sitename = "BasisSets",
    warnonly = true,
    format   = Documenter.HTML(
        size_threshold = nothing,
        prettyurls = get(ENV, "CI", nothing) == "true",
        collapselevel = 1,
    ),
    pages = [
        "Introduction to BasisSets" => "index.md",
    ],
)

repo = "HartreeFoca/BasisSets.jl"
withenv("GITHUB_REPOSITORY" => repo) do
    deploydocs(
        repo = repo,
        target = "build"
    )
end