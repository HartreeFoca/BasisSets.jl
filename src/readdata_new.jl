using JSON
using JSON3

root = pwd()

#println("$(root)/data/METADATA.json")

function readjson(file)
    open(file,"r") do f
        return JSON.parse(f)
    end
end

res = readjson("$(root)/data/METADATA.json")

v0 = []
v1 = []

keys0 = []
keys1 = []

function _getbasename(metadata, key, version)
    name = metadata[key]["versions"][version]["file_relpath"]
    basename = split(name, ".")[1]

    return basename
end

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

function _getversionfile(keys, v, filename)

    basis = Dict(keys .=> v)
    comparison = []

    file = open(filename, "w")

    for i in eachindex(keys)
        push!(comparison, cmp(lowercase(keys[i]), lowercase(v[i])))

        if cmp(lowercase(keys[i]), lowercase(v[i])) != 0
            #println("$(keys[i]) != $(v[i])")
            write(file, "$(lowercase(keys[i])) != $(lowercase(v[i]))\n")
        end
    end

    close(file)

    return basis
end

function levenshtein(guess, correct)
    m = length(guess)
    n = length(correct)
    d = zeros(Int, m+1, n+1)

    for i in range(0, m)
        d[i+1, 1] = i
    end

    for j in range(0, n)
        d[1, j+1] = j
    end

    for j in range(1, n)
        for i in range(1, m)
            if guess[i] == correct[j]
                d[i+1, j+1] = d[i, j]
            else
                d[i+1, j+1] = min(d[i, j+1] + 1, d[i+1, j] + 1, d[i, j] + 1)
            end
        end
    end

    return d[m+1, n+1]

end



#levenshtein("hello", "hello")


basis = _getversionfile(keys0, v0, "diffV0.txt")

function _msg(guesses)
    header = "Your request was not found. Did you mean any of these basis sets: "

    for guess in guesses
        header *= "$guess "
    end

    return header
end

function lookup(correct)
    guesses = []
    guess = ""

    for key in keys(basis)
        if levenshtein(key, correct) < 3
            push!(guesses, key)
        elseif levenshtein(key, correct) == 0
            guess = key
        end
    end

    if guess != ""
        msg = "Your request was found: $guess"
    else
        msg = _msg(guesses)
    end

    return msg
end

println(lookup("cc-pv(5d)z"))
#_getversionfile(keys1, v1, "diffV1.txt")

