#Scenario description
"""
Scenario Description: Rural Night Turn
Vehicle is turning left/right at an intersection-related location, in a rural area at night, under clear weather conditions, with a posted speed limit of 25 mph; and then departs the edge of the road.
"""

##Map and Model##

param map = localPath('./assets/maps/CARLA/Town06.xodr')
param carla_map = 'Town06'
model scenic.simulators.carla.model

##Constants##

EGO_MODEL = "vehicle.lincoln.mustang"
EGO_SPEED = 25

##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior(trajectory):
    try:
        do FollowTrajectoryBehavior(target_speed=globalParameters.EGO_SPEED, trajectory=trajectory)
    interrupt when withinDistanceToEdgeOfRoad(self, 5):
        take SetBrakeAction(1.0)

##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is3Way or i.is4Way, network.intersections))

# Randomly select left or right turn
turn_type = random.choice(["LEFT_TURN", "RIGHT_TURN"])

if turn_type == "LEFT_TURN":
    egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, intersection.maneuvers))
else:
    egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.RIGHT_TURN, intersection.maneuvers))

egoInitLane = egoManeuver.startLane
egoTrajectory = [egoInitLane, egoManeuver.connectingLane, egoManeuver.endLane]
egoSpawnPt = new OrientedPoint in egoInitLane.centerline

##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior(egoTrajectory)

require (distance to intersection) > 10
terminate when (distance from ego to edgeOfRoad) < 5