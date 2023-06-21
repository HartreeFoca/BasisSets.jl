module BasisSets
    using HTTP
    using JSON

    include("periodictable.jl")
    include("molecule.jl")

    export Atom
    export getatom
    export XYZFile
    export getatoms
    export retrievedata

    coordinates = XYZFile("/Users/leticiamadureira/BasisSets.jl/test/data/water.xyz", "sto-3g")
    orbitals = retrievedata(coordinates)
    println(orbitals[1])
end