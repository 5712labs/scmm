```shell script
docker builder prune
docker build -t scmm .
docker run -d -it --name scmmcon -p 8000:8000 -v .:/app scmm
docker exec -it scmmcon /bin/bash

or 

docker build --platform linux/amd64 -t scmm .
docker run --platform linux/amd64 -d -it --name scmmcon -p 8000:8000 -v .:/app scmm
```

```shell script
echo "# scmm" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/5712labs/scmm.git
git push -u origin main
```

```shell script
git remote add origin https://github.com/5712labs/scmm.git
git branch -M main
git push -u origin main
```
