#/usr/bin/bash
# start the watcher
python /home/${USER}/.atom-container-watcher-clone/watcher.py status -c /home/${USER}/.atom-container-watcher.ini | grep -v "not running"
if [ $? -ne 0 ]
then
  echo 'Watcher not running, starting it..'
  pkexec python /home/${USER}/.atom-container-watcher-clone/watcher.py start -c /home/${USER}/.atom-container-watcher.ini
  pkexec rm -rf /tmp/.docker.xauth
  sleep 2
fi

# start docker container
xauth nlist :1 | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.xauth nmerge -
docker start atom-editor