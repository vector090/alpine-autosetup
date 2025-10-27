
HOST=vm1

echo CIDATA
./setup-create-cidataiso $HOST

echo APKOVL
export MODE=apkovl
# ./setup-create-apkovl $HOST
./setup-create-image $HOST
