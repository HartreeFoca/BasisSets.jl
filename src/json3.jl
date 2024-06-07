using StructTypes
using JSON3
using JSON 

json_string = """{"a":"abc","aaaaaaaaaaaaaa":{"a":"abc","aaaaaaaaaaaaaa":"abc"},"c":"abc"}"""

struct MyType
    a::Int
    b::String
    c::String
end

StructTypes.StructType(::Type{MyType}) = StructTypes.Struct()

hello_world = JSON.parse(json_string)

println(hello_world)

