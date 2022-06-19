import flask
import sqlalchemy
from flask import Flask, render_template
from strawberry.flask.views import GraphQLView
from sqlalchemy import create_engine, text, MetaData, Table, ForeignKey
from sqlalchemy.orm import Session, sessionmaker, scoped_session
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
    clusters = db.relationship("Cluster", order_by = "Cluster.id", back_populates = "environment")

    def __init__(self,name=""):
        self.name = name

class Cluster(db.Model):
    __tablename__ = "ampcluster"
    id = db.Column("ID",db.Integer,primary_key=True)
    environmentID = db.Column("EnvironmentID",db.Integer,ForeignKey('ampenvironment.ID'))
    name = db.Column("Name",db.String(100))
    description = db.Column("Description",db.String(255))
    deploymentTypeID = db.Column("DeploymentType",db.Integer,ForeignKey('ampdeploymenttype.ID'))
    environment = db.relationship("Environment", back_populates = "clusters")
    deploymentType = db.relationship("DeploymentType", back_populates = "clusters")
    servers = db.relationship("Server", order_by = "Server.id", back_populates = "cluster")

class DeploymentType(db.Model):
    __tablename__ = "ampdeploymenttype"
    id = db.Column("ID",db.Integer,primary_key=True)
    shortName = db.Column("ShortName",db.String(10))
    name = db.Column("Name",db.String(100))
    clusters = db.relationship("Cluster", order_by = "Cluster.id", back_populates = "deploymentType")

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
    clientAPIs = db.relationship("API",secondary="ampapiapi",primaryjoin="API.id==APIAPI.targetAPIID",secondaryjoin="API.id==APIAPI.sourceAPIID",overlaps="targetAPIs")
    targetAPIs = db.relationship("API",secondary="ampapiapi",primaryjoin="API.id==APIAPI.sourceAPIID",secondaryjoin="API.id==APIAPI.targetAPIID",overlaps="clientAPIs")
    instances = db.relationship("APIInstance",order_by = "APIInstance.id", back_populates = "api")
    apiSystems = db.relationship("APISystem", order_by = "APISystem.id", back_populates = "api")

class System(db.Model):
    __tablename__ = "ampsystem"
    id = db.Column("ID",db.Integer,primary_key=True)
    name = db.Column("Name",db.String(100))
    description = db.Column("Description",db.String(255))
    apiSystems = db.relationship("APISystem", order_by = "APISystem.id", back_populates = "system")

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
    db.create_all()

except BaseException as e:
    print(e)
finally:
    print("finally")

print("About to create engine")
print(app.config["SQLALCHEMY_DATABASE_URI"])
try:
    engine = create_engine(app.config["SQLALCHEMY_DATABASE_URI"])
except BaseException as e:
    print("except")
    print(e)
finally:
    print("finally")
print("After creating engine1")

try:
    print("Aloha")
    c = Cluster()
    print("Before query")
    e = Environment.query.filter(Environment.name=="Dev").first()
    print("Environment...")
    print(e)
    d = DeploymentType.query.filter(DeploymentType.shortName=="ON_PREM").first()
    print("DeploymentType...")
    print(d)
    c.environment = e
    #c.environmentID = 1
    #c.deploymentTypeID = 1
    c.name = "XMyOwnCluster"
    c.description = "aaaaa abcdefg"
    c.deploymentType = d
    #c.deploymentTypeID = d.id

    d1 = DeploymentType()
    d1.shortName = "F1"
    d1.name = "Fake Deployment Type"
    print(d1.clusters)

    c.deploymentType = d1

    session = scoped_session(sessionmaker(autocommit=False,autoflush=False,bind=engine))
    print(session)

    print("Is there a current session for d1?")
    print(session.object_session(d1))

    """print("About to find the current session holding onto Cluster c")
    clusterSession = session.object_session(c)
    print(clusterSession)
    clusterSession.close()

    session.add(c)

    session.commit()"""
except BaseException as e:
    print("except1234")
    print(type(e))
    print(e)
finally:
    print("WOOHOO")

app.add_url_rule(
    "/joegraphql",
    view_func=GraphQLView.as_view("joegraphql_view", schema=schema, graphiql=True),
)

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

@app.route("/api/<apiName>")
def apiPage(apiName):
    api = API.query.filter_by(name = apiName).first()
    if api == None:
        return "No API named <b>{apiName}</b> in the AMP system.".format(apiName=apiName)

    environments = []
    for instance in api.instances:
        environments.append(instance.cluster.environment)
    envs=sorted(set(environments), key=lambda e: e.name)
    return render_template("api.html",api=api,environments=envs)
    """for instance in api.instances:
        res += "API <b>{apiName}</b> is running on cluster {clusterName} (servers: {servers}) in environment {envName}. Systems: {systems}".format(
            apiName=instance.api.name,
            clusterName=instance.cluster.name,
            servers=instance.cluster.servers,
            systems=instance.api.apiSystems,
            envName=instance.cluster.environment.name)
        res += "<br /><br />"
        res += "API {apiName} has the following client APIs:".format(apiName=instance.api.name)
        if instance.api.clientAPIs != None:
            for clientAPI in instance.api.clientAPIs:
                res += clientAPI.name
        res += "API {apiName} has the following target APIs:".format(apiName=instance.api.name)
        if instance.api.targetAPIs != None:
            for targetAPI in instance.api.targetAPIs:
                res += targetAPI.name
        print()
        print()
    print("After create_all()")
    return "Hello this is the API page for API named " + apiName + "<br /><br/>" + res;
    """
