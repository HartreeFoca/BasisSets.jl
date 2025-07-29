module BasisSets
    using 
        HTTP, 
        JSON3, 
        LinearAlgebra, 
        StaticArrays,
        Optim,
        QuadGK,
        ForwardDiff

    include("periodictable.jl")
    include("molecule.jl")
    include("parser.jl")
    include("getdata.jl")
    include("optimizebasis.jl")

    export 
        Atom, 
        GaussianBasisSet,
        getatom,
        Molecule,
        molecule,
        @molecule,
        getatoms,
        doublefactorial,
        normalization,
        parsebasis,
        parsebasis_fromfile,
        metadata,
        optimize_basis,
        optimize_basis_ad,
        optimizebasis,
        optimizebasis_ad

    const _METADATA = let 
        path = joinpath(@__DIR__, "data", "METADATA.json")  # __DIR__ == src/
        JSON3.read(path)
    end

    metadata() = _METADATA

end