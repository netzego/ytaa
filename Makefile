CHANNEL_NAME  != cat user
ARCHIVE_FILE  := log
OPUS_DIR      := opus
OUTPUT_FORMAT := %(title)s.%(ext)s
MP3_BITRATE   := 320k

clean:
	@rm -fr $(OPUS_DIR)
	@rm -fr mp3/
	@[[ -e "$(ARCHIVE_FILE)" ]] && rm $(ARCHIVE_FILE) || true

download: | $(OPUS_DIR)
	@yt-dlp \
		--no-colors \
		--restrict-filenames \
		--extract-audio \
		--download-archive $(ARCHIVE_FILE) \
		--output "$(OUTPUT_FORMAT)" \
		--path $(OPUS_DIR) \
		"https://youtube.com/$(CHANNEL_NAME)/videos"

mp3:
	@mkdir -vp mp3
	@fd -I -t f \.opus$$ ./$(DOWNLOAD_DIR) -x ffmpeg -hide_banner -i {} -vn -ar 44100 -ac 2 -b:a $(MP3_BITRATE) mp3/{/.}.mp3 

$(DOWNLOAD_DIR):
	@mkdir -p $(DOWNLOAD_DIR)

.PHONY: \
	clean \
	download \
	mp3

.DEFAULT_GOAL := download
