using StructTypes
using JSON3

json_string = """{"a": 1, "b": "hello, world", "c": "hello"}"""

struct MyType
    a::Int
    b::String
    c::String
end

StructTypes.StructType(::Type{MyType}) = StructTypes.Struct()

hello_world = JSON3.read(json_string, MyType)

println(hello_world)

JSON3.write(hello_world)

