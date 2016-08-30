PWD=`pwd`
CID=`docker run -d -v $PWD:/grpc umegaya/gcc ping localhost`
echo $CID
docker exec $CID bash -c "cd /grpc && make && make install && make -C third_party/protobuf install"
docker commit $CID umegaya/protobuf

