# Screeps Server

There are two different type how to start a screeps server.
* [without a world](#create-the-world)
* [with a world already created](#running-the-server)

## <a name="create-the-world"></a>Create the world
If you do not have an existing server directory, just start the Docker container with the command line argument `init`, and everything gets done for you. The `LOCAL_UID` environment variable ensures that the files that are created in the mounted volume have the correct owner set. You can enter any valid (host) uid here or use `$(id -u)` to use the current uid of the logged in user.

```bash
docker run --rm -it -v $PWD:/screeps -e LOCAL_UID=$(id -u) -e STEAM_KEY=YOUR_STEAM_KEY_HERE qnimbus/docker-screeps init
```
Now it's all set to run the Screeps server.

## <a name="running-the-server"></a>Running the server
Make sure you have a server directory (from aprevious installations or by running the 'init' command above).

You can use 'docker-compose' to start the screeps server, create the screeps_net bridged network and start the redis and mongodb instances.

```bash
docker-compose -f docker-compose.yml up -d
```

If you want to start each container manually follow the steps below.

1. Make sure you are in the server directory
2. [Create the custom bridged network](#creating-network)
3. [Start mongo & redis containers](#mongo-redis)
4. Run the server
```bash
docker run --rm -it --name screeps --network screeps_net -v $PWD:/screeps -p 21025:21025 -d -e LOCAL_UID=$(id -u) qnimbus/docker-screeps
```

## Additional setup steps

### <a name="creating-network"></a>Creating a bridged network for MongoDB and Redis

You need to add the screeps, mongo and redis containers to a custom bridged network so the container names are resolvable via DNS on the individual containers. If you do not have a separate custom bridged network you can create one as follows:

```bash
docker network create --attachable -d "bridge" --subnet 172.28.0.0/16 screeps_net
```

*Note: The subnet can be changed to your individual needs as well as the network name ('screeps_net')*

### <a name="mongo-redis"></a>Starting and running MongoDB and Redis

```bash
docker run --rm --name redis --network screeps_net -d -v redis-volume:/data redis
```

```bash
docker run --rm --name mongo --network screeps_net -d -v mongo-volume:/data/db mongo
```

### Creating a password

In order to push your code to your private server you need a password (using `screepsmod-auth`) for your user. You can configure a password by pointing your browser at 
`http://[private-server-ip]:21025/authmod/password/` or by typing `setPassword('your_password')` into the screeps console when logged in on the screeps client.

## Managing the server

### Mods
Mods can be installed by running:
```bash
docker run --rm -v $PWD:/screeps qnimbus/docker-screeps yarn add screepsmod-auth
```
### CLI
The CLI can be accessed by running:
```bash
docker exec -it screeps npx screeps cli
```

## Stopping and starting the server
Stop:
```docker stop screeps```  
Start:
```docker start screeps```

## Updating

1. Stop the server:
  ```docker stop screeps```
2. Remove the server:
  ```docker rm screeps```
3. Remove current image 
  ```docker rmi qnimbus/docker-screeps```
4. Follow [Running the server](#running-the-server)
