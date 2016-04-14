#/usr/bin/bash
PWD=`pwd`
XAUTH=/tmp/.docker.xauth
ICON_URL=https://raw.githubusercontent.com/atom/atom/master/resources/app-icons/stable/png/1024.png
VIRTUALENVS_DIR=/home/${USER}/.virtualenvs
PROJECTS_DIR=/home/${USER}/projects
CODE_DIR=/home/${USER}/code
SSH_DIR=/home/${USER}/.ssh
GITCONFIG=/home/${USER}/.gitconfig

xauth nlist :1 | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# clone the Watcher utility, and install deps
rm -rf /home/${USER}/.atom-container-watcher-clone
git clone https://github.com/splitbrain/Watcher.git /home/${USER}/.atom-container-watcher-clone
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yqq python-pyinotify

# install gksu so we can prompt the user when the watcher needs to be started
sudo apt-get install -yqq gksu

# create the watcher config
cat << EOF > /home/${USER}/.atom-container-watcher.ini
[DEFAULT]
logfile=/tmp/atom-container-watcher.log
pidfile=/tmp/atom-container-watcher.pid

[code]
watch=$CODE_DIR
events=create,move_to
excluded=
recursive=true
autoadd=true
command=chown -R ${USER}:${USER} $CODE_DIR

[projects]
watch=$PROJECTS_DIR
events=create,move_to
excluded=
recursive=true
autoadd=true
command=chown -R ${USER}:${USER} $PROJECTS_DIR

[virtualenvs]
watch=$VIRTUALENVS_DIR
events=create,move_to
excluded=
recursive=true
autoadd=true
command=chown -R ${USER}:${USER} $VIRTUALENVS_DIR

EOF

# create mounted host directories if needed
mkdir -p $CODE_DIR
mkdir -p $PROJECTS_DIR
mkdir -p $VIRTUALENVS_DIR

# create the container
docker create -ti \
  -v $CODE_DIR:/code/ \
  -v $PROJECTS_DIR:/projects/ \
  -v $VIRTUALENVS_DIR:/virtualenvs/ \
  -v $SSH_DIR:/root/.ssh:ro \
  -v $GITCONFIG:/root/.gitconfig:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $XAUTH:$XAUTH \
  -e XAUTHORITY=$XAUTH \
  --restart=no \
  --name atom-editor \
  atom-editor

# add an application icon in gnome
curl -#L $ICON_URL -o /home/${USER}/.atom-container-icon.png
cat << EOF > /home/${USER}/.local/share/applications/atom-container.desktop
[Desktop Entry]
Name=Atom
Exec=`pwd`/run-container.sh
Icon=/home/${USER}/.atom-container-icon.png
Type=Application
Categories=Development;

EOF
