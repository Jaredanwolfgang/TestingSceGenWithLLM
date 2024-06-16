#Scenario description#
"""
TITLE: Red Light Violation Collision
AUTHOR: [Your Name], [your.email@example.com]
DESCRIPTION: Vehicle runs a red light in an urban area, colliding with another vehicle crossing the intersection from a lateral direction.
CONDITIONS: Daylight, clear weather, speed limit 35 mph.
"""

##Map and Model##

param map = localPath('./assets/maps/CARLA/Town10HD.xodr')
param carla_map = 'Town10HD'
model scenic.simulators.carla.model

##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 35  # Speed limit in mph

##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    try:
        do FollowLaneBehavior(speed=EGO_SPEED)
    interrupt when withinDistanceToRedTrafficLight(self, 15):
        # Ignoring red light
        continue

behavior OtherVehicleBehavior(speed):
    try:
        do FollowLaneBehavior(speed=speed)
    interrupt when withinDistanceToAnyObjs(self, 5):  # Close proximity to collision
        take SetBrakeAction(1.0)

##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way, network.intersections))
egoLane = Uniform(*intersection.incomingLanes)
otherLane = Uniform(*filter(lambda l: l != egoLane and l.isConnectedTo(egoLane), intersection.incomingLanes))

##Scenario Specifications##

ego = new Car on egoLane.centerline,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

otherVehicle = new Car on otherLane.centerline,
    with blueprint EGO_MODEL,
    with behavior OtherVehicleBehavior(EGO_SPEED)

require (distance to intersection) > 50
terminate when (distance from ego to otherVehicle) < 5  # Collision condition