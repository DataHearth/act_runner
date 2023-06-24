set shell := ["zsh", "-uc"]

base_img_name := "datahearth/act_runner"
gitea_img_name := "gitea.antoine-langlois.net/" + base_img_name
all_targets := "base docker rust"

alias b := build
alias p := push
alias ba := build-all
alias pa := push-all

build TARGET:
  @docker build -t datahearth/act_runner:{{TARGET}} \
    --target {{TARGET}} \
    --cache-to type=inline \
    --cache-from type=registry,ref=datahearth/act_runner:{{TARGET}} .
  @docker tag datahearth/act_runner:{{TARGET}} {{gitea_img_name}}:{{TARGET}}

push TARGET: (build TARGET)
  @docker push datahearth/act_runner:{{TARGET}}
  @docker push {{gitea_img_name}}:{{TARGET}}

build-all:
  #!/usr/local/bin/zsh
  for target in {{all_targets}}; do
    echo "Building $target";
    docker build -t datahearth/act_runner:$target \
      --target $target \
      --cache-to type=inline \
      --cache-from type=registry,ref=datahearth/act_runner:$target .;

    docker tag datahearth/act_runner:$target {{gitea_img_name}}:$target;
  done

push-all: build-all
  #!/usr/local/bin/zsh
  for target in {{all_targets}}; do
    echo "Pushing $target";
    docker push datahearth/act_runner:$target;
    docker push {{gitea_img_name}}:$target;
  done
