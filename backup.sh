#1
docker images -n | awk '{print $1 " " $2 " " $3}' | grep -v '<none>' | tr -c "a-z A-Z0-9_.\n-" "%" | while read REPOSITORY TAG IMAGE_ID
do
  echo "== Saving $REPOSITORY $TAG $IMAGE_ID =="
  docker save -o $REPOSITORY-$TAG-$IMAGE_ID.tar $IMAGE_ID
done

#2
docker images -n | awk '{print $1 " " $2 " " $3}' | grep -v '<none>' > images.list

#3
while read REPOSITORY TAG IMAGE_ID
do
    echo -e "\n== Tagging $REPOSITORY $TAG $IMAGE_ID =="
    REPO=$(echo $REPOSITORY | sed "s/\//%/g")
    docker load -i $REPO-$TAG-$IMAGE_ID.tar
    docker tag "$IMAGE_ID" "$REPOSITORY:$TAG"
done < images.list
