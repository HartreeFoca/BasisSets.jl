using JSON3
using JSON

function transformbasisname(root, name, version="1")
    name = lowercase(name)
    name = string(name, ".$version.table.json")
    
    basis = joinpath(root, "data", name)

    path = joinpath(root, "data")

    #name = replace(name, "/" => "_sl_")
    #name = replace(name, "*" => "_st_")

    return [path, basis]
end

function _getelement(data, element)
    return data["elements"][element]
end

function getdir(dir, element)
    path = dir[1]
    basis = dir[2]
    res = JSON3.read(basis)
    
    databranchpath = joinpath(path, res["elements"][element])
    databranch = JSON3.read(databranchpath)["elements"][element]["components"]

    data = JSON3.read(joinpath(root, "data", databranch[1]))

    out = _getelement(data, element)

    return out
end

root = pwd()

final = transformbasisname(root, "MIDI", "0")

res = getdir(final, 2)

println("$(root)/data/METADATA.json")

function read_json(file)
    open(file,"r") do f
        return JSON.parse(f)
    end
end

res = read_json("$(root)/data/METADATA.json")

v0 = []
v1 = []

keys0 = []
keys1 = []

for key in keys(res)
    versions = keys(res[key]["versions"])

    for version in versions
        if version == "0"
            push!(keys0, key)
            name = res[key]["versions"][version]["file_relpath"]
            basename = split(name, ".")[1]
            push!(v0, basename)
        else
            push!(keys1, key)
            name = res[key]["versions"][version]["file_relpath"]
            basename = split(name, ".")[1]
            push!(v1, basename)
        end
    end
end

Dict(keys0 .=> v0)

comparison = []

file = open("diff.txt", "w")

for i in eachindex(keys0)
    #println(cmp(lowercase(keys0[i]), lowercase(v0[i])))
    push!(comparison, cmp(lowercase(keys0[i]), lowercase(v0[i])))
    if cmp(lowercase(keys0[i]), lowercase(v0[i])) != 0
        println("$(keys0[i]) != $(v0[i])")
        write(file, "$(lowercase(keys0[i])) != $(lowercase(v0[i]))\n")
    end
end

close(file)

println(comparison)
Dict(keys0 .=> v0)