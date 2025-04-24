docker run -v ${HOME}/.ssh:/keys \
  maven-builder build \
  --repository git@github.com:user/repo.git \
  --ssh-key /keys


docker run -e GIT_USERNAME=user -e GIT_PASSWORD=pass \
  maven-builder install \
  --repository https://github.com/user/repo.git

docker run -v /host/gpg:/keys/gpg \
  maven-builder publish \
  --repository git@github.com:user/repo.git \
  --gpg-key /keys/gpg

