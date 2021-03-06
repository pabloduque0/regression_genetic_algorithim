module Representation
    export Organism, Population
    using Random, Distributions

    # Struct that represents a single organism
    mutable struct Organism
        gauss_kernels::Array{Tuple{Float64, Float64, Float64}, 1}
        σ::Array{Float64, 1}
        α::Array{Float64, 1}
        fitness::Union{Float64, Missing}
        hit_ratio::Union{Int64, Missing}
    end
    # Struct that represents a population as a list of organisms
    mutable struct Population
        members::Array{Organism, 1}
    end

    # Generate N organisms, therefore a population
    function generate_population(population_size, n_kernels, initial_σ)
        organism_list = Organism[]
        for i in range(1, population_size)
            kernels = Tuple{Float64, Float64, Float64}[]
            for k in range(1, n_kernels)
                weight, c, γ = generate_kernel_params(initial_σ)
                push!(kernels, tuple(weight, c, γ))
            end
            σ = rand(Normal(0.0, 1.0), 1)[1]
            this_organism = Organism(kernels,
                                    repeat([σ], (n_kernels * length(kernels[1]))),
                                    repeat([0.0], (n_kernels * length(kernels[1]))),
                                    missing,
                                    missing)
            push!(organism_list, this_organism)
        end
        #c = rand(range(0.817, step=0.001, length=floor(Int, (1.0-0.817)/0.001) + 1))
        population = Population(organism_list)
        return population
    end

    # Function to generate a single kernel
    function generate_kernel_params(σ)
        normal_d = Normal(0.0, σ)
        weight = rand(normal_d, 1)[1]
        c = rand(normal_d, 1)[1]
        γ = rand(normal_d, 1)[1]
        return weight, c, γ
    end

end  # module Representation
