#!/bin/bash
set -eo pipefail

declare -A base=(
  [alpine3.12]='alpine'
  [slim-buster]='debian'
)

variants=(
  alpine3.12
  slim-buster
)

min_version='2.0'
dockerLatest='develop'
dockerDefaultVariant='slim-buster'


# version_greater_or_equal A B returns whether A >= B
function version_greater_or_equal() {
  [[ "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" || "$1" == "$2" ]];
}

dockerRepo="monogramm/docker-dokos"
latests=(
  $( curl -fsSL 'https://gitlab.com/dokos/dokos/-/tags' | \
     grep -oE 'v[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+' | \
     sort -urV )
  develop
)

# Remove existing images
echo "reset docker images"
rm -rf ./images/
mkdir ./images/

echo "update docker images"
readmeTags=
travisEnv=
for latest in "${latests[@]}"; do
  version=$(echo "$latest" | cut -d. -f1-2)

  # Only add versions >= "$min_version"
  if version_greater_or_equal "$version" "v$min_version" || [ "$latest" == 'develop' ]; then

    for variant in "${variants[@]}"; do
      # Create the version+variant directory with a Dockerfile.
      dir="images/$version/$variant"
      if [ -d "$dir" ]; then
        continue
      fi
      echo "generating dokos $latest (${base[$variant]})"
      mkdir -p "$dir"

      # Copy the docker files and directories
      for name in redis_cache.conf nginx.conf mariadb.conf .env; do
        cp -a "template/$name" "$dir/"
        sed -i \
          -e 's/{{ NGINX_SERVER_NAME }}/localhost/g' \
          "$dir/$name"
      done
      for name in test hooks bin; do
        cp -ar "template/$name" "$dir/"
      done
      cp "template/docker-compose_mariadb.yml" "$dir/docker-compose.mariadb.yml"
      cp "template/docker-compose_postgres.yml" "$dir/docker-compose.postgres.yml"
      cp "template/docker-compose.test.yml" "$dir/docker-compose.test.yml"
      cp "template/Dockerfile.${base[$variant]}.template" "$dir/Dockerfile"
      cp "template/.dockerignore" "$dir/.dockerignore"

      # Replace the variables.
      sed -ri -e '
        s/%%VARIANT%%/'"$variant"'/g;
        s/%%VERSION%%/'"$latest"'/g;
        s/%%DODOCK_VERSION%%/'"$version"'/g;
        s/%%DOKOS_VERSION%%/'"$version"'/g;
      ' "$dir/Dockerfile" \
        "$dir/test/Dockerfile" \
        "$dir/docker-compose."*.yml \
        "$dir/.env"

      sed -ri -e '
        s|DOCKER_TAG=.*|DOCKER_TAG='"$version"'|g;
        s|DOCKER_REPO=.*|DOCKER_REPO='"$dockerRepo"'|g;
      ' "$dir/hooks/run"

      # Create a list of "alias" tags for DockerHub post_push
      if [ "$version" = "v$dockerLatest" ]; then
        if [ "$variant" = "$dockerDefaultVariant" ]; then
          export DOCKER_TAGS="$latest-$variant $version-$variant $variant $latest $version latest "
        else
          export DOCKER_TAGS="$latest-$variant $version-$variant $variant "
        fi
      elif [ "$version" = "$latest" ]; then
        if [ "$variant" = "$dockerDefaultVariant" ]; then
          export DOCKER_TAGS="$latest-$variant $latest "
        else
          export DOCKER_TAGS="$latest-$variant "
        fi
      else
        if [ "$variant" = "$dockerDefaultVariant" ]; then
          export DOCKER_TAGS="$latest-$variant $version-$variant $latest $version "
        else
          export DOCKER_TAGS="$latest-$variant $version-$variant "
        fi
      fi
      echo "${DOCKER_TAGS} " > "$dir/.dockertags"

      # Add README tags
      readmeTags="$readmeTags\n-   ${DOCKER_TAGS} (\`$dir/Dockerfile\`)"

      # Add Travis-CI env var
      travisEnv='\n  - VERSION='"$version"' VARIANT='"$variant"' DATABASE=mariadb'"$travisEnv"
      travisEnv='\n  - VERSION='"$version"' VARIANT='"$variant"' DATABASE=postgres'"$travisEnv"

      if [[ $1 == 'build' ]]; then
        tag="$version-$variant"
        echo "Build Dockerfile for ${tag}"
        docker build -t "${dockerRepo}:${tag}" "$dir"
      fi
    done

  fi

done

# update README.md
sed '/^<!-- >Docker Tags -->/,/^<!-- <Docker Tags -->/{/^<!-- >Docker Tags -->/!{/^<!-- <Docker Tags -->/!d}}' README.md > README.md.tmp
sed -e "s|<!-- >Docker Tags -->|<!-- >Docker Tags -->\n$readmeTags\n|g" README.md.tmp > README.md
rm README.md.tmp

# update .travis.yml
if [ -f .travis.yml ]; then
  travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
  echo "$travis" > .travis.yml
fi
