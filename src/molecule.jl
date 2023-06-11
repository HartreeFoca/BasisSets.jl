struct XYZFile
    file
    basis
end

struct Molecule 
    charge::Int
    multiplicity::Int
    atoms::Array{Atom, 1}
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

function retrievedata(coordinates::XYZFile)
    api = "https://www.basissetexchange.org/api/basis/"

    basis = coordinates.basis
    atoms = getatoms(coordinates.file)

    orbitals = Dict()

    for atom in atoms
        url = api * basis * "/format/json/?version=0&elements=" * string(atom.number)
        println(url)
        response = HTTP.get(url)
            
        if response.status == 200
            data = JSON.parse(String(response.body))
            orbitals = parsebasis(data)

            return orbitals
        end
    end
end

function parsebasis(json)
    subshells = ['S', 'P', 'D', 'F', 'G', 'H', 'I']
    basis = Dict()

    for (atomnumber, atombasis) in json["elements"]
        atomnumber = parse(Int, atomnumber)
        basis[atomnumber] = []

        for shell in atombasis["electron_shells"]
            angmomentum = shell["angular_momentum"][1]  # assuming it's always a one-element array

            for (_, coefficients) in enumerate(shell["coefficients"])
                primitives = [(parse(Float64, exp), parse(Float64, coef))
                              for (exp, coef) in zip(shell["exponents"], coefficients)]
                push!(basis[atomnumber], (subshells[angmomentum + 1], primitives))
            end
        end
    end
    
    return basis
end
