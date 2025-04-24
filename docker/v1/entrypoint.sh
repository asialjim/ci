#!/bin/bash

show_help() {
    cat <<EOF
Usage: docker run [OPTIONS] maven-builder COMMAND [ARGS]

Commands:
  build       Build Maven project
  install     Install to local repository
  publish     Publish to central repository
  release     Execute release process
  /bin/bash   Enter container shell
  sh          Execute custom script
  help        Show this help message

Parameters:
  --repository    Git repository URL (required)
  --ssh-key       Host SSH key directory
  --git-username  Git HTTP username
  --git-password  Git HTTP password
  --gpg-key       Host GPG key directory

Examples:
  docker run -v \$(pwd):/app maven-builder build --repository git@github.com:user/repo.git
  docker run -v /keys:/keys maven-builder publish --repository https://github.com/user/repo.git --gpg-key /keys/gpg
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --repository)
                REPOSITORY="$2"
                shift 2
                ;;
            --ssh-key)
                SSH_KEY="$2"
                shift 2
                ;;
            --git-username)
                GIT_USERNAME="$2"
                shift 2
                ;;
            --git-password)
                GIT_PASSWORD="$2"
                shift 2
                ;;
            --gpg-key)
                GPG_KEY="$2"
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done
    REMAINING_ARGS=("$@")
}

setup_gpg() {
    if [ -n "$GPG_KEY" ]; then
        echo "Using custom GPG keys from $GPG_KEY"
        gpg --batch --import "$GPG_KEY"/private.key 2>/dev/null
        gpg --batch --import "$GPG_KEY"/public.key 2>/dev/null
    fi
}

setup_ssh() {
    if [ -n "$SSH_KEY" ]; then
        echo "Using custom SSH keys from $SSH_KEY"
        mkdir -p /root/.ssh
        cp "$SSH_KEY"/id_ed25519* /root/.ssh/ 2>/dev/null
        chmod 600 /root/.ssh/id_ed25519 2>/dev/null
    fi
}

setup_git() {
    if [[ "$REPOSITORY" == http* ]] && [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
        echo "Configuring HTTP credentials..."
        git config --global credential.helper "store --file ~/.git-credentials"
        echo "${REPOSITORY%%//*}//${GIT_USERNAME}:${GIT_PASSWORD}@${REPOSITORY#*//}" > /root/.git-credentials
    elif [[ "$REPOSITORY" == git@* ]]; then
        echo "Configuring SSH authentication..."
        chmod 700 /root/.ssh
        ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
    fi
}

clone_repository() {
    if [ -z "$REPOSITORY" ]; then
        echo "Error: --repository parameter is required"
        exit 1
    fi

    echo "Cloning repository: $REPOSITORY"
    rm -rf /app/*
    git clone "$REPOSITORY" /app || {
        echo "Failed to clone repository"
        exit 1
    }
    cd /app || exit 1
}

execute_command() {
    case "${REMAINING_ARGS[0]}" in
        build)
            mvn clean package "${REMAINING_ARGS[@]:1}"
            ;;
        install)
            mvn clean install "${REMAINING_ARGS[@]:1}"
            ;;
        publish)
            mvn clean deploy "${REMAINING_ARGS[@]:1}"
            ;;
        release)
            /release-script.sh "${REMAINING_ARGS[@]:1}"
            ;;
        /bin/bash)
            exec /bin/bash
            ;;
        sh)
            exec sh "${REMAINING_ARGS[@]:1}"
            ;;
        help)
            show_help
            ;;
        *)
            echo "Unknown command: ${REMAINING_ARGS[0]}"
            show_help
            exit 1
            ;;
    esac
}

main() {
    parse_arguments "$@"

    # 必须参数检查
    if [ -z "$REPOSITORY" ] && [[ ! "${REMAINING_ARGS[0]}" =~ ^(help|sh|/bin/bash)$ ]]; then
        echo "Error: --repository parameter is required for this command"
        exit 1
    fi

    setup_gpg
    setup_ssh
    setup_git

    if [[ ! "${REMAINING_ARGS[0]}" =~ ^(help|sh|/bin/bash)$ ]]; then
        clone_repository
    fi

    execute_command
}

main "$@"