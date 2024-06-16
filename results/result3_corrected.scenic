#Scenario description#
"""
TITLE: Lane Change Encroachment
AUTHOR: [Your Name], [your.email@example.com]
DESCRIPTION: Ego vehicle changes lanes in an urban area at a non-junction and encroaches into another vehicle traveling in the same direction.
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town01.xodr')
param carla_map = 'Town01'
model scenic.simulators.carla.model


##Constants##

MODEL = 'vehicle.toyota.prius'

EGO_INIT_DIST = [20, 40]
param EGO_SPEED = VerifaiRange(7, 10)
param EGO_BRAKE = VerifaiRange(0.5, 1.0)

OTHER_INIT_DIST = [0, 20]
param OTHER_SPEED = VerifaiRange(7, 10)

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

road = Uniform(*network.roads)
lane1 = Uniform(*road.lanes)
lane2 = Uniform(*road.lanes)
#lane2 = Uniform(*filter(lambda l: l != lane1, road.lanes))

egoInitPoint = new OrientedPoint in lane1.centerline
otherInitPoint = new OrientedPoint in lane2.centerline

egoTrajectory = [lane1, lane2]
otherTrajectory = [lane2]


##Scenario Specifications##

ego = new Car at egoInitPoint,
    with blueprint MODEL,
    with behavior EgoBehavior(egoTrajectory)

other = new Car at otherInitPoint,
    with blueprint MODEL,
    with behavior FollowLaneBehavior(target_speed=globalParameters.OTHER_SPEED)

# require EGO_INIT_DIST[0] <= (distance to road) <= EGO_INIT_DIST[1]
# require OTHER_INIT_DIST[0] <= (distance from other to road) <= OTHER_INIT_DIST[1]
# terminate when (distance to egoInitPoint) > TERM_DIST