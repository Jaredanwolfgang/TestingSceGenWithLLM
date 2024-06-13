# Scenario description
"""
TITLE: Intersection 06
AUTHOR: Francis Indaheng, findaheng@berkeley.edu
DESCRIPTION: Ego vehicle makes a left turn at 4-way intersection in a rural area at night, under clear weather conditions, with a posted speed limit of 25 mph, and then departs the edge of the road.
SOURCE: NHSTA, #26
"""

##Map and Model##

param map = localPath('assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
model scenic.simulators.carla.model


##Constants##

MODEL = 'vehicle.lincoln.mkz_2017'

EGO_INIT_DIST = [20, 25]
param EGO_SPEED = VerifaiRange(20, 25)
param EGO_BRAKE = VerifaiRange(0.5, 1.0)

DEPART_DIST = 50
TERM_DIST = 70


##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior(trajectory):
    try:
        do FollowTrajectoryBehavior(target_speed=globalParameters.EGO_SPEED, trajectory=trajectory)
    interrupt when (distance to egoSpawnPt) > DEPART_DIST:
        terminate


##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way, network.intersections))

egoInitLane = Uniform(*intersection.incomingLanes)
egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, egoInitLane.maneuvers))
egoTrajectory = [egoInitLane, egoManeuver.connectingLane, egoManeuver.endLane]
egoSpawnPt = new OrientedPoint in egoInitLane.centerline


##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint MODEL,
    with behavior EgoBehavior(egoTrajectory)

require EGO_INIT_DIST[0] <= (distance to intersection) <= EGO_INIT_DIST[1]
terminate when (distance to egoSpawnPt) > TERM_DIST