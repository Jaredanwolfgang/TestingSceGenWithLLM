#Scenario description#
""" Scenario Description
Ego car negotiating a curve.
The ego-vehicle is driving on a road with a curve and must maintain control while navigating the bend.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town04.xodr')
param carla_map = 'Town04'
model scenic.simulators.carla.model


##Constants##

EGO_MODEL = "vehicle.tesla.model3"
EGO_SPEED = 15  # Speed suitable for a curve


##Moniters##

##Defining Agent Behaviors##

behavior EgoCurveBehavior():
    try:
        do FollowLaneBehavior(target_speed=EGO_SPEED)
    interrupt when withinDistanceToAnyObjs(self, 10):  # Adjust based on potential obstacles
        take SetBrakeAction(0.5)  # Moderate braking to maintain control


##Spatial Relations##

# Select a road with a curve
roads = network.roads
select_road = Uniform(*filter(lambda r: any(l.curvature > 0.001 for l in r.lanes), roads))
select_lane = Uniform(*select_road.lanes)


##Scenario Specifications##

start = new OrientedPoint on select_lane.centerline
ego = new Car at start,
    with blueprint EGO_MODEL,
    with behavior EgoCurveBehavior()

terminate when (distance to start) > 100  # Terminate after a certain distance