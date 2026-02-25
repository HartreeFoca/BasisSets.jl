abstract type AbstractShell end

# FIXME move me!
struct Primitive{T<:Real}
    α :: T         
    d :: T         
end

struct Shell{T<:Real} <: AbstractShell
    R      :: SVector{3,T}
    ℓ      :: Int           
    m      :: Int
    n      :: Int
    prims  :: Vector{Primitive{T}}
end

# TODO come back to this!
function ℓ(shell::Shell{T<:Real})::Int
    return shell.ℓ
end

struct EvenTemperedShell{T<:Real} <: AbstractShell
    R   :: SVector{3,T}
    ℓ   :: Int
    m   :: Int
    n   :: Int
    β   :: SVector{3,T}
    γ   :: SVector{3,T}
    k   :: Int 
end

struct RelativisticShell{T<:Real} <: AbstractShell
    R   :: SVector{3,T}
    ℓ   :: Int
    m   :: Int
    n   :: Int
    ECP :: SVector{3,T}
end

function normalize(shell::AbstractShell)::Vector{Float64}
    # FIXME get these scalars!
    # TODO how do I get these in a Julia-esque fashion?
    return _normalize.(alphas(shell), shell.ℓ, shell.m, shell.n)
end

# in docs for AbstractShell, state that all subtypes must implement alphas

function alphas(shell::Shell{T<:Real})::Vector{Float64}
    return [prim.α for prim in shell.prims]
end

function normalize(shell::Shell{T<:Real})::Vector{Float64}
    return _normalize.(alphas(shell), shell.ℓ, shell.m, shell.n)
end

# COPY PASTA!
function normalize(shell::RelativisticShell{T<:Real})::Vector{Float64}
    alphas = [prim.α for prim in shell.prims]
    return _normalize.(alphas, shell.ℓ, shell.m, shell.n)
end

function normalize(shell::EvenTemperedShell{T<:Real})::Vector{Float64}
    alphas = shell.β * (shell.γ - shell.k)
    return _normalize.(alphas, shell.ℓ, shell.m, shell.n)
end

function _normalize(α, ℓ::Int, m::Int, n::Int)::Float64
    N = (4 * α)^(ℓ + m + n)
    N /=
        doublefactorial(2 * ℓ - 1) * doublefactorial(2 * m - 1) * doublefactorial(2 * n - 1)
    N *= ((2 * α) / π)^(3 / 2)
    N = sqrt(N)
    return N
end