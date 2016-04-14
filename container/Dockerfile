FROM ubuntu

RUN apt-get clean -qq all && apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -qqy && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl ca-certificates git gconf2 gconf-service libgtk2.0-0 libnotify4 libxtst6 libnss3 python gvfs-bin xdg-utils

ENV DISPLAY :1
ENV WORKON_HOME /virtualenvs
ENV PROJECT_HOME /projects

RUN curl -#L https://atom.io/download/deb -o atom.deb && dpkg -i atom.deb

WORKDIR /root/

# copy preserved configs
RUN mkdir -p .atom
COPY config/* .atom/

# install packages/themes
RUN apm install atom-material-ui
RUN apm install atom-material-syntax
RUN apm install minimap
RUN apm install minimap-find-and-replace
RUN apm install minimap-cursorline
RUN apm install minimap-selection
RUN apm install minimap-codeglance

CMD ["/usr/bin/atom", "-f"]
