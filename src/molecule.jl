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

#function parsebasis(json)
#
#    basis = Dict()
#    for (atomnumber, atombasis) in json["elements"]
#        atomnumber = parse(Int, atomnumber)
#        basis[atomnumber] = []
#
#        for shell in atombasis["electron_shells"]
#            angmomentum = shell["angular_momentum"]
#            println(angmomentum)
#            primitives = [(parse(Float64, exp), parse(Float64, coef)) 
#                          for (exp, coef) in zip(shell["exponents"], shell["coefficients"][1])]
#
#            if length(shell["coefficients"]) == 2
#                secprimitives = [(parse(Float64, exp), parse(Float64, coef)) 
#                               for (exp, coef) in zip(shell["exponents"], shell["coefficients"][2])]
#                push!(basis[atomnumber], ('P', secprimitives))
#            end
#
#            for ang in angmomentum
#                if ang == 0
#                    anglabel = 'S'
#                elseif ang == 1
#                    anglabel = 'P'
#                elseif ang == 2
#                    anglabel = 'D'
#                elseif ang == 3
#                    anglabel = 'F'
#                elseif ang == 4
#                    anglabel = 'G'
#                end
#                push!(basis[atomnumber], (anglabel, primitives))
#            end
#        end
#    end
#    
#    return basis
#end

function parsebasis(basis_json)
    basis = Dict()

    for (atom_number, atom_basis) in basis_json["elements"]
        atom_number = parse(Int, atom_number)
        basis[atom_number] = []

        for shell in atom_basis["electron_shells"]
            ang_momentum = shell["angular_momentum"]
            println(ang_momentum)

            primitives = [(parse(Float64, exp), parse(Float64, coef)) 
                          for (exp, coef) in zip(shell["exponents"], shell["coefficients"][1])]

            if length(shell["coefficients"]) == 2
                primitives2 = [(parse(Float64, exp), parse(Float64, coef)) 
                               for (exp, coef) in zip(shell["exponents"], shell["coefficients"][2])]
                if 1 in ang_momentum
                    push!(basis[atom_number], ('P', primitives2))
                end
            end
            if 0 in ang_momentum
                push!(basis[atom_number], ('S', primitives))

            elseif 1 in ang_momentum
                push!(basis[atom_number], ('P', primitives))

            elseif 2 in ang_momentum
                push!(basis[atom_number], ('D', primitives))

            elseif 3 in ang_momentum
                push!(basis[atom_number], ('F', primitives))

            elseif 4 in ang_momentum
                push!(basis[atom_number], ('G', primitives))

            end

        end
    end
    return basis
end
