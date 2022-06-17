import strawberry
from enum import Enum

@strawberry.enum
class DeploymentType(Enum):
    ON_PREM = "On-Premise"
    CLOUDHUB = "CloudHub"
    RTF = "Runtime Fabric"
