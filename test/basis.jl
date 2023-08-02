@time @testset "basis.jl" begin
    sto3gBasis = parsebasis("./data/water/water.xyz", "sto-3g")
    @test sto3gBasis[1].ℓ == 0
end