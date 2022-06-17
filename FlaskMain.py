import flask
import sqlalchemy
from flask import Flask, render_template
from strawberry.flask.views import GraphQLView
from sqlalchemy import create_engine, text, MetaData, Table, ForeignKey
from sqlalchemy.orm import Session
import asyncio
import random
from flask_sqlalchemy import SQLAlchemy

from amp_schema import schema

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql://{username}:{password}@{server}/ampdatabase".format(username="joe", password="password", server="localhost:3306")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
metadata_obj = MetaData()
db = SQLAlchemy(app)

class Environment(db.Model):
    __tablename__ = "ampenvironment"
    id = db.Column("ID",db.Integer,primary_key=True)
    name = db.Column("Name",db.String(100))

    def __init__(self,name=""):
        self.name = name

class Cluster(db.Model):
    __tablename__ = "ampcluster"
    id = db.Column("ID",db.Integer,primary_key=True)
    environment_id = db.Column("EnvironmentID",db.Integer,ForeignKey('ampenvironment.ID'))
    name = db.Column("Name",db.String(100))
    description = db.Column("Description",db.String(255))
    deploymentTypeID = db.Column("DeploymentType",db.Integer,ForeignKey('ampdeploymenttype.ID'))
    environment = db.relationship("Environment", back_populates = "clusters")
    deploymentType = db.relationship("DeploymentType")

class DeploymentType(db.Model):
    __tablename__ = "ampdeploymenttype"
    id = db.Column("ID",db.Integer,primary_key=True)
    shortName = db.Column("ShortName",db.String(10))
    name = db.Column("Name",db.String(100))

class APIAPI(db.Model):
    __tablename__ = "ampapiapi"
    id = db.Column("ID",db.Integer,primary_key=True)
    sourceAPIID = db.Column("SourceAPIID",db.Integer,ForeignKey('ampapi.ID'))
    targetAPIID = db.Column("TargetAPIID",db.Integer,ForeignKey('ampapi.ID'))

class API(db.Model):
    __tablename__ = "ampapi"
    id = db.Column("ID",db.Integer,primary_key=True)
    name = db.Column("Name",db.String(100))
    description = db.Column("Description",db.String(255))
    consolePath = db.Column("ConsolePath",db.String(100))
    usesPII = db.Column("UsesPII",db.Boolean)
    clientAPIs = db.relationship("API",secondary="ampapiapi",primaryjoin="API.id == ampapiapi.c.TargetAPIID",secondaryjoin="API.id == ampapiapi.c.SourceAPIID")
    targetAPIs = db.relationship("API",secondary="ampapiapi",primaryjoin="API.id == ampapiapi.c.SourceAPIID",secondaryjoin="API.id == ampapiapi.c.TargetAPIID")

class System(db.Model):
    __tablename__ = "ampsystem"
    id = db.Column("ID",db.Integer,primary_key=True)
    name = db.Column("Name",db.String(100))
    description = db.Column("Description",db.String(255))

class APISystem(db.Model):
    __tablename__ = "ampapisystem"
    id = db.Column("ID",db.Integer,primary_key=True)
    apiID = db.Column("APIID",db.Integer,ForeignKey("ampapi.ID"))
    systemID = db.Column("SystemID",db.Integer,ForeignKey("ampsystem.ID"))
    systemTypeID = db.Column("SystemTypeID",db.Integer,ForeignKey("ampsystemtype.ID"))
    api = db.relationship("API", back_populates="apiSystems")
    system = db.relationship("System", back_populates="apiSystems")
    systemType = db.relationship("SystemType")

    def __repr__(self):
        return "System {systemName} is a {systemTypeName} system for API {apiName}".format(
            systemName=self.system.name,
            apiName=self.api.name,
            systemTypeName=self.systemType.shortName)

class OperatingSystemType(db.Model):
    __tablename__ = "ampoperatingsystemtype"
    id = db.Column("ID",db.Integer,primary_key=True)
    shortName = db.Column("ShortName",db.String(10))
    name = db.Column("Name",db.String(100))

class APIInstance(db.Model):
    __tablename__ = "ampapiinstance"
    id = db.Column("ID",db.Integer,primary_key=True)
    apiID = db.Column("APIID",db.Integer,ForeignKey("ampapi.ID"))
    clusterID = db.Column("ClusterID",db.Integer,ForeignKey("ampcluster.ID"))
    anypointInstanceID = db.Column("AnypointInstanceID",db.String(255))
    api = db.relationship("API")
    cluster = db.relationship("Cluster")

class Server(db.Model):
    __tablename__ = "ampserver"
    id = db.Column("ID",db.Integer,primary_key=True)
    name = db.Column("Name",db.String(100))
    description = db.Column("Description",db.String(255))
    clusterID = db.Column("ClusterID",db.Integer,ForeignKey("ampcluster.ID"))
    operatingSystemID = db.Column("OperatingSystemID",db.Integer,ForeignKey("ampoperatingsystemtype.ID"))
    cluster = db.relationship("Cluster", back_populates = "servers")
    operatingSystem = db.relationship("OperatingSystemType")

    def __repr__(self):
        return "Server {name}".format(name=self.name)

class SystemType(db.Model):
    __tablename__ = "ampsystemtype"
    id = db.Column("ID",db.Integer,primary_key=True)
    shortName = db.Column("ShortName",db.String(10))
    name = db.Column("Name",db.String(100))

