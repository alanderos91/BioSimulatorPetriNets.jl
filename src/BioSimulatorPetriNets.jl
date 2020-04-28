module BioSimulatorPetriNets

using LightGraphs, TikzGraphs, BioSimulator

struct BioSimPetriNet
    g::SimpleDiGraph{Int}
    # node metadata
    species_nodes::Vector{Int}
    reaction_nodes::Vector{Int}
    node_labels::Vector{String}
    species_styles::Dict{Int,String}
    reaction_styles::Dict{Int,String}
    # edge metadata
    edge_labels::Dict{Tuple{Int,Int},String}
    edge_styles::Dict{Tuple{Int,Int},String}
end

# style for species nodes
const SPC_STYLE = "draw, rounded corners, fill=blue!10, font=\\large"

# style for reaction nodes
const RXN_STYLE = "draw, rounded corners, thick, fill=red!10, font=\\large"

# style for species ---> reaction edges
const SPCRXN_STYLE = "-stealth, draw, rounded corners=5pt, line width=0.5mm, solid, xshift=-2"

# style for reaction ---> species edges
const RXNSPC_STYLE = "-stealth, draw, rounded corners=5pt, line width=0.5mm, dashed, xshift=2, red, swap"

function construct_petri_net(model::Network)
    # initialize directed graph
    s = number_species(model)
    r = number_reactions(model)
    g = SimpleDiGraph(s + r)

    # define mapping between index and species
    species = species_list(model)
    idx2spc = Dict(id => i for (i, id) in enumerate(keys(species)))

    # initialize fields for storing edge metadata
    reactions = reaction_list(model)
    edge_set = Tuple{Int,Int}[]                 # pairs, i ---> j
    stoc_set = Dict{Tuple{Int,Int},Int}()       # stoichiometry for (i,j)
    edge_styles = Dict{Tuple{Int,Int},String}() # display style for (i,j)

    # construct edges; reactions numbered s+1 thru s+r
    for (k, reaction) in enumerate(values(reactions))
        j = k + s # node index in directed graph
        reactants = reaction.reactants
        products  = reaction.products

        # iterate over reactants to add species ---> reaction edges
        for (reactant, v) in reactants
            i = idx2spc[reactant] # retrieve node index for reactant
            e = (i, j)            # species i ---> reaction j

            edge_styles[e] = SPCRXN_STYLE # set edge style
            v > 1 && (stoc_set[e] = v)    # display stoichiometry > 1

            push!(edge_set, e)
        end

        # iterate over products to add reaction ---> species edges
        for (product, v) in products
            i = idx2spc[product] # retrieve node index for product
            e = (j, i)          # reaction j ---> species i

            edge_styles[e] = RXNSPC_STYLE # set edge style
            v > 1 && (stoc_set[e] = v)    # display stoichiometry > 1

            push!(edge_set, e)
        end
    end

    # add edges to directed graph
    for edge in edge_set
        add_edge!(g, edge[1], edge[2])
    end

    # set labels and styles for species nodes, 1:s
    species_nodes  = collect(1:s)
    species_labels = [string(v) for v in keys(species)]
    species_styles = Dict( i => SPC_STYLE for i in species_nodes )

    # set labels and styles for reaction nodes, s+1:s+r
    reaction_nodes = collect(s+1:s+r)
    reaction_labels = [string(v) for v in keys(reactions)]
    reaction_styles = Dict( i => RXN_STYLE for i in reaction_nodes)

    # put labels together
    node_labels = [species_labels; reaction_labels]
    edge_labels = Dict(e => string(v) for (e, v) in stoc_set)

    return BioSimPetriNet(
        g,
        species_nodes,
        reaction_nodes,
        node_labels,
        species_styles,
        reaction_styles,
        edge_labels,
        edge_styles
    )
end

function visualize_petri_net(x::BioSimPetriNet; layout = Layouts.Layered(), kwargs...)
    # unpack graph and metadata
    graph           = x.g
    labels          = x.node_labels
    species_styles  = x.species_styles
    reaction_styles = x.reaction_styles
    edge_labels     = x.edge_labels
    edge_styles     = x.edge_styles

    # replace underscores (_) with dots (⋅) to separate complexes
    labels = map(x -> replace(x, "_" => "\$\\cdot\$"), labels)

    # pass info to TikzGraphs
    return TikzGraphs.plot(graph, layout,
        labels,
        node_styles = merge(species_styles, reaction_styles),
        edge_labels = edge_labels,
        edge_styles = edge_styles;
        kwargs...
    )
end

function visualize_petri_net(x::Network; kwargs...)
    petri_net = construct_petri_net(x)

    return visualize_petri_net(x; kwargs...)
end

export BioSimPetriNet, construct_petri_net, visualize_petri_net

end # module
