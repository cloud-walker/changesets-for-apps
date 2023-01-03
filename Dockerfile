FROM alpine:3.14
COPY main.sh /main.sh
ENTRYPOINT ["/main.sh"]