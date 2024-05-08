from langchain_core.pydantic_v1 import BaseModel, Field

class Scenic_output(BaseModel):
    '''
    The output of Scenic language can be divided into the following
    fields:
    - Set Map and Model
    - Constants
        - Constants used in the following fields
    - Monitors
        - Traffic Light Monitors
    - Defining Agent Behaviors
        - Ego Behaviors
        - Other Vehicle Behaviors (Leading Cars, Following Cars, 
        Adversary Cars, Adjacent Cars, Pedestrians, etc.)
    - Defining Spatial Relations (Geometry)
        - Include background activities
    - Scenario Specifications (Placement)
        - Scenario Specifications
    - 
    '''
    map_and_model: str = Field(
        ...,
        title="Map and Model",
        description="The map and model of the scenario"
    )
    constants: str = Field(
        ...,
        title="Constants",
        description="Constants used in the scenario"
    )
    monitors: str = Field(
        ...,
        title="Monitors",
        description="Traffic Light Monitors"
    )
    behaviors: str = Field(
        ...,
        title="Behaviors",
        description="Defining Agent Behaviors"
    )
    spatial_relations: str = Field(
        ...,
        title="Spatial Relations",
        description="Defining Spatial Relations"
    )
    scenario: str = Field(
        ...,
        title="Scenario",
        description="Scenario Specifications"
    )

