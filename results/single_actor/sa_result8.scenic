#Scenario description#
""" Scenario Description
Ego car turning right across lateral direction in an intersection. Only one car in this scenario.
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

behavior EgoTurnRightBehavior():
    #try:
        do FollowLaneBehavior()
    #interrupt when atIntersection():
    #    take SetSteerAction(1)  # Full right steering


##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way or i.is3Way, network.intersections))

egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.RIGHT_TURN, intersection.maneuvers))
egoInitLane = egoManeuver.startLane
egoSpawnPt = new OrientedPoint in egoInitLane.centerline


##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint EGO_MODEL,
    with behavior EgoTurnRightBehavior()

#terminate when ego.atIntersection() and ego.heading % 360 > 80 and ego.heading % 360 < 100  # Assuming right turn heading is around 90 degrees