import typing
import strawberry
from strawberry.dataloader import DataLoader
from Environment import Environment
from DeploymentType import DeploymentType
from Cluster import Cluster
from Server import Server

def get_environments() -> typing.List[Environment]:
    """
    TODO Refactor this to pull this info from a database
    rather than having it hardcoded
    TODO Set up process to load data into database in batch fashion
    """
    qaClusters = get_qa_clusters()
    return [
        Environment(id="1234",name="Production_Not_Q",clusters=[],apis=[]),
        Environment(id="1234",name="QA",clusters=qaClusters,apis=[])
    ]

def get_qa_clusters() -> typing.List[Cluster]:
    qaServers=[]
    qaClusters = [
        Cluster(id="ABCD12",
            name="POD2",
            servers=qaServers,
            description="The Pod2 QA cluster, shared by many in-house applications",
            deploymentType=DeploymentType.ON_PREM),
        Cluster(id="ABCD13",
            name="POD3",
            servers=qaServers,
            description="The Pod3 QA cluster, primarily for Policy integrations",
            deploymentType=DeploymentType.ON_PREM)
        ]
    return qaClusters

def load_servers(keys: typing.List[str]) -> typing.List[Server]:
    return [Server(id=key) for key in keys]

def joe_random_str_resolver(root) -> str:
    return "RANDO_JOE_" + str(type(root))

@strawberry.type
class Query:
    joe_random_str: str = strawberry.field(resolver=joe_random_str_resolver)

    @strawberry.field
    def joe_random_str2() -> str:
        return "blahblah2"

    @strawberry.field
    def environments(self, name: str) -> typing.List[Environment]:
        ret = []
        for env in get_environments():
            if name in env.name:
                ret.append(env)
        return ret

    @strawberry.field
    def clusters(self, name: str) -> typing.List[Cluster]:
        ret = []
        for cluster in get_qa_clusters():
            if name in cluster.name:
                ret.append(cluster)
        return ret

@strawberry.type
class Mutation:
    @strawberry.mutation
    def update_environment(self, id: str, description: str) -> Environment:
        print(f'Updating environment {id} with description {description}')

        return Environment(id=id, description=description)

print("Hello World1")
print("Hello World2")
print("Hello World3")


schema = strawberry.Schema(query=Query,mutation=Mutation)
