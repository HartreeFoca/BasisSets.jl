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

files = getmetadata(dat[1])

print(getfilefrombasis("ahlrichs", "AHLRICHS_TZV"))