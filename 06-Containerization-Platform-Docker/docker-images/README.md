### Docker Image

#### 📚 Resources  
- [What is a Docker Image? (Docker Docs)](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-an-image/)

#### 🧪 Practice Commands

Base command for managing Docker images. Use subcommands like ls, inspect, rm, etc.
```bash
docker image
```
Format: 
```bash
docker image COMMAND
```
To Lists all locally stored Docker images along with their repo name, tag, image ID, creation date, and size:
```bash
docker image ls
```
Alias for docker image ls is: 
```bash
docker images
```
To view detailed low-level JSON output for the specified image. Includes metadata like layers, environment vars, entrypoint, etc.
```bash
docker image inspect <IMAGE ID or IMAGE NAME>
```
For eg:
```bash
docker image inspect nginx
```
or
```bash
docker image inspect be69f2940aaf
``


