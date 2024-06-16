#Scenario description#
"""
TITLE: Left Turn Intersection Cut-off
AUTHOR: [Your Name], [your_email@example.com]
DESCRIPTION: Ego vehicle is turning left at an intersection in an urban area under clear weather conditions. It cuts across the path of another vehicle initially traveling in the same direction.
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town02.xodr')
param carla_map = 'Town02'
model scenic.simulators.carla.model

##Constants##

MODEL = 'vehicle.volkswagen.t2'
EGO_SPEED = 15  # Adjusted speed for urban area
OTHER_SPEED = 30
INTERSECTION_DISTANCE = 30
CUTOFF_DISTANCE = 10

##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior(trajectory):
    try:
        do FollowTrajectoryBehavior(target_speed=EGO_SPEED, trajectory=trajectory)
    interrupt when withinDistanceToAnyObjs(self, CUTOFF_DISTANCE):
        take SetBrakeAction(1.0)

behavior OtherCarBehavior():
    try:
        do FollowLaneBehavior(target_speed=OTHER_SPEED)
    interrupt when withinDistanceToAnyObjs(self, CUTOFF_DISTANCE):
        take SetBrakeAction(1.0)

##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way or i.is3Way, network.intersections))

egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, intersection.maneuvers))
egoInitLane = egoManeuver.startLane
egoTrajectory = [egoInitLane, egoManeuver.connectingLane, egoManeuver.endLane]
egoSpawnPt = new OrientedPoint in egoInitLane.centerline

otherInitLane = egoManeuver.connectingLane  # Assuming the other car is on the lane ego connects to
otherSpawnPt = new OrientedPoint in otherInitLane.centerline

##Scenario Specifications##

ego = new Car at egoSpawnPt,
    with blueprint MODEL,
    with behavior EgoBehavior(egoTrajectory)

other = new Car at otherSpawnPt,
    with blueprint MODEL,
    with behavior OtherCarBehavior()

require (distance to intersection) <= INTERSECTION_DISTANCE
terminate when (distance to egoSpawnPt) > 50