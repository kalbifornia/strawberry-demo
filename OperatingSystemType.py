import strawberry
from enum import Enum

@strawberry.enum
class OperatingSystemType(Enum):
    LINUX = "Linux"
    WINDOWS = "Windows"
