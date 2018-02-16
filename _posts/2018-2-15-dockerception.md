---
title: "Docker-in-Docker-in-Docker"
layout: post
date: 2018-02-15 20:00
image: /assets/images/posts/Docker-Gopher-Banner.png
headerImage: true
tag:
- golang
- docker
- tools
star: false
category: blog
author: robert
description: Docker, docker-compose, and SSH services in Docker
---

Last Sunday I finally had a morning at home to relax, and at long last I got to see what my room looks like during the day.

<p align="center">
    <a href="https://www.instagram.com/p/BfCDws3h81K/?taken-by=savethefade">
        <img src="/assets/images/home.jpg" width="75%" />
    </a>
</p>

<p align="center">
    <i>Peace.</i>
</p>

For _ A E S T H E T I C _ purposes there's only one plant in this picture but it has a few friends on the shelves below. I'll need to eat more jam soon because I'm running a bit short on jars.

# Prelude

Outside of work, my main focus has been UBC Launchpad's [Inertia](https://github.com/ubclaunchpad/inertia) project, of which I am now the project lead. The idea is to provide a [Heroku](https://www.heroku.com)-like application without being restricted to Heroku's servers - in other words, we wanted a simple, plug-and-play continuous deployment solution for any VPS. We felt this could be particularly useful for us thanks to sponsorships from VPS companies that Launchpad frequently receives (and then inevitably loses after a while) - quick redeployment was always a hastle. This would also provide us with a way to easily deploy internal projects for demonstrations.

Early on, we decided to focus on supporting Docker projects - specifically docker-compose ones - to make life a little bit easier to use. Docker is a containerization platform that has blown up in popularity over the last few years, mostly thanks to its incredible ease of use. Docker-compose is a layer on top of the typical `Dockerfile`s you see in that it can be used to easily build and start up multiple containers at once using the command `docker-compose up`. This meant that we could let Docker handle the nitty gritty of building things and focus on polishing our tool. 

We wanted to provide users with a seamless CLI experience for setting up a continuously deploying instance of their application. Architecturally, we decided on a CLI and daemon combination:

<p align="center">
    <a href="https://github.com/ubclaunchpad/inertia/blob/master/.demo/inertia-v0-0-2-slides.pdf">
        <img src="/assets/images/posts/inertia-diagram.png" width="100%" />
    </a>
</p>

<p align="center">
    <i>A slide from a presentation I gave about Inertia.</i>
</p>

# Docker in Docker

We decided it would be simplest if we simply pulled the Inertia Docker image serverside and ran that as our daemon. This meant that our daemon would be a Docker container with the permission to build and start other Docker images.

