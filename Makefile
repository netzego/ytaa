CHANNEL_NAME  != cat user
ARCHIVE_FILE  := log
OPUS_DIR      := opus
OPUS_FILES	  := $(wildcard $(OPUS_DIR)/*.opus)
OUTPUT_FORMAT := %(title)s.%(ext)s
MP3_BITRATE   := 320k
MP3_DIR       := mp3
MP3_FILES	   = $(patsubst $(OPUS_DIR)/%.opus, $(MP3_DIR)/%.mp3, $(OPUS_FILES))

clean:
	@rm -fr $(OPUS_DIR)
	@rm -fr mp3/
	@[[ -e "$(ARCHIVE_FILE)" ]] && rm $(ARCHIVE_FILE) || true

download: | $(OPUS_DIR)
	@yt-dlp \
		--no-colors \
		--restrict-filenames \
		--extract-audio \
		--audio-quality 0 \
		--download-archive $(ARCHIVE_FILE) \
		--output "$(OUTPUT_FORMAT)" \
		--path $(OPUS_DIR) \
		"https://youtube.com/$(CHANNEL_NAME)/videos"

$(MP3_DIR)/%.mp3: $(OPUS_DIR)/%.opus | $(MP3_DIR)
	AV_LOG_FORCE_NOCOLOR=true \
		ffmpeg -hide_banner -i $< -vn -ar 44100 -ac 2 -b:a $(MP3_BITRATE) $@

$(OPUS_DIR) $(MP3_DIR):
	@mkdir -p $@

opus2mp3: $(MP3_FILES) | $(MP3_DIR)

.PHONY: \
	clean \
	download \
	opus2mp3

.DEFAULT_GOAL := download
