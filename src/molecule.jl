struct Molecule 
    file::String
    charge::Int
    multiplicity::Int
    basis::String
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

function retrievedata(molecule::Molecule)
    api = "https://www.basissetexchange.org/api/basis/"

    basis = molecule.basis
    atoms = _atoms(molecule.file)

    for atom in atoms
        url = api * basis * "/format/json?elements=" * atom.number
    end
end