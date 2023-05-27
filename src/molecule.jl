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
    println(basis)
    atoms = getatoms(coordinates.file)

    for atom in atoms
        println(atom.number)
        url = api * basis * "/format/json/?version=1&elements=" * string(atom.number)
        print(url)
        response = HTTP.get(url)
            
        if response.status == 200
            data = JSON.parse(String(response.body))
            print(data)
            return data
        end
    end
end