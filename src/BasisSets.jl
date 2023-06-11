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

    coordinates = XYZFile("/Users/leticiamadureira/BasisSets.jl/src/water.xyz", "d-aug-cc-pv5z")
    orbitals = retrievedata(coordinates)
    println(orbitals)
end

#https://www.basissetexchange.org/api/basis//format/json/?version=0&elements=8
#https://www.basissetexchange.org/api/basis/d-aug-cc-pv5z/format/json/?version=1&elements=8