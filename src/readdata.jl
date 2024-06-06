using JSON3

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

print(JSON3.read("$(root)/data/METADATA.json"))
