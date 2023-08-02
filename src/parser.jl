struct CartesianCoordinates
    file
    basis
end
struct GaussianBasisSet
    exponents
    coefficients
    ℓ
    m
    n
end

function _angularmomentum(ℓ::T) where T <: Integer
    orbitals = Dict(
        0 => [(0,0,0)],
        1 => [(1,0,0),(0,1,0),(0,0,1)],
        2 => [(2,0,0),(1,1,0),(1,0,1),(0,2,0),(0,1,1),(0,0,2)],
        3 => [(3,0,0),(2,1,0),(2,0,1),(1,2,0),(1,1,1),(1,0,2),
            (0,3,0),(0,2,1),(0,1,2), (0,0,3)],
        4 => [(4,0,0),(3,1,0),(3,0,1),(2,2,0),(2,1,1),(2,0,2),
            (1,3,0),(1,2,1),(1,1,2),(1,0,3),(0,4,0),(0,3,1),
            (0,2,2),(0,1,3),(0,0,4)],
        5 => [(5,0,0),(4,1,0),(4,0,1),(3,2,0),(3,1,1),(3,0,2),
            (2,3,0),(2,2,1),(2,1,2),(2,0,3),(1,4,0),(1,3,1),
            (1,2,2),(1,1,3),(1,0,4),(0,5,0),(0,4,1),(0,3,2),
            (0,2,3),(0,1,4),(0,0,5)],
        6 => [(6,0,0),(5,1,0),(5,0,1),(4,2,0),(4,1,1),(4,0,2),
            (3,3,0),(3,2,1),(3,1,2),(3,0,3),(2,4,0),(2,3,1),
            (2,2,2),(2,1,3),(2,0,4),(1,5,0),(1,4,1),(1,3,2),
            (1,2,3),(1,1,4),(1,0,5),(0,6,0),(0,5,1),(0,4,2),
            (0,3,3),(0,2,4),(0,1,5),(0,0,6)],
        7 => [(7,0,0),(6,1,0),(6,0,1),(5,2,0),(5,1,1),(5,0,2),
            (4,3,0),(4,2,1),(4,1,2),(4,0,3),(3,4,0),(3,3,1),
            (3,2,2),(3,1,3),(3,0,4),(2,5,0),(2,4,1),(2,3,2),
            (2,2,3),(2,1,4),(2,0,5),(1,6,0),(1,5,1),(1,4,2),
            (1,3,3),(1,2,4),(1,1,5),(1,0,6),(0,7,0),(0,6,1),
            (0,5,2),(0,4,3),(0,3,4),(0,2,5),(0,1,6),(0,0,7)]
    )

    return orbitals[ℓ]
end

function getatoms(file)
    atoms = []

    open(file, "r") do f
        lines = readlines(f)
        deleteat!(lines, 1:2)

        for line in lines
            atom = split(line)
            push!(atoms, getatom(atom[1]))
        end
    end

    return atoms
end

function _getbasis(atoms, basis)
    atomicnumbers = [atom.number for atom in atoms]
    elements = join(atomicnumbers, ",")

    url = "https://www.basissetexchange.org/api/basis/" * basis * "/format/json/?version=1&elements=" * "$(elements)"
    response = HTTP.request("GET", url)

    data = String(response.body)
    data = JSON3.read(data)

    return data
end

function parsebasis(file, basisset)
    atoms = getatoms(file)
    data = _getbasis(atoms, basisset)

    basis = GaussianBasisSet[]

    for atom in atoms
        for shell in data["elements"]["$(atom.number)"]["electron_shells"]
            for (index, ℓ) in enumerate(shell["angular_momentum"])
                for momentum in _angularmomentum(ℓ)
                    push!(basis,
                        GaussianBasisSet(
                            hcat(parse.(Float64, shell["exponents"])...),
                            hcat(parse.(Float64, shell["coefficients"][index])...),
                            momentum[1],
                            momentum[2],
                            momentum[3]
                        )
                    )
                end
            end
        end
    end

    return basis
end