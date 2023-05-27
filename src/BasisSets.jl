module BasisSets
    using HTTP
    using JSON

    include("periodictable.jl")
    export Atom
    export _atom

    include("molecule.jl")
    export Molecule
    export _atoms
end