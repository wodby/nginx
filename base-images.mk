# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.23 := sha256:f733f2c1102cfa10e918520c78295d3c9c3af80be3e43219b3d089b87846de7f
BASE_IMAGE_DIGEST_3.23-2.20.8 := sha256:97a0fa5605e88ab222015a788b6f45440f9f9f3b27b08904ffdb24225fcb2163

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
