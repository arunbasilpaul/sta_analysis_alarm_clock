# sta_analysis_alarm_clock
The aim of this project is to conduct an Static Timing Analysis on an earlier project 'Alarm Clock'. Strict constraints will be used to push the system to its limits, with analysis and optimisations being conducted at various levels.

# What is STA?
Static Timing Analysis (STA) is a method to verify that your digital design meets its timing requirements without running functional simulations. It checks whether all signal paths can transfer data within the required clock period, considering:
- Setup time
- Hold time
- Clock uncertainties (skew, jitter, variation)
- Data path delays (logic and routing)

# Why STA?
In FPGAs, even if simulation works perfectly, you can fail on hardware if STA is ignored:
- Data corruption due to missed setup or hold
- Unstable operation under temperature/voltage variations
- Clock domain crossing failures
