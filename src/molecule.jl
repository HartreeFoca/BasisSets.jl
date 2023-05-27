struct Molecule 
    file::String
    charge::Int
    multiplicity::Int
    basis::String
end

function _atoms(file)
    atoms = []

    open(file, "r") do f
        lines = readlines(f)
        deleteat!(lines, 1:2)

        for line in lines
            atom = split(line)
            push!(atoms, _atom(atom[1]))
        end
    end

    return atoms
end

_atoms("/Users/leticiamadureira/Hartree-Foca/McMurchieDavidson.jl/src/basissets/water.xyz")

function _retrievedata(molecule::Molecule)
    api = "https://www.basissetexchange.org/api/basis/"

    basis = molecule.basis
    atoms = _atoms(molecule.file)

    for atom in atoms
        url = api * basis * "/format/json?elements=" * atom.number
    end
end