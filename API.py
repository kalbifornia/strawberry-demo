import strawberry

@strawberry.type
class API:
    id: str
    name: str
    description: str

    def __init__(self,id="",name="",description=""):
        self.id = id
        self.name=name
        self.description=description
