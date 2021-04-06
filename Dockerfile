FROM golang:alpine 

WORKDIR $GOPATH/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

EXPOSE 8080

CMD ["tfc-operator-demo-app"]