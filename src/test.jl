function momentum2shell(momentum::String)
    shells = Dict(
        "S" => [(0,0,0)],
        "P" => [(1,0,0), (0,1,0), (0,0,1)],
        "D" => [(2,0,0), (1,1,0), (1,0,1), (0,2,0), (0,1,1), (0,0,2)],
        "F" => [(3,0,0), (2,1,0), (2,0,1), (1,2,0), (1,1,1), (1,0,2), 
                (0,3,0), (0,2,1), (0,1,2), (0,0,3)]
    )
    return shells[momentum]
end

function sym2num(sym::String)
    symbols = [:H]
    return findfirst(isequal(sym), symbols)
end

function getBasis(filename::String)
    basis = Dict()
    lines = readlines(filename)
    i = 1
    while i <= length(lines)
        line = lines[i]
        if !isempty(line) && line[1] != '!'
            println(strip(line)[1])
            atom = sym2num("H")
            basis[atom] = []
            i += 1
            while i <= length(lines) && lines[i] != "****"
                words = split(lines[i])
                momentum = words[1]
                numPrims = parse(Int, words[2])
                prims = []
                for j in 1:numPrims
                    i += 1
                    words = split(lines[i])
                    prims = append!(prims, [(parse(Float64, replace(words[1], "D" => "e")), parse(Float64, replace(words[2], "D" => "e")))])
                end
                basis[atom] = append!(basis[atom], [(momentum, prims)])
                i += 1
            end
        end
        i += 1
    end
    print(basis)
    return basis
end

getBasis("/Users/leticiamadureira/BasisSets.jl/src/info.dat")
