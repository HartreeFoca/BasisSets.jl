using JSON3
using JSON
using DataFrames
using CSV

dat = [
"ahlrichs", 
"ahlrichs_dhf", 
"ahlrichs_fit", 
"ahlrichs_x2c", 
"ano", 
"ano_claudino", 
"aug_mcc", 
"binning", 
"blaudeau", 
"ccj", 
"cologne", 
"crenb", 
"demon2k", 
"dfo", 
"dgauss", 
"dunning", 
"dunning_dk", 
"dunning_dk3", 
"dunning_f12", 
"dunning_f12_fit", 
"dunning_fit", 
"dunning_hay", 
"dunning_pp", 
"dunning_pp_fit", 
"dunning_sf", 
"dunning_x2c", 
"huzinaga", 
"iglo", 
"jensen", 
"jgauss", 
"jorge", 
"koga", 
"lanl", 
"lehtola_emd", 
"lehtola_hgbs", 
"lehtola_sap", 
"nasa", 
"orp", 
"partridge", 
"paschoal", 
"pb", 
"pec", 
"pob", 
"pople", 
"pople_mod", 
"ranasinghe", 
"sadlej", 
"sapporo", 
"sarc", 
"sauer_j", 
"sbkjc", 
"sigmaNZ", 
"sto", 
"stuttgart", 
"truhlar", 
"ugbs", 
"wachters", 
"zorrilla"
]

global PATH = "data/"

function getmetadata(family)

    csvfile = PATH * family * ".csv"
    df = CSV.read(csvfile, DataFrame)

    return df 
end

function getbasisavailable()
    return dat
end

function getbasisfromfamily(family)

    metadata = getmetadata(family)
    basis = metadata[!, 1]

    return basis
end

function getfilefrombasis(family, bs)

    metadata = getmetadata(family)
    basis = metadata[!, 1]
    files = metadata[!, 2]

    posfile = findall(basis .== bs)
    file = files[posfile[1]]

    return PATH * file
end

function getbasis(family, bs)

    file = getfilefrombasis(family, bs)
    rd = JSON3.read(file)

    return rd
end

function getelements(family, bs)

    rd = getbasis(family, bs)
    elements = rd["elements"]

    return elements
end

function getelementfile(family, bs, element)

    rd = getbasis(family, bs)
    elsection = rd["elements"][element]

    components = values(elsection["components"])

    return components
end

file = getfilefrombasis("ahlrichs", "def2-SVPD")
println(file)

rd = JSON3.read(file)
println(rd)

println(getbasisfromfamily(dat[1]))

println(getelements("ahlrichs", "def2-SV(P)"))

#println(getelementfile("ahlrichs", "def2-SVP", 11))