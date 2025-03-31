mkdir -p ~/Downloads

# Archivo .tmp
echo "archivo temporal" > ~/Downloads/test1.tmp

# Archivo .log
echo "log de ejemplo" > ~/Downloads/test2.log

# Archivo de 150MB
fallocate -l 150M ~/Downloads/test3.grande
