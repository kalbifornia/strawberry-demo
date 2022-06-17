import strawberry
import typing
from Server import Server
from DeploymentType import DeploymentType

@strawberry.type
class Cluster:
    id: str
    name: str
    servers: typing.List[Server]
    description: str
    deploymentType: DeploymentType

    def __init__(self,id="",name="",servers=[],description="",deploymentType=DeploymentType.ON_PREM):
        self.id=id
        self.name=name
        self.servers=servers
        self.description=description
        self.deploymentType=deploymentType
