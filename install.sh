#!/bin/bash
set -e

INSTALL_DIR="${HOME}/.local/bin"
BINARY_NAME="limavel"
DOWNLOAD_URL="https://github.com/Limavel/limavel/releases/download/0.9.2/limavel"

# Check macOS
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Error: This installer only supports macOS." >&2
  exit 1
fi

# Check Apple Silicon (aarch64/arm64)
if [ "$(uname -m)" != "arm64" ]; then
  echo "Error: This installer only supports Apple Silicon (arm64) architecture." >&2
  exit 1
fi

# Check curl
if ! command -v curl &> /dev/null; then
  echo "Error: curl is required but not installed." >&2
  exit 1
fi

echo "Installing ${BINARY_NAME}..."

# Download to temp file
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"

# Create install directory if needed
mkdir -p "$INSTALL_DIR"

# Install
chmod +x "$TMP_FILE"
mv "$TMP_FILE" "${INSTALL_DIR}/${BINARY_NAME}"

echo "Successfully installed ${BINARY_NAME} to ${INSTALL_DIR}/${BINARY_NAME}"

# Check if INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
  echo ""
  echo "Warning: ${INSTALL_DIR} is not in your PATH."
  echo "Add it by running:"
  echo ""
  echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
  echo ""
fi

echo "Run '${BINARY_NAME}' to get started."
