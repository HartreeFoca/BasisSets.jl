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

    for atom in atoms
        url = api * basis * "/format/json/?version=1&elements=" * string(atom.number)
        response = HTTP.get(url)
            
        if response.status == 200
            data = JSON.parse(String(response.body))
            elements = data["elements"]
            print(elements[string(atom.number)]["electron_shells"])
            return data
        end
    end
end

# Assuming the dictionary is stored in the variable `data`
# elements = data["elements"]
# oxygen_data = elements["8"]
# electron_shells = oxygen_data["electron_shells"]
# 
# for shell in electron_shells
#     angular_momentum = shell["angular_momentum"]
#     exponents = shell["exponents"]
#     
#     println("Angular momentum: ", angular_momentum)
#     println("Exponents: ", exponents)
# end