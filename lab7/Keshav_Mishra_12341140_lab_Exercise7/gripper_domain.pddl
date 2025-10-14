(define (domain gripper-domain)
  (:requirements :strips :typing)
  
  (:types
    room ball gripper
  )

  (:predicates
    (at-robby ?r - room)
    (at-ball ?b - ball ?r - room)
    (free ?g - gripper)
    (carry ?g - gripper ?b - ball)
  )

  ;; Action 1: Move(x, y)
  (:action move
    :parameters (?from - room ?to - room)
    :precondition (and
      (at-robby ?from)
    )
    :effect (and
      (not (at-robby ?from))
      (at-robby ?to)
    )
  )

  ;; Action 2: Pick-up(x, y, z)
  (:action pick-up
    :parameters (?b - ball ?r - room ?g - gripper)
    :precondition (and
      (at-robby ?r)
      (at-ball ?b ?r)
      (free ?g)
    )
    :effect (and
      (carry ?g ?b)
      (not (at-ball ?b ?r))
      (not (free ?g))
    )
  )

  ;; Action 3: Drop(x, y, z)
  (:action drop
    :parameters (?b - ball ?r - room ?g - gripper)
    :precondition (and
      (at-robby ?r)
      (carry ?g ?b)
    )
    :effect (and
      (at-ball ?b ?r)
      (free ?g)
      (not (carry ?g ?b))
    )
  )
)
