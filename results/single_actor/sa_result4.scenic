#Scenario description#
""" Scenario Description
Ego car going straight along a lane.
The ego-vehicle drives straight along a lane without any interruptions.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town02.xodr')
param carla_map = 'Town02'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 10


##Moniters##

##Defining Agent Behaviors##

behavior EgoStraightBehavior():
    # try:
        do FollowLaneBehavior(target_speed=EGO_SPEED)


##Spatial Relations##

lane = Uniform(*network.lanes)


##Scenario Specifications##

start = new OrientedPoint on lane.centerline
ego = new Car at start,
    with blueprint EGO_MODEL,
    with behavior EgoStraightBehavior()

terminate when (distance to start) > 100