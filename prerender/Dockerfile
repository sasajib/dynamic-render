# Source images
FROM "docker.io/bitnami/minideb:bullseye" as minideb

# The build stage
FROM "node:18-bullseye" AS build

# Install the installer script
COPY --from=minideb \
	"/usr/sbin/install_packages" \
	"/usr/sbin/install_packages"

# Create the application directory
RUN mkdir "/app"
WORKDIR "/app"

# Install the tools needed
RUN install_packages \
	"git"

# Get the application itself
RUN git "clone" \
	"https://github.com/prerender/prerender.git"
WORKDIR "/app/prerender"

# Run the build
RUN \
	npm "install"

# Copy the new server.js that works with container
COPY "server.js" "/app/prerender/server.js"

# The main image
FROM "node:18-bullseye"

ARG QUAY_EXPIRATION="Never"
SHELL [ "/bin/bash", "-e", "-u", "-o", "pipefail", "-c" ]

# Add the labels for the image
LABEL org.opencontainers.image.vendor="University of Helsinki"
LABEL org.opencontainers.image.authors="University of Helsinki"

LABEL org.opencontainers.image.title="Prerender"
LABEL org.opencontainers.image.description="TODO"
LABEL org.opencontainers.image.version="18"

LABEL org.opencontainers.image.base.name="docker.io/library/node:18-bullseye"

LABEL quay.expires-after="${QUAY_EXPIRATION}"

# Install the installer script
COPY --from=minideb \
	"/usr/sbin/install_packages" \
	"/usr/sbin/install_packages"

# Install the Chrome package repo
RUN curl --silent --show-error --location \
	"https://dl-ssl.google.com/linux/linux_signing_key.pub" \
	| gpg --no-default-keyring \
	--keyring "gnupg-ring:/etc/apt/trusted.gpg.d/google.gpg" \
	--import \
	&& chown "_apt" "/etc/apt/trusted.gpg.d/google.gpg"
COPY "google-chrome.list" "/etc/apt/sources.list.d/google-chrome.list"

# Install the requirements for Chrome
RUN install_packages \
	"fonts-ipafont-gothic" \
	"fonts-wqy-zenhei" \
	"fonts-thai-tlwg" \
	"fonts-kacst" \
	"fonts-freefont-ttf" \
	"libxss1" \
	"xserver-common" \
	"x11-utils" \
	"x11-xserver-utils" \
	"google-chrome-stable"

# Install prerender packages
RUN mkdir --parents "/app/prerender"
WORKDIR "/app/prerender"
RUN npm "install" "prerender"

# Copy the application
COPY --from=build \
	"/app/prerender" \
	"/app/prerender"

# Set up the environment
EXPOSE 3000
WORKDIR "/app/prerender"
CMD [ "node", "server.js" ]
