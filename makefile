all:
	platypus -a 'HubNet Client Launcher' -i HubNet\ Client.icns -o 'None' -R -D -y launch-hubnet-client.sh

debug:
	platypus -a 'HubNet Client Launcher' -i HubNet\ Client.icns -D -y launch-hubnet-client.sh

clean:
	rm -rf 'HubNet Client Launcher.app'
