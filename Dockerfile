FROM alpine:3

COPY ./build.sh .

RUN apk add --no-cache bash && \
    bash build.sh && \
    rm build.sh && \
    apk del bash
