using HTTP
using JSON3
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

url = "https://www.basissetexchange.org/api/basis/sto-3g/format/json/?version=1&elements=8"
response = HTTP.request("GET", url)

data = String(response.body)
data = JSON3.read(data)

print(data["elements"])