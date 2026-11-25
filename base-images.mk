# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := wodby/alpine
BASE_IMAGE_VERSION_SUFFIX :=

BASE_IMAGE_DIGEST_3.23 := sha256:82110ae2d885dd6761027078f0ed94a91cece852df3ec5bc758ed789e3a4466e
BASE_IMAGE_DIGEST_3.23-r19 := sha256:3385ca66ed38db73e9c0da4ff2e2f71d141edf6989594f1c867f5cd708c79a8c

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
