CHANNEL_NAME  := @akuphone
ARCHIVE_FILE  := audio.log
DOWNLOAD_DIR  := audio
OUTPUT_FORMAT := %(title)s.%(ext)s

clean:
	@rm -fr $(DOWNLOAD_DIR)
	@rm $(ARCHIVE_FILE)

download: $(DOWNLOAD_DIR)
	@yt-dlp \
		--restrict-filenames \
		--extract-audio \
		--download-archive $(ARCHIVE_FILE) \
		--output "$(OUTPUT_FORMAT)" \
		--path $(DOWNLOAD_DIR) \
		"https://youtube.com/$(CHANNEL_NAME)/videos"

$(DOWNLOAD_DIR):
	mkdir -p $(DOWNLOAD_DIR)

.PHONY: \
	clean \
	download

.DEFAULT_GOAL := download
