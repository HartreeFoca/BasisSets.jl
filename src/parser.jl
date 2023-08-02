struct CartesianCoordinates
    file
    basis
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

function retrievedata(moleculefile::CartesianCoordinates)
    api = "https://www.basissetexchange.org/api/basis/"

    basis = moleculefile.basis
    atoms = getatoms(moleculefile.file)
    println(atoms)

    molecule = []

    for atom in atoms
        url = api * basis * "/format/gaussian94/?version=0&elements=" * string(atom.number)
        response = HTTP.get(url)
            
        if response.status == 200
            println("done")
        end
    end

    return molecule
end