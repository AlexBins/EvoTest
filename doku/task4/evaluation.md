# Manuelle Auswahl
		--- Ausgewählte Testfälle ---
		xpos, ypos, angle, length, depth, fitness = 5.000000,	0.000000,	0.000000,	2.500000,	1.000000,	0.000000
		xpos, ypos, angle, length, depth, fitness = -5.000000,	0.000000,	0.000000,	2.500000,	1.000000,	0.000000
		xpos, ypos, angle, length, depth, fitness = 2.000000,	0.000000,	-1.570796,	2.500000,	1.000000,	0.000000
		xpos, ypos, angle, length, depth, fitness = 4.000000,	0.000000,	0.000000,	2.500000,	1.000000,	0.039828
		xpos, ypos, angle, length, depth, fitness = -4.000000,	0.000000,	0.000000,	2.500000,	1.000000,	0.039828
		xpos, ypos, angle, length, depth, fitness = 0.000000,	4.000000,	0.000000,	2.500000,	1.000000,	0.020079
		xpos, ypos, angle, length, depth, fitness = 0.000000,	0.000000,	0.000000,	5.000000,	2.000000,	0.006673
		xpos, ypos, angle, length, depth, fitness = 2.500000,	0.000000,	3.141593,	5.000000,	1.000000,	0.000000
		xpos, ypos, angle, length, depth, fitness = -2.500000,	0.000000,	3.141593,	5.000000,	1.000000,	0.008106

		--- Evaluierung über alle TCs ---
		X-Position  (mean, std): 0.222222	3.500992
		Y-Position  (mean, std): 0.444444	1.333333
		Orientation (mean, std): 0.523599	1.570796
		Slot-Length (mean, std): 3.333333	1.250000
		Slot-Depth  (mean, std): 1.111111	0.333333
		Fitness     (mean, std): 0.012724	0.016692

# Initialbelegungen
## 20 Chromosome
		X-Position  (mean, std): 0.149863	4.776595
		Y-Position  (mean, std): 1.981836	1.603240
		Orientation (mean, std): 3.710814	1.766984
		Slot-Length (mean, std): 3.541091	0.954493
		Slot-Depth  (mean, std): 1.524017	0.337020
## 100 Chromosomen
		X-Position  (mean, std): 0.606088	4.370631
		Y-Position  (mean, std): 1.356262	1.404913
		Orientation (mean, std): 3.277912	1.841481
		Slot-Length (mean, std): 3.578740	0.748358
		Slot-Depth  (mean, std): 1.524872	0.284375

# Evolution
Es werden folgende Manipulationen angenommen:
- 10% der Population werden neu erzeugt
- Bit-Flip Wahrscheinlichkeit beträgt 0.1
- Rekombination ist zufällig
- Fitness ist abhängig von Minimaldistanz, Parkplatzgröße und dem Anfangsabstand
- Die Selection erfolgt gewichtet anhand der Fitnes

## 20 Chromosome
		--- 50 Epochen ---
		X-Position  (mean, std): -1.397059	3.868202
		Y-Position  (mean, std): 1.329412	1.236982
		Orientation (mean, std): 3.036873	2.229607
		Slot-Length (mean, std): 2.377255	0.098629
		Slot-Depth  (mean, std): 1.134314	0.124914
		
		--- 500 Epochen ---
		X-Position  (mean, std): -0.976471	1.458951
		Y-Position  (mean, std): -0.668627	0.334993
		Orientation (mean, std): 5.247076	0.939060
		Slot-Length (mean, std): 2.316324	0.070785
		Slot-Depth  (mean, std): 1.108824	0.139015
## 100 Chromosome
		--- 50 Epochen ---
		X-Position  (mean, std): 0.515882	2.301561
		Y-Position  (mean, std): 0.888431	0.934355
		Orientation (mean, std): 2.456849	2.272890
		Slot-Length (mean, std): 2.402382	0.164123
		Slot-Depth  (mean, std): 1.158000	0.125341
		
		--- 500 Epochen ---
		X-Position  (mean, std): 0.352941	2.883735
		Y-Position  (mean, std): -0.538824	0.420933
		Orientation (mean, std): 3.691803	2.331866
		Slot-Length (mean, std): 2.308667	0.092787
		Slot-Depth  (mean, std): 1.116588	0.148013
