#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Original Author: https://github.com/Draakoor
Modifications by: https://github.com/msmcpeake
Changelog:
  - Translated all comments and output from German to English
  - Added final success message: "✅ Manifest processing complete. All files are up to date."
"""

import os
import hashlib
import requests
from urllib.parse import urljoin

# URLs
MANIFEST_URL = "https://raw.githubusercontent.com/HMW-mod/hmw-distribution/refs/heads/master/manifest.json"
BASE_DOWNLOAD_URL = "https://par-1.cdn.horizonmw.org/"

def calculate_sha256(file_path):
    """
    Calculates the SHA-256 hash of a file.
    """
    sha256_hash = hashlib.sha256()
    try:
        with open(file_path, "rb") as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()
    except FileNotFoundError:
        return None

def download_file(file_url, local_path):
    """
    Downloads a file from the specified URL and saves it locally.
    """
    os.makedirs(os.path.dirname(local_path), exist_ok=True)
    try:
        response = requests.get(file_url, stream=True)
        response.raise_for_status()
        with open(local_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"Downloaded: {local_path}")
    except Exception as e:
        print(f"Error downloading {file_url}: {e}")

def process_manifest(manifest):
    """
    Processes the manifest, verifies files, and downloads them if necessary.
    """
    for module in manifest.get("Modules", []):
        print(f"Processing module: {module['Name']} (Version {module['Version']})")
        files_with_hashes = module.get("FilesWithHashes", {})
        download_path = module.get("DownloadInfo", {}).get("DownloadPath", "")

        for file_path, expected_hash in files_with_hashes.items():
            local_path = os.path.join(os.getcwd(), file_path)
            actual_hash = calculate_sha256(local_path)

            if actual_hash == expected_hash:
                print(f"File is up to date: {local_path}")
            else:
                print(f"File is missing or outdated: {local_path}")
                file_url = urljoin(BASE_DOWNLOAD_URL, os.path.join(download_path, file_path).replace("\\", "/"))
                download_file(file_url, local_path)

def main():
    try:
        # Download manifest.json
        response = requests.get(MANIFEST_URL)
        response.raise_for_status()
        manifest = response.json()

        # Process the manifest
        process_manifest(manifest)

        # Final success message
        print("✅ Manifest processing complete. All files are up to date.")

    except requests.RequestException as e:
        print(f"Error fetching manifest.json: {e}")
    except ValueError as e:
        print(f"Invalid format in manifest.json: {e}")

if __name__ == "__main__":
    main()
