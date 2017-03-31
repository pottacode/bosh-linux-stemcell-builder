#!/bin/bash

set -eu

export VERSION=$( cat version/number | sed 's/\.0$//;s/\.0$//' )
stemcell=$(realpath stemcell/*.tgz)

for file in $COPY_KEYS ; do
  file="${file/\%s/$VERSION}"

  echo "$file"
  echo "$stemcell"

  checksum="$(sha1sum "${stemcell}" | awk '{print $1}')"
  echo "$file sha1=$checksum"
  if [ -n "${BOSHIO_TOKEN}" ]; then
    curl -X POST \
        --fail \
        -d "sha1=${checksum}" \
        -H "Authorization: bearer ${BOSHIO_TOKEN}" \
        "https://bosh.io/checksums/${file}"
  fi

  # occasionally this fails for unexpected reasons; retry a few times
  for i in {1..4}; do
    aws s3 cp "s3://$CANDIDATE_BUCKET_NAME/$file" "s3://$PUBLISHED_BUCKET_NAME/$file" \
      && break \
      || sleep 5
  done

done

echo "Done"
