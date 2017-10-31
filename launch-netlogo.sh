#cd ../../../
app=`ls -1 | grep -e 'HubNet Client [.0-9]\+[ A-Za-z\-]*[0-9]*\.app'`
ls

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

while ! ps -A | grep "HubNet Client" | grep "test$numClients"; do sleep 10; done

for n in $(seq 1 $numClients)
do
   osascript -e "tell application \"System Events\"" -e "tell process \"HubNet\"" -e "try" -e "click button \"Enter\" of window 1" -e "end try -- ignore errors" -e "end tell" -e "end tell"
   sleep 100
done
