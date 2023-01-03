FROM alpine
COPY main.sh /main.sh
ENTRYPOINT ["/main.sh"]