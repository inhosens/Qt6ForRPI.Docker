## Cross Compile QT 6.6.1 for Raspberry 4 using Docker

## Build Ubuntu Qt-Host
```
docker build -f Dockerfile.host -t qthost .
```

## Compile Qt 6.6.1 Host fetching qt-6.6.1
```
docker run qthost
```

## Or compile Qt Host with existing qt source
```
docker run --mount type=bind,source=<Existing Qt source>,target=/src/qt6 qthost
```
or
```
docker run -v <Existing Qt source>:/src/qt6 qthost
```

## Commit Host to a new image
```
docker ps -a #Find the ID of the build container
docker commit {ID} qthost
```

## Create build and built directories
### build contains the cross compiled Qt 6.6.1
```
mkdir qt-raspi
```

## Build Qt 6.6.1 Raspberry Pi image
```
docker build -f Dockerfile.rpi -t qtrpi .
```

## Compile Qt 6.6.1 for Raspberry Pi
```
docker run \
	-v $(pwd)/qt-raspi:/opt/qt-raspi \
	-v <Existing Qt source>:/src/qt6 \
	qtrpi
```
