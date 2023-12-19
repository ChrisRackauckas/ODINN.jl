
export NN

include("ML_utils.jl")

# Abstract type as a parent type for Machine Learning models
abstract type MLmodel <: AbstractModel end

"""
function Model(;
    iceflow::Union{IFM, Nothing},
    mass_balance::Union{MBM, Nothing}
    machine_learning::Union{MLM, Nothing},
    ) where {IFM <: IceflowModel, MBM <: MBmodel, MLM <: MLmodel}
    
Initialize Model at ODINN level (iceflow + mass balance + machine learning).

"""
function Model(;
    iceflow::Union{IFM, Nothing},
    mass_balance::Union{MBM, Nothing},
    machine_learning::Union{MLM, Nothing},
    ) where {IFM <: IceflowModel, MBM <: MBmodel, MLM <: MLmodel}

    model = Sleipnir.Model(iceflow, mass_balance, machine_learning)

    return model
end

struct NN{F <: AbstractFloat} <: MLmodel 
    architecture::Flux.Chain
    θ::Vector{F}
end

"""
    NN(params::Parameters;
        architecture::Union{Flux.Chain, Nothing} = nothing,
        θ::Union{Vector{AbstractFloat}, Nothing} = nothing)
        
        Feed-forward neural network.

Keyword arguments
=================
    - `architecture`: `Flux.Chain` neural network architecture
    - `θ`: Neural network parameters
"""
function NN(params::Sleipnir.Parameters;
            architecture::Union{Flux.Chain, Nothing} = nothing,
            θ::Union{Vector{F}, Nothing} = nothing) where {F <: AbstractFloat}

    if isnothing(architecture)
        architecture, θ = get_NN(θ)
    end

    # Build the simulation parameters based on input values
    ft = params.simulation.float_type
    neural_net = NN{ft}(architecture, θ)

    return neural_net
end
