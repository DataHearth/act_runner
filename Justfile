set shell := ["zsh", "-uc"]

base_img_name := "datahearth/act_runner"
gitea_img_name := "gitea.antoine-langlois.net/" + base_img_name
all_targets := "base docker rust go"

alias b := build
alias p := push
alias ba := build-all
alias pa := push-all

build TARGET:
  @docker build -t {{base_img_name}}:{{TARGET}} \
    --target {{TARGET}} \
    --cache-to type=inline \
    --cache-from type=registry,ref={{base_img_name}}:base \
    --cache-from type=registry,ref={{base_img_name}}:{{TARGET}} .
  @docker tag {{base_img_name}}:{{TARGET}} {{gitea_img_name}}:{{TARGET}}

push TARGET: (build TARGET)
  @docker push datahearth/act_runner:{{TARGET}}
  @docker push {{gitea_img_name}}:{{TARGET}}

build-all:
  #!/usr/bin/env zsh
  for target in {{all_targets}}; do
    echo "Building $target";
    docker build -t {{base_img_name}}:$target \
      --target $target \
      --cache-to type=inline \
      --cache-from type=registry,ref={{base_img_name}}:base \
      --cache-from type=registry,ref={{base_img_name}}:$target .

    docker tag {{base_img_name}}:$target {{gitea_img_name}}:$target;
  done

push-all: build-all
  #!/usr/bin/env zsh
  for target in {{all_targets}}; do
    echo "Pushing $target";
    docker push datahearth/act_runner:$target;
    docker push {{gitea_img_name}}:$target;
  done
