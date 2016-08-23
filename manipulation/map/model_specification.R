# Specification of the fitted models

# common value for all models
q <- .1

# ---- model-A --------------

# transition matrix
Q <- rbind( c(0, q, q, q), 
            c(q, 0, q, q),
            c(0, q, 0, q), 
            c(0, 0, 0, 0)) 
# misclassification matrix
E <- rbind( c(0, 0, 0, 0),  
            c(0, 0, 0, 0), 
            c(0, 0, 0, 0),
            c(0, 0, 0, 0) )
# transition names
qnames = c(
  "Healthy - Mild",  # q12
  "Health - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  "Severe - Mild",   # q32
  "Severe - Dead"    # q34
)
A <- list(q=q, Q=Q, E=E, qnames = qnames)


# ---- model-B --------------

# transition matrix
Q <- rbind( c(0, q, q, q), 
            c(q, 0, q, q),
            c(0, q, 0, q), 
            c(0, 0, 0, 0)) 
# misclassification matrix
E <- rbind( c(0, 0, 0, 0),  
            c(0, 0, 0, 0), 
            c(.1, 0, 0, 0),
            c(0, 0, 0, 0) )
# transition names
qnames = c(
  "Healthy - Mild",  # q12
  "Health - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  "Severe - Mild",   # q32
  "Severe - Dead"    # q34
)
B <- list(q=q, Q=Q, E=E, qnames = qnames)

# ---- model-C --------------

# transition matrix
Q <- rbind( c(0, q, q, q), 
            c(q, 0, q, q),
            c(q, q, 0, q), 
            c(0, 0, 0, 0)) 
# misclassification matrix
E <- rbind( c(0, 0, 0, 0),  
            c(0, 0, 0, 0), 
            c(0, 0, 0, 0),
            c(0, 0, 0, 0) )
# transition names
qnames = c(
  "Healthy - Mild",  # q12
  "Health - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  "Severe - Healthy",# q31
  "Severe - Mild",   # q32
  "Severe - Dead"    # q34
)
C <- list(q=q, Q=Q, E=E, qnames = qnames)

# ---- model-D --------------

# transition matrix
Q <- rbind( c(0, q, q, q), 
            c(q, 0, q, q),
            c(q, q, 0, q), 
            c(0, 0, 0, 0)) 
# misclassification matrix
E <- rbind( c(0, 0, 0, 0),  
            c(0, 0, 0, 0), 
            c(.1, 0, 0, 0),
            c(0, 0, 0, 0) )
# transition names
qnames = c(
  "Healthy - Mild",  # q12
  "Health - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  "Severe - Healthy",# q31
  "Severe - Mild",   # q32
  "Severe - Dead"    # q34
)
D <- list(q=q, Q=Q, E=E, qnames = qnames)

# ---- assemble-specification-object ------------

model_specification <- list(A=A, B=B, C=C, D=D)
