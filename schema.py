import typing
import strawberry
import random
import asyncio
from typing import AsyncGenerator, AsyncIterable

def get_books():
    return [
        GoodBook(
            title='The Great Gatsby',
            author='F. Scott Fitzgerald',
            year='1921',
            awards=[
                Award(name="GoldenBerry Award",description="The best book with golden berries on the cover."),
                Award(name="Aloha Seal")
            ]
        ),
        Book(
            title="How to Reverse Your Disease",
            author="Joe Kalb",
            year="2023"
        )
    ]


@strawberry.type
class Book:
    id: str
    title: str
    author: str
    year: str

    def __init__(self,title="",author="",year=""):
        self.title = title
        self.author = author
        self.year = year
        self.id = str(int(random.random()*1000))

@strawberry.type
class Award:
    id: str
    name: str
    description: str

    def __init__(self,name="",description=""):
        self.name=name
        self.description=description
        self.id = str(int(random.random()*1000))

@strawberry.type
class GoodBook(Book):
    awards: typing.List[Award]

    def __init__(self,title,author,year,awards=None):
        print("Hellooooo")
        super().__init__(title,author,year)
        self.awards = awards

@strawberry.type
class MyQuery:
    books: typing.List[Book] = strawberry.field(resolver=get_books)

@strawberry.type
class MyMutation:
    @strawberry.mutation
    def add_book(self, title: str, author: str, year: str) -> Book:
        print(f'Adding {title} by {author}')

        return Book(title=title, author=author, year=year)

@strawberry.type
class MySubscription:
    @strawberry.subscription
    async def count(self, target: int = 100) -> AsyncGenerator[int, None]:
        for i in range(target):
            print("HEY")
            yield i
            await asyncio.sleep(0.5)

schema = strawberry.Schema(query=MyQuery,mutation=MyMutation)
