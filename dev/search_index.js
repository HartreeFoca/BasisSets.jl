var documenterSearchIndex = {"docs":
[{"location":"input/","page":"-","title":"-","text":"parsebasis(molecule, basis)","category":"page"},{"location":"input/#BasisSets.parsebasis-Tuple{Any, Any}","page":"-","title":"BasisSets.parsebasis","text":"The parsebasis method takes an XYZ file and returns a list of GaussianBasisSet objects.  The XYZ file is a simple text file that contains the number of atoms in the first line,  followed by the atomic symbols and the Cartesian coordinates of each atom.  For example, the following is the XYZ file for a water molecule:\n\n3\n\nO 0.000000 -0.007156 0.965491\nH 0.000000 0.001486 -0.003471\nH 0.000000 0.931026 1.207929\n\nWe give the file as an input:\n\n621g = parsebasis(\"../test/data/water/water.xyz\", \"6-21g\")\n\nAnd you will get:\n\nMain.BasisSets.GaussianBasisSet[\n    Main.BasisSets.GaussianBasisSet(\n        [5472.27 817.806 186.446 53.023 17.18 5.91196], \n        [0.00183216881 0.01410469084 0.06862615542 0.229375851 0.466398697 0.3641727634], \n        0, 0, 0\n    ), \n    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [-0.4044535832 1.221561761], 0, 0, 0), \n    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [0.244586107 0.8539553735], 1, 0, 0), \n    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [0.244586107 0.8539553735], 0, 1, 0), \n    Main.BasisSets.GaussianBasisSet([7.40294 1.5762], [0.244586107 0.8539553735], 0, 0, 1), \n    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 0, 0, 0), \n    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 1, 0, 0), \n    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 0, 1, 0), \n    Main.BasisSets.GaussianBasisSet([0.373684;;], [1.0;;], 0, 0, 1), \n    Main.BasisSets.GaussianBasisSet([5.447178 0.82454724], [0.1562849787 0.9046908767], 0, 0, 0), \n    Main.BasisSets.GaussianBasisSet([0.18319158;;], [1.0;;], 0, 0, 0), \n    Main.BasisSets.GaussianBasisSet([5.447178 0.82454724], [0.1562849787 0.9046908767], 0, 0, 0), \n    Main.BasisSets.GaussianBasisSet([0.18319158;;], [1.0;;], 0, 0, 0)\n]\n\n\n\n\n\n","category":"method"},{"location":"input/","page":"-","title":"-","text":"molecule","category":"page"},{"location":"input/#BasisSets.molecule","page":"-","title":"BasisSets.molecule","text":"This method takes an .xyz file (with cartesian coordinates of atoms in a molecule) and returns a Molecule. The .xyz file should be formatted as follows\n\n2 \n\nH      -1.788131055      0.000000000     -4.028513155\nH      -1.331928651      0.434077746     -3.639854078\n\nIn the first line, the file should contain the numer of atoms that are in the molecule. In the second line, there is a comment, which can be the name of the compound,  molecular formula, etc. To further information about .xyz files, click here. For example, if we take the  example file h2.xyz, it is possible to give it as an input by calling molecule method.\n\nmolecule(\"h2.xyz\")\n\nThe example above works if the file is in the current directory that you are working on. In other case, you can just give the path to the file of interest.\n\nmolecule(PATH)\n\n\n\n\n\n","category":"function"},{"location":"input/","page":"-","title":"-","text":"getatoms","category":"page"},{"location":"input/#BasisSets.getatoms","page":"-","title":"BasisSets.getatoms","text":"This function takes a Molecule type and convert into a list of Atom type.\n\n\n\n\n\n","category":"function"},{"location":"input/","page":"-","title":"-","text":"Molecule","category":"page"},{"location":"input/#BasisSets.Molecule","page":"-","title":"BasisSets.Molecule","text":"ChemicalEntity is an abstract type that englobes Molecule, Atom, AtomicOrbital and MolecularOrbital structures. Molecule is a subtype of ChemicalEntity that stores coordinates, atomic symbols and atomic numbers as objects. \n\n\n\n\n\n","category":"type"},{"location":"#BasisSets.jl","page":"Introduction to BasisSets","title":"BasisSets.jl","text":"","category":"section"},{"location":"","page":"Introduction to BasisSets","title":"Introduction to BasisSets","text":"(Image: CI)","category":"page"},{"location":"","page":"Introduction to BasisSets","title":"Introduction to BasisSets","text":"This is a parser developed to parse and wrap Basis Sets from Basis Set Exchange","category":"page"}]
}