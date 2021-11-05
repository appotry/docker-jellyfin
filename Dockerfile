FROM lsiobase/ubuntu:focal

# set version label
# ARG BUILD_DATE
# ARG VERSION
# ARG JELLYFIN_RELEASE
LABEL build_version="sleepgod version:latest Build-date:20211106060947"
LABEL maintainer="sleepgod"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y ca-certificates --no-install-recommends \
	gnupg curl apt-utils && \
 echo "**** install jellyfin 1*****" && \
 curl -s https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add - && \
 echo "**** install jellyfin 2*****" && \
 echo 'deb [arch=amd64] https://repo.jellyfin.org/ubuntu focal main' > /etc/apt/sources.list.d/jellyfin.list && \
 if [ -z ${JELLYFIN_RELEASE+x} ]; then \
        JELLYFIN="jellyfin"; \
 else \
        JELLYFIN="jellyfin=${JELLYFIN_RELEASE}"; \
 fi && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
	at \
	xfonts-wqy \
	fonts-wqy-zenhei \
	fonts-wqy-microhei \
	${JELLYFIN} \
	libfontconfig1 \
	libfreetype6 \
	intel-media-va-driver-non-free \
	vainfo \
	libssl1.1 && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ / 

# ports and volumes
EXPOSE 8096 8920
VOLUME /config
