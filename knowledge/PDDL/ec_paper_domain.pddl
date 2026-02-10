(define (domain dlr)
  (:requirements :strips :typing :equality :negative-preconditions)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; TYPES
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (:types
    Robot           ; The robot agent
    Location        ; Places the robot can navigate to (e.g., in_front_of_sink)
    Surface         ; Surfaces where objects can be placed (e.g., table1, sink)
    ManipulationObject ; Objects the robot can manipulate
    Arm             ; Robot's arms
  )



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; PREDICATES
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (:predicates
    ;; Robot navigation and location
    (robot_at_location ?robot - Robot ?location - Location) ; Robot is at a location
    (connected ?loc1 - Location ?loc2 - Location)           ; Locations are connected
    (location_can_reach_surface ?location - Location ?surface - Surface)     ; Surface is reachable from location

    ;; Object manipulation
    (object_on_surface ?manipobject - ManipulationObject ?surface - Surface) ; Object is on a surface
    (holding ?robot - Robot ?manipobject - ManipulationObject ?arm - Arm)    ; Robot holds object with one arm
    (holding_with_two_hands ?robot - Robot ?manipobject - ManipulationObject ?arm1 - Arm ?arm2 - Arm) ; Robot holds object with both arms

    ;; Surface state
    (closed ?surface - Surface)      ; Surface (e.g., shelf) is closed
    (clear ?surface - Surface)       ; Surface is clear (no object on it)

    ;; Robot arm state
    (arm_free ?arm - Arm)            ; Arm is free
    (hasArm ?robot - Robot ?arm - Arm) ; Robot has this arm
    (different ?x ?y)                ; Used for logic involving two different arms

    (object_localized ?manipobject - ManipulationObject) ; object has been found


  )


  (:action navigate_to_location
    :parameters (?robot - Robot ?from - Location ?to - Location)
    :precondition (and
      (robot_at_location ?robot ?from)
      (connected ?from ?to)
    )
    :effect (and
      (not (robot_at_location ?robot ?from))
      (robot_at_location ?robot ?to)
    )
  )


  ;; Pick up an object from a surface with two arms


  (:action pick_object_two_hands
    :parameters (?robot - Robot ?manipobject - ManipulationObject ?arm1 - Arm ?arm2 - Arm ?location - Location ?surface - Surface)
    :precondition (and
      (robot_at_location ?robot ?location)
      (location_can_reach_surface ?location ?surface)
      (object_on_surface ?manipobject ?surface)
      (arm_free ?arm1)
      (arm_free ?arm2)
      (hasArm ?robot ?arm1)
      (hasArm ?robot ?arm2)
      (not (closed ?surface))
      (object_localized ?manipobject)
     (different ?arm1 ?arm2)    
    )
    :effect (and
      (holding_with_two_hands ?robot ?manipobject ?arm1 ?arm2)
      (not (object_on_surface ?manipobject ?surface))
      (not (arm_free ?arm1))
      (not (arm_free ?arm2))
      (clear ?surface)
    )
  )



  ;; Pick up an object from a surface with one arm



  (:action pick_object_one_hand
    :parameters (?robot - Robot ?manipobject - ManipulationObject ?arm - Arm ?location - Location ?surface - Surface)
    :precondition (and
      (robot_at_location ?robot ?location)
      (location_can_reach_surface ?location ?surface)
      (object_on_surface ?manipobject ?surface)
      (arm_free ?arm)
      (hasArm ?robot ?arm)
      (not (closed ?surface))
      (object_localized ?manipobject)
    )
    :effect (and
      (holding ?robot ?manipobject ?arm)
      (not (object_on_surface ?manipobject ?surface))
      (not (arm_free ?arm))
      (clear ?surface)
    )
  )

 ;; Place an object on a surface with two arms

  (:action place_object_two_hands
    :parameters (?robot - Robot ?manipobject - ManipulationObject ?arm1 - Arm ?arm2 - Arm ?location - Location ?surface - Surface)
    :precondition (and
      (robot_at_location ?robot ?location)
      (holding_with_two_hands ?robot ?manipobject ?arm1 ?arm2)
      (clear ?surface)
      (hasArm ?robot ?arm1)
      (hasArm ?robot ?arm2)
      (not (closed ?surface))
      (location_can_reach_surface ?location ?surface)
     (different ?arm1 ?arm2)    
    )
    :effect (and
      (object_on_surface ?manipobject ?surface)
      (arm_free ?arm1)
      (arm_free ?arm2)
      (not (holding_with_two_hands ?robot ?manipobject ?arm1 ?arm2))
      (not (clear ?surface))
    )
  )

  

  ;; Place an object on a surface with one arm

  (:action place_object_one_hand
    :parameters (?robot - Robot ?manipobject - ManipulationObject ?arm - Arm ?location - Location ?surface - Surface)
    :precondition (and
      (robot_at_location ?robot ?location)
      (holding ?robot ?manipobject ?arm)
      (clear ?surface)
      (hasArm ?robot ?arm)
      (not (closed ?surface))
      (location_can_reach_surface ?location ?surface)
    )
    :effect (and
      (object_on_surface ?manipobject ?surface)
      (arm_free ?arm)
      (not (holding ?robot ?manipobject ?arm))
      (not (clear ?surface))
    )
  )

  ;; Open a surface (e.g., a shelf)


  (:action open_surface
    :parameters (?robot - Robot ?surface - Surface ?arm - Arm ?location - Location)
    :precondition (and
      (robot_at_location ?robot ?location) ; You may want to add a mapping from location to surface
      (location_can_reach_surface ?location ?surface)
      (hasArm ?robot ?arm)
      (arm_free ?arm)
      (closed ?surface)
    )
    :effect (and
      (not (closed ?surface))
    )
  )

  ;; Close a surface (e.g., a shelf)


  (:action close_surface
    :parameters (?robot - Robot ?surface - Surface ?arm - Arm ?location - Location)
    :precondition (and
      (robot_at_location ?robot ?location) ; You may want to add a mapping from location to surface
      (location_can_reach_surface ?location ?surface)
      (hasArm ?robot ?arm)
      (arm_free ?arm)
      (not (closed ?surface))
    )
    :effect (and
      (closed ?surface)
    )
  )


;; localize object

    (:action localize_object
        :parameters (?manipobject - ManipulationObject ?robot - Robot)
        :precondition (and
        )
        :effect (object_localized ?manipobject)
    )


)