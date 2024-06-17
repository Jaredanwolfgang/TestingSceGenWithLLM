#Scenario description#
""" Scenario Description
Ego car turning left into another road in an intersection. Only one car in this scenario.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town04.xodr')
param carla_map = 'Town04'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 5


##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    #try:
        do FollowLaneBehavior(target_speed=EGO_SPEED)
    #interrupt when atIntersection():
    #    take TurnLeftAction()


##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way or i.is3Way, network.intersections))

egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, intersection.maneuvers))
egoInitLane = egoManeuver.startLane
egoSpawnPt = new OrientedPoint in egoInitLane.centerline


##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

require (distance to intersection) > 20
terminate when (distance to intersection) < 5