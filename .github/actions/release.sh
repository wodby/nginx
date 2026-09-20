#!/usr/bin/env bash

# Version aliases identify published releases; only primary tags publish images.
if [[ "${GITHUB_REF:-}" =~ ^refs/tags/.+-r[0-9]+$ ]]; then
    exit 0
fi

set -exo pipefail

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then      
  minor_ver="${NGINX_VER%.*}"
  major_ver="${minor_ver%.*}"

  tags=("${minor_ver}")

  if [[ -n "${LATEST_MAJOR}" ]]; then
    tags+=("${major_ver}")
  fi  

  if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
    image_revision=("${GITHUB_REF##*/}")
    tags=("${minor_ver}-${image_revision}")
    if [[ -n "${LATEST_MAJOR}" ]]; then
      tags+=("${major_ver}-${image_revision}")
    fi
  else          
    if [[ -n "${LATEST}" ]]; then
      tags+=("latest")
    fi
  fi

  for tag in "${tags[@]}"; do
    make buildx-imagetools-create TAG=${tag}
  done
fi
