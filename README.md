# Atom Container

Run the Atom editor (https://atom.io) inside a Docker container as a native-seeming app on your host.

This container will share certain host directories with the Dockerized Atom, and attempt to keep file ownership untouched so that other applications on the host can directly use/manipulate files in those directories without issue.

#### Some things to know

There are a few notable host directories that will be shared with the Atom container:

- `~/projects`: This is where the code for your various projects is expected to live.

  *Note: The `$PROJECT_HOME` environment variable in the container is set to this location.*

- `~/.virtualenvs`: If you use python virtualenvs, this is where they are stored.

  *Note: The `$WORKON_HOME` environment variable in the container is set to this location.*

- `~/code`: This is for personal code (generally not under RCS).
    
### Installation

1. Create the Docker image. This takes a while, so go take a walk around the building while it works.

```bash
$ make-image.sh
```

2. Create a new Atom container. This is a separate step primarily to ease development, but also makes it simple to reset your Atom environment if you mess it up (easy to do when you are fiddling with packages/themes, or you've mucked up your settings).

```bash
$ create-container.sh
```

### Run Atom

If you use Gnome 3, you should now have a Atom icon in your applications list. (You **might** get an icon under Unity as well, but I'm not sure. Somebody who uses that DE, let me know!)

You'll notice that you sometimes will get prompted for your password when you run Atom - don't panic! This simply means that the file watcher that keeps your host directories owned by you instead of root hasn't been started yet. You should only see that prompt once per login session (or if you manually stop the watcher process).

### Known Bugs

The styling on the Atom app uses some sort of default GTK3 style that doesn't match even the standard Gnome 3 style. It's not disgusting looking though, so I haven't bothered to fix it yet.
