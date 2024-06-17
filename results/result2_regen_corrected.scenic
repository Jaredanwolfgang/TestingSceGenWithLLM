#Scenario description#
"""
TITLE: Left Turn Intersection Conflict
AUTHOR: [Your Name], [your.email@example.com]
DESCRIPTION: Ego vehicle turns left at an intersection in an urban area under clear weather conditions and cuts across the path of another vehicle initially traveling in the same direction.
****** still cannot provide correct space relationship
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town02.xodr')
param carla_map = 'Town02'
model scenic.simulators.carla.model


##Constants##

MODEL = 'vehicle.audi.a2'

EGO_INIT_DIST = [20, 40]
param EGO_SPEED = VerifaiRange(7, 10)
param EGO_BRAKE = VerifaiRange(0.5, 1.0)

ADV_INIT_DIST = [0, 20]
param ADV_SPEED = VerifaiRange(7, 10)

param SAFETY_DIST = VerifaiRange(10, 20)
CRASH_DIST = 5
TERM_DIST = 70


##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior(trajectory):
    try:
        do FollowTrajectoryBehavior(target_speed=globalParameters.EGO_SPEED, trajectory=trajectory)
    interrupt when withinDistanceToAnyObjs(self, globalParameters.SAFETY_DIST):
        take SetBrakeAction(globalParameters.EGO_BRAKE)
    interrupt when withinDistanceToAnyObjs(self, CRASH_DIST):
        terminate


##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is3Way or i.is4Way, network.intersections))

egoInitLane = Uniform(*intersection.incomingLanes)
egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, egoInitLane.maneuvers))
egoTrajectory = [egoInitLane, egoManeuver.connectingLane, egoManeuver.endLane]
egoSpawnPt = new OrientedPoint in egoInitLane.centerline

advInitLane = Uniform(*filter(lambda l: l.adjacentTo(egoInitLane), network.lanes))
advTrajectory = [advInitLane, advInitLane]  # Adv vehicle continues straight
advSpawnPt = new OrientedPoint in advInitLane.centerline


##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint MODEL,
    with behavior EgoBehavior(egoTrajectory)

adversary = new Car at advSpawnPt,
    with blueprint MODEL,
    with behavior FollowTrajectoryBehavior(target_speed=globalParameters.ADV_SPEED, trajectory=advTrajectory)

require EGO_INIT_DIST[0] <= (distance to intersection) <= EGO_INIT_DIST[1]
require ADV_INIT_DIST[0] <= (distance from adversary to intersection) <= ADV_INIT_DIST[1]
terminate when (distance to egoSpawnPt) > TERM_DIST