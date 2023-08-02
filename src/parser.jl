struct CartesianCoordinates
    file
    basis
end
struct GaussianBasisSet
    atom
    basis
    exponents
    coefficients
end

function _angularmomentum(ℓ::T) where T <: Integer
    orbitals = Dict(
        0 => "S",
        1 => "P",
        2 => "D",
        3 => "F",
        4 => "G",
        5 => "H",
        6 => "I",
        7 => "J"
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

function _getbasis(element, basis)
    url = "https://www.basissetexchange.org/api/basis/" * basis * "/format/json/?version=1&elements=" * "$(element)"
    response = HTTP.request("GET", url)

    data = String(response.body)
    data = JSON3.read(data)

    return data
end

function parsebasis(file, basisset)
    atoms = getatoms(file)
    basis = []

    for atom in atoms
        data = _getbasis(atom.number, basisset)
        gtos = []

        element = Dict()

        for shell in data["elements"]["$(atom.number)"]["electron_shells"]
            for (index, ℓ) in enumerate(shell["angular_momentum"])
                element[_angularmomentum(ℓ)] = Dict(
                    "exponents" => shell["exponents"],
                    "coefficients" => shell["coefficients"][index]
                )
            end

            append!(gtos, element)
        end
        append!(basis, gtos)
    end

    return basis
end

#parsebasis("../test/data/water/water.xyz", "sto-3g")
