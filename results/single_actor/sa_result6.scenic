#Scenario description#
""" Scenario Description
Ego car turning left across path from lateral direction. Only one car in this scenario.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 5


##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    try:
        do FollowLaneBehavior()
    interrupt when simulation().currentTime > 5:  # After 5 seconds, initiate the left turn
        take SetSteerAction(-1)  # Steer hard left
        take SetSpeedAction(EGO_SPEED)  # Maintain speed


##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way or i.is3Way, network.intersections))

egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, intersection.maneuvers))
egoInitLane = egoManeuver.startLane
egoSpawnPt = new OrientedPoint in egoInitLane.centerline


##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

terminate when (distance to intersection) > 50