#Scenario description#
""" Scenario Description
Pedestrian Crossing Road
A pedestrian crosses the road while the ego-vehicle approaches from one direction. The ego-vehicle must slow down or stop to avoid collision with the pedestrian.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town02.xodr')
param carla_map = 'Town02'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 10
PED_SPEED = 2
SAFETY_DISTANCE = 10


##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    try:
        do FollowLaneBehavior(target_speed=EGO_SPEED)
    interrupt when withinDistanceToAnyObjs(self, SAFETY_DISTANCE, Pedestrian):
        while withinDistanceToAnyObjs(self, SAFETY_DISTANCE, Pedestrian):
            take SetBrakeAction(1.0)

behavior PedestrianBehavior():
    do WalkStraightBehavior(target_speed=PED_SPEED)


##Spatial Relations##

road = Uniform(*network.roads)
lane = Uniform(*road.lanes)
crosswalk = Uniform(*network.crosswalks)


##Scenario Specifications##

ego = new Car on lane.centerline,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

ped = new Pedestrian at crosswalk.start,
    with behavior PedestrianBehavior()

require (distance to crosswalk) > 50
terminate when (distance from ped to crosswalk.end) < 5