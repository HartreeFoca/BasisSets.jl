@time @testset "molecule.jl" begin

    benchmark = Molecule(["H", "H"], [0.0 0.0 0.0; 0.0 0.0 0.74], [1, 1])

    println("test `molecule()`")
    mol1 = molecule("./data/hydrogen/h-atom.xyz")
    @test mol1 isa Molecule
    @test mol1.atoms == benchmark.atoms
    @test mol1.coords == benchmark.coords
    @test mol1.numbers == benchmark.numbers

    println("test `@molecule {}`")
    mol2 = @molecule {
            H  0.0  0.0  0.0
            H  0.0  0.0  0.74
        }
    @test mol2 isa Molecule
    @test mol2.atoms == benchmark.atoms
    @test mol2.coords == benchmark.coords
    @test mol2.numbers == benchmark.numbers

    println("test `BasisSets.parse_xyz()`")
    mol3 = BasisSets.parse_xyz("
            H  0.0  0.0  0.0
            H  0.0  0.0  0.74
        ")
    @test mol3 isa Molecule
    @test mol3.atoms == benchmark.atoms
    @test mol3.coords == benchmark.coords
    @test mol3.numbers == benchmark.numbers

end