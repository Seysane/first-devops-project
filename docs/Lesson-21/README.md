# Lesson 5 Exercises

This section documents exercises from lesson 5

---

#### Exercise requirements

- Create simple app with 2 docker containers:
 - database container (PostgreSQL or MySQL)
 - app container with simple app
- create named volume for databases
- create image for web app
- documentation (this file)

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker network create devops-net a80b5f2ef27a6da1f087eb635b91554c2942b26fd88e074c0d8f8d368855dac8                     
```

##### Creating volume

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker volume create postgres_data
postgres_data
```

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker run -d \                                                  >   --name postgres-db \                                                                                                ata:/var/lib/postgresql/data \                                                                                            -e POSTGRES_D>   --network devops-net \                                                                               >   -v postgres_data:/var/lib/postgresql/data \                                                                         >   -e POSTGRES_DB=devops_db \                                                                                          >   -e POSTGRES_USER=devops_user \                                                                                      >   -e POSTGRES_PASSWORD=devops_pass \                                                                                  >   postgres:16-alpine                                                                                                  Unable to find image 'postgres:16-alpine' locally                                                                       16-alpine: Pulling from library/postgres                                                                                cc7fa208b8a7: Pull complete                                                                                             689a434e3a86: Pull complete                                                                                             55afa1ecc21d: Pull complete                                                                                             2d3064b8615b: Pull complete                                                                                             713473b5b92b: Pull complete                                                                                             c86ab38aa6db: Pull complete                                                                                             0749aef11dca: Pull complete                                                                                             4096c457dc0d: Pull complete                                                                                             ef6ab46d98b2: Pull complete                                                                                             2f537278bc74: Pull complete                                                                                             7af924000309: Pull complete                                                                                             015d68c2a4bf: Download complete                                                                                         4ecb750a4bb0: Download complete                                                                                         Digest: sha256:57c72fd2a128e416c7fcc499958864df5301e940bca0a56f58fddf30ffc07777                                         Status: Downloaded newer image for postgres:16-alpine                                                                   a0eb037c684906ddf93e0f62240b4519778938b05ec8e239e0c3cfc5724db0b2                                   
```

##### Creating docker image

```bash                   
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker build -t my-web-app:1.0 .[+] Building 8.1s (10/10) FINISHED                                                                       docker:default  => [internal] load build definition from Dockerfile                                                               0.1s  => => transferring dockerfile: 286B                                                                               0.0s  => [internal] load metadata for docker.io/library/python:3.11-slim                                                1.4s  => [internal] load .dockerignore                                                                                  0.1s  => => transferring context: 2B                                                                                    0.0s  => [1/5] FROM docker.io/library/python:3.11-slim@sha256:db3ff2e1800a8581e2c48a27c3995339d47bdf046da21c7627accd3d  1.4s  => => resolve docker.io/library/python:3.11-slim@sha256:db3ff2e1800a8581e2c48a27c3995339d47bdf046da21c7627accd3d  0.1s  => => sha256:c89b9f64c028c19ba92e195d7589d914b9cd1fc69f3c3dfeb931e93876ac2064 248B / 248B                         0.1s  => => sha256:6b265b8eae4a26a263eb55546aa430c1eef37032a7cd86393d98c6b779f28319 14.42MB / 14.42MB                   0.7s  => => sha256:9775d166087aba0afe5ba9a88859c04c08090e82ae218742d09fec9119e0335d 1.29MB / 1.29MB                     0.5s  => => extracting sha256:9775d166087aba0afe5ba9a88859c04c08090e82ae218742d09fec9119e0335d                          0.1s  => => extracting sha256:6b265b8eae4a26a263eb55546aa430c1eef37032a7cd86393d98c6b779f28319                          0.3s  => => extracting sha256:c89b9f64c028c19ba92e195d7589d914b9cd1fc69f3c3dfeb931e93876ac2064                          0.0s  => [internal] load build context                                                                                  0.1s  => => transferring context: 1.40kB                                                                                0.0s  => [2/5] WORKDIR /app                                                                                             0.1s  => [3/5] COPY requirements.txt .                                                                                  0.1s  => [4/5] RUN pip install --no-cache-dir -r requirements.txt                                                       2.9s  => [5/5] COPY app.py .                                                                                            0.1s  => exporting to image                                                                                             1.6s  => => exporting layers                                                                                            1.0s  => => exporting manifest sha256:0fd7f6ec7f2e8571d3cbcaa2cca02439873497350bef087afe6933b5b081daa4                  0.0s  => => exporting config sha256:3f5704f149f64895dd3ae659771fed13240e4603bb10c0f0d477381dc10e91d2                    0.0s  => => exporting attestation manifest sha256:93ebf7e83a1d87700d866f4f5b3a774d6ad8e8918faad4426deeac9b076e7e1c      0.1s  => => exporting manifest list sha256:d3429da51a6b8d88cb5403eaace7169f0dd8b0711a98b718b03852958a12851f             0.0s  => => naming to docker.io/library/my-web-app:1.0                                                                  0.0s  => => unpacking to docker.io/library/my-web-app:1.0                                                               0.3s 
```

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker run -d \                                                  >   --name web-app \                                                                                                    HOST=postgres-db \                                                                                                        -e DB_NAME=devops_db \                                                                                                  -e DB_US>   --network devops-net \                                                                                    >   -p 5000:5000 \                                                                                                      >   -e DB_HOST=postgres-db \                                                                                            >   -e DB_NAME=devops_db \                                                                                              >   -e DB_USER=devops_user \                                                                                            >   -e DB_PASS=devops_pass \                                                                                            >   my-web-app:1.0
2cd63e84360abb028f34ec5c6b1d01679f63260871717da9005beed4a5edaf8c                                   
```

##### Testing 1.0 with curl

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ curl http://localhost:5000 {"message":"Po\u0142\u0105czono pomy\u015blnie z baz\u0105 danych PostgreSQL!","status":"success","total_visits":1}     
```


```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ curl http://localhost:5000 {"message":"Po\u0142\u0105czono pomy\u015blnie z baz\u0105 danych PostgreSQL!","status":"success","total_visits":2} 
```

We can see that total_visits counter is counting, now I will stop and remove database

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker stop postgres-db postgres-db                                                                                        ```

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker rm postgres-db postgres-db                                                                                        
```

Now I will run container with database again

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-21$ docker run -d\ 
--name postgres-db \                                                                                                ata:/var/lib/postgresql/data \                                                                                            -e POSTGRES_D>   --network devops-net \                                                                               >   -v postgres_data:/var/lib/postgresql/data \                                                                         >   -e POSTGRES_DB=devops_db \                                                                                          >   -e POSTGRES_USER=devops_user \                                                                                      >   -e POSTGRES_PASSWORD=devops_pass \                                                                                  >   postgres:16-alpine                                                                                 816aad8c645463050d5096e2b50ade6ed46adc1f6e682d4f591443332012b1ca
```

##### Testing 2.0 with curl

```bash                  
sane@power-sane:~/first-devops-project/docs/Lesson-21$ curl http://localhost:5000 {"message":"Po\u0142\u0105czono pomy\u015blnie z baz\u0105 danych PostgreSQL!","status":"success","total_visits":3}     
```


So the database still counts and the data is safe.