module BasisSets
    using HTTP
    using JSON

    include("periodictable.jl")
    include("molecule.jl")

    export Atom
    export getatom
    export getatoms
    export retrievedata
end