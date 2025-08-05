abstract type AbstractBasisSet end

abstract type AbstractShell end

struct Primitive{T<:Real}
    α :: T         
    d :: T         
end

struct Shell{T<:Real} <: AbstractShell
    R      :: SVector{3,T}
    ℓ      :: Int           
    prims  :: Vector{Primitive{T}}
end

struct ContractedGaussianBasis{T<:Real} <: AbstractBasisSet
    shells :: Vector{Shell{T}}
end

struct PseudoPotentialBasis <: AbstractBasisSet
    shells::Vector{Shell{Float64}}
    potentials::Vector{PseudoPotential}
end

struct EvenTemperedShell{T<:Real} <: AbstractShell
    R   :: SVector{3,T}
    ℓ   :: Int
    β   :: T
    γ   :: T
    k   :: Int
    d   :: Vector{T}    
end

function expand(s::EvenTemperedShell{T}) where T
    α = [s.β * s.γ^(i-1) for i in 1:s.k]
    prims = [Primitive{T}(αᵢ, s.d[i]) for (i, αᵢ) in pairs(α)]
    return Shell{T}(s.R, s.ℓ, prims)
end

struct STOnGShell{T<:Real} <: AbstractShell
    R     :: SVector{3,T}
    ℓ     :: Int
    n     :: Int                  # STO-3G, STO-6G …
    αtab  :: Vector{T}
    dtab  :: Vector{T}
end

expand(s::STOnGShell{T}) where T =
    Shell{T}(s.R, s.ℓ, [Primitive{T}(α,d) for (α,d) in zip(s.αtab,s.dtab)])


H_ET_basis = ContractedGaussianBasis(expand.(shells))  # primitives materialised