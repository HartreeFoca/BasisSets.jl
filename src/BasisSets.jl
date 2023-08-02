module BasisSets
    using HTTP

    include("periodictable.jl")
    include("parser.jl")

    export Atom
    export getatom
    export CartesianCoordinates
    export getatoms
    export parsebasis

end