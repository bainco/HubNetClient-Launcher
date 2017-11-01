cd ../../../
app=`ls -1 | grep -e 'HubNet Client [.0-9]\+[ A-Za-z\-]*[0-9]*\.app'`

if [ -z "${app// }" ]; then
    path=`pwd`
    osascript -e "display dialog \"I couldn't find a HubNet Client app in:\n\n${path}\n\nMake sure HubNet Client Launcher is in the same folder as the HubNet Client app.\" buttons {\"Quit\"}"
    exit 1
fi

read -r -d '' applescriptCode <<'EOF'
   set tIP to do shell script "ipconfig getifaddr en1"
   set dialogText to text returned of (display dialog "Server:" default answer tIP)
   return dialogText
EOF
ipAddress=$(osascript -e "$applescriptCode");

read -r -d '' applescriptCode <<'EOF'
   set dialogText to text returned of (display dialog "Number of test clients:" default answer "1")
   return dialogText
EOF
numClients=$(osascript -e "$applescriptCode");

for n in $(seq 1 $numClients)
do
   userName="test$n"
   if [ "$#" -ge 1 ]; then
       for var in "$@"
       do
   	open -n "$app" --args "$var" --ip "$ipAddress" --id "$userName"
       done
   else
       open -n "$app" --args --ip "$ipAddress" --id "$userName"
   fi
done

osascript -e "display dialog \"Once all HubNet clients have launched, please click Connect.\" buttons {\"Connect\"}"

for n in $(seq 1 $numClients)
do
   thePID=$(ps -ax | grep "HubNet Client" | grep "test$n$" | awk '{print $1}')
   osascript -e "tell application \"System Events\"" -e "set frontmost of every process whose unix id is $thePID to true" -e "key code 36" -e "end tell"
done
