module BasisSets
    using HTTP
    using JSON3

    include("periodictable.jl")
    include("parser.jl")

    export Atom
    export getatom
    export getatoms
    export parsebasis
end