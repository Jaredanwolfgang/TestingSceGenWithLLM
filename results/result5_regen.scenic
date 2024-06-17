#Scenario description#
"""
Scenario Description
Ego car and another car going straight on the same lane with ego car following; Leading car suddenly decelerating which makes ego car brakes.
****** this behaves perfectly! Because it's quite similar to a oas scenario 
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town02.xodr')
param carla_map = 'Town02'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
LEAD_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 10
LEAD_BRAKE_THRESHOLD = 0.8
SAFETY_DISTANCE = 10
INITIAL_DISTANCE_APART = -1 * Uniform(5, 10)
STEPS_PER_SEC = 10


##Moniters##

##Defining Agent Behaviors##

behavior LeadCarBehavior():
    try:
        do FollowLaneBehavior()
    interrupt when 30 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 40 * STEPS_PER_SEC:
        take SetBrakeAction(LEAD_BRAKE_THRESHOLD)

behavior EgoCarBehavior():
    try:
        do FollowLaneBehavior()
    interrupt when withinDistanceToAnyObjs(self, SAFETY_DISTANCE):
        take SetBrakeAction(LEAD_BRAKE_THRESHOLD)


##Spatial Relations##

lane = Uniform(*network.lanes)


##Scenario Specifications##

leadCar = Car on lane.centerline,
    with blueprint LEAD_MODEL,
    with behavior LeadCarBehavior()

ego = Car following roadDirection from leadCar for INITIAL_DISTANCE_APART,
    with blueprint EGO_MODEL,
    with behavior EgoCarBehavior()

require (distance to intersection) > 50
terminate when (distance from leadCar to ego) > 50