from langchain_core.pydantic_v1 import BaseModel, Field
from langchain_openai import ChatOpenAI

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
    - Defining Spatial Relations
        - Geometry
        - Placement
    - Scenario Specifications
        - Scenario Specifications
    - Background Activities
        - Defining Background Cars and Pedestrians
    - 
    '''
    map: str = Field(
        ...,
        title="Map",
        description="The map of the scenario"
    )
    model: str = Field(
        ...,
        title="Model",
        description="The model of the scenario"
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
    background_activities: str = Field(
        ...,
        title="Background Activities",
        description="Defining Background Cars and Pedestrians"
    )
