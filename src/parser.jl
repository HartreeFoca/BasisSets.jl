abstract type AbstractBasisSet end

abstract type AbstractMolecule end
struct CartesianCoordinates
    file
    basis
end

struct Molecule <: AbstractMolecule
    atoms::Vector{Atom}
    coords::Matrix{Float64}
end

struct GaussianBasisSet <: AbstractBasisSet
    R::Vector{Float64}
    α::Vector{Float64}
    d::Vector{Float64}
    ℓ::Int64
    m::Int64
    n::Int64
end

function _angularmomentum(ℓ::T) where T <: Integer
    orbitals = Dict(
        0 => [(0,0,0)],
        1 => [(1,0,0),(0,1,0),(0,0,1)],
        2 => [(2,0,0),(1,1,0),(1,0,1),(0,2,0),(0,1,1),(0,0,2)],
        3 => [(3,0,0),(2,1,0),(2,0,1),(1,2,0),(1,1,1),(1,0,2),
            (0,3,0),(0,2,1),(0,1,2), (0,0,3)],
        4 => [(4,0,0),(3,1,0),(3,0,1),(2,2,0),(2,1,1),(2,0,2),
            (1,3,0),(1,2,1),(1,1,2),(1,0,3),(0,4,0),(0,3,1),
            (0,2,2),(0,1,3),(0,0,4)],
        5 => [(5,0,0),(4,1,0),(4,0,1),(3,2,0),(3,1,1),(3,0,2),
            (2,3,0),(2,2,1),(2,1,2),(2,0,3),(1,4,0),(1,3,1),
            (1,2,2),(1,1,3),(1,0,4),(0,5,0),(0,4,1),(0,3,2),
            (0,2,3),(0,1,4),(0,0,5)],
        6 => [(6,0,0),(5,1,0),(5,0,1),(4,2,0),(4,1,1),(4,0,2),
            (3,3,0),(3,2,1),(3,1,2),(3,0,3),(2,4,0),(2,3,1),
            (2,2,2),(2,1,3),(2,0,4),(1,5,0),(1,4,1),(1,3,2),
            (1,2,3),(1,1,4),(1,0,5),(0,6,0),(0,5,1),(0,4,2),
            (0,3,3),(0,2,4),(0,1,5),(0,0,6)],
        7 => [(7,0,0),(6,1,0),(6,0,1),(5,2,0),(5,1,1),(5,0,2),
            (4,3,0),(4,2,1),(4,1,2),(4,0,3),(3,4,0),(3,3,1),
            (3,2,2),(3,1,3),(3,0,4),(2,5,0),(2,4,1),(2,3,2),
            (2,2,3),(2,1,4),(2,0,5),(1,6,0),(1,5,1),(1,4,2),
            (1,3,3),(1,2,4),(1,1,5),(1,0,6),(0,7,0),(0,6,1),
            (0,5,2),(0,4,3),(0,3,4),(0,2,5),(0,1,6),(0,0,7)]
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
            println(atom[2])
            push!(atoms, getatom(atom[:, 1]))
        end
    end

    return atoms
end

function _getbasis(atoms, basis)
    atomicnumbers = [atom.number for atom in atoms]
    elements = join(atomicnumbers, ",")

    url = "https://www.basissetexchange.org/api/basis/" * basis * "/format/json/?version=1&elements=" * "$(elements)"
    response = HTTP.request("GET", url)

    data = String(response.body)
    data = JSON3.read(data)

    return data
end

"""
The ```parsebasis``` method takes an XYZ file and returns a list of ```GaussianBasisSet``` objects. 
The XYZ file is a simple text file that contains the number of atoms in the first line, 
followed by the atomic symbols and the Cartesian coordinates of each atom. 
For example, the following is the XYZ file for a water molecule:

```julia
3

O 0.000000 -0.007156 0.965491
H 0.000000 0.001486 -0.003471
H 0.000000 0.931026 1.207929
```

We give the file as an input:

```julia
621g = parsebasis("../test/data/water/water.xyz", "6-21g")
```

And you will get:
```julia
Main.BasisSets.GaussianBasisSet[
    Main.BasisSets.GaussianBasisSet(
        [5472.27 817.806 186.446 53.023 17.18 5.91196], 
        [0.00183216881 0.01410469084 0.06862615542 0.229375851 0.466398697 0.3641727634], 
        0, 0, 0
    ), 
    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [-0.4044535832 1.221561761], 0, 0, 0), 
    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [0.244586107 0.8539553735], 1, 0, 0), 
    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [0.244586107 0.8539553735], 0, 1, 0), 
    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [0.244586107 0.8539553735], 0, 0, 1), 
    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 0, 0, 0), 
    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 1, 0, 0), 
    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 0, 1, 0), 
    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 0, 0, 1), 
    Main.BasisSets.GaussianBasisSet([5.447178 0.82454724], [0.1562849787 0.9046908767], 0, 0, 0), 
    Main.BasisSets.GaussianBasisSet([0.18319158;;], [1.0;;], 0, 0, 0), 
    Main.BasisSets.GaussianBasisSet([5.447178 0.82454724], [0.1562849787 0.9046908767], 0, 0, 0), 
    Main.BasisSets.GaussianBasisSet([0.18319158;;], [1.0;;], 0, 0, 0)
]
```
"""
function parsebasis(file, basisset)
    atoms = getatoms(file)
    data = _getbasis(atoms, basisset)

    basis = GaussianBasisSet[]

    for atom in atoms
        for shell in data["elements"]["$(atom.number)"]["electron_shells"]
            for (index, ℓ) in enumerate(shell["angular_momentum"])
                for momentum in _angularmomentum(ℓ)
                    push!(basis,
                        GaussianBasisSet(
                            hcat(parse.(Float64, shell["exponents"])...),
                            hcat(parse.(Float64, shell["coefficients"][index])...),
                            momentum[1],
                            momentum[2],
                            momentum[3]
                        )
                    )
                end
            end
        end
    end

    return basis
end