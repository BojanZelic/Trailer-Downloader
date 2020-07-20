# Trailer-Downloader
A simple set of python scripts for downloading a movie trailer from Apple or from YouTube with help from TMDB. For quality purposes, the scripts will always attempt to download a trailer from Apple before falling back to TMDB and YouTube. You can also download missing trailers for an entire library at once or integrate the script with Radarr or Tautulli to download trailers automatically. This project is useful if you are running a media server like Plex and you would like to have local trailers for each of your movies.

## Requirements
-[FFmpeg](https://github.com/FFmpeg/FFmpeg)

-[Python 3.0+](https://www.python.org/)

-[requests](https://github.com/psf/requests)

-[tmdbsimple](https://github.com/celiao/tmdbsimple/blob/master/README.rst) + TMDB API Key

-[youtube-dl](https://github.com/rg3/youtube-dl/blob/master/README.md#installation)

-[unidecode](https://github.com/avian2/unidecode)

## Installation
1. Install [FFmpeg](https://github.com/FFmpeg/FFmpeg)

2. Install python requirements
```
sudo python3 -m pip install -r requirements.txt
```

## Settings
```
cp settings.ini.example settings.ini
```
Create and edit the **settings.ini** file. Here you can add your api key for TMDB and set up your country code, language, resolution settings, subfolders, and custom formatting options.

## Usage

### Download Trailer For Specific Movie

To download a trailer for a specific movie, use the command below. You will need to provide the movie title, year, and directory to the script.
```
python3 download.py --title "A Star Is Born" --year "2018" --directory "/path/to/movies/A Star Is Born (2018)"
```

### Download Trailers For All Movies In A Directory

To download trailers for an entire library that already exists, use the command below. You will need to supply the directory that all of your movie folders are in. The script will iterate through all of your movie folders in the directory and it will automatically pull the title and year from the folder name. Trailers will be downloaded into the folder for each movie.
```
python3 download_all.py --directory "/path/to/movies"
```

### Download Trailer Automatically

This script can also be fired by Radarr or Tautulli to automatically download a trailer each time a new movie is added to your collection.

#### Radarr
To set this up, open Radarr and go to Settings > Connect. Create a new notification and set the type to "Custom Script". Choose a name for your script and check the boxes for "On Import", "On Upgrade", and "On Rename". Set the path to point to the **download_radarr.py** script and be sure to save your changes.

#### Tautulli
To set this up, open Tautulli and go to Settings > Notification Agents and add a new notification agent. The type should be "script" and you'll want to add the path to the folder the scripts are located in and select **download_tautulli.py** as your script in the configuration tab. Also add a name for the description. Next, go to the triggers tab and check the box for "Recently Added" and then go to the conditions tab and add a condition to only fire when "media type is movie". For the arguments tab, go to the "Recently Added" section and add the snippet below. Be sure to save it and you're all set.
```
<movie>nopythonpath python3 --file "{file}"</movie>
```

## Notes
#### Docker Standalone

```
docker run \
  -v /path/to/settings.ini:/usr/src/app/settings.ini \
  -v /path/to/movies:/videos \
    bojanzelic/trailer-downloader
````

#### Docker inside Radarr or Tautilli

If you're running Radarr or Tautulli inside a Docker container and you would like to use the automated downloading script, the container will need access to the scripts and the requirements will need to be installed inside the container. An easy way of doing that is just to attach this set of scripts to the container as a volume. Then you can exec into the container and install the requirements. Here's an example of doing that with Tautulli.

This will attach the scripts to the /scripts folder in the container (-v /path/to/scripts:/scripts).
```
docker run --name tautulli --restart=always -p 8181:8181 \
  -v /path/to/config:/config \
  -v /path/to/logs:/logs \
  -v /path/to/scripts:/scripts \
  linuxserver/tautulli
```

This will install the requirements inside the container.
```
docker exec -it tautulli /bin/bash -c "apk add --no-cache python3 && /usr/bin/python3 -m pip install -r /scripts/requirements.txt"
```

#### Structure

These scripts expect your movies to be in a very specific structure. If your movies do not match the format below, you **will not** be able to use this.

-Movies  
---Movie Title 1 (2014)  
-----Movie Title 1 (2014).mp4  
---Movie Title 2 (2009)  
-----Movie Title 2 (2009).mkv  

Enjoy!