try:
    Environment.clusters = db.relationship("Cluster", order_by = Cluster.id, back_populates = "environment")
    Cluster.servers = db.relationship("Server", order_by = Server.id, back_populates = "cluster")
    API.apiSystems = db.relationship("APISystem", order_by = APISystem.id, back_populates = "api")
    API.instances = db.relationship("APIInstance",order_by = APIInstance.id, back_populates = "api")
    System.apiSystems = db.relationship("APISystem", order_by = APISystem.id, back_populates = "system")

    db.create_all()
    clusters = (Cluster.query.filter_by(id = 2).all())
    for c in clusters:
        print(c.name)
    apiInstances = (APIInstance.query.all())
    for instance in apiInstances:
        print(instance.id)
        print("API {apiName} is running on cluster {clusterName} (servers: {servers}) in environment {envName}. Systems: {systems}".format(
            apiName=instance.api.name,
            clusterName=instance.cluster.name,
            servers=instance.cluster.servers,
            systems=instance.api.apiSystems,
            envName=instance.cluster.environment.name))
        print("API {apiName} has the following client APIs:".format(apiName=instance.api.name))
        if instance.api.clientAPIs != None:
            for clientAPI in instance.api.clientAPIs:
                print(clientAPI.name)
        print("API {apiName} has the following target APIs:".format(apiName=instance.api.name))
        if instance.api.targetAPIs != None:
            for targetAPI in instance.api.targetAPIs:
                print(targetAPI.name)
        print()
        print()
    print("After create_all()")
except BaseException as e:
    print(e)
finally:
    print("finally")
    """
print("About to create engine")
print(app.config["SQLALCHEMY_DATABASE_URI"])
try:
    engine = create_engine(app.config["SQLALCHEMY_DATABASE_URI"])
except BaseException as e:
    print("except")
    print(e)
finally:
    print("finally")
print("After creating engine")
environmentTable = Table('ampenvironment',metadata_obj,autoload=True,autoload_with=engine)
clusterTable = Table('ampcluster',metadata_obj,autoload=True,autoload_with=engine)
print(environmentTable.columns.keys())
select_stmt = environmentTable.select()
print("Select statement")
print(select_stmt)
print(engine)
conn = engine.connect()
result = conn.execute(select_stmt)
print(conn)
print(result)
try:
    print(result.fetchall())
except BaseException as e:
    print(e)
finally:
    print("finally block")
print("Hey")

try:
    j = clusterTable.join(environmentTable,clusterTable.columns["EnvironmentID"] == environmentTable.columns["ID"])
    print(j)
    select_cluster_stmt = sqlalchemy.select([clusterTable,environmentTable]).select_from(j)
    result2 = conn.execute(select_cluster_stmt)
    print()
    print()
    print("About to fetchall!!")
    for res in result2.fetchall():
        print(res["EnvironmentID"])
    #print(result2.fetchall())
except BaseException as e:
    print(e)
finally:
    print("finally block 2")
print("DONE!")"""

app.add_url_rule(
    "/joegraphql",
    view_func=GraphQLView.as_view("joegraphql_view", schema=schema, graphiql=True),
)

@app.route("/hello/<user>")
async def hello_name(user):
    query = """
        query MyQuery {
          environments(name: "Q") {
            id
            name
            clusters {
              name
              id
              description
              deploymentType
              servers {
                description
                name
                operatingSystem
              }
            }
          }
        }
    """
    res = await schema.execute(query)
    print(type(res))

    """This tells us:
    1. What kind of database we are communicating with.
    2. What DBAPI are we using?
    3. How do we locate the database?

    Also, note that the echo field is set to True, meaning it will emit all SQL
    to a Python logger which will write to standard output.
    """
    engine = create_engine("sqlite+pysqlite:///:memory:",echo=True,future=True)


    with Session(engine) as session:
        createStmt = (text("CREATE TABLE some_table (x int, y int)"))
        createResult = session.execute(createStmt)

        insert_text = text("INSERT INTO some_table(x,y) VALUES (:x,:y)")
        params=[{"x":4,"y":99},
        {"x":12,"y":13},
        {"x":-13,"y":77}]
        session.execute(insert_text,params)

        select_stmt = text("SELECT * FROM some_table WHERE y > :y").bindparams(y=60)
        db_result = session.execute(select_stmt)
        for row in db_result:
            print(f'x: {row.x} y: {row.y}')

    return render_template("hello.html",name=user,otherThing=res,)


async def doSomethingAsync():
    print("Something")
    await asyncio.sleep(5)
    query = """
        query MyQuery {
          environments(name: "Q") {
            id
            name
            clusters {
              name
              id
              description
              deploymentType
              servers {
                description
                name
                operatingSystem
              }
            }
          }
        }
    """
    res = await schema.execute(query)
    return res

async def doSomethingElseAsync():
    print("Something else")
    await asyncio.sleep(3)
    query = """
        query MyQuery {
            joeRandomStr
        }
    """
    res = await schema.execute(query)
    return res

async def nested():
    return 42

@app.route("/")
async def index():
    a = await doSomethingAsync()
    b = await doSomethingElseAsync()
    c = await nested()
    print(c)
    print(b.data["joeRandomStr"])
    print(a)
    return "Hello World" + str(int(random.random()*1000))
