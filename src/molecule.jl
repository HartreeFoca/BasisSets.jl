struct XYZFile
    file
    basis
end

struct GaussianBasisSet
    coefficients::Matrix{Float64}
    exponents::Matrix{Float64}
    ℓ::Int
    m::Int
    n::Int
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
    println(atoms)

    molecule = []

    for atom in atoms
        url = api * basis * "/format/json/?version=0&elements=" * string(atom.number)
        response = HTTP.get(url)
            
        if response.status == 200
            data = JSON.parse(String(response.body))
            orbitals = parsebasis(data)

            push!(molecule, orbitals)
        end
    end

    return molecule
end

function parsebasis(json)
    println(json["elements"])
    subshells = ['S', 'P', 'D', 'F', 'G', 'H', 'I']
    basis = Dict()

    for (atomnumber, atombasis) in json["elements"]
        atomnumber = parse(Int, atomnumber)
        basis[atomnumber] = []

        println(atombasis["electron_shells"])

        for shell in atombasis["electron_shells"]
            angmomentum = shell["angular_momentum"]
            for (term, momentum) in enumerate(angmomentum)
                data = []
                push!(
                    basis[atomnumber], 
                    (subshells[momentum + 1], 
                    data)
                )
                for (coefficient, exponent) in zip(shell["coefficients"][term], shell["exponents"])
                   push!(data, (exponent, coefficient))
                end
            end
        end
    end
    
    return basis
end
