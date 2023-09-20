module BasisSets
    using HTTP
    using JSON3

    include("periodictable.jl")
    include("molecule.jl")
    include("parser.jl")

    export Atom
    export getatom
    export Molecule
    export molecule
    export getatoms
    export parsebasis
end