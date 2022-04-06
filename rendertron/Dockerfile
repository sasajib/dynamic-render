# Source images
FROM "docker.io/bitnami/minideb:bullseye" as minideb

# The build stage
FROM "node:17-bullseye" AS build

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
	"https://github.com/GoogleChrome/rendertron.git"
WORKDIR "/app/rendertron"

# Run the build
RUN \
	npm "install" && \
	npm "run" "build"

# The main image
FROM "node:17-bullseye"

ARG QUAY_EXPIRATION="Never"
SHELL [ "/bin/bash", "-e", "-u", "-o", "pipefail", "-c" ]

# Add the labels for the image
LABEL org.opencontainers.image.vendor="University of Helsinki"
LABEL org.opencontainers.image.authors="University of Helsinki"

LABEL org.opencontainers.image.title="Rendertron"
LABEL org.opencontainers.image.description="TODO"
LABEL org.opencontainers.image.version="17"

LABEL org.opencontainers.image.base.name="docker.io/library/node:17-bullseye"

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

# Install the requirements for Rendertron/Chrome
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

# Copy the built Rendertron
COPY --from=build \
	"/app/rendertron" \
	"/app/rendertron"

# Set up the environment
EXPOSE 3000
WORKDIR "/app/rendertron"
CMD [ "npm", "run", "start" ]
