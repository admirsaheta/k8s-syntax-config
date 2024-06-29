#!/bin/bash
# VERSION 1.4
# https://git.io/fj7Te

# Function to set the highlight output options
highlight_protocol() {
  # Using truecolor for output
  echo "-O truecolor"
}

# Function to detect and set the appropriate syntax highlighting parameter
syntax_protocol() {
  local args=("$@")
  local syntax_param=""

  # Iterate over the provided arguments to find output format
  for arg in "${args[@]}"; do
    case "$arg" in
      # Set syntax to YAML if -oyaml is found
      -o*yaml)
        syntax_param="-S yaml"
        break
        ;;
      # Set syntax to JSON if -ojson is found
      -o*json)
        syntax_param="-S json"
        break
        ;;
    esac
  done

  # Return the detected syntax parameter
  echo "$syntax_param"
}

# Function to execute the kubectl command with optional syntax highlighting
kubectl_protocol() {
  local syntax_param="$1"
  shift

  # If no syntax parameter is set, execute kubectl command normally
  if [ -z "$syntax_param" ]; then
    kubectl "$@"
  else
    # Execute kubectl command and pipe the output through highlight
    kubectl "$@" | highlight "$syntax_param" "$(highlight_protocol)"
  fi
}

# Main function to orchestrate the script logic
main_protocol() {
  # Detect syntax highlighting parameter based on input arguments
  local syntax_param
  syntax_param=$(syntax_protocol "$@")
  
  # Execute kubectl command with or without syntax highlighting
  kubectl_protocol "$syntax_param" "$@"
}

# Execute the main function with the script's input parameters
main_protocol "$@"
