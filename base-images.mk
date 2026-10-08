# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.23 := sha256:3465fc8b1c5e8229dfd8a04e811f622925caa8b6247e25cb40007263c87bfc29
BASE_IMAGE_DIGEST_3.23-r3 := sha256:2a602d2ee1122c28c34ff17be24d4e1b6fbafe8501981e3b488688e59ca4c051

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
