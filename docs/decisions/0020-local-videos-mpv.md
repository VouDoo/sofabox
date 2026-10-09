# 0020 – Local videos: mpv, opened from the menu

- **Status:** accepted
- **Context:** Besides streaming sites, the box should play video files kept on it, from the couch, without making it heavier (goal 7).
- **Decision:**
  - **mpv** plays the videos: fullscreen, keyboard-driven, decoded on the GPU, with every codec from RPM Fusion ([0008](0008-fedora.md)). It only runs while a video plays.
  - The files live in one folder on the box, `~/Videos`, **copied over SSH**: nothing new runs or listens.
  - A **Videos** entry in the menu lists them in fuzzel, the same menu as the apps ([0003](0003-super-key-menu.md)).
  - mpv remembers where each video stopped, and loads the subtitle files next to it.
- **Rejected:**
  - **Kodi:** a full media center with a library and posters, but a second interface with its own settings and add-ons, heavier than the need.
  - **Jellyfin** as a service: watched in the browser, which can't play many file formats (HEVC, AC3, DTS…), so the server converts them on the fly, a constant CPU load on an old PC.
  - **The browser** (`file://`): same format limits, and no resume.
  - **USB drives mounted automatically:** more moving parts; copying over SSH needs nothing new.
- **Consequences:**
  - No library: videos show as a list of file names (and subfolders), so naming them well matters.
  - Getting videos onto the box needs another computer on the network.
