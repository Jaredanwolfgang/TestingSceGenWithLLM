""" Scenario Description
Traffic Scenario 01.
Control loss without previous action.
The ego-vehicle loses control due to bad conditions on the road and it must recover, coming back to
its original lane.
"""

#################################
# MAP AND MODEL                 #
#################################

param map = localPath('../../assets/maps/CARLA/Town01.xodr')
param carla_map = 'Town01'
model scenic.simulators.carla.model

#################################
# CONSTANTS                     #
#################################

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 10

#################################
# AGENT BEHAVIORS               #
#################################

# EGO BEHAVIOR: Follow lane, and brake after passing a threshold distance to the leading car
behavior EgoBehavior(speed=10):
    do FollowLaneBehavior(speed)

#################################
# SPATIAL RELATIONS             #
#################################

# Please refer to scenic/domains/driving/roads.py how to access detailed road infrastructure
# 'network' is the 'class Network' object in roads.py
# make sure to put '*' to uniformly randomly select from all elements of the list, 'lanes'
lane = Uniform(*network.lanes)

#################################
# SCENARIO SPECIFICATION        #
#################################

start = new OrientedPoint on lane.centerline
ego = new Car at start,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior(EGO_SPEED)

debris1 = new Debris following roadDirection for Range(10, 20)
debris2 = new Debris following roadDirection from debris1 for Range(5, 10)
debris3 = new Debris following roadDirection from debris2 for Range(5, 10)

require (distance to intersection) > 50
terminate when (distance from debris3 to ego) > 10 and (distance to start) > 50
