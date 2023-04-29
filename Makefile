CHANNEL_NAME  := $(shell cat user)
ARCHIVE_FILE  := log
DOWNLOAD_DIR  := opus
OUTPUT_FORMAT := %(title)s.%(ext)s

clean:
	@rm -fr $(DOWNLOAD_DIR)
	@rm -fr mp3/
	@rm $(ARCHIVE_FILE)

download: $(DOWNLOAD_DIR)
	@yt-dlp \
		--restrict-filenames \
		--extract-audio \
		--download-archive $(ARCHIVE_FILE) \
		--output "$(OUTPUT_FORMAT)" \
		--path $(DOWNLOAD_DIR) \
		"https://youtube.com/$(CHANNEL_NAME)/videos"

mp3:
	@mkdir -vp mp3
	fd -t f \.opus$$ ./$(DOWNLOAD_DIR) -x ffmpeg -i {} -vn -ar 44100 -ac 2 -b:a 320k mp3/{/.}.mp3 

$(DOWNLOAD_DIR):
	@mkdir -p $(DOWNLOAD_DIR)

.PHONY: \
	clean \
	download \
	mp3

.DEFAULT_GOAL := download
