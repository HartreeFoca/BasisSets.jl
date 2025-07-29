abstract type ChemicalEntity end

"""
```ChemicalEntity``` is an *abstract type* that englobes ```Molecule```, ```Atom```, ```AtomicOrbital``` and ```MolecularOrbital``` structures.
```Molecule``` is a *subtype* of ```ChemicalEntity``` that stores coordinates, atomic symbols and atomic numbers as objects. 
"""
struct Molecule <: ChemicalEntity
    atoms::Vector{String}
    coords::Matrix{Float64}
    numbers::Vector{Int64}
end

"""
This method takes an ```.xyz``` file (with cartesian coordinates of atoms in a molecule) and returns a ```Molecule```. The ```.xyz``` file should be formatted as follows

```julia
2 

H      -1.788131055      0.000000000     -4.028513155
H      -1.331928651      0.434077746     -3.639854078
```

In the first line, the file should contain the numer of atoms that are in the molecule. In the second line, there is a comment, which can be the *name of the compound*, 
*molecular formula*, etc. To further information about ```.xyz``` files, [*click here*](https://www.reviversoft.com/file-extensions/xyz). For example, if we take the 
example file ```h2.xyz```, it is possible to give it as an input by calling ```molecule``` method.

```julia
molecule("h2.xyz")
```

The example above works if the file is in the current directory that you are working on. In other case, you can just give the path to the file of interest.

```julia
molecule(PATH)
```
"""
function molecule(xyzfile::String)::Molecule
    elements = []
    coordinates = []
    Zvalues = []

    for line in Iterators.drop(eachline(xyzfile), 2)
        fields = split(line)

        element = fields[1]
        push!(elements, element)
        push!(Zvalues, getatom(element))

        coordinate = parse.(Float64, fields[2:4])
        push!(coordinates, coordinate)
    end

    coordinates = mapreduce(permutedims, vcat, coordinates)

    return Molecule(elements, coordinates, Zvalues)
end

"""
This method takes a string (with cartesian coordinates of atoms in a molecule) and returns a ```Molecule```. The string should be formatted as follows

```julia
BasisSets.parse_xyz("
    H  0.0  0.0  0.0
    H  0.0  0.0  1.4
")
```

Each line should contain the element symbol, x-coordinate, y-coordinate, and z-coordinate, with spaces between them.
"""
function parse_xyz(xyztext::String)::Molecule
    elements = []
    coordinates = []
    Zvalues = []
    for line in eachline(IOBuffer(xyztext))
        m = match(r"(?<symbol>[a-zA-Z]+)\s+(?<x>[+-]?\d+(?:\.\d+)?)\s+(?<y>[+-]?\d+(?:\.\d+)?)\s+(?<z>[+-]?\d+(?:\.\d+)?)[\s\t\n]*$", line)
        if startswith(line, r"^[\s\t]*#")
            @info "The line \"$line\" is a comment and will be skipped."
        elseif line=="" || isempty(line) || occursin(r"^[\s\t]*$", line)
            # skip empty lines
        elseif !isnothing(m)
            element = m[:symbol]
            coordinate = parse.(Float64, [m[:x], m[:y], m[:z]])
            Zvalue = BasisSets.getatom(element)
            push!(elements, element)
            push!(coordinates, coordinate)
            push!(Zvalues, Zvalue)
        else
            throw(ErrorException("The line \"$line\" does not match expected format."))
        end
    end
    coordinates = mapreduce(permutedims, vcat, coordinates)
    return Molecule(elements, coordinates, Zvalues)
end


"""
This macro takes a string without double quotation (with cartesian coordinates of atoms in a molecule) and returns a ```Molecule```. This interface is inspired [Fermi.jl](https://github.com/FermiQC/Fermi.jl).

```julia
@molecule {
    H  0.0  0.0  0.0
    H  0.0  0.0  1.4
}
```

This macro supports string interpolation and is useful for calculating potential energy surfaces (PES).
```julia
@molecule {
    H  0.0  0.0  0.0
    H  0.0  0.0  \$(1.0 + 0.4)
}
```
"""
macro molecule(block)
    mol = string(block)
    mol = replace(mol, "{" => "\"")
    mol = replace(mol, "}" => "\"")
    mol = replace(mol, "; " => "\n")
    mol = esc(Meta.parse(mol))
    :(parse_xyz($mol))
end