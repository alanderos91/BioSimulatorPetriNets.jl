using Documenter, BioSimulatorPetriNets

makedocs(;
    modules=[BioSimulatorPetriNets],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/alanderos91/BioSimulatorPetriNets.jl/blob/{commit}{path}#L{line}",
    sitename="BioSimulatorPetriNets.jl",
    authors="Alfonso Landeros",
    assets=String[],
)

deploydocs(;
    repo="github.com/alanderos91/BioSimulatorPetriNets.jl",
)
