####################################################
###   Global parameters for glacier simulations  ###
####################################################

### Physics  ###
# Ice diffusivity factor
#A = 2e-16   # varying factor (0.125 - 10)

# A ranging from 0.125 to 5
#A = 0.5e-24 #2e-16  1 / Pa^3 s
#A = 5e-24 #2e-16  1 / Pa^3 s
A = 1.3e-24 #2e-16  1 / Pa^3 s
A *= 60 * 60 * 24 * 365.25 # [1 / Pa^3 yr]

@everywhere begin

# 
const ρ = 900                     # Ice density [kg / m^3]
const g = 9.81                    # Gravitational acceleration [m / s^2]
const n = 3                       # Glen's flow law exponent

const α = 0                       # Weertman-type basal sliding (Weertman, 1964, 1972). 1 -> sliding / 0 -> no sliding
const C = 15e-14                  # Sliding factor, between (0 - 25) [m⁸ N⁻³ a⁻¹]

const Γ = (n-1) * (ρ * g)^n / (n+2) # 1 / m^3 s

### Differential equations ###
# Configuration of the forward model

# Model            # small number
const Δx = 50                    # [m]
const Δy = 50
const cfl  = max(Δx^2,Δy^2)/4.1
const maxA = 8e-16
const minA = 3e-17
const maxT = 1
const minT = -25

# Time               # initial time
const t₁ = 5    

### Workflow ###
ensemble = EnsembleDistributed() # Multiprocessing
# ensemble = EnsembleSplitThreads()
# ensemble = EnsembleThreads()  # Multithreading
# ensemble = EnsembleSerial()# number of simulation years 

end # @everywhere

## Climate parameters
const base_url = ("https://cluster.klima.uni-bremen.de/~oggm/gdirs/oggm_v1.4/L1-L2_files/elev_bands") # OGGM elevation bands
const mb_type = "mb_real_daily"
const grad_type = "var_an_cycle" # could use here as well 'cte'
# fs = "_daily_".*climate
const fs = "_daily_W5E5"

## UDE training
const epochs = 50
const η = 0.01

create_ref_dataset = false   
train_UDE = true