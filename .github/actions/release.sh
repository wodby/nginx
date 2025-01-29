#!/usr/bin/env bash

set -exo pipefail

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then      
  minor_ver="${VERSION%.*}"
  major_ver="${minor_ver%.*}"

  tags=("${minor_ver}")

  if [[ -n "${LATEST_MAJOR}" ]]; then
    tags+=("${major_ver}")
  fi  

  if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
    stability_tag=("${GITHUB_REF##*/}")
    tags=("${minor_ver}-${stability_tag}")
    if [[ -n "${LATEST_MAJOR}" ]]; then
      tags+=("${major_ver}-${stability_tag}")
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
