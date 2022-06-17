import strawberry
import typing
from API import API
from Cluster import Cluster
from Keys import Keys

@strawberry.type(description="Environment represents a Mulesoft environment",directives=[Keys(fields="id")])
class Environment:
    id: str
    name: str
    apis: typing.List[API]
    clusters: typing.List[Cluster]

    def __init__(self,id="",name="",apis=[],clusters=[]):
        self.id = id
        self.name = name
        self.apis = apis
        self.clusters = clusters
