# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.23 := sha256:c9802ff2ecda0ae2c6069ebef81e7a0e8d8b0c59f9d71bcd77d1cf7150eac5ca
BASE_IMAGE_DIGEST_3.23-r11 := sha256:1beb3313d1097f154446c701c9f7ba52cdbf91dffe3a1e96f417d0deded8e4c7

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
