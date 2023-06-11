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

    #coordinates = XYZFile("/Users/leticiamadureira/BasisSets.jl/src/water.xyz", "d-aug-cc-pv6z")
    #orbitals = retrievedata(coordinates)
end