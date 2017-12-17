#!/bin/bash
cd "${1:-/repo}"

runcr() {
  local dir="$1"
  while  [ -f "${dir}.new" ] ; do
     rm -f "${dir}.new" ;
    echo running createrepo $dir
    flock "$dir" createrepo --update "$dir"
  done
}
watched=()

  for d in * ; do
    if [ -d "$d" -a "$d" != "repodata" ]  ; then
      if [ $(find "$d" -type f -name \*.rpm | wc -l) -gt 0 ] ; then 
        echo "Initializing $d"
        createrepo "$d"
      fi
      watched+=("$d")
    fi
  done

echo "Watching ${watched[*]}"
inotifywait -m --exclude 'repodata.*' \
   -e close_write -e move -e delete  \
   "${watched[@]}"  | 
while read watched events file ; do
   printf "Watched: %s %s %s\n" $watched $events $file 
   if [[ "$file" =~ .*\.rpm ]] ; then  
     dir="${watched%%/}"
     touch "${dir}.new"
     if flock -n "${dir}" true ; then 
        echo "running cr"
        runcr "${dir}" &
      fi 
   fi
done
   
