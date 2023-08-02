@time @testset "basis.jl" begin
    sto3gBasis = parsebasis("./data/water/water.xyz", "sto-3g")
    @test sto3gBasis[1].exponents = round.([130.7093214 23.80886605 6.443608313], digits=4)
end