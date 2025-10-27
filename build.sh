
HOST=vm1

# prefer cidata mode

echo CIDATA
./setup-create-cidataiso $HOST


echo APKOVL
export MODE=apkovl
# ./setup-create-apkovl $HOST
# ./setup-create-image $HOST # already auto call setup-create-apkovl