However, our team member [Chad](https://github.com/chadlagore) came across an interesting [hack](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) that involved just a few steps when running our Inertia image:
- mount the host machine Docker socket onto the container - this granted access to the container, and through this socket, the container will be able to execute Docker commands on the host machine rather than just within itself.
- mount relevant host directories into the container - this includes things like SSH keys.

This practice is called "Docker-in-Docker" and for the most part seemed [discouraged](https://www.lvh.io/posts/dont-expose-the-docker-socket-not-even-to-a-container.html), since it granted the Docker container considerable access to the host machine through the Docker socket, in contradiction to Docker's design principles. And I can definitely understand why - the video in the link above demonstrates just how much power you have over the host machine if you can access the Docker-in-Docker container (effectively that of a root user, allowing you access to everything, even adding SSH users!). However, for our purposes, if someone does manage to SSH into a VPS to access the daemon container... then the VPS has already been compromised, and I guess that's not really our problem.

Implementation wise, this setup was just a long `docker run` command:

```bash
sudo docker run -d --rm                              `# runs container detached, remove image when shut down` \
    -p "$PORT":8081                                  `# exposes port on host machine for daemon to listen on` \
    -v /var/run/docker.sock:/var/run/docker.sock     `# mounts host's docker socket to the same place on the container` \
    -v $HOME:/app/host                               `# mounts host's directories for container to use` \
    -e DAEMON="true"                                 `# env variable for inertia code - CLI and daemon share the same codebase` \
    -e HOME=$HOME                                    `# exports HOME variable to the container` \
    -e SSH_KNOWN_HOSTS='/app/host/.ssh/known_hosts'  `# points env variable to SSH keys` \
    --name "$DAEMON_NAME"                            `# name our daemon baby` \
    ubclaunchpad/inertia
```

INTERESTING TIDBIT: multiline bash commands don't work the way you expect that they should. The snippet above uses [command substitution](https://stackoverflow.com/a/12797512) to sneak in some comments, instead of this:

```bash
sudo docker run -d --rm \
    -p "$PORT":8081 \ # my comment???? -> breaks the command :(
    ...
```

Anyway, by starting the daemon with these parameters, if we `docker exec -it inertia-daemon sh` into the container, we can install Docker and start up new containers on the host, which is *almost* what we want.

# docker-compose in Docker

With the daemon running with *access* to the Docker socket, we didn't want to keep relying on bash commands. While it was inevitable that we would have to run SSH commands on the server from the client to set up the daemon, we wanted to avoid doing that to start project containers.

Fun fact: Docker is built on Go, and the [moby](https://github.com/moby/moby) (formerly Docker) repository has a nice, developer-oriented API for the Docker engine - using this means that we could avoid having to set up Docker all over again in the daemon's container.

```go
import (
    docker "github.com/docker/docker/client"
    "github.com/docker/docker/api/types"
    "github.com/docker/docker/api/types/container"
    "github.com/docker/docker/api/types/filters"
)

func example() {
    cli, _ := docker.NewEnvClient()
    defer cli.Close()
    ctx := context.Background()

    resp, _ := cli.ContainerCreate(ctx, /* ...params... */ )
    _ = cli.ContainerStart(ctx, resp.ID, types.ContainerStartOptions{})
}
```

This functionality makes everything fairly straight forward if you already have your Docker image ready and on hand. However, building the an image from docker-compose is an entirely different issue. Docker-compose is not a standard part of the Docker build tools, and that meant that Docker's Golang client did not offer a nice docker-compose function outside of an [experimental library](https://github.com/docker/libcompose). That library was definitely an option, but the big bold "EXPERIMENTAL" warning made me feel a little uncomfortable.

In hindsight, that library would definitely have been the better idea. In fact, as I was writing this post I opened up a [ticket](https://github.com/ubclaunchpad/inertia/issues/87) pointing out that we should probably look into making the move... but ultimately what I ended up doing wasn't too bad, although it was a bit "hacky".

The idea came from the fact that Docker offers a [docker-compose image](https://hub.docker.com/r/docker/compose/), and I believe what I did is what it was intended for - my initial attempt:

```bash
docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME:/build \
    -w="/build/project" \
    docker/compose:1.18.0 up --build
```

From the Daemon, I downloaded and launched the docker-compose image while granting it access to the host's Docker socket and directories (where the cloned repository is). This started a Docker container alongside the Daemon container, that then started the user's project containers alongside itself! Dockerception.

Now that I knew this worked, doing it with the Golang Docker client was just a matter replicating the command:

```go
cli, _ := docker.NewEnvClient()
defer cli.close(()
ctx := context.Background()
// Pull docker-compose image
cli.ImagePull(context.Background(), dockerCompose, types.ImagePullOptions{})

// Build docker-compose and run the 'up' command
resp, err := cli.ContainerCreate(
    ctx, &container.Config{
        Image:      dockerCompose,
        WorkingDir: "/build/project",
        Env:        []string{"HOME:/build"},
        Cmd:        []string{"up", "--build"}, // 'docker-compose up --build'!!!
    },
    &container.HostConfig{
        Binds: []string{ // set up mounts - equivalent of '-v'
            "/var/run/docker.sock:/var/run/docker.sock",
            os.Getenv("HOME") + ":/build",
        },
    }, nil, "docker-compose",
)
```

While it seemed to work for simple projects, at NWHacks, when I attempted to deploy my [team's project](https://bobheadxi.github.io/borrow-me/) using Inertia, it didn't build. The more I think about it, the worse I realise this idea was... but hey, who knows, knowing this might come in handy some day. Either way, now I'm quite eager to see if [libcompose](https://github.com/docker/libcompose) (the library I mentioned earlier) fares any better.

If once you fail, try, try again?

**Update:** Libcompose has proved hell to get working properly. Thanks to some wild conflicts and breakages, I had to rely on the `master` branch of both `docker/docker` and `docker/libcompose` and add a few commit-specific constraints:

```
[[constraint]]
  name = "github.com/docker/docker"
  branch = "master"

# Lock to commit before introduction of prometheus analytics (breaks our build)
[[override]]
  name = "github.com/docker/distribution"
  revision = "13076371a63af450031941c2770e412439de65d4"

# Lock to commit before something that also breaks our build
[[override]]
  name = "github.com/xeipuuv/gojsonschema"
  revision = "0c8571ac0ce161a5feb57375a9cdf148c98c0f70"
```

And I haven't even tried using it yet. Maybe the docker-compose container wasn't such a bad idea after all.

# SSH Services in Docker

The next issue was testing. For a while most of us tested Inertia on a Google Cloud VPS, but I really wanted a way to test locally, so at some point I [simply ran the Inertia Daemon locally](https://github.com/ubclaunchpad/inertia/pull/30) to make sure everything worked.

```bash
inertia init
inertia remote add local 0.0.0.0 -u robertlin
docker build -t inertia .
sudo docker run \
    -p 8081:8081 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/bin/docker:/usr/bin/docker \
    -v $HOME:/app/host \
    -e SSH_KNOWN_HOSTS='/app/host/.ssh/known_hosts' \
    -e HOME=$HOME --name="inertia-daemon" inertia
# ...
inertia local up # project deploys!
```

This was far from ideal - I was more or less testing if Inertia worked on MacOS (which I'm pretty sure is not a popular VPS platform) and we were unable to really test any of Inertia's SSH functionalities or SSH key generation or Docker setup, to name a few. However, it did give Chad the idea to use [Docker to simulate a VPS](https://github.com/ubclaunchpad/inertia/issues/23), and perhaps even launch it on [Travis CI](https://travis-ci.org/ubclaunchpad/inertia) for instrumented tests.

To do this, a bit of setup outside of just pulling an Ubuntu Docker image had to be done - namely SSH setup. [This guide from Docker](https://docs.docker.com/engine/examples/running_ssh_service/) helped me get started, and my initial `Dockerfile.ubuntu` was pretty much exactly the example in the post.

```bash
ARG VERSION
FROM ubuntu:${VERSION}

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:inertia' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
```

This first part is from the example and it pulls the requested Ubuntu image, downloads and installs SSH tools and sets up a user and password (`root` and `inertia` respectively), as well as some other things that still make no sense to me.

Inertia is too cool for passwords and instead relies on SSH keys, so I had to add this:

```bash
RUN echo "AuthorizedKeysFile     %h/.ssh/authorized_keys" >> /etc/ssh/sshd_config
# Copy test key to allow use
RUN mkdir $HOME/.ssh/
COPY . .
RUN cat test_key.pub >> $HOME/.ssh/authorized_keys
```

The first command writes my line (`"AuthorizedKeysFile..."`) into the given file (`/etc/ssh/sshd_config`) and 
then copies the key (which I set up beforehand) into the container.  This allows me to SSH into the service.

```bash
EXPOSE 0-9000
CMD ["/usr/sbin/sshd", "-D"]
```

Note that `EXPOSE` does NOT mean "publish". It simply says that this container should be accessible through these ports, but to access it from the host, we'll need to publish it on run. I opted to expose every port from 0 to 9000 to make it easier to change the ports I am publishing.

```bash
docker run --rm -d `# run in detached mode and remove when shut down` \
    -p 22:22       `# port 22 is the standard port for SSH access` \
    -p 80:80       `# arbitrary port that an app I used to present needed` \
    -p 8000:8000   `# another arbitrary port for some Docker app` \    
    -p 8081:8081   `# port for the inertia daemon` \
    --name testvps \
    --privileged   `# because this is a special container` \
    $IMAGE
```

To facilitate simpler building, a Makefile (which I use in every project nowadays):

```
SSH_PORT = 22
VERSION  = latest
VPS_OS   = ubuntu

test:
    make testenv-$(VPS_OS) VERSION=$(VERSION)
    go test $(PACKAGES) --cover

testenv-ubuntu:
    docker stop testvps || true && docker rm testvps || true
    docker build -f ./test_env/Dockerfile.ubuntu \
        -t ubuntuvps \
        --build-arg VERSION=$(VERSION) \
        ./test_env
    bash ./test_env/startvps.sh $(SSH_PORT) ubuntuvps
```

This way you can change what VPS system to test against using arguments, for example `make testenv-ubuntu VERSION=14.04`.

And amazingly this worked! The VPS container can be treated just as you would treat a real VPS.

```bash
make testenv-ubuntu 
# note the location of the key that is printed
cd /path/to/my/dockercompose/project
inertia init
inertia remote add local 
# PEM file: inertia test key, User: 'root', Address: 0.0.0.0 (standard SSH port)
inertia local init
inertia remote status local
# Remote instance 'local' accepting requests at http://0.0.0.0:8081
```

I could even include instrumented tests and everything worked perfectly:

```go
func TestInstrumentedBootstrap(t *testing.T) {
    remote := getInstrumentedTestRemote()
    session := NewSSHRunner(remote)
    var writer bytes.Buffer
    err := remote.Bootstrap(session, "testvps", &Config{Writer: &writer})
    assert.Nil(t, err)

    // Check if daemon is online following bootstrap
    host := "http://" + remote.GetIPAndPort()
    resp, err := http.Get(host)
    assert.Nil(t, err)
    assert.Equal(t, resp.StatusCode, http.StatusOK)
    defer resp.Body.Close()
    _, err = ioutil.ReadAll(resp.Body)
    assert.Nil(t, err)
}
```

Frankly I was pretty surprised this worked so beautifully. The only knack was that specific ports had to be published for an app deployed to a container VPS to be accessible, but I didn't think that was a big deal. I also set up a Dockerfile for [CentOS](https://github.com/ubclaunchpad/inertia/blob/master/test_env/Dockerfile.centos) which took quite a while and gave me many headaches - you can click the link to see it if you want.

With all this set up, I could include it in our Travis builds to run instrumented tests on different target platforms:

```yml
services:
  - docker

# Test different VPS platforms we want to support
env:
  - VPS_OS=ubuntu VERSION=16.04
  - VPS_OS=ubuntu VERSION=14.04
  - VPS_OS=centos VERSION=7
  - VPS_OS=ubuntu VERSION=latest
  - VPS_OS=centos VERSION=latest

before_script:
  # ... some stuff ...
  # This will spin up a VPS for us. Travis does not allow use
  # of Port 22, so map VPS container's SSH port to 69 instead. 
  - make testenv-"$VPS_OS" VERSION="$VERSION" SSH_PORT=69

script:
  - go test -v -race
```

And now we can look all professional and stuff with all these Travis jobs that take forever!

<p align="center">
    <a href="https://travis-ci.org/ubclaunchpad/inertia">
        <img src="/assets/images/posts/travis-builds.png" width="100%" />
    </a>
</p>

<p align="center">
    <i>Builds for days!!</i>
</p>