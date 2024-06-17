#Scenario description#
"""
TITLE: Urban Straight Road with Pedestrian Encounter
AUTHOR: [Your Name], [Your Email]
DESCRIPTION: Ego vehicle is going straight in an urban area under clear weather conditions and encounters a pedestrian at a non-junction location.
****** use sample, Pedestrian less regionContainedIn attribute, Use wrong behavior for pedestrian
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town04.xodr')
param carla_map = 'Town04'
model scenic.simulators.carla.model

##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 25  # Speed limit in mph
PED_SPEED = 1.5  # Average walking speed

##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    try:
        do FollowLaneBehavior(target_speed=EGO_SPEED)
    interrupt when withinDistanceToAnyObjs(self, 10):
        take SetBrakeAction(1.0)

behavior PedestrianBehavior():
    do CrossingBehavior(ego)

##Spatial Relations##

lane = Uniform(*network.lanes)

##Scenario Specifications##
spawnPt = new OrientedPoint on lane.centerline

ego = new Car following roadDirection from spawnPt for -30,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

pedestrian = new Pedestrian right of spawnPt by 3, # Place pedestrian at a random point on the lane
    with heading 90 deg relative to spawnPt.heading,
    with regionContainedIn None,
    with behavior PedestrianBehavior()

#require (distance to intersection) > 50  # Ensure the location is non-junction
terminate when (distance from ego to pedestrian) > 50  # Terminate when the vehicle has passed the pedestrian