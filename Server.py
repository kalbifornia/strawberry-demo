import strawberry
from OperatingSystemType import OperatingSystemType

@strawberry.type
class Server:
    id: str
    name: str
    description: str
    operatingSystem: OperatingSystemType

    def __init__(self,id="",name="",description="",operatingSystem=OperatingSystemType.WINDOWS):
        self.id=id
        self.name=name
        self.description=description
        self.operatingSystem=operatingSystem
