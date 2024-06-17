#Scenario description#
"""
TITLE: Pedestrian 05
AUTHOR: [Your Name], [Your Email]
DESCRIPTION: Ego vehicle must suddenly stop to avoid collision when pedestrian crosses the road unexpectedly.
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town06.xodr')
param carla_map = 'Town06'
model scenic.simulators.carla.model


##Constants##

MODEL = 'vehicle.audi.etron'

EGO_INIT_DIST = [20, 40]
param EGO_SPEED = VerifaiRange(7, 10)
param EGO_BRAKE = VerifaiRange(0.5, 1.0)

PED_MIN_SPEED = 1.0
PED_THRESHOLD = 20

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

lane = Uniform(*network.lanes)


##Scenario Specifications##

ego = new Car on lane.centerline,
    with blueprint MODEL,
    with behavior EgoBehavior(lane.centerline)

ped = new Pedestrian at (lane.centerline.start + Vector(10, 0, 0)),
    with heading perpendicularTo(lane.centerline.heading),
    with behavior CrossingBehavior(ego, PED_MIN_SPEED, PED_THRESHOLD)

require EGO_INIT_DIST[0] <= (distance to ped) <= EGO_INIT_DIST[1]
terminate when (distance to lane.centerline.start) > TERM_DIST