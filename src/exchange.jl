using HTTP
using JSON

url = "https://www.basissetexchange.org/api/basis/crenbl/format/json/?version=0&elements=103"
#base_url = "https://www.basissetexchange.org/api/basis/"
#basis_set = "CRENBL"
#atom = "Lr"
#url = base_url * basis_set * "/format/json?elements=" * atom
response = HTTP.get(url)
print(response)

api = "https://www.basissetexchange.org/api/"

function parsebasisset(data::Dict{String, Any}, number_to_symbol::Dict{Int, String})
    # Extract the elements data
    elements = data["elements"]

    # Initialize empty dictionaries to store exponents and coefficients
    exponents = Dict{String, Vector{Vector{Float64}}}()
    coefficients = Dict{String, Vector{Vector{Float64}}}()

    # Iterate over all elements
    for (element_number, element_data) in elements
        # Convert element_number to integer and then to its symbol as string
        element_symbol = number_to_symbol[parse(Int, element_number)]

        # Initialize arrays to store this element's exponents and coefficients
        element_exponents = Vector{Float64}[]
        element_coefficients = Vector{Float64}[]

        # Iterate over all electron shells
        for shell in element_data["electron_shells"]
            # Convert exponents and coefficients to Float64 and store them
            push!(element_exponents, parse.(Float64, shell["exponents"]))
            push!(element_coefficients, parse.(Float64, shell["coefficients"][1]))
        end

        # Store this element's exponents and coefficients in the dictionaries
        exponents[element_symbol] = element_exponents
        coefficients[element_symbol] = element_coefficients
    end
    
    return exponents, coefficients
end

# Now, you can call the function like this:
exponents, coefficients = parsebasisset(data, number_to_symbol)

print(exponents)

function _retrievedata(url::String)
    try
        response = HTTP.get(url)
        
        # Check the response status code
        if response.status == 200
            data = JSON.parse(String(response.body))
            return data
        else
            error("Error: Response status code ${response.status}")
        end
    catch e
        error("Error occurred while retrieving basis set data: $e")
    end
end

_retrievedata(url)