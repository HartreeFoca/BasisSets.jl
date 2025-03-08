module BasisSets
    using HTTP
    using JSON3
    using LinearAlgebra
    using StaticArrays

    include("periodictable.jl")
    include("molecule.jl")
    include("parser.jl")
    include("getdata.jl")

    export Atom
    export getatom
    export Molecule
    export molecule
    export getatoms
    export doublefactorial
    export normalization
    export parsebasis
end