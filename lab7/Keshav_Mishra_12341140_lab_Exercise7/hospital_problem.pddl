(define (problem hospital-emergency-problem)
  (:domain hospital-emergency)

  (:objects
    a1 a2 - ambulance
    p1 p2 p3 - patient
    loc1 loc2 loc3 - location
    h1 h2 - hospital
  )

  (:init
    ;; Ambulances
    (at a1 h1)
    (at a2 h2)
    (empty a1)
    (empty a2)

    ;; Patients
    (patient-at p1 loc1)
    (patient-at p2 loc2)
    (patient-at p3 loc3)

    ;; Connections (sample configuration)
    (connected h1 loc1)
    (connected loc1 loc2)
    (connected loc2 loc3)
    (connected loc3 h2)
    
    ;; Blocked routes
    (blocked loc2 loc3)
  )

  (:goal
    (and
      (patient-at p1 h1)
      (patient-at p2 h2)
      (patient-at p3 h1)
    )
  )
)
