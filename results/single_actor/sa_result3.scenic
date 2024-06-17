#Scenario description#
""" Scenario Description
A pedestrian walking forward along the sidewalk.
"""

##Map and Model##

param map = localPath('../../assets/maps/CARLA/Town04.xodr')
param carla_map = 'Town04'
model scenic.simulators.carla.model


##Constants##

PED_MODEL = "walker.pedestrian.0001"
PED_SPEED = 2.0


##Moniters##

##Defining Agent Behaviors##

behavior PedestrianWalkingBehavior():
    try:
        do SetWalkingSpeedAction(PED_SPEED)
        do SetWalkingDirectionAction(self.heading)
    interrupt when not self.onSidewalk:
       terminate


##Spatial Relations##

sidewalk = Uniform(*network.sidewalks)


##Scenario Specifications##

ped = new Pedestrian on sidewalk.centerline,
    with blueprint PED_MODEL,
    with behavior PedestrianWalkingBehavior()

# terminate when ped.distanceTo(ped.initialPosition) > 100