@time @testset "basis.jl" begin
    mol = molecule("./data/water/water.xyz")
    sto3gBasis = parsebasis(mol, "sto-3g")
    
    @test sto3gBasis[1].ℓ == 0
end