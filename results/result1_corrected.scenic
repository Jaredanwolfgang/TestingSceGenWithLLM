#Scenario description#
"""
TITLE: Red Light Violation Collision
AUTHOR: [Your Name], [your.email@example.com]
DESCRIPTION: Vehicle runs a red light in an urban area, colliding with another vehicle crossing the intersection from a lateral direction.
CONDITIONS: Daylight, clear weather, speed limit 35 mph.
****** remove continue, otherLane changed, FollowLaneBehavior has no speed attribute but target_speed 
****** to make it dangerous, must set the value of beginning distance to about 40
****** going straight with another vehicle crossing from a lateral direction
"""

##Map and Model##

param map = localPath('../assets/maps/CARLA/Town10HD.xodr')
param carla_map = 'Town10HD'
model scenic.simulators.carla.model

##Constants##

EGO_MODEL = "vehicle.lincoln.mkz_2017"
EGO_SPEED = 35  # Speed limit in mph

##Moniters##

##Defining Agent Behaviors##

behavior EgoBehavior():
    try:
        do FollowLaneBehavior(EGO_SPEED)
    interrupt when withinDistanceToAnyObjs(self, 15):
        # Ignoring red light
        take SetBrakeAction(1.0)

behavior OtherVehicleBehavior(speed):
    try:
        do FollowLaneBehavior(speed)
    interrupt when withinDistanceToAnyObjs(self, 5):  # Close proximity to collision
        take SetBrakeAction(1.0)

##Spatial Relations##

intersection = Uniform(*filter(lambda i: i.is4Way, network.intersections))

#ego_trajectory = [straight_maneuver.startLane, straight_maneuver.connectingLane, straight_maneuver.endLane]
#crossing_startLane = csm.startLane
#crossing_car_trajectory = [csm.startLane, csm.connectingLane, csm.endLane]

egoLane = Uniform(*intersection.incomingLanes)
straight_maneuvers = filter(lambda i: i.type == ManeuverType.STRAIGHT, egoLane.maneuvers)
straight_maneuver = Uniform(*straight_maneuvers)
conflicting_straight_maneuvers = filter(lambda i: i.type == ManeuverType.STRAIGHT, straight_maneuver.conflictingManeuvers)
csm = Uniform(*conflicting_straight_maneuvers)
otherLane = csm.startLane

##Scenario Specifications##

ego = new Car on egoLane.centerline,
    with blueprint EGO_MODEL,
    with behavior EgoBehavior()

otherVehicle = new Car on otherLane.centerline,
    with blueprint EGO_MODEL,
    with behavior OtherVehicleBehavior(EGO_SPEED)

require (distance to intersection) < 40
terminate when (distance from ego to otherVehicle) < 5  # Collision condition