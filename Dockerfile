FROM alpine/git:2.49.1
COPY check.sh /check.sh
ENTRYPOINT ["/check.sh"]