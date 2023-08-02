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

function retrievedata(coordinates)
    atoms = getatoms(coordinates.file)
    orbitals = []

    for atom in atoms
        push!(orbitals, parseatom(atom, coordinates.basis))
    end

    return orbitals
end