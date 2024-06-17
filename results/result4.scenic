#Scenario description#
"""
TITLE: Urban Straight Road with Pedestrian Encounter
AUTHOR: [Your Name], [Your Email]
DESCRIPTION: Ego vehicle is going straight in an urban area under clear weather conditions and encounters a pedestrian at a non-junction location.
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town07.xodr')
param carla_map = 'Town07'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 25  # Speed limit in mph
PED_SPEED = 1.5  # Average walking speed

##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    try:
        do FollowLaneBehavior(speed=EGO_SPEED)
    interrupt when withinDistanceToAnyObjs(self, 10):
        take SetBrakeAction(1.0)

behavior PedestrianBehavior():
    do WalkStraightBehavior(speed=PED_SPEED)

##Spatial Relations##

lane = Uniform(*network.lanes)

##Scenario Specifications##

ego = new Car on lane.centerline,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

pedestrian = new Pedestrian at (lane.centerline.sample(0.5)),  # Place pedestrian at a random point on the lane
    with behavior PedestrianBehavior()

require (distance to intersection) > 50  # Ensure the location is non-junction
terminate when (distance from ego to pedestrian) > 20  # Terminate when the vehicle has passed the pedestrian
