# INSIEMI #

set POSTI;
set DISTANZE within (POSTI cross POSTI);

# PARAMETRI #

param dmin;
param d{DISTANZE};

# VARIABILI #

var x{POSTI} binary;

# VINCOLI #

subject to distanza_minima{(i,j) in DISTANZE : d[i,j] < dmin} : x[i] + x[j] <= 1;

# OBIETTIVO #

maximize posti_occupati: sum{i in POSTI} x[i];