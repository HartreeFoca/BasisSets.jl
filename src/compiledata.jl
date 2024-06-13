using JSON

struct BSE
    name::String
    elements::Array{String,1}
    angularmomentum
    coefficients::Array{Float64,1}
    exponents
end

function readjson(file)
    open(file,"r") do f
        return JSON.parse(f)
    end
end

function _getbasename(metadata, key, version)
    name = metadata[key]["versions"][version]["file_relpath"]
    basename = split(name, ".")[1]

    return basename
end

function _getbasistofile(keys, v)
    basis = Dict(keys .=> v)

    return basis
end

root = pwd()

res = readjson("$(root)/data/METADATA.json")

v0 = []
v1 = []

keys0 = []
keys1 = []

for key in keys(res)
    versions = keys(res[key]["versions"])

    for version in versions
        if version == "0"
            push!(keys0, key)
            basename = _getbasename(res, key, version)

            push!(v0, basename)
        else
            push!(keys1, key)
            basename = _getbasename(res, key, version)

            push!(v1, basename)
        end
    end
end

basis0 = _getbasistofile(keys0, v0)
basis1 = _getbasistofile(keys1, v1)

elements = []

bs = []

for (pos, el) in enumerate(collect(keys(basis0))[1:5])
    println("Current search: $(el)")

    fil = res[el]["versions"]["0"]["file_relpath"]
    println("File: $(fil)")

    files = collect(values(readjson("$(root)/data/$(fil)")["elements"]))
    println("Files: $(files)")

    els = collect(keys(readjson("$(root)/data/$(files[1])")["elements"]))
    println("Elements: $(els)")

    push!(elements, els)

    exponents = []
    coefficients = []

    l = []

    for e in elements[pos]
        c = []

        dat = collect(readjson("$(root)/data/$(files[1])")["elements"][e]["components"])
        println("Data: $(dat)")

        for d in dat
            println("Components: $(d)")
            final = readjson("$(root)/data/$(d)")
            println("Final: (final[elements][$(e)])")
            println("Element: $(e)")

            push!(c, final["elements"][e])
        end

        push!(l, c)

        println(length(c))
    end

    push!(bs, l)

end

println(length(bs))
