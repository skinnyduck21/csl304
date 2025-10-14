(define (problem gripper-problem)
  (:domain gripper-domain)

  (:objects
    rooma roomb - room
    ball1 ball2 ball3 ball4 - ball
    left right - gripper
  )

  (:init
    ;; Robot and all balls start in rooma
    (at-robby rooma)
    (at-ball ball1 rooma)
    (at-ball ball2 rooma)
    (at-ball ball3 rooma)
    (at-ball ball4 rooma)
    
    ;; Both grippers are free
    (free left)
    (free right)
  )

  (:goal
    (and
      (at-ball ball1 roomb)
      (at-ball ball2 roomb)
      (at-ball ball3 roomb)
      (at-ball ball4 roomb)
    )
  )
)
