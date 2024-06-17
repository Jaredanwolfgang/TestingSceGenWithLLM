#Scenario description#
""" Scenario Description
Ego car turning left across path from opposite direction. Only one car in this scenario.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town04.xodr')
param carla_map = 'Town04'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 10


##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    #try:
        do FollowLaneBehavior()
    #interrupt when isTurningLeft():
    #    take SetSpeedAction(EGO_SPEED / 2)  # Slow down while turning left


##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way or i.is3Way, network.intersections))

egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, intersection.maneuvers))
egoInitLane = egoManeuver.startLane
egoSpawnPt = new OrientedPoint in egoInitLane.centerline


##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

require (distance to intersection) > 50
terminate when (distance to egoSpawnPt) > 100