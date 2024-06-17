#Scenario description#
"""
TITLE: Decelerating Lead Vehicle
AUTHOR: [Your Name], [Your Email]
DESCRIPTION: Two vehicles are going straight on the same lane. The leading vehicle suddenly decelerates.
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
model scenic.simulators.carla.model


##Constants##

MODEL = 'vehicle.dodge.charger_police'

LEAD_INIT_SPEED = 10
LEAD_DECEL_THRESHOLD = 0.8
FOLLOW_INIT_SPEED = 10
SAFETY_DISTANCE = 10
INITIAL_DISTANCE_APART = -1 * Uniform(5, 10)
STEPS_PER_SEC = 10


##Moniters##

##Defining Agent Behaviors##

behavior LeadCarBehavior():
    try:
        do FollowLaneBehavior(LEAD_INIT_SPEED)
    interrupt when 5 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 6 * STEPS_PER_SEC:
        take SetBrakeAction(LEAD_DECEL_THRESHOLD)

behavior FollowCarBehavior():
    try:
        do FollowLaneBehavior(FOLLOW_INIT_SPEED)
    interrupt when withinDistanceToAnyObjs(self, SAFETY_DISTANCE):
        take SetBrakeAction(1.0)


##Spatial Relations##

roads = network.roads
select_road = Uniform(*roads)
select_lane = Uniform(*select_road.lanes)


##Scenario Specifications##

lead_car = new Car on select_lane.centerline,
        with behavior LeadCarBehavior()

follow_car = new Car following roadDirection from lead_car for INITIAL_DISTANCE_APART,
        with behavior FollowCarBehavior()

require (distance to intersection) > 50
terminate when (distance from follow_car to lead_car) > 20 and (distance to start) > 100
