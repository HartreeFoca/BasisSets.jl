module BasisSets
    using HTTP

    include("periodictable.jl")
    include("parser.jl")

    export Atom
    export getatom
    export CartesianCoordinates
    export getatoms
    export retrievedata

    coordinates = CartesianCoordinates("/Users/leticiamadureira/BasisSets.jl/test/data/water/water.xyz", "sto-3g")
    orbitals = retrievedata(coordinates)
end