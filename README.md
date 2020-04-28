# BioSimulatorPetriNets

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://alanderos91.github.io/BioSimulatorPetriNets.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://alanderos91.github.io/BioSimulatorPetriNets.jl/dev)
[![Build Status](https://travis-ci.com/alanderos91/BioSimulatorPetriNets.jl.svg?branch=master)](https://travis-ci.com/alanderos91/BioSimulatorPetriNets.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/alanderos91/BioSimulatorPetriNets.jl?svg=true)](https://ci.appveyor.com/project/alanderos91/BioSimulatorPetriNets-jl)
[![Codecov](https://codecov.io/gh/alanderos91/BioSimulatorPetriNets.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/alanderos91/BioSimulatorPetriNets.jl)
[![Coveralls](https://coveralls.io/repos/github/alanderos91/BioSimulatorPetriNets.jl/badge.svg?branch=master)](https://coveralls.io/github/alanderos91/BioSimulatorPetriNets.jl?branch=master)

**TODO**: Setup CI, docs (badges above do not work yet)

### Installation

```julia
using Pkg
Pkg.add("https://github.com/alanderos91/BioSimulatorPetriNets.jl.git")
```

### Example

```julia
using BioSimulator, BioSimulatorPetriNets

# example model
m = Network("birth-death process")
m <= Species("X", 5)
m <= Reaction("birth", 1.1, "X --> X + X")
m <= Reaction("death", 1.0, "X --> 0")

# construct Petri net directly
p = construct_petri_net(m)

# generate Tikz output thru TikzGraphs.jl (renders in Juno in plot pane)
visualize_petri_net(p, options = "scale = 2") # 1. using BioSimPetrinet object
visualize_petri_net(m, options = "scale = 2") # 2. using Network object directly

# use TikzGraphs.jl to specify layout algorithm
using TikzGraphs
visualize_petri_net(p, layout = Layouts.Layered(), options = "scale = 2")
```